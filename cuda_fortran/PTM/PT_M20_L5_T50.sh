echo "Start the performanc test......."

echo "../test_fortran/test_fortran  20 20 20 5 50"
../test_fortran/test_fortran  20 20 20 5 50

echo  "../test_gpu/test_gpu  20 20 20 5 50"
../test_gpu/test_gpu  20 20 20 5 50

echo  "../test_gpu_mg/ test_gpu_mg  20 20 20 5 50"
../test_gpu_mg/test_gpu_mg  20 20 20 5 50

echo  "../test_gpu_mg_auto/ test_gpu_mg_auto  20 20 20 5 50"
../test_gpu_mg_auto/test_gpu_mg_auto  20 20 20 5 50

echo  "../test_device/test_device  20 20 20 5 50"
../test_device/test_device  20 20 20 5 50

echo  "../test_device_auto/test_device_auto  20 20 20 5 50"
../test_device_auto/test_device_auto  20 20 20 5 50

echo "../test_acc/test_acc  20 20 20 5 50"
../test_acc/test_acc  20 20 20 5 50

echo "../test_omp/test_omp 20 20 20 5 50"
../test_omp/test_omp 20 20 20 5 50

echo "end of the performanc test"
