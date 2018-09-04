! f90 library for our matmult project
!
integer function ireadmatdim(io,nDim)

    integer::io                 ! input channel
    integer,dimension(2)::nDim  ! array dimension

!   free format: item separated by white spaces
    read(io,*,iostat=ioerr) nDim(1),nDim(2)
    if (ioerr /= 0) then
        ireadmatdim = 1
        return
    endif

    ireadmatdim = 0

end function ireadmatdim


integer function ireadnmat(io,nMatrix)

    integer::io                	   ! input channel
    integer,dimension(1)::nMatrix  ! array dimension

!   free format: item separated by white spaces
    read(io,*,iostat=ioerr) nMatrix
    if (ioerr /= 0) then
        ireadnmat = 1
        return
    endif

    ireadnmat = 0

end function ireadnmat

! read the matrix data from a text file
integer function ireadmat(io,mat,ndim)

    integer::io                             ! io channel
    integer,dimension(2)::ndim
    real(8),dimension(ndim(1),ndim(2))::mat ! matrix buffer

    ! read the values of the lines
    do i=1,ndim(1)
        read(io,*,iostat=ioerr) (mat(i,j),j=1,ndim(2))
        if (ioerr /= 0) then
            write (*,'(a,i2)') 'error: reading matrix data in line ',i
            ireadmat = 1
            return
        endif
    end do

    ireadmat = 0
end function ireadmat

! subprogram to print the matrix data to the screen
subroutine listmat(io,title,mat,ndim)

    character(*):: title
    integer::io
    integer,dimension(2)::ndim
    real(8),dimension(ndim(1),ndim(2))::mat ! matrix buffer
    character*(256) ofmt
    write(ofmt,'(a,i4,a)') '(',ndim(2),'(3x,f20.2))'

    write(io,'(a,a)') 'Matrix -',title
    do i=1,ndim(1)
        write(io,ofmt) (mat(i,j),j=1,ndim(2))
    end do

    if (title == 'Output') then
        write(*,'(a,a)') 'Matrix -',title
    do i=1,ndim(1)
        write(*,ofmt) (mat(i,j),j=1,ndim(2))
    end do
    end if

end subroutine listmat

! function to multiply 2 matrices
! c = a x b
integer function imatmult(a,b,c,nDimA,nDimB)

    integer, dimension(2)::nDimA,nDimB          ! dimension of matrix a and b
    real(8), dimension(nDimA(1),nDimA(2))::a    ! matrix a
    real(8), dimension(nDimB(1),nDimB(2))::b    ! matrix b
    real(8), dimension(nDimA(1),nDimB(2))::c    ! matrix c

    ! check the dimensions
    if (nDimA(2) /= nDimB(1)) then
        imatmult = 1
        return
    endif

    ! - over all rows of a (c)
    do i=1,nDimA(1)

        ! - over all columns of b (c)
        do j=1,nDimB(2)

            c(i,j) = 0.
            do k=1,nDimA(2)
                c(i,j) = c(i,j) + a(i,k)*b(k,j)
            enddo
        enddo
    enddo
    imatmult = 0

end function imatmult




