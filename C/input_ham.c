#include <stdio.h>
#include <complex.h>
#include <math.h>

int input_hamiltonian(char *fname,int no, int nr,
		      double complex *hop,
		      double *rvec){
  FILE *fp;
  int i,j,k,ret;
  double t1,t2,t3,t4,t5;

  fp=fopen(fname,"r");
  if(fp==NULL){
    printf("No file!");
    return -1;
  }
  else {
    for(i=0; i<=no; i++){
      for(j=0; j<=no; j++){
	for(k=0; k<=nr; k++){
	  printf("%d %d %d\n",i,j,k);
	  ret=fscanf(fp,"%lf %lf %lf %lf %lf",t1,t2,t3,t4,t5);
	  printf("%lf %lf %lf %lf %lf \n",t1,t2,t3,t4,t5);
	}
      }
    }
  }
  fclose(fp);
  printf("%s %d %d\n",fname,no,nr);
  return 0;
}

int main(){
  const char name[256]="ham.dat";
  const int no=1, nr=4;
  int err;
  double rvec[nr][3];
  double complex hop[no][no][nr];
  err=input_hamiltonian(name,no,nr,hop,rvec);
  return 0;
}
