# test_device puts all the variables in the device
nvfortran -g -m64 -O0  -Wall -Werror -gpu=ccnative -cuda -traceback -Mrecursive  -o test_device test_device.cuf

#nvfortran -g -pg -m64 -O0  -Wall -Werror -gpu=ccnative -cuda -traceback -Mrecursive  -o test_device test_device.cuf
