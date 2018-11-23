      !
      !>input hamiltonian from file
      !
      subroutine input_hamiltonian(file_name,hop,rvec,nr,no,inflag)
        implicit none
        integer(4),intent(in):: nr,no,inflag
        real(8),intent(out):: rvec(3,nr)
        complex(8),intent(out):: hop(nr,no,no)
        character(len=*),intent(in):: file_name

        integer(4) i,j,k,l,m
        real(8),allocatable::ndegen(:)
        real(8):: tmp(3),h_real,h_imag
        character(10) dum

        hop=0.0d0
        select case(inflag)
        case(1)
           Open(100,file=trim(adjustl(file_name)),status='old')
           do i=1,no
              do j=1,no
                 do  k=1,nr
                    !read(100,'(2(E15.8,1X),2(E22.15,1X))')& !2D input
                    read(100,'(3(E10.3,1X),2(E22.15,1X))')& !3D input
                         rvec(1,k),rvec(2,k),rvec(3,k),hop(k,i,j)
                 end do
              end do
           end do
           close(100)
        case(2)
           Open(100,file=trim(adjustl(file_name))//'/ham_r.txt',status='old')
           Open(101,file=trim(adjustl(file_name))//'/irvec.txt',status='old')
           do i=1,nr
              read(101,*)rvec(1:3,i)
              do j=1,no
                 do  k=1,no
                    read(100,*)hop(i,j,k)
                 end do
              end do
           end do
           close(100)
           close(101)
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
           read(100,'(15F5.0)')(ndegen(i),i=1,nr)
           do  i=1,nr
              do j=1,no
                 do k=1,no
                    read(100,'(3F5.0,2I5,2F12.6)') rvec(:,i),l,m,h_real,h_imag
                    hop(i,k,j)=cmplx(h_real,h_imag)/ndegen(i)
                 end do
              end do
           end do
           deallocate(ndegen)
           close(100)
        case(4)
           Open(100,file='Hopping.dat',status='old')
           read(100,*)
           do i=1,3
              read(100,*)
           end do
           read(100,*) l,m,i
           if(.not. no==l)then
              print *,'orbital number conflict between input and hamiltonian'
              stop
           end if
           if(.not. nr==m)then
              print *,'number of hoppings conflict between input and hamiltonian'
              stop
           end if
           read(100,*)
           read(100,*)
           do i=1,no
              read(100,*)
           end do
           do  k=1,nr
              do i=1,no
                 do j=1,no
                    read(100,*)rvec(k,:),tmp(:),l,m,h_real,h_imag
                    hop(k,i,j)=cmplx(h_real,h_imag)
                 end do
              end do
           end do
           close(100)
        case default
           write(*,*) "wrong input flag"
           stop
        end select

        return
      end subroutine input_hamiltonian
