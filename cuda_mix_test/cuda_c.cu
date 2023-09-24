#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include <time.h>

__global__ void testkernel(int *data, int size){

  for (int i = 1; i < size; i++) data[0] += data[i];
}

extern "C" {
 int cudatestfunc(int *data, int size){
  int *d_data;
  //cudaMalloc((void **) &d_data, size*sizeof(int));
  std::cout<<cudaGetErrorName(cudaMalloc( (void **)&d_data, size * sizeof(int) ))<<std::endl;
  std::cout<<cudaGetErrorName(cudaMemcpy(d_data, data, size*sizeof(int), cudaMemcpyHostToDevice)) << std::endl;
  testkernel<<<1,1>>>(d_data, size);
  int result;
  std::cout<<cudaGetErrorName(cudaMemcpy(&result, d_data, sizeof(int), cudaMemcpyDeviceToHost)) << std::endl;
  std::cout<<cudaGetErrorName(cudaMemcpy(data, d_data, size*sizeof(int), cudaMemcpyDeviceToHost)) << std::endl;
  return result;
 }
}
