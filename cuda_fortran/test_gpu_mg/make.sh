# test_gpu_mg use managed Unified Memory
nvfortran -g -m64 -O0  -Wall -Werror -gpu=ccnative -cuda -traceback -Mrecursive  -o test_gpu_mg test_gpu_mg.cuf
