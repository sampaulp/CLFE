! numerical calculation of the slope
real(8) function fs(f,x,h)
    implicit none

    real(8), external:: f
    real(8)::x,h

    fs = (f(x+h/2.) - f(x-h/2.))/h

end function
