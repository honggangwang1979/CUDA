This folder tests various memory management:
1. fds_3d_cpu.c: pure c code
2. fds_3d_function.cu: traditional cu code witht cudaMalloc/cudaMemcpy
3. fds_cuda_mg.cu: use cudaMallocManaged() but without cudaDeviceSyncrize which generates random result
4. fds_cuda_mg_cds.cu : use both cudaMallocManaged() and cudaDeviceSyncrize which generates correct result
5. fds_cuda_HMM.cu : use the so-called new Heterogerous Memory Management (HMM) without  cudaMallocManaged(), will give wrong result so HMM is not stable at this moment
6 t43.cu : test the different performance between Unified memory and non Unified memory, showing UM is faster than non-UM
