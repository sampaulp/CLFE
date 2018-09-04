subroutine Sorting(root,nroot,maxrt)
implicit none

integer :: maxrt                        ! max number of roots to find
integer :: nroot
real(8),dimension(maxrt):: root         ! Array where the found roots are to be stored

real(8) :: a
integer,dimension(1) :: b
integer :: c                            ! determines the position
integer :: i                            ! Index for loop

do i=1,(nroot-1)
    a=root(i)                           ! Vector entry
    b=maxloc(root(i:nroot))             ! Read position of the maximum of the root vector
    c=b(1)+i-1                          ! Determine the position to be moved
    root(i) = root(c)                   ! maximum number of values to be written
    root(c) = a                         ! original entry will be written down to the position of maximum entry,
end do

end subroutine Sorting

