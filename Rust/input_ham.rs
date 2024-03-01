/*
Rust input Hamiltonian code
default Rust cannnot use complex, so hamiltonian import double array in this function
if you can use num trait please use input_ham_num.rs
*/

use std::str;
use std::fs::File;
use std::io::prelude::*;
use std::io::BufReader;
fn input_hamiltonian(fname: &str,sw_form: i32) -> (i32,i32,Vec< Vec<f64> >,Vec< Vec< Vec< Vec<f64> > > >) {
  let mut no=0;
  let mut nr=0;
  let mut rvec=Vec::new();
  let mut ham_tmp=Vec::new();
  match sw_form{
    0 =>{
      //.input file
      let f=File::open(fname).expect("file not found");
      let files=BufReader::new(f);
      let mut tmp=Vec::new();
      for line in files.lines(){
        let mut tmp1:[f64; 5]=Default::default();
        let mut i=0;
        for s in line.unwrap().split_whitespace(){
          let fs=s.parse::<f64>().unwrap();
          tmp1[i]=fs;
          i+=1;
        }
        tmp.push(tmp1);
      }
      let mut count=0;
      let mut sw_r=true;
      let tmp0:[f64;3]=[tmp[0][0],tmp[0][1],tmp[0][2]];
      for i in 0..tmp.len(){
        if (tmp0[0]==tmp[i][0]) & (tmp0[1]==tmp[i][1]) & (tmp0[2]==tmp[i][2]){
          count+=1;
          if count>1{
            sw_r=false
          }
        }
        if sw_r{
          rvec.push(vec![tmp[i][0],tmp[i][1],tmp[i][2]]);
        }
        ham_tmp.push(vec![tmp[i][3],tmp[i][4]]);
      }
      no=(count as f64).sqrt() as i32;
      nr=(tmp.len()/count) as i32;
    }
    1 =>{
      // rvec.txt,hop.txt, and ndegen.txt
      //input rvec
      let f=File::open(format!("{}/irvec.txt",fname)).expect("file not found");
      let files=BufReader::new(f);
      for line in files.lines(){
        let mut rtmp=vec![0 as f64; 3];
        let mut i=0;
        for s in line.unwrap().split_whitespace(){
          let fs=s.parse::<f64>().unwrap();
          rtmp[i]=fs;
          i+=1;
        }
        rvec.push(rtmp);
      }
      nr=rvec.len() as i32;
      // input ham_r.txt
      let f=File::open(format!("{}/ham_r.txt",fname)).expect("file not found");
      let files=BufReader::new(f);
      for line in files.lines(){
        let mut tmp:[f64; 2]=Default::default();
        let mut i=0;
        for s in line.unwrap().trim_matches('(').trim_matches(')').split(","){
          let fs=s.trim().parse::<f64>().unwrap();
          tmp[i]=fs;
          i+=1;
        }
        ham_tmp.push(vec![tmp[0],tmp[1]]);
      }
      no=((ham_tmp.len() as f64/nr as f64) as f64).sqrt() as i32
    }
    2 =>{
      // {case}_hr.dat
      let f=File::open(format!("{}_hr.dat",fname)).expect("file not found");
      let files=BufReader::new(f);
      let mut fiter=0;
      for _line in files.lines(){
        if fiter==1{ //get no
        }
        if fiter==2{ //get nr
        }
        fiter+=1;
      }
    }
    _ =>{
      // Hopping.dat
      let f=File::open("Hopping.dat").expect("file not found");
      let files=BufReader::new(f);
      let mut fiter=0;
      let mut rlen=0;
      no=1000;
      let mut ham_tmp=Vec::new();
      for line in files.lines(){
        if fiter==3{
          let mut i=0;
          for s in line.unwrap().split_whitespace(){
            let fs=s.parse::<i32>().unwrap();
            if i==0{
              no=fs;
            }
            if i==1{
              nr=fs;
            }
	    i+=1;
          }
        }
        else if fiter>3+no{
          let mut i=0;
	  let mut tmp:[f64; 10]=Default::default();
          for s in line.unwrap().split_whitespace(){
            let fs=s.parse::<f64>().unwrap();
            tmp[i]=fs;
            i+=1;
          }
          if rlen<nr{
            rvec.push(vec![tmp[0],tmp[1],tmp[2]]);
	  }
          ham_tmp.push(vec![tmp[8],tmp[9]]);
          rlen+=1;
        }
        fiter+=1;
      }
    }
  }
  let mut ham_r=vec![vec![vec![vec![0 as f64; 2]; no as usize]; no as usize]; nr as usize];
  let mut l=0;
  for k in 0..no{
    for j in 0..no{
      for i in 0..nr{
        let ii=i as usize;
	let jj=j as usize;
	let kk=k as usize;
        if sw_form==1{
          l=(k+no*j+no*no*i) as usize;
        }
        ham_r[ii][jj][kk][0]=ham_tmp[l][0];
        ham_r[ii][jj][kk][1]=ham_tmp[l][1];
	if sw_form==0{
          l+=1
	}
      }
    }
  }
  return (no,nr,rvec,ham_r);
}

fn main(){
  let (no,nr,rvec,ham_r)=input_hamiltonian("ham",0);
  println!("{},{}",no,nr);
  for r in rvec{
    println!("{} {} {}",r[0],r[1],r[2]);
  }
  for ham in ham_r{
    for ha in ham{
      for h in ha{
        println!("{} {}",h[0],h[1])
      }
    }
  }
}
