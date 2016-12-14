#include <iostream>
#include <fstream>
#include <complex>
#include <string>
#include <boost/multi_array.hpp>

using std::string;
using std::complex;
using std::cout;
using std::endl;

typedef boost::multi_array<double,2> rarray;
typedef boost::multi_array<complex<double>,3> harray;
//using rarray = boost::multi_array<double,2>; // for C++11 or later
//using harray = boost::multi_array<complex<double>,3>; //for C++11 or later

int input_hamiltonian(string &fname, rarray &rvec, harray &hop, const int &flag){
  const int no=hop.size(), nr=rvec.size();
  string fname_tmp,str;
  switch(flag){
  case 1:{
    fname_tmp=fname;
    break;
  }
  case 2:{
    fname_tmp=fname+"/irvec.txt";
    break;
  }
  case 3:{
    fname_tmp=fname+"_hr.dat";
    break;
  }
  case 4:{
    fname_tmp="Hopping.dat";
  }
  }
  std::ifstream rfile(fname_tmp.c_str(),std::ios::in);
  if(rfile.fail()){
    cout<<"fail input file"<<endl;
    return -1;
  }

  switch(flag){
  case 1:{
    for(int i=0; i<no; i++){
      for(int j=0; j<no;j++){
	for(int k=0;k<nr;k++){
	  getline(rfile,str);
	  sscanf(str.c_str(),"%lf %lf %lf %lf %lf",
		      &rvec[k][0], &rvec[k][1], &rvec[k][2],
		      &hop[j][i][k].real(), &hop[j][i][k].imag());
	}
      }
    }
    break;
  }
  case 2:{
    std::ifstream hfile((fname+"/ham_r.txt").c_str(),std::ios::in);
    if(hfile.fail()){
      cout<<"fail input file"<<endl;
      return -1;
    }
    for(int i=0; i<nr; i++){
      getline(rfile,str);
      sscanf(str.c_str(),"%lf %lf %lf",&rvec[i][0], &rvec[i][1], &rvec[i][2]);
      for(int j=0; j<no;j++){
	for(int k=0;k<no;k++){
          getline(hfile,str);
          sscanf(str.c_str(),"(%lf, %lf)",&hop[k][j][i].real(), &hop[k][j][i].imag());
	}
      }
    }
    break;
  }
  case 3:{
    break;
  }
  case 4:{
    int l,m;
    double tmp[3];
    for(int i=0;i<7+no;i++){
      getline(rfile,str);
    }
    for(int i=0;i<nr;i++){
      for(int j=0;j<no;j++){
	for(int k=0;k<no;k++){
	  getline(rfile,str);
	  sscanf(str.c_str(),"%lf %lf %lf %lf %lf %lf %ld %ld %lf %lf",
		 &rvec[i][0], &rvec[i][1], &rvec[i][2],
		 &tmp[0], &tmp[1], &tmp[2], &l, &m,
		 &hop[k][j][i].real(), &hop[k][j][i].imag());
	}
      }
    }
    break;
  }
  }
  return 0;
}

int main(){
  static const int no=1,nr=4,flag=1;

  int err;
  string fname="ham.dat";
  rarray rvec(boost::extents[nr][3]);
  harray hop(boost::extents[no][no][nr]);

  err=input_hamiltonian(fname,rvec,hop,flag);
  for(int i=0; i<nr; i++){
    for(int j=0;j<3; j++){
      cout<<rvec[i][j]<<" ";
    }
    for(int j=0; j<no;j++){
      for(int k=0;k<no;k++){
	cout<<hop[k][j][i];
      }
    }
    cout<<endl;
  }
  return 0;
}
