1. This folder shows different GPU programming method and compares their performance:
   (1) test_fortran: this is the baseline case only using CPU. the problem is to calcualte the addition of two 3d array indicating a physical variables in 3d mesh cells.
       the four parameters fed to the exe is: N_i, N_j, N_k, M_load, whire the first 3 are 3 dimentions, the last one is the working load for each cell.

       the simulated time for N_i=200, N_j=300, N_k=400, M_load=10 is:
              10.14s

   (2) test_gpu: this use traditional cuda programming method with explicit data exchange between the host and the device.

       the simulated time for N_i=200, N_j=300, N_k=400, M_load=10 is:
              4.79s

   (3) test_gpu_mg: this use managed data (Unified Memory) method with implict data exchange whenever necessary based on the compilier's best knowledge.

       the simulated time for N_i=200, N_j=300, N_k=400, M_load=10 is:
              4.56s

   (4) test_device: this method puts all the variables in the device memory space, which waives the data changes between the host and the device memory space.

       the simulated time for N_i=200, N_j=300, N_k=400, M_load=10 is:
              0.94s

   (5) test_device_auto: this method is same to test_device but use conditional compilier to do the kernel device work.
       (Note: this code does not use module to contain all the variables and include the cudafor, so every subroutine which calls cuda funtions or subroutines should include the cudafor library by using !@cuf use cudafor

       the simulated time for N_i=200, N_j=300, N_k=400, M_load=10 is:
              0.95s

   (6) test_acc: this method use OpenAcc instead of cuda.

       the simulated time for N_i=200, N_j=300, N_k=400, M_load=10 is:
              4.79s
