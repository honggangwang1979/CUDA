# this case shows a more realistic example of mixed programming: calling Cuda C from Fortran module. It can be a benchmark to update the fds to GPU version based on CUDA C/C++.  We are going to compare the performance different between fortran + Cuda C and pure Cuda Fortran. See ../cuda_fortran for the pure Cuda fortran case

#nvcc -g -G -o fds_3d_test fds_3d_function.cu

#This case shows how to call cuda c function from fortran code
#reference : https://forums.developer.nvidia.com/t/calling-cuda-c-from-fortran/197064/4

#start : .so compiling method

nvcc -ccbin /usr/bin/g++ -Xcompiler -fPIC -g -G -arch=sm_60 -o libfds_GPU.so --shared fds_3d_function.cu

#this following 2 lines are to remove the GLIBC version conflic information, without which the compilation may output memcpy@glibc_xxxx error

#patchelf --clear-symbol-version memcpy libfds_GPU.so  
#patchelf --clear-symbol-version clock_gettime libfds_GPU.so

#mpifort fds_3d_GPU.f90 -g -o fds_3d_GPU -L. -lfds_GPU -L/usr/local/cuda/lib64 -lcudart -lstdc++ -fno-underscoring -lmpi
gfortran -c -g test_gpu.f90 fds_3d_GPU_no_mpi.f90
gfortran fds_3d_GPU_no_mpi.o test_gpu.o -g -o fds_3d_GPU_nm -L. -lfds_GPU -L/opt/conda/envs/rapids/lib -lcudart -lstdc++ -fno-underscoring
#gfortran -c test_gpu.f90
#gfortran fds_3d_GPU_no_mpi.f90 test_gpu.f90 -g -o fds_3d_GPU_nm -L. -lfds_GPU -L/usr/local/cuda/lib64 -lcudart -lstdc++ -fno-underscoring

#end: .so compiling method


#this following 3 lines work as a non-.so compiling method
#nvcc -ccbin /usr/bin/g++ -g -G -c fds_3d_function.cu
#mpifort fds_3d_GPU.f90 fds_3d_function.o -g -o fds_3d_GPU -L/usr/local/cuda/lib64 -lcudart -lstdc++ -fno-underscoring -lmpi
#gfortran fds_3d_GPU_no_mpi.f90 fds_3d_function.o -g -o fds_3d_GPU_nm -L/usr/local/cuda/lib64 -lcudart -lstdc++ -fno-underscoring

export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/notebooks/cuda_mix_test
