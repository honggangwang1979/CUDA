// this code is to test the Unified Memeory vs non-unified memory

#include <cufft.h>
#include <iostream>
#include <string>

//using namespace std;
const int dataSize  = 1048576*32;

void setupWave(const int ds, cufftComplex *d){
  for (int i = 0; i < ds; i++){
    d[i].x = 1.0f;
    d[i].y = 0.0f;}
}

int main(){

cufftComplex *inData, *outData;

cufftHandle plan;
cufftPlan1d(&plan, dataSize, CUFFT_C2C, 1);

cudaMallocManaged(&inData, dataSize * sizeof(cufftComplex));
cudaMallocManaged(&outData, dataSize * sizeof(cufftComplex));

cudaEvent_t start_before_memHtoD, start_kernel, stop_kernel,
                stop_after_memDtoH;
cudaEventCreate(&start_kernel);
cudaEventCreate(&start_before_memHtoD);
cudaEventCreate(&stop_kernel);
cudaEventCreate(&stop_after_memDtoH);

setupWave(dataSize, inData);

cudaEventRecord(start_before_memHtoD);
cudaMemPrefetchAsync(inData, dataSize * sizeof(cufftComplex), 0);
cudaMemPrefetchAsync(outData, dataSize * sizeof(cufftComplex), 0);
cudaDeviceSynchronize();

cudaEventRecord(start_kernel);

//call kernal 
cufftExecC2C(plan, inData, outData, CUFFT_FORWARD);

cudaEventRecord(stop_kernel);

cudaEventSynchronize(stop_kernel);

float sum = 0;
for (int i = 0; i < dataSize; i++) {
        sum += outData[i].x + outData[i].y;
}
cudaEventRecord(stop_after_memDtoH);
cudaEventSynchronize(stop_after_memDtoH);

std::cout << "sum for UM is " << sum << std::endl;


float umTime = 0;
float overallUmTime = 0;
cudaEventElapsedTime(&umTime, start_kernel, stop_kernel);
cudaEventElapsedTime(&overallUmTime, start_before_memHtoD,
                stop_after_memDtoH);

std::string resultString_um = std::to_string(dataSize) + " samples took " + std::to_string(umTime) + "ms,  Overall: " + std::to_string(overallUmTime) + "\n";

std::cout << resultString_um;
cudaEventDestroy(start_kernel);
cudaEventDestroy(stop_kernel);
cudaFree(inData);
cudaFree(outData);
cudaEventDestroy(start_before_memHtoD);
cudaEventDestroy(stop_after_memDtoH);

cufftDestroy(plan);


// start non UM process:

cufftComplex *d_inData;
cufftComplex *d_outData;
inData = (cufftComplex*) (malloc(sizeof(cufftComplex) * dataSize));
outData = (cufftComplex*) (malloc(sizeof(cufftComplex) * dataSize));
cudaMalloc((void**) (&d_inData), dataSize * sizeof(cufftComplex));
cudaMalloc((void**) (&d_outData), dataSize * sizeof(cufftComplex));
//cufftHandle plan;
cufftPlan1d(&plan, dataSize, CUFFT_C2C, 1);

//cudaEvent_t start_before_memHtoD, start_kernel, stop_kernel,
//                stop_after_memDtoH;
cudaEventCreate(&start_kernel);
cudaEventCreate(&start_before_memHtoD);
cudaEventCreate(&stop_kernel);
cudaEventCreate(&stop_after_memDtoH);

setupWave(dataSize, inData);

cudaEventRecord(start_before_memHtoD);
cudaMemcpy(d_inData, inData, dataSize * sizeof(cufftComplex),
                                        cudaMemcpyHostToDevice);
cudaEventRecord(start_kernel);

cufftExecC2C(plan, d_inData, d_outData, CUFFT_FORWARD);

cudaEventRecord(stop_kernel);

cudaEventSynchronize(stop_kernel);

cudaMemcpy(outData, d_outData, dataSize * sizeof(cufftComplex),
                cudaMemcpyDefault);

 sum = 0;
for (int i = 0; i < dataSize; i++) {
        sum += outData[i].x + outData[i].y;
}
cudaEventRecord(stop_after_memDtoH);
cudaEventSynchronize(stop_after_memDtoH);

std::cout << "sum for non-UM is " << sum << std::endl;

//float umTime = 0;
//float overallUmTime = 0;
cudaEventElapsedTime(&umTime, start_kernel, stop_kernel);
cudaEventElapsedTime(&overallUmTime, start_before_memHtoD,
                stop_after_memDtoH);

resultString_um = std::to_string(dataSize) + " samples took "
                + std::to_string(umTime) + "ms,  Overall: "
                + std::to_string(overallUmTime) + "\n";
std::cout << resultString_um;
free(outData);
free(inData);
cudaFree(d_outData);
cudaFree(d_inData);
cudaEventDestroy(start_kernel);
cudaEventDestroy(stop_kernel);

cudaEventDestroy(start_before_memHtoD);
cudaEventDestroy(stop_after_memDtoH);

cufftDestroy(plan);

}

