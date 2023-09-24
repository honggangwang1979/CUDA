#include <iostream>
#include <stdio.h> 
#include <stdlib.h> 
#include <string.h>
#include <cuda.h> 
#include <cuda_runtime.h> 
#include <time.h>

// simple kernel function that adds two vectors 
__global__ void vect_add(float *a, float *b, int N) { 
	int idx = threadIdx.x; if (idx<N) a[idx] = a[idx] + b[idx]; 
} 

__global__ void cube_add(double *a, double *b, double *c, int N_i, int N_j, int N_k) { 
	int index_i = blockIdx.x*blockDim.x + threadIdx.x; 
	int index_j = blockIdx.y*blockDim.y + threadIdx.y;
	int index_k = blockIdx.z*blockDim.z + threadIdx.z;

	int strid_i = blockDim.x * gridDim.x;
	int strid_j = blockDim.y * gridDim.y;
	int strid_k = blockDim.z * gridDim.z;
	//int total_does = 0;


        for ( int i = index_i; i<N_i; i+=strid_i ){
        	for ( int j = index_j; j<N_j; j+=strid_j ){
        		for ( int k = index_k; k<N_k; k+=strid_k ){
				c[i*N_j*N_k+j*N_k+k] = a[i*N_j*N_k+j*N_k+k] + b[i*N_j*N_k+j*N_k+k];
				//c[i+j*N_i+k*N_i*N_j] = a[i+j*N_i+k*N_i*N_j] + b[i+j*N_i+k*N_i*N_j];
				//total_does++;
			}
		}
	}

	//printf("one thread runs %d times. \n", total_does);
} 
__global__ void cube_minus(double *a, double *b, double *c, int N_i, int N_j, int N_k) { 
	int index_i = blockIdx.x*blockDim.x + threadIdx.x; 
	int index_j = blockIdx.y*blockDim.y + threadIdx.y;
	int index_k = blockIdx.z*blockDim.z + threadIdx.z;

	int strid_i = blockDim.x * gridDim.x;
	int strid_j = blockDim.y * gridDim.y;
	int strid_k = blockDim.z * gridDim.z;
	int total_does = 0;


        for ( int i = index_i; i<N_i; i+=strid_i ){
        	for ( int j = index_j; j<N_j; j+=strid_j ){
        		for ( int k = index_k; k<N_k; k+=strid_k ){
				c[i*N_j*N_k+j*N_k+k] = a[i*N_j*N_k+j*N_k+k] - b[i*N_j*N_k+j*N_k+k];
				//c[i+j*N_i+k*N_i*N_j] = a[i+j*N_i+k*N_i*N_j] + b[i+j*N_i+k*N_i*N_j];
				total_does++;
			}
		}
	}

	printf("one thread runs %d times. \n", total_does);
}

__global__ void cube_product(double *a, double *b, double *c, int N_i, int N_j, int N_k) { 
	int index_i = blockIdx.x*blockDim.x + threadIdx.x; 
	int index_j = blockIdx.y*blockDim.y + threadIdx.y;
	int index_k = blockIdx.z*blockDim.z + threadIdx.z;

	int strid_i = blockDim.x * gridDim.x;
	int strid_j = blockDim.y * gridDim.y;
	int strid_k = blockDim.z * gridDim.z;
	//int total_does = 0;


        for ( int i = index_i; i<N_i; i+=strid_i ){
        	for ( int j = index_j; j<N_j; j+=strid_j ){
        		for ( int k = index_k; k<N_k; k+=strid_k ){
				for( int m=0; m<1000; m++ )
					c[i*N_j*N_k+j*N_k+k] = a[i*N_j*N_k+j*N_k+k] * b[i*N_j*N_k+j*N_k+k];
				//c[i+j*N_i+k*N_i*N_j] = a[i+j*N_i+k*N_i*N_j] + b[i+j*N_i+k*N_i*N_j];
				//total_does++;
			}
		}
	}

	//printf("one thread runs %d times. \n", total_does);
}

// function called from main fortran program extern "C" 
// this following line works for the main() commented by the end of this code
//extern "C" void kw_simple_3d_opr_(double *a, double *b, double *c, int *pN_i, int *pN_j, int *pN_k, char *pOperator) 
void kernel_wrapper_(double *a, double *b, double *c, int *pN_i, int *pN_j, int *pN_k, char *pOperator) 
{ 

	clock_t start = clock();
	double *a_d, *b_d, *c_d; 
	// declare GPU vector copies 
	int blocks = 1; 
	int blockDim_x=16, blockDim_y=16, blockDim_z=4;
	int gridDim_x, gridDim_y, gridDim_z;

	int N_i = *pN_i; 
	int N_j = *pN_j; 
	int N_k = *pN_k; 
	char Operator = *pOperator;
        
        gridDim_x = N_i%blockDim_x == 0 ? N_i/blockDim_x: N_i/blockDim_x +1;
        gridDim_y = N_j%blockDim_y == 0 ? N_j/blockDim_y: N_j/blockDim_y +1;
        gridDim_z = N_k%blockDim_z == 0 ? N_k/blockDim_z: N_k/blockDim_z +1;

	//dimention cannot be zero,otherwise wierd things may happen
	//gridDim_x = 0;  
	//gridDim_y = 0;

	dim3 grid(gridDim_x, gridDim_y, gridDim_z);
	dim3 block(blockDim_x, blockDim_y, blockDim_z);


	// i*j*k threads offloaded on GPU // Allocate memory on GPU 
	int Tsize = N_i *N_j *N_k *sizeof(double);
	//std::cout<<cudaGetErrorName(cudaMalloc( (void **)&a_d, Tsize))<<std::endl;
	//std::cout<<cudaGetErrorName(cudaMalloc( (void **)&b_d, Tsize))<<std::endl;
	//std::cout<<cudaGetErrorName(cudaMalloc( (void **)&c_d, Tsize))<<std::endl;

	// CudaMallocHost use pinned host memory which is supposed to be faster than CudaMalloc()
	//std::cout<<cudaGetErrorName(cudaMallocHost( (void **)&a_d, Tsize))<<std::endl;
	//std::cout<<cudaGetErrorName(cudaMallocHost( (void **)&b_d, Tsize))<<std::endl;
	//std::cout<<cudaGetErrorName(cudaMallocHost( (void **)&c_d, Tsize))<<std::endl;

	// CudaHostAlloc use zero-copy memory which is supposed to be even faster than CudaMallocHost()
	//std::cout<<cudaGetErrorName(cudaHostAlloc( (void **)&a_d, Tsize,cudaHostAllocMapped))<<std::endl;
	//std::cout<<cudaGetErrorName(cudaHostAlloc( (void **)&b_d, Tsize,cudaHostAllocMapped))<<std::endl;
	//std::cout<<cudaGetErrorName(cudaHostAlloc( (void **)&c_d, Tsize,cudaHostAllocMapped))<<std::endl;

	// copy vectors from CPU to GPU 
	//std::cout<<cudaGetErrorName(cudaMemcpy( a_d, a, Tsize, cudaMemcpyHostToDevice ))<<std::endl; 
	//std::cout<<cudaGetErrorName(cudaMemcpy( b_d, b, Tsize, cudaMemcpyHostToDevice ))<<std::endl; 
	//std::cout<<cudaGetErrorName(cudaMemcpy( c_d, c, Tsize, cudaMemcpyHostToDevice ))<<std::endl; 

	printf("Time elapsed: %f\n", ((double)clock() - start) / CLOCKS_PER_SEC);

	printf("in kernal before cube_add\n");

	// call function on GPU
       	//vect_add<<< blocks, N >>>( a_d, b_d, N); 
	switch ( Operator ){
		case '+':
        		//cube_add<<<grid, block>>>( a_d, b_d, c_d, N_i, N_j, N_k); 
        		cube_add<<<grid, block>>>( a, b, c, N_i, N_j, N_k); 
			break;
		case '-':
        		//cube_minus<<<grid, block>>>( a_d, b_d, c_d, N_i, N_j, N_k); 
			break;
		case '*':
        		//cube_product<<<grid, block>>>( a_d, b_d, c_d, N_i, N_j, N_k); 
			break;
	}
	//cudaDeviceSynchronize();
	// copy vectors back from GPU to CPU 

	printf("in kernal after cube_add\n");

	//cudaMemcpy( a, a_d, Tsize, cudaMemcpyDeviceToHost ); 
	//cudaMemcpy( b, b_d, Tsize, cudaMemcpyDeviceToHost ); 
	//cudaMemcpy( c, c_d, Tsize, cudaMemcpyDeviceToHost ); 

       	// free GPU memory 
	//cudaFree(a_d);
        //cudaFree(b_d); 
        //cudaFree(c_d); 
	return; 
} 

int main()
{
	int N_i = 2, N_j=3, N_k=4;
	double a[N_i][N_j][N_k];
	double b[N_i][N_j][N_k];
	double c[N_i][N_j][N_k];

	double *pa, *pb, *pc;

	int Tsize = N_i * N_j *N_k * sizeof(double);

	cudaMallocManaged(&pa, Tsize );
	cudaMallocManaged(&pb, Tsize );
	cudaMallocManaged(&pc, Tsize );

	memset(pa, 0x0, Tsize);
	memset(pb, 0x0, Tsize);
	memset(pc, 0x0, Tsize);

	for ( int k=0; k<N_k; k++){
		for ( int j=0; j<N_j; j++){
			for ( int i=0; i<N_i; i++) {
				//a[i][j][k] = i + j*N_i + k * N_j * N_i;
				//b[i][j][k] = a[i][j][k];
				//c[i][j][k] = 0.0;
				pa[i+j*N_i+k*N_i*N_j] = i + j*N_i + k *N_j * N_i;
				pb[i+j*N_i+k*N_i*N_j] = i + j*N_i + k *N_j * N_i;
				pc[i+j*N_i+k*N_i*N_j] = 0;
				printf("pa[%d][%d][%d]=%f\n",i,j,k,pa[i+j*N_i+k*N_i*N_j]);
			}
		}
	}


	printf("Tsize = %d, sizeof(a) =%d \n", Tsize, sizeof(a) );

        //pa = (double*)calloc(N_i * N_j * N_k, sizeof(double));
        //pb = (double*)calloc(N_i * N_j * N_k, sizeof(double));
        //pc = (double*)calloc(N_i * N_j * N_k, sizeof(double));



	//memcpy(pa, a, Tsize);
	//memcpy(pb, b, Tsize);
	//memcpy(pc, c, Tsize);

	char Operator = '+';
	clock_t start = clock();
	kernel_wrapper_((double *)pa,(double *)pb,(double *)pc, &N_i, &N_j, &N_k, &Operator);
	printf("Time elapsed: %f\n", ((double)clock() - start) / CLOCKS_PER_SEC);

	for ( int i=0; i<N_i; i++) {
		for ( int j=0; j<N_j; j++){
			for ( int k=0; k<N_k; k++){
				printf("c[%d][%d][%d]=%f\n",i,j,k,pc[i+j*N_i+k*N_j*N_i]);
			}
		}
	}

	cudaFree(pa);
	cudaFree(pb);
	cudaFree(pc);
	return 0;
} 
