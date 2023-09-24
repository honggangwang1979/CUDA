# fds_test does not use cudaMallocManaged()
nvcc -ccbin /usr/bin/g++ -g -G -arch=sm_60 -o fds_test fds_3d_function.cu

# fds_test_mg does use cudaMallocManaged() but does not use  cudaDeviceSynchronize()
nvcc -ccbin /usr/bin/g++ -g -G -arch=sm_60 -o fds_test_mg  fds_cuda_mg.cu

# fds_test_mg_cds does use cudaMallocManaged() and  cudaDeviceSynchronize()
nvcc -ccbin /usr/bin/g++ -g -G -arch=sm_60 -o fds_test_mg_cds  fds_cuda_mg_cds.cu

# fds_test_HMM does use cudaMallocManaged() and  cudaDeviceSynchronize() : the so called heterogeneous memory management (HMM), which is not stable currently
nvcc -ccbin /usr/bin/g++ -g -G -arch=sm_60 -o fds_test_HMM fds_cuda_HMM.cu

# fds_3d_cpu only use cpu
gcc  -g -o fds_3d_cpu fds_3d_cpu.c

# test the performance difference between Unified Memory(UM) and non UM
nvcc -std=c++11 -arch=sm_60 -o t43 t43.cu -lcufft
