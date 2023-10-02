# test_device puts all the variables in the device, but use comditional compilation
nvfortran -g -m64 -O0  -Wall -Werror -gpu=ccnative -cuda -traceback -Mrecursive  -o test_device_auto test_device_auto.cuf
