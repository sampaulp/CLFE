! newton algorithm
!
! Input data
!   f     : function to analyse
!   x0    : starting value
!   p     : precision
!   nx    : maxium number of cycles
!   h     : step width of the derivative
!   s     : step width for vanishing slop
! Ouput data (passing by reference)
!   x     : result
!   fx    : function value
!   fsx   : derivative
! Helpers
!   io    : io-channel for logging, -1: no logging
! Return data
!   number of iterations, if -1 then not found
!
!                       --input----------
real(8) function newton(lb,x0,h,maxit,eps)

    implicit none

    real(8)::x0,x                               ! Start value of the Newton iteration, x values ​​in the course of the iteration
    real(8)::lb,h,eps                        ! Read values from the input file (lower bound,step width, precision)

    integer::maxit                              ! max iteration

    real(8)::fx,fsx                             ! Function value, gradient
    integer::i                                  ! Iteration number

    ! External functions
    real(8), external :: f                      ! Function to be calculated
    real(8), external :: fs                     ! function Tangent

    ! Initializing
    i = 0
    x=x0

    Newtonsloop: do
        i = i+1                                 ! Iterations

        if(i>maxit) then                        ! Termination of the loop if the maximum iterations exceed the given number
            newton=lb-10                        ! Value outside the interval limit given as a result
            return
        end if

        fx=f(x)                                 ! Function at x

        if (abs(fx)<eps) then                   ! Check whether the equation has reached 0
            newton=x
            return
        end if

        fsx=fs(f,x,h)                           ! Slope in x

        if(abs(fsx)<=eps) then                  ! Termination of the loop when the slope tends to 0
            newton=lb-10
        end if

        x = x-fx/fsx                            ! Determine the x value for the next iteration

    end do Newtonsloop

end function Newton

