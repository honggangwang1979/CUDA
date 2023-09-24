#include <stdio.h> 
#include <stdlib.h> 
#include <string.h>
#include <time.h>


void cube_add(double *a, double *b, double *c, int N_i, int N_j, int N_k) { 
       	for ( int i = 0; i<N_i; i++){
        	for ( int j = 0; j<N_j; j++){
        		for ( int k = 0; k<N_k; k++){
				for( int m=0; m<100; m++ )
					c[i*N_j*N_k+j*N_k+k] = a[i*N_j*N_k+j*N_k+k] + b[i*N_j*N_k+j*N_k+k];
					//c[i + j*N_i +k*N_i*N_j] = a[i + j*N_i +k*N_i*N_j] + b[i + j*N_i +k*N_i*N_j] ;
			}
		}
	}

	//printf("one thread runs %d times. \n", total_does);
} 

// function called from main fortran program extern "C" 
// this following line works for the main() commented by the end of this code
void kernel_wrapper_(double *a, double *b, double *c, int *pN_i, int *pN_j, int *pN_k) 
{ 
	int N_i = *pN_i; 
	int N_j = *pN_j; 
	int N_k = *pN_k; 
        
	printf("in kernal before cube_add\n");
       	cube_add( a, b, c, N_i, N_j, N_k); 
	printf("in kernal after cube_add\n");

	return; 
} 

int main()
{
	//int N_i = 2, N_j=3, N_k=4;
	//int N_i = 20, N_j=30, N_k=40;
	int N_i = 200, N_j=300, N_k=400;


	double *pa, *pb, *pc;

	int Tsize = N_i * N_j *N_k * sizeof(double);

        pa = (double*)calloc(N_i * N_j * N_k, sizeof(double));
        pb = (double*)calloc(N_i * N_j * N_k, sizeof(double));
        pc = (double*)calloc(N_i * N_j * N_k, sizeof(double));

	memset(pa, 0x0, Tsize);
	memset(pb, 0x0, Tsize);
	memset(pc, 0x0, Tsize);

	for ( int i=0; i<N_i; i++) {
		for ( int j=0; j<N_j; j++){
			for ( int k=0; k<N_k; k++){
				pa[i+j*N_i+k*N_j*N_i] = i + j*N_i + k * N_j * N_i;
				pb[i+j*N_i+k*N_j*N_i] = i + j*N_i + k * N_j * N_i;
				pc[i+j*N_i+k*N_j*N_i] = 0.0;
				//printf("a[%d][%d][%d]=%f\n",i,j,k,a[i][j][k]);
			}
		}
	}

	clock_t start = clock();
	kernel_wrapper_((double *)pa,(double *)pb,(double *)pc, &N_i, &N_j, &N_k);
	printf("Time elapsed: %f\n", ((double)clock() - start) / CLOCKS_PER_SEC);

	for ( int i=0; i<N_i; i++) {
		for ( int j=0; j<N_j; j++){
			for ( int k=0; k<N_k; k++){
//				printf("c[%d][%d][%d]=%f\n",i,j,k,pc[i*N_j*N_k+j*N_k+k]);
			}
		}
	} 

	free(pa);
	free(pb);
	free(pc);
	return 0;
} 
