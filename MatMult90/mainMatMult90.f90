! read 2 matrices form an input file
! multiply them and write the results to
! an output file
program mainMatMult90
    implicit none

    integer::ioin=10             ! input channel
    integer::ioout=11            ! output channel
    integer::nMatrix
    integer::i=1
    integer::m,n,check=1

    integer::ioerr                ! error handler for io
    integer::memerr               ! error handler for memory allocation

    ! static array
    integer,dimension(2)::nDimA     ! dimension of matrix A
    integer,dimension(2)::nDimB     ! dimension of matrix B
    integer,dimension(2)::nDimC     ! dimension of matrix C

    ! dynamical arrays
    real(8), allocatable, dimension(:,:)::A
    real(8), allocatable, dimension(:,:)::B
    real(8), allocatable, dimension(:,:)::C

    ! functions declares
    integer::ireadmatdim, ireadmat, imatmult, ireadnmat

    ! filename strings
    character(256)::infile
    character(256)::outfile
    character(len=26)::Matname

    ! for Matrix naming
    Matname = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    ! iniatialize
    infile  = "MatMult90.in"
    outfile = "MatMult90.out"

    ! read the command options
    if (iargc() > 0)    call getarg(1,infile)
    if (iargc() > 1)    call getarg(2,outfile)

    write (*,*) 'Matrix Multiplication Program'

    ! open the inputfile
    open(ioin,file=infile,status='old',iostat=ioerr)
    if (ioerr /= 0) then
        write(*,*)'error: file ',infile(1:len_trim(infile)),' not found!'
        stop
    endif

    ! open the output file
    open(ioout,file=outfile,status='replace',iostat=ioerr)
    if (ioerr /= 0) then
        write(*,*)'error: file ',outfile(1:len_trim(outfile)),' not found!'
        stop
    endif

    write (*,*) '* Input/Output file opened'

    !read the number of matrix
    if (ireadnmat(ioin,nMatrix) /= 0) then
        write(*,*)'error: Number of matrix is not given!'
        stop
    endif

	!Prepare the first matrix and display
    if (ireadmatdim(ioin,nDimA) /= 0) then
        write(*,*)'error: no dimension for matrix,',i
        stop
    endif

    write (*,*) '* Input data read and checked for errors'

    ! allocate the memory for matrix A
    allocate(A(nDimA(1),nDimA(2)),stat=memerr)
    if (memerr /= 0) then
        write(*,*)'allocation error for matrix',i
        stop
    endif

    ! read matrix A
    if (ireadmat(ioin,A,nDimA) /= 0) then
        write(*,*)'error reading matrix',i
        stop
    endif

    write(ioout,*)'-----------------------------------'
    write(ioout,*)'--------- Input Matrices ----------'
    write(ioout,*)'-----------------------------------'
    call listmat(ioout,Matname(i:i),A,nDimA)

    !Prepare the other matrices and display
    do i = 2,nMatrix
        ! read Matrix B
        if (ireadmatdim(ioin,nDimB) /= 0) then
            write(*,*)'error: no dimension for matrix',i
            stop
        endif

        ! allocate the memory for matrix B
        allocate(B(nDimB(1),nDimB(2)),stat=memerr)
        if (memerr /= 0) then
            write(*,*)'allocation error for matrix',i
            stop
        endif

        ! read matrix B
        if (ireadmat(ioin,B,nDimB) /= 0) then
            write(*,*)'error reading matrix',i
            stop
        endif

        call listmat(ioout,Matname(i:i),B,nDimB)

        ! check the dimension
        check = check + 1
        if (nDimA(2) /= nDimB(1)) then
            write(*,*)'error: wrong matrix dimension!', check
            stop
        end if

        ! allocate the memory for matrix i
        allocate(C(nDimA(1),nDimB(2)),stat=memerr)
        if (memerr /= 0) then
            write(*,*)'allocation error for matrix sum'
            stop
        endif

        ! multiply the matrices
        if (imatmult(A,B,C,nDimA,nDimB) /= 0) then
            write(*,*)'dimension error, no product available!'
            stop
        endif

        ! print the matrixdata of C
        nDimC(1) = nDimA(1)
        nDimC(2) = nDimB(2)

        !Helper Matrix
        deallocate(A,stat=memerr)

        ! reshape the dimension for A
        allocate(A(nDimC(1),nDimC(2)),stat=memerr)
        if (memerr /= 0) then
            write(*,*)'allocation error in reshaping matrix'
            stop
        endif

        nDimA(1) = nDimC(1)
        nDimA(2) = nDimC(2)

        !copy A to C
        do m = 1, nDimA(1)
            do n =1, nDimA(2)
                A(m,n) = C(m,n)
            end do
        end do

        deallocate(B,stat=memerr)
        deallocate(C,stat=memerr)

    end do

    write (*,*) '* Matrix multiplied'
    write (*,'(a,a,a)')' ', '* Output data written to log-file -', outfile
    write (*,'(a,i1)') 'No. of Matrix multiplied -',nMatrix

    !Output Matrix
    write(ioout,*)'-----------------------------------'
    write(ioout,*)'---------Output Result-------------'
    write(ioout,*)'-----------------------------------'
    call listmat(ioout,"Output",A,nDimA)

    ! close the files
    close(ioin)
    close(ioout)

end program

