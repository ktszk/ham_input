#include <iostream>
#include <fstream>
#include <complex>
#include <string>

int input_hamiltonian(std::string &fname, int no, int nr, 
		      std::complex<double> hop[no][no][nr], double rvec[nr][3],int flag){
  using std::cout;
  using std::endl;
  std::string str;
  std::ifstream rfile, hfile;
  std::string fname_tmp; 

  switch(flag){
  case 1:
    fname_tmp=fname;
    break;
  case 2:
    fname_tmp=fname+"/irvec.txt";
    break;
  case 3:
    fname_tmp=fname+"_hr.dat";
    break;
  }
  rfile.open(fname_tmp.c_str(),std::ios::in);
  if(rfile.fail()){
    cout<<"fail input file"<<endl;
    return -1;
  }
  switch(flag){
  case 1:
    for(int i=0; i<no; i++){
      for(int j=0; j<no;j++){
	for(int k=0;k<nr;k++){
	  std::getline(rfile,str);
	  std::sscanf(str.c_str(),"%lf %lf %lf %lf %lf",&rvec[k][0], &rvec[k][1], &rvec[k][2],
		      &hop[j][i][k].real(), &hop[j][i][k].imag());
	}
      }
    }
    break;
  case 2:
    hfile.open((fname+"/ham_r.txt").c_str(),std::ios::in);
    if(hfile.fail()){
      cout<<"fail input file"<<endl;
      return -1;
    }
    for(int i=0; i<nr; i++){
      std::getline(rfile,str);
      std::sscanf(str.c_str(),"%lf %lf %lf",&rvec[i][0], &rvec[i][1], &rvec[i][2]);
      for(int j=0; j<no;j++){
	for(int k=0;k<no;k++){
	  std::getline(hfile,str);
	  std::sscanf(str.c_str(),"(%lf, %lf)",&hop[k][j][i].real(), &hop[k][j][i].imag());
	}
      }
    }
    break;
  case 3:
    break;
  }
  return 0;
}

int main(){
  using std::cout;
  using std::endl;
  static const int no=5,nr=729*2,flag=1;

  int err;
  double rvec[nr][3];
  std::string fname="ham.dat";
  std::complex<double> hop[no][no][nr];

  err=input_hamiltonian(fname,no,nr,hop,rvec,flag);
  for(int i=0; i<nr; i++){
    for(int j=0;j<3; j++){
      cout<<rvec[i][j]<<" ";
    }
    for(int j=0; j<no;j++){
      for(int k=0;k<no;k++){
	cout<<hop[k][j][i]<<endl;
      }
    }
  }
  return 0;
}
