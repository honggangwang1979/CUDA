MODULE fds_CUDA

!use iso_c_binding

IMPLICIT NONE

!interface 
!        subroutine kw_simple_3d_opr_(a, b, c, N_i, N_j, N_k, Op) bind(C, name="kw_simple_3d_opr_")
!                import :: c_char, c_double, c_int
!                implicit none
!                real(c_double), Dimension(:,:,:) :: a, b, c
!                integer(c_int) :: N_i, N_j, N_k
!                character(c_char) :: Op
!        end subroutine 
!end interface

CONTAINS

Subroutine test_gpu()
!        use iso_c_binding
 integer*4 :: i, j, k 
 !integer*4, parameter :: N=8 , N_i=2, N_j=3, N_k=4
 integer*4, parameter :: N=8 , N_i=20, N_j=30, N_k=40
 !integer*4, parameter :: N=8 , N_i=200, N_j=30, N_k=40
 !real*4, Dimension(N) :: a, b

 real*8, Dimension(N_i,N_j,N_k) :: a, b, c
! real*8, Dimension(N_i,N_j,N_k,2) :: b_test


 DO i=1,N_i 
        Do j=1,N_j
                Do k=1,N_k
	                a(i,j,k)=i+(j-1)*N_i+(k-1)*N_i*N_j
	                b(i,j,k)=a(i,j,k)
!                        b_test(i,j,k,1)=a(i,j,k)
!                        b_test(i,j,k,2)=a(i,j,k)
	                c(i,j,k)=a(i,j,k)
!                        print *, 'before : i=',i,' j=',j, ' k=',k, 'a(i,j,k)=', a(i,j,k)
                END DO 
        END DO 
 END DO 

!CALL kw_simple_3d_opr_(a, b_test(:,:,:,2), c, N_i, N_j, N_k,'+')
CALL kw_simple_3d_opr_(a, b, c, N_i, N_j, N_k,'+')

! DO i=1,N_i 
!        Do j=1,N_j
!                Do k=1,N_k
!                        print *, 'After: i=',i,' j=',j, ' k=',k, 'c(i,j,k)=', c(i,j,k)
!                END DO 
!        END DO 
! END DO 


  END Subroutine 
END MODULE fds_CUDA
