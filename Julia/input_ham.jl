#!/usr/bin/env julia
function import_hop(fname,sw_ndegen)
    tmp=open(fname*"/irvec.txt","r") do fp
        readlines(fp)
    end
    tmp2=[split(l) for l in tmp]
    rvec=[[parse(Float64,l) for l in ll]  for ll in tmp2]
    nr=length(rvec)
    tmps=open(fname*"/ham_r.txt","r") do fp
        readlines(fp)
    end
    tmp2=[split(strip(l,['\n','(',')']),',') for l in tmps]
    tmps=[parse(Float64,t[1])+1im*parse(Float64,t[2]) for t in tmp2]
    no=Int(sqrt(length(tmps)/nr))
    ham_r=zeros(Complex,nr,no,no)
    for i in 1:no
        for j in 1:no
            for k in 1:nr
                ham_r[k,j,i]=tmps[k+nr*(j-1)+no*nr*(i-1)]
            end
        end
    end

    for l in ham_r
        println(l)
    end
    if sw_ndegen
        tmps=open(fname*"/ndegen.txt","r") do fp
            readlines(fp)
        end
        ndegen=[float64(l) for l in tmp]
    else
        ndegen=ones(Float64,(1,nr))
    end 
    return(rvec,ndegen,ham_r,no,nr)
end

function import_out(fname)
    tmp=open(fname,"r") do fp
        readlines(fp)
    end
    tmp1=[split(l) for l in tmp]
    r0=[parse(Float64,t) for t in tmp1[1][1:3]]
    con=0
    for rr in tmp1
        if rr[1:3]==r0
            con=con+1
        end
    end
    no=int(sqrt(con))
    nr=div(length(tmp1),con)
    rvec=[[parse(Float64,t) for t in tp[1:3]] for tp in tmp1[1:nr]]
    ham_r=reshape([parse(Float64,tp[4])+1im*parse(Float64,tp[5]) for tp in tmp1],(nr,no,no))
    ndegen=ones(Float64,(1,nr))
    return(rvec,ndegen,ham_r,no,nr)
end

function import_hr(fname)
    tmp=open(fname*"_hr.dat","r") do fp
        readlines(fp)
    end
    no,nr=int(tmp[2]),int(tmp[3])
    return(no,nr)
end

function import_Hopping()
    tmp=open("Hopping.dat","r") do fp
        readlines(fp)
    end
    tmp1=[split(l) for l in tmp[2:5]]
    axis=[[parse(Float64,l) for l in tp] for tp in tmp1]
    tmp1=split(tmp[5])
    no=parse(Int,tmp1[1])
    nr=parse(Int,tmp1[2])
    nor=parse(Int,tmp1[3])
    tmp1=[tmp[no*no*i][:3] for i in 1:nr]
    rvec=[[parse(Float64,l) for l in tp] for tp in tmp1]
    tmp1=[split(l) for l in tmp[(7+no):end]]
    ham_r=reshape([parse(Float64,tp[9])+1im*parse(Float64,tp[10]) for tp in tmp1],nr,no,no)
    return(rvec,ndegen,ham_r,no,nr,axis)
end
