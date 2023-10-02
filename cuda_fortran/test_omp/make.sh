#test_fortran only uses cpu, as results show, test_fortran will outperform test_gpu for small number of fds cells like 20 x 30 x 40 , the critical point is 200 x 300 x 40 for M_load = 10 (10 add operations every cell)

nvfortran -g -mp -m64 -O0  -Wall -Werror -traceback -Mrecursive  -o test_omp test_omp.f90

# -pg makes gprof work. first run: test_omp, then run: gprof ./test_omp
#gfortran -g -mp -pg -m64 -O0   -o test_omp test_omp.f90

#set the num of threads to the number shown by 'nproc' command, which is the number of cores * hyperthreading. For exmaple, for P5000, lscpu shows the number of cores are 8, nproc shows 24, which means hyperthreading=3
export OMP_NUM_THREADS=24
export OMP_NESTED=TRUE
