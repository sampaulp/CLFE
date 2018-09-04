! input function to analyse
real(8) function f (x)
    implicit none

    real(8)::x

    f=(x*(1-(3*x))*(cos(x/4)/sin(x/4)))/(2*cos(x/2)-3*sin(x/3))
    !f=(((x**7)/2)+((x**4)/7) -((x**3)/10)+(2*(x**2))-10+4)
    !f=exp(-x/6)*((1-x+(x**2))*(sin(x/2)))-exp(x/6)*(1-(2*cos(x/3)))
end
