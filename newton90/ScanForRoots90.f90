integer function ScanForRoots(lb,ub,sw,eps,h,maxit,root,maxrt,iolog)

    implicit none

    ! Variables that are read from the input file
    real(8) :: lb                           ! lower bound
    real(8) :: ub                           ! upper bound
    real(8) :: sw                           ! step width: Start value
    real(8) :: eps                          ! precision
    real(8) :: h                            ! step width: Tangents
    integer :: maxit                        ! maximum iteration
    integer :: maxrt                        ! maximum number of roots to find

    !Output file
    integer :: iolog                        !Name of Output logfile

    ! Output variables
    real(8), dimension(maxrt) :: root       ! Array where the calculated roots have to be stored

    ! External functions
    real(8), external :: newton             ! Function for the tangent
    real(8), external :: f                  ! Function to be calculated

    ! Variables for the Newtons loop
    real(8) :: x0,x                         ! Starting value in the Newtons loop
    real(8) :: xnewton                     ! Return value of the Newton Sub-routine
    integer :: i,j                          ! Index for the loop

    ! Initialization of the number of Roots to be found
    ScanForRoots=0

    ! "root" is assigned with values that are below the lower limit of "lb". The values are overwritten later.
    do i=1,maxrt
        root(i) = lb-10                     ! The sum 10 s only arbitrary, it should be greater than 1
    end do

    j=1
    x0=lb                                   ! Initialize the first start value

    ! Check the interfaceand print the input data
    if (iolog > 0) then
        write(iolog,'(a)')     "--------------------------------------------"
        write(iolog,'(a,i3)')     "Maximum no. of roots...........:",maxrt
        write(iolog,'(a,f10.4)')  "Lower bound....................:",lb
        write(iolog,'(a,f10.4)')  "Upper bound....................:",ub
        write(iolog,'(a,f10.4)')  "Step width.....................:",sw
        write(iolog,'(a,e11.3)')  "Precision......................:",eps
        write(iolog,'(a,e11.3)')  "Step width of the derivative...:",h
        write(iolog,'(a,i3)')     "Maximum no. of iterations......:",maxit
        write(iolog,'(a)')     "--------------------------------------------"
    endif

    Mainloop: do

        x = x0 + sw
        x0=x

        if (x0>ub) return

        xnewton = newton(lb,x0,h,maxit,eps)                                ! Perform the Newton loop for each starting value and return

        if(x>lb .and. x<ub)then
            if(iolog>0)then
                write(iolog,'(a,i9,a,f10.4,a,a,e12.3)')"roots",j,":",xnewton,"  , ","f(x)=",f(x)
            endif
            j=j+1
        end if

        call check(xnewton,eps,ub,lb,maxrt,root,ScanForRoots)              ! Check if root is in the interval under consideration and whether the zero point has been found previous operations

        if (ScanForRoots==maxrt) return                                    ! Terminate when the maximum number of roots are reached

    end do Mainloop

end function ScanForRoots

