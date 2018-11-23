#!/usr/bin/env julia
function import_hop(fname,sw_ndegen)
    tmp=open(fname*"/irvec.txt","r") do fp
        readlines(fp)
    end
    rvec=[float64(split(l)) for l in tmp]
    tmps=open(fname*"/ham_r.txt","r") do fp
        readlines(fp)
    end
    tmps=[float64(split(strip(l,['\n','(',')']),',')) for l in tmps]
    ham_r=[complex64(t[1],t[2]) for t in tmps]
    nr=length(rvec)
    no=int(sqrt(length(ham_r)/nr))
    ham_r=reshape(ham_r,no,no,nr)
    if sw_ndegen
        tmps=open(fname*"/ndegen.txt","r") do fp
            readlines(fp)
        end
        ndegen=[float64(l) for l in tmp]
    else
        ndegen=[1 for i in 1:nr]
    end 
    return(rvec,ndegen,ham_r,no,nr)
end

function import_out(fname)
    tmp=open(fname,"r") do fp
        readlines(fp)
    end
    tmp1=[float64(split(l)) for l in tmp]
    r0=tmp1[1][1:3]
    con=0
    for rr in tmp1
        if rr[1:3]==r0
            con=con+1
        end
    end
    no=int(sqrt(con))
    nr=div(length(tmp1),con)
    rvec=[tp[1:3] for tp in tmp1[1:nr]]
    ham_r=reshape([complex64(tp[4],tp[5]) for tp in tmp1],nr,no,no)
    ndegen=[1 for i in 1:nr]
    return(rvec,ndegen,ham_r,no,nr)
end

function import_hr(fname):
    tmp=open(fname*"_hr.dat","r") do fp
        readlines(fp)
    end
    no,nr=int(tmp[2]),int(tmp[3])
end

function import_Hopping():
    tmp=open("Hopping.dat","r") do fp
        readlines(fp)
    end
    axis=[float64(split(l)) for l in tmp[2:5]]
    no,nr,nor=int(split(tmp[5]))
    tmp1=[float64(split(l)) for l in tmp[7+no:]]
    rvec=[tmp[no*no*i][:3] for i in 1:nr]
    ham_r=reshape([complex64(tp[9],tp[10]) for tp in tmp1],nr,no,no)
    return(rvec,ndegen,ham_r,no,nr,axis)
end
