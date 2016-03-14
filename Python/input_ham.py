#!/usr/bin/env python
#-*- coding:utf-8 -*-
from __future__ import print_function, division
def import_hop():
    import math
    tmp=[f.split() for f in open('irvec.txt','r')]
    rvec=[[float(tp[0]),float(tp[1]),float(tp[2])] for tp in tmp]
    nr=len(rvec)
    ndegen=([float(f) for f in open('ndegen.txt','r')] if True else [1]*nr)
    no=int(math.sqrt(sum(1 for line in open('ham_r.txt','r'))/nr))
    tmp=[f.strip(' ()\n').split(',') for f in open('ham_r.txt','r')]
    tmp1=[complex(float(tp[0]),float(tp[1])) for tp in tmp]
    ham_r=[[[tmp1[j+k*no+i*no*no] for k in range(no)] for j in range(no)] for i in range(nr)]
    return(rvec,ndegen,ham_r,no,nr)

def import_out(fname):
    import math
    tmp=[f.split() for f in open(fname,'r')]
    tmp1=[[float(tp) for tp in tpp] for tpp in tmp]
    tmp=[complex(tp[3],tp[4]) for tp in tmp1]
    r0=tmp1[0][:3]
    con=sum(1 if rr[:3]==r0 else 0  for rr in tmp1)
    no=int(math.sqrt(con))
    nr=len(tmp1)//con
    rvec=[tp[:3] for tp in tmp1[:nr]]
    ham_r=[[[tmp[i+j*nr+k*nr*no] for k in range(no)] for j in range(no)] for i in range(nr)]
    ndegen=[1]*nr
    return(rvec,ndegen,ham_r,no,nr)

def import_hr(name):
    tmp=[f.split() for f in open('%s_hr.dat'%name)]
    no=int(tmp[1][0])
    nr=int(tmp[2][0])
    c1=0; c2=3
    while not c1==nr:
        c1=c1+len(tmp[c2])
        c2=c2+1
    tmp1=[[int(t) for t in tp] for tp in tmp[3:c2]]
    ndegen=[]
    for tp in tmp1:
        ndegen=ndegen+tp
    tmp1=[[float(t) for t in tp] for tp in tmp[c2:]]
    tmp=[complex(tp[5],tp[6]) for tp in tmp1]
    rvec=[tmp1[no*no*i][:3] for i in range(nr)]
    ham_r=[[[tmp[k+j*no+i*no*no] for k in range(no)] for j in range(no)] for i in range(nr)]
    return(rvec,ndegen,ham_r,no,nr)
