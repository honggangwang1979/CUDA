#include <stdio.h> 
#include <stdlib.h> 
#include <string.h>
#include <time.h>


void cube_add(double *a, double *b, double *c, int N_i, int N_j, int N_k) { 
        for ( int i = 0; i<N_i; i++){
        	for ( int j = 0; j<N_j; j++){
        		for ( int k = 0; k<N_k; k++){
				//for( int m=0; m<1000; m++ )
					c[i*N_j*N_k+j*N_k+k] = a[i*N_j*N_k+j*N_k+k] + b[i*N_j*N_k+j*N_k+k];
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
	int N_i = 200, N_j=30, N_k=40;
	double a[N_i][N_j][N_k];
	double b[N_i][N_j][N_k];
	double c[N_i][N_j][N_k];

	memset(a, 0x0,  sizeof(a));
	memset(b, 0x0,  sizeof(a));
	memset(c, 0x0,  sizeof(a));
	double *pa, *pb, *pc;

	for ( int k=0; k<N_k; k++){
		for ( int j=0; j<N_j; j++){
			for ( int i=0; i<N_i; i++) {
				a[i][j][k] = i + j*N_i + k * N_j * N_i;
				b[i][j][k] = a[i][j][k];
				c[i][j][k] = 0.0;
				//printf("a[%d][%d][%d]=%f\n",i,j,k,a[i][j][k]);
			}
		}
	}

	int Tsize = N_i * N_j *N_k * sizeof(double);

	//printf("Tsize = %d, sizeof(a) =%d \n", Tsize, sizeof(a) );

        pa = (double*)calloc(N_i * N_j * N_k, sizeof(double));
        pb = (double*)calloc(N_i * N_j * N_k, sizeof(double));
        pc = (double*)calloc(N_i * N_j * N_k, sizeof(double));

	memset(pa, 0x0, Tsize);
	memset(pb, 0x0, Tsize);
	memset(pc, 0x0, Tsize);

	memcpy(pa, a, Tsize);
	memcpy(pb, b, Tsize);
	memcpy(pc, c, Tsize);

	clock_t start = clock();
	kernel_wrapper_((double *)pa,(double *)pb,(double *)pc, &N_i, &N_j, &N_k);
	printf("Time elapsed: %f\n", ((double)clock() - start) / CLOCKS_PER_SEC);

	/*
	for ( int i=0; i<N_i; i++) {
		for ( int j=0; j<N_j; j++){
			for ( int k=0; k<N_k; k++){
				//printf("c[%d][%d][%d]=%f\n",i,j,k,pc[i+j*N_i+k*N_j*N_i]);
			}
		}
	} */

	free(pa);
	free(pb);
	free(pc);
	return 0;
} 
