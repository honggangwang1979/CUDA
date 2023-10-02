#these are two small tests
nvfortran -g -m64 -O0  -Wall -Werror -gpu=ccnative -cuda -traceback -Mrecursive  -o ./items/managed ./items/test_mg.cuf
nvfortran -g -m64 -O0  -Wall -Werror -gpu=ccnative -cuda -traceback -Mrecursive  -o ./items/no_managed ./items/test_no_mg.cuf
