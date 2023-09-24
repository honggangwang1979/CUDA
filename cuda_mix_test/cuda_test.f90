!=======================================================================================================================
!Interface to cuda C functions
!=======================================================================================================================
module cuda_test

  use iso_c_binding

  interface
     !
     integer(c_int) function cudatestfunc(idata, isize) bind(C, name="cudatestfunc")
       use iso_c_binding
       implicit none
       type(c_ptr),value :: idata
       !type(c_ptr) :: idata
       integer(c_int),value :: isize
     end function cudatestfunc
     !
  end interface

end module cuda_test



!=======================================================================================================================
program main
!=======================================================================================================================
 use iso_c_binding

  use cuda_test

  type(c_ptr) :: mydata

  !pf_mydata(:) is used to receive the pointer coming back from c function, since mydata cannot be used in fortran directly because
  !it is a c_ptr pointer
  integer*4, pointer :: pf_mydata(:)

  integer*4, target   :: mysize,myresult
  integer*4,dimension(:),allocatable,target :: darray

  mysize = 100
  allocate(darray(mysize))
  darray = (/ (1, I = 1, mysize) /)
  darray(1) = -9
  mydata = c_loc(darray)
  myresult = cudatestfunc(mydata, mysize)

  !This line is important: it convert c_ptr pointer to fortran pointer, and then we can access the data in fortran.
  call c_f_pointer(mydata, pf_mydata, shape=[mysize] )

  write (*, '(A, I10)') "  result: ", myresult
  write (*,*)
  print *, pf_mydata

end program main

