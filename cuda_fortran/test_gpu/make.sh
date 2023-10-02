#run: "nsys profile ./test_gpu" and "nsys stats *rep" to find the hotspots of the code
  
#test_gpu uses cuda gpu, only traditional cuda gpu, move from host to device and back to host
nvfortran -g -m64 -O0  -Wall -Werror -gpu=ccnative -cuda -traceback -Mrecursive  -o test_gpu test_gpu.cuf 
