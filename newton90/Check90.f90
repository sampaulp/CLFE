subroutine check(newton,eps,ub,lb,maxrt,root,ScanForRoots)

    implicit none

    real(8)::newton                               ! Root found in the Newton loop
    real(8)::eps,ub,lb                              ! precision, upper bound, lower bound
    integer::maxrt,ScanForRoots                     ! Maximum number of roots to be found, No. of rots calculated
    integer::i                                      ! Index
    real(8), dimension(maxrt) :: root               ! Vector for storing the roots

    ! external functions
    real(8), external :: f                           ! function to be analyzed

    if (abs(f(newton)) < eps .and. newton<=ub .and. newton>=lb) then

        checkloop: do i=1,maxrt

            if (abs(newton-root(i))<(0.001)) return        ! Check whether the root has been calculated or not

            if (i==maxrt) then
                ScanForRoots = ScanForRoots+1                ! Counter for increasing the no.of roots found
                root(ScanForRoots)=newton                  ! Saving the calculated root
                if (ScanForRoots==maxrt) return              ! If the maximum number has been found, then return
            end if

        end do checkloop

    end if

end subroutine check
