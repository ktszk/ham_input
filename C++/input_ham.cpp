#include <iostream>
#include <fstream>
#include <complex>
#include <string>
#include <vector>

using std::string;
using std::vector;
using std::complex;
using std::cout;
using std::endl;

typedef vector<vector<double> > r_array;
typedef vector<vector<vector<complex<double> > > > ham_array;

int input_hamiltonian(string &fname, r_array &rvec,ham_array &hop,const int &flag){
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
	  std::sscanf(str.c_str(),"%lf %lf %lf %lf %lf",
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
      std::sscanf(str.c_str(),"%lf %lf %lf",&rvec[i][0], &rvec[i][1], &rvec[i][2]);
      for(int j=0; j<no;j++){
	for(int k=0;k<no;k++){
	  getline(hfile,str);
	  std::sscanf(str.c_str(),"(%lf, %lf)",&hop[k][j][i].real(), &hop[k][j][i].imag());
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
  r_array rvec(nr,vector<double>(3));
  ham_array hop(no,vector<vector<complex<double> > >(no,vector<complex<double> >(nr)));

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
