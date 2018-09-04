! function to read the input data
integer function ireaddata(filename,maxrt,lb,ub,sw,eps,h,maxit)

    character(256)::filename     ! name of the inputfile
    real(8)::lb                  ! starting postion
    real(8)::ub                  ! starting postion
    real(8)::eps                 ! precision
    integer::maxit               ! max. iterations
    integer::maxrt               ! max. iterations
    real(8)::h                   ! step calculation the slope
    real(8)::sw                  ! step for a bad slope

    integer::io = 80             ! channel number
    integer::ioerr = 0           ! io status value

    ! open the input file
    open(io,file=filename,status='old',iostat=ioerr)
    if (ioerr /= 0) then
        write(*,*) "*** error: could not open inputfile!"
        ireaddata = -1
        return
    endif
    write (*,*) "***Input file read"

    ! read the data from the file
    read(io,*,iostat=ioerr) maxrt
    if (ioerr /= 0) then
        write (*,*) "*** error: maxrt not found!"
        ireaddata = -2
        goto 10
    endif

    if (maxrt < 1) then
        write (*,*) "*** error: bad maxit value!"
        ireaddata = -3
        goto 10
    endif

    read(io,*,iostat=ioerr) lb
    if (ioerr /= 0) then
        write (*,*) "*** error: lb not found!"
        ireaddata = -4
        goto 10
    endif

    read(io,*,iostat=ioerr) ub
    if (ioerr /= 0) then
        write (*,*) "*** error: ub not found!"
        ireaddata = -5
        goto 10
    endif

    ! read the step for bad slopes from the file
    read(io,*,iostat=ioerr) sw
    if (ioerr /= 0) then
        write (*,*) "*** error: sw not found!"
        ireaddata = -6
        goto 10
    endif

    ! read the precision data from the file
    read(io,*,iostat=ioerr) eps
    if (ioerr /= 0) then
        write (*,*) "*** error: eps not found!"
        ireaddata = -7
        goto 10
    endif

    if (eps < 0.) then
        write (*,*) "*** error: bad precision value!"
        ireaddata = -8
        goto 10
    endif

    ! read the slope step h from the file
    read(io,*,iostat=ioerr) h

    !write (*,*),h

    if (ioerr /= 0) then
        write (*,*) "*** error: h not found!"
        ireaddata = -9
        goto 10
    endif

    if (h < 0. .or. dabs(h) > 0.1) then
        write (*,*) "*** error: bad h value!"
        ireaddata = -10
        goto 10
    endif

    ! read the iteration number from the file
    read(io,*,iostat=ioerr) maxit
    if (ioerr /= 0) then
        write (*,*) "*** error: maxit not found!"
        ireaddata = -11
        goto 10
    endif

    if (maxit < 2) then
        write (*,*) "*** error: bad maxit value!"
        ireaddata = -12
        goto 10
    endif

    ! success!!!
    ireaddata = 0

    ! close the file
 10 close(io)

end function ireaddata
