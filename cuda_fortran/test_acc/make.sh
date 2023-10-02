#test_acc use OpenAcc insted of cuda, the result shows that test_acc, test_gpu_mg and test_device are comparable  
nvfortran -g -m64 -O0 -acc -gpu=ccnative -Minfo=accel -o test_acc test_acc.f90
