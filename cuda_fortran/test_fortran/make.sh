#test_fortran only uses cpu, as results show, test_fortran will outperform test_gpu for small number of fds cells like 20 x 30 x 40 , the critical point is 200 x 300 x 40 for M_load = 10 (10 add operations every cell)

nvfortran -g -m64 -O0  -Wall -Werror -traceback -Mrecursive  -o test_fortran test_fortran.f90

# -pg makes gprof work. first run: test_fortran, then run: gprof ./test_fortran
#gfortran -g -pg -m64 -O0   -o test_fortran test_fortran.f90
