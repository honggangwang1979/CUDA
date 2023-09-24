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
        program test_mpi
        use mpi
        implicit none

        integer i, size, rank, namelen, ierr
        character (len=MPI_MAX_PROCESSOR_NAME) :: name
        integer stat(MPI_STATUS_SIZE)

        call MPI_INIT (ierr)

        call MPI_COMM_SIZE (MPI_COMM_WORLD, size, ierr)
        call MPI_COMM_RANK (MPI_COMM_WORLD, rank, ierr)
        call MPI_GET_PROCESSOR_NAME (name, namelen, ierr)

        if (rank.eq.0) then

            print *, 'Hello world: rank ', rank, ' of ', size, ' running on ', name

            call test_gpu()

            do i = 1, size - 1
                call MPI_RECV (rank, 1, MPI_INTEGER, i, 1, MPI_COMM_WORLD, stat, ierr)
                call MPI_RECV (size, 1, MPI_INTEGER, i, 1, MPI_COMM_WORLD, stat, ierr)
                call MPI_RECV (namelen, 1, MPI_INTEGER, i, 1, MPI_COMM_WORLD, stat, ierr)
                name = ''
                call MPI_RECV (name, namelen, MPI_CHARACTER, i, 1, MPI_COMM_WORLD, stat, ierr)
                print *, 'Hello world: rank ', rank, ' of ', size, ' running on ', name
            enddo

        else

            call test_gpu()

            call MPI_SEND (rank, 1, MPI_INTEGER, 0, 1, MPI_COMM_WORLD, ierr)
            call MPI_SEND (size, 1, MPI_INTEGER, 0, 1, MPI_COMM_WORLD, ierr)
            call MPI_SEND (namelen, 1, MPI_INTEGER, 0, 1, MPI_COMM_WORLD, ierr)
            call MPI_SEND (name, namelen, MPI_CHARACTER, 0, 1, MPI_COMM_WORLD, ierr)

        endif

        call MPI_FINALIZE (ierr)

        end

Subroutine test_gpu()
 integer*4 :: i 
 integer*4, parameter :: N=8 , N_i=2, N_j=3, N_k=4
 !real*4, Dimension(N) :: a, b

 real*8, Dimension(N_i,N_j,N_k) :: a, b, c


 DO i=1,N_i 
        Do j=1,N_j
                Do k=1,N_k
	                a(i,j,k)=i+(j-1)*N_i+(k-1)*N_i*N_j
	                b(i,j,k)=a(i,j,k)
	                c(i,j,k)=a(i,j,k)
                        print *, 'before : i=',i,' j=',j, ' k=',k, 'a(i,j,k)=', a(i,j,k)
                END DO 
        END DO 
 END DO 

CALL kw_simple_3d_opr_(a, b, c, N_i, N_j, N_k,'+')

 DO i=1,N_i 
        Do j=1,N_j
                Do k=1,N_k
	                a(i,j,k)=i+(j-1)*N_i+(k-1)*N_i*N_j
	                b(i,j,k)=a(i,j,k)
	                c(i,j,k)=a(i,j,k)
                        print *, 'After: i=',i,' j=',j, ' k=',k, 'c(i,j,k)=', c(i,j,k)
                END DO 
        END DO 
 END DO 


END subroutine