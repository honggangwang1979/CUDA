!
! Copyright 2003-2013 Intel Corporation.  All Rights Reserved.
!
! The source code contained or described herein and all documents
! related to the source code ("Material") are owned by Intel Corporation
! or its suppliers or licensors.  Title to the Material remains with
! Intel Corporation or its suppliers and licensors.  The Material is
! protected by worldwide copyright and trade secret laws and treaty
! provisions.  No part of the Material may be used, copied, reproduced,
! modified, published, uploaded, posted, transmitted, distributed, or
! disclosed in any way without Intel's prior express written permission.
!
! No license under any patent, copyright, trade secret or other
! intellectual property right is granted to or conferred upon you by
! disclosure or delivery of the Materials, either expressly, by
! implication, inducement, estoppel or otherwise.  Any license under
! such intellectual property rights must be express and approved by
! Intel in writing.
!


module fds_CUF

implicit none

contains

 subroutine GetArgument(argc, argv)
     implicit none
     integer :: argc, ix
     character (len=16), dimension(:), allocatable  :: argv
     
     argc = command_argument_count()
     allocate(argv(argc))

     do  ix=1, argc
         call get_command_argument(ix, argv(ix))
     end do
 end subroutine GetArgument

 elemental subroutine str2int(in_str,out_int,out_stat)
    implicit none
    ! Arguments
    character(len=*),intent(in) :: in_str
    integer*4,intent(out)         :: out_int
    integer*4,intent(out)         :: out_stat

    read(in_str,*,iostat=out_stat)  out_int
  end subroutine str2int

 elemental subroutine str2real(in_str,out_real,out_stat)
    implicit none
    ! Arguments
    character(len=*),intent(in) :: in_str
    real,intent(out)         :: out_real 
    integer,intent(out)         :: out_stat

    read(in_str,*,iostat=out_stat)  out_real
  end subroutine str2real


  subroutine cube_add(a, b, c, N_i, N_j, N_k, M_load)

        implicit none 

        real*8 :: a(N_i,N_j,N_k),b(N_i,N_j,N_k),c(N_i,N_j,N_k)
        integer*4, value :: N_i, N_j, N_k, M_load

        integer*4 :: i, j, k,m

        !$omp parallel do shared(N_i, N_j, N_k, M_load, a, b, c) collapse(3)
 	DO i=1,N_i
 		DO j=1,N_j
 			DO k=1,N_k
				do m=1, M_load
                        		c(i,j,k) = a(i,j,k) + b(i,j,k)	
				end do
			End DO
		End DO
	End DO
        !$end omp parallel do
  end subroutine cube_add

  subroutine kw_simple_3d_opr_(a, b, c, N_i, N_j, N_k,M, Op)
    !use cudafor
    implicit none

    real*8 :: a(N_i,N_j,N_k), b(N_i,N_j,N_k), c(N_i,N_j,N_k)

    integer :: N_i, N_j, N_k, M, istat
    character, value :: op


    !type(cudaEvent) :: start, stop

    call cube_add(a, b, c, N_i, N_j, N_k, M)

  end subroutine kw_simple_3d_opr_


  Subroutine test_gpu( N_i, N_j, N_k, M, T_steps )

   IMPLICIT NONE

   integer*4 :: i,j,k 

   integer*4 :: M, N_i, N_j, N_k, T_steps
   !integer*4, parameter :: N=8 , N_i=200, N_j=30, N_k=40

   real*8, Dimension(N_i,N_j,N_k) :: a, b, c
   ! real*8, Dimension(N_i,N_j,N_k,2) :: b_test

   real*8 :: Terror=0.0
   real e, etime, t(2), start_time, stop_time

   !$omp parallel shared(N_i, N_j, N_k, a, b, c)
   !$omp do collapse(3)
   DO i=1,N_i 
          Do j=1,N_j
                  Do k=1,N_k
	                a(i,j,k)=i+(j-1)*N_i+(k-1)*N_i*N_j
	                b(i,j,k)=a(i,j,k)
	                c(i,j,k)=0.0
                         
!		 	print *, 'before : i=',i,' j=',j, ' k=',k, 'a(i,j,k)=', a(i,j,k)
                  END DO 
          END DO 
   END DO 
   !$omp end do
   !$omp end parallel
  !c = 0.0
  !CALL kw_simple_3d_opr_(a, b_test(:,:,:,2), c, N_i, N_j, N_k,'+')

  !e = etime(t) 
  !print *, 'Time elapsed before kernal :', e, ',user:', t(1), ', sys:', t(2)

  call cpu_time(start_time)
  print *, 'before kernal cpu time :', start_time

  !$omp parallel do shared(N_i, N_j, N_k, M, T_steps, a, b, c) 
  DO i=1, T_steps
        CALL kw_simple_3d_opr_(a, b, c, N_i, N_j, N_k, M, '+')
  END DO
  !$end omp parallel do

  call cpu_time(stop_time)
  print *, 'test_omp after kernal cpu time :',stop_time 

  !e = etime(t) 
  !print *, 'Time elapsed after kernal :', e, ',user:', t(1), ', sys:', t(2)

  !$omp parallel do  shared(N_i, N_j, N_k, a, b, c) reduction(+:Terror) collapse(3)
   DO i=1,N_i 
          Do j=1,N_j
                  Do k=1,N_k
                          !print *, 'After: i=',i,' j=',j, ' k=',k, 'c(i,j,k)=', c(i,j,k)
			  Terror = Terror + c(i,j,k)-a(i,j,k)-b(i,j,k)
                  END DO 
          END DO 
   END DO 
   !$end omp parallel do

   print *, 'Terror=', Terror


  END subroutine

end module 

program test_no_mpi
	use fds_CUF
        implicit none

        integer i, size, rank, namelen, ierr
        integer*4 :: M=8 , N_i=2, N_j=3, N_k=4,T_steps=10, stat

	integer :: argc, ix
        character (len=16), dimension(:), allocatable  :: argv

        real :: e, etime, t(2)

        call GetArgument(argc, argv)

        if ( argc == 5 ) then
        	call str2int(argv(1), N_i,stat ) 
        	call str2int(argv(2), N_j ,stat) 
        	call str2int(argv(3), N_k ,stat) 
        	call str2int(argv(4), M ,stat) 
        	call str2int(argv(5), T_steps ,stat) 
        	print*, N_i, N_j, N_k, M, T_steps
        else
        	print*, "Use default arguments:", N_i, N_j, N_k, M, T_steps
	endif
             

        call test_gpu(N_i, N_j, N_k, M, T_steps)
end
