#!/usr/bin/env python
#-*- coding:utf-8 -*-
#if you can use only standard library, please use this script
from __future__ import print_function, division
"""
fname: input file name
sw_hoplist: switch hopping order if True [nr,no,no] else [no,no,nr] default True
no is number of orbitals. nr is number of hopping matrices. 
sw_ndegen: import_hop only, select lead ndegen from ndegen.txt (True) or not (False) default False
"""
def import_hop(fname,sw_ndegen=False):
    import math
    tmp=[f.split() for f in open(fname+'/irvec.txt','r')]
    rvec=[[float(tt) for tt in tp] for tp in tmp]
    tmp=[f.strip(' ()\n').split(',') for f in open(fname+'/ham_r.txt','r')]
    nr=len(rvec)
    no=int(math.sqrt(len(tmp)/nr))
    tmp1=[complex(float(tp[0]),float(tp[1])) for tp in tmp]
    ham_r=[[[tmp1[k+j*no+i*no*no] for k in range(no)] for j in range(no)] for i in range(nr)]
    ndegen=([float(f) for f in open(fname+'/ndegen.txt','r')] if sw_ndegen else [1]*nr)
    return(rvec,ndegen,ham_r,no,nr)

def import_out(fname):
    import math
    tmp=[f.split() for f in open(fname,'r')]
    tmp1=[[float(tp) for tp in tpp] for tpp in tmp]
    tmp=[complex(tp[3],tp[4]) for tp in tmp1]
    r0=tmp1[0][:3]
    con=sum(1 if rr[:3]==r0 else 0  for rr in tmp1)
    no,nr=int(math.sqrt(con)),len(tmp1)//con
    rvec=[tp[:3] for tp in tmp1[:nr]]
    ham_r=[[[tmp[i+j*nr+k*nr*no] for k in range(no)] for j in range(no)] for i in range(nr)]
    ndegen=[1]*nr
    return(rvec,ndegen,ham_r,no,nr)

def import_hr(name):
    tmp=[f.split() for f in open('%s_hr.dat'%name)]
    no,nr=int(tmp[1][0]),int(tmp[2][0])
    c2,tmp1=3,[]
    while not len(tmp1)==nr:
        tmp1.extend(tmp[c2])
        c2=c2+1
    ndegen=[[int(t) for t in tp] for tp in tmp1]
    tmp1=[[float(t) for t in tp] for tp in tmp[c2:]]
    tmp=[complex(tp[5],tp[6]) for tp in tmp1]
    rvec=[tmp1[no*no*i][:3] for i in range(nr)]
    ham_r=[[[tmp[k+j*no+i*no*no] for k in range(no)] for j in range(no)] for i in range(nr)]
    return(rvec,ndegen,ham_r,no,nr)

def import_Hopping():
    tmp=[f.split() for f in open('Hopping.dat','r')]
    axis=[[float(tp) for tp in tpp] for tpp in tmp[1:4]]
    no,nr=int(tmp[4][0]),int(tmp[4][1])
    ndegen=[1]*nr
    tmp1=[[float(t) for t in tp] for tp in tmp[6+no:]]
    rvec=[tmp1[no*no*i][:3] for i in range(nr)]
    tmp=[complex(tp[8],tp[9]) for tp in tmp1]
    ham_r=[[[tmp[k+j*no+i*no*no] for k in range(no)] for j in range(no)] for i in range(nr)]
    return(rvec,ndegen,ham_r,no,nr,axis)
