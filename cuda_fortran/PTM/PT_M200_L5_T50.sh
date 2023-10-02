echo "Start the performanc test......."

echo "../test_fortran/test_fortran  200 200 200 5 50"
../test_fortran/test_fortran  200 200 200 5 50

echo  "../test_gpu/test_gpu  200 200 200 5 50"
../test_gpu/test_gpu  200 200 200 5 50

echo  "../test_gpu_mg/ test_gpu_mg  200 200 200 5 50"
../test_gpu_mg/test_gpu_mg  200 200 200 5 50

echo  "../test_gpu_mg_auto/ test_gpu_mg_auto  200 200 200 5 50"
../test_gpu_mg_auto/test_gpu_mg_auto  200 200 200 5 50

echo  "../test_device/test_device  200 200 200 5 50"
../test_device/test_device  200 200 200 5 50

echo  "../test_device_auto/test_device_auto  200 200 200 5 50"
../test_device_auto/test_device_auto  200 200 200 5 50

echo "../test_acc/test_acc  200 200 200 5 50"
../test_acc/test_acc  200 200 200 5 50

echo "../test_omp/test_omp 200 200 200 5 50"
../test_omp/test_omp 200 200 200 5 50

echo "end of the performanc test"
