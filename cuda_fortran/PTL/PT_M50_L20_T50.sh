echo "Start the performanc test......."

echo "../test_fortran/test_fortran  50 50 50 20 50"
../test_fortran/test_fortran  50 50 50 20 50

echo  "../test_gpu/test_gpu  50 50 50 20 50"
../test_gpu/test_gpu  50 50 50 20 50

echo  "../test_gpu_mg/ test_gpu_mg  50 50 50 20 50"
../test_gpu_mg/test_gpu_mg  50 50 50 20 50

echo  "../test_gpu_mg_auto/ test_gpu_mg_auto  50 50 50 20 50"
../test_gpu_mg_auto/test_gpu_mg_auto  50 50 50 20 50

echo  "../test_device/test_device  50 50 50 20 50"
../test_device/test_device  50 50 50 20 50

echo  "../test_device_auto/test_device_auto  50 50 50 20 50"
../test_device_auto/test_device_auto  50 50 50 20 50

echo "../test_acc/test_acc  50 50 50 20 50"
../test_acc/test_acc  50 50 50 20 50

echo "../test_omp/test_omp 50 50 50 20 50"
../test_omp/test_omp 50 50 50 20 50

echo "end of the performanc test"
