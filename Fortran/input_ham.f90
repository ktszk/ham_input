      !
      !>input hamiltonian from file
      !
      subroutine input_hamiltonian(hop,rvec,nr,no,inflag,file_name,sb2c)
        implicit none
        integer(4),intent(in):: nr,no,inflag
        logical(4),intent(in):: sb2c
        real(8),intent(out):: rvec(nr,3)
        complex(8),intent(out):: hop(nr,no,no)
        character(len=*),intent(in):: file_name

        integer(4) i,j,k,l,m
        logical(4) flag
        real(8) dumi,dumr !imaginary/real part of hoppings
        real(8),allocatable::ndegen(:)
        character(10) dum

        hop=0.0d0
        flag=.True. !for Wein2k
        !flag=.False. !for Quantum Espresso

        select case(inflag)
        case(2)
           Open(100,file=trim(adjustl(file_name))//'/ham_r.txt',status='old')
           Open(101,file=trim(adjustl(file_name))//'/irvec.txt',status='old')
           do i=1,nr
              read(101,*)rvec(i,1:3)
              do j=1,no
                 do  k=1,no
                    read(100,*)hop(i,j,k)
                 end do
              end do
           end do
           close(100)
           close(101)
        case(1)
           Open(100,file=trim(adjustl(file_name)),status='old')
           do i=1,no
              do j=1,no
                 do  k=1,nr
                    !read(100,'(2(E15.8,1X),2(E22.15,1X))')& !2D input
                    read(100,'(3(E10.3,1X),2(E22.15,1X))')& !3D input
                         rvec(k,1),rvec(k,2),rvec(k,3),hop(k,i,j)
                 end do
              end do
           end do
           close(100)
        case(3)
           Open(100,file=trim(adjustl(file_name))//'_hr.dat',status='old')
           read(100,*)
           read(100,*)l !no
           read(100,*)m !nr
           if(.not. no==l)then
              print *,'orbital number conflict between input and hamiltonian'
              stop
           end if
           if(.not. nr==m)then
              print *,'number of hoppings conflict between input and hamiltonian'
              stop
           end if
           allocate(ndegen(nr))
           read(100,'(15I5)')(ndegen(i),i=1,nr)
           do  i=1,nr
              do j=1,no
                 do k=1,no
                    read(100,'(5I5,2F12.6)') rvec(i,:),l,m,hop(i,k,j)
                    hop(i,k,j)=hop(i,k,j)/ndegen(i)
                 end do
              end do
           end do
           deallocate(ndegen)
           close(100)
        case default
           write(*,*) "input flag is wrong"
           stop
        end select

        if(inflag/=0)then
           do  k=1,no
              do j=1,no
                 do i=1,nr
                    l=int(dble(hop(i,j,k))*1.0d6)
                    m=int(imag(hop(i,j,k))*1.0d6)
                    hop(i,j,k)=cmplx(dble(l)*1.0d-6,dble(m)*1.0d-6)
                 end do
              end do
           end do
        end if

        if(sb2c)call bcc2desc(rvec,nr,flag)

        return
      contains
        !
        !> this subroutine projects BCC/BCT base to Cartesian base
        !
        subroutine bcc2desc(r,M,flag)
          implicit none
          integer(4),intent(in):: M
          logical(4),intent(in):: flag
          real(8),intent(inout):: r(M,3)

          integer(4) i
          real(8),dimension(M,3):: re

          do i=1,M
             if(flag)then !for wien2k
                re(i,1)=(-r(i,1)+r(i,2)+r(i,3))
                re(i,2)=(r(i,1)-r(i,2)+r(i,3))
                re(i,3)=(r(i,1)+r(i,2)-r(i,3))
             else !for Quantum Espresso
                re(i,1)=(r(i,1)+r(i,2)-r(i,3))
                re(i,2)=(-r(i,1)+r(i,2)-r(i,3))
                re(i,3)=(r(i,1)+r(i,2)+r(i,3))
             end if
             r(i,1)=(re(i,1)-re(i,2))*0.5d0
             r(i,2)=(re(i,1)+re(i,2))*0.5d0
             r(i,3)=re(i,3)
          end do

          return
        end subroutine bcc2desc
      end subroutine input_hamiltonian
