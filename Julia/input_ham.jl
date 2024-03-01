#!/usr/bin/env julia
#=
Julia input Hamiltonian code
=#
function import_hop(fname,sw_ndegen)
    tmp=open(fname*"/irvec.txt","r") do fp
        readlines(fp)
    end
    nr=length(tmp)
    rvec=zeros(Float64,3,nr)
    for i in 1:nr
        rvec[:,i]=parse.(Float64,split(tmp[i]))
    end
    tmp=open(fname*"/ham_r.txt","r") do fp
        readlines(fp)
    end
    no=Int(sqrt(length(tmp)/nr))
    tmp2=[parse.(Float64,split(strip(l,['\n','(',')']),',')) for l in tmp]
    tmp=[t[1]+1im*t[2] for t in tmp2]
    ham_r=zeros(Complex,nr,no,no)
    for i in 1:no
        for j in 1:no
            for k in 1:nr
                ham_r[k,j,i]=tmp[i+no*(j-1)+no*no*(k-1)]
            end
        end
    end

    if sw_ndegen
        tmps=open(fname*"/ndegen.txt","r") do fp
            readlines(fp)
        end
        ndegen=parse.(Float64,tmp)
    else
        ndegen=ones(Float64,(1,nr))
    end 
    return(rvec,ndegen,ham_r,no,nr)
end

function import_out(fname)
    tmp=open(fname,"r") do fp
        readlines(fp)
    end
    tmp1=[parse.(Float64,split(l)) for l in tmp]
    r0=tmp1[1][1:3]
    con=0
    for rr in tmp1
        if rr[1:3]==r0
            con+=1
        end
    end
    no=Int(sqrt(con))
    nr=div(length(tmp1),con)
    rvec=zeros(Float64,3,nr)
    for i in 1:nr
        for j in 1:3
            rvec[j,i]=tmp1[i][j]
        end
    end
    tmp=[tp[4]+1im*tp[5] for tp in tmp1]
    ham_r=zeros(Complex,nr,no,no)
    for i in 1:no
        for j in 1:no
            for k in 1:nr
                ham_r[k,j,i]=tmp[k+nr*(j-1)+no*nr*(i-1)]
            end
        end
    end
    ndegen=ones(Float64,1,nr)
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
