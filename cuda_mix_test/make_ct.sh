#this case shows a simple fortran calling c function example

gfortran -c -g cuda_test.f90 -o cuda_testf.o  
nvcc -ccbin /usr/bin/g++ -g -G -arch=sm_60 -c cuda_c.cu -o libcuda_c.so
gfortran cuda_testf.o -g -o cuda_test -L. -lcuda_c -L/opt/conda/envs/rapids/lib -lcudart -lstdc++
