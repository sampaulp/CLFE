! Main program of our Newton example
!
! Modules:
!   Main program                    : newtonMain90.f90
!   Newton algorithm                : newton90.f90
!   calculate the derivative of f(x): derivative90.f90
!   read input data from a file     : read90.f90
! input:
!   function to analyse.............: function90.f90
!
program newtonMain
    implicit none

	! Input File
    integer :: maxrt          ! max number of roots to find
    real(8) :: lb             ! lower bound
    real(8) :: ub             ! upper bound
    real(8) :: sw             ! step width: Stratwerte
    real(8) :: eps            ! precision
    real(8) :: h              ! step width: Tangent
    integer :: maxit          ! max iteration

    ! Read
	character(256)::inpfile      ! name of the input file
	integer::iarg	             ! number of command options
    character(256)::arg          ! option string

    ! External functions
	integer,external::ireaddata     		   ! read the input data
    real(8), external :: f                     ! Function to be analyzed
    real(8), external :: fs                    ! Function Tangent
    integer, external :: ScanForRoots          ! Function which returns the number of roots found

    ! Output variables
    real(8), allocatable,dimension(:)::root    ! Array that saves the calculated roots
    integer :: nroot                           ! No. of Calculated roots

    ! Index for Loops
    integer :: i

    !Output file
    integer::iolog = 10          ! log channel
    character(256)::logfile      ! name of the log file

    ! initializations of input & output file
    inpfile = 'ScanForRoots.inp'
    logfile = 'FoundRoots.out'

    ! analyse the command line options
    iarg = iargc()      ! get the option number
    write(*,'(i2,a)') iarg," option(s)"

    ! print the options
    do i=0,iarg
        call getarg(i,arg)
        write (*,'(a,i2,a,a)') "option ",i,": ",arg
    enddo

    ! use the command line options
    if (iarg > 0)   call getarg(1,inpfile)
    if (iarg > 1)   call getarg(2,logfile)

    ! read the input data
    if (ireaddata(inpfile,maxrt,lb,ub,sw,eps,h,maxit) < 0) then
        write(*,*) "*** error: inputdata not found!"
        stop
    endif

	! Space allocation for the roots
    allocate(root(maxrt))

    ! open the log file
    open(iolog,file=logfile,status='replace')
    write(iolog,*) '>> Lets Start logging...'

    ! Calling ScanForRoots file
    nroot = ScanForRoots(lb,ub,sw,eps,h,maxit,root,maxrt,iolog)

    ! Sorting arrays of zeros starting with the largest x
    if (nroot>1) then
        call Sorting(root,nroot,maxrt)
    end if

    ! Creating output

    ! Write input variables
    write(*,*)
    write(*,*)'Input Data: '
    write(*,*)'--------------------------------------------'
    write(*,'(a,i15)')  'Maximum no. of roots:........',maxrt
    write(*,'(a,f15.8)')'Lower Interval bound:........',lb
    write(*,'(a,f15.8)')'Upper Interval bound:........',ub
    write(*,'(a,f15.8)')'Increment of x:..............',sw
    write(*,'(a,f15.8)')'Precision:...................',eps
    write(*,'(a,f15.8)')'Increment of Tangent:.......',h
    write(*,'(a,i15)')  'Maximum no. of Iterations:...',maxit
    write(*,*)'--------------------------------------------'
    write(*,*)
    write(*,*)'Output : '
    write(*,*)'--------------------------------------------'
    write(*,'(a,i15)')  'No. of roots found: ',nroot
    write(*,*)'--------------------------------------------'
    write(iolog,*)'--------------------------------------------'
    write(iolog,*)'Roots after removing repeated values'

    ! Output of the roots
    if (nroot==0) then
        write(*,*)'No roots can be calculated'
    else
        do i = 1, (nroot)
            write(*,'(a,i15,a,f10.4)')'Root',i,':',root(i)
            write(iolog,'(a,i15,a,f10.4)')'Root',i,'--->',root(i)
        end do
    end if

    write(iolog,*)'--------------------------------------------'

    if (nroot == maxrt) then
        write(*,*)
        write(*,'(a,i15)')'Waring : There can be more roots in the given interval!'
        write(*,'(a,i15)')'Increase the value numbroots!'
    end if

    deallocate(root)                                   ! Deleting the allocated spaces and making it free again

    ! close the log file
    write(iolog,*) '>> Close log file...'
    close(iolog)

end program

