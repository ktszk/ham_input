#include <stdio.h>
#include <string.h>
#include <complex.h>
#include <math.h>

int input_hamiltonian(char fname[],int no, int nr,
		      double complex hop[][no][nr],
		      double rvec[][3],int flag){
  FILE *fp,*fp2;
  int i,j,k;
  double t1,t2;
  char rname[128],hname[128];
  char *err,line[256];

  switch(flag){
  case 1:{
    fp=fopen(fname,"r");
    if(fp==NULL){
      printf("No file!");
      return -1;
    }
    for(i=0; i<no; i++){
      for(j=0; j<no; j++){
	for(k=0; k<nr; k++){
	  err=fgets(line,256,fp);
	  sscanf(line,"%lf %lf %lf %lf %lf",
		     &rvec[k][0],&rvec[k][1],&rvec[k][2],&t1,&t2);
	  hop[i][j][k]=t1+I*t2;
	}
      }
    }
    fclose(fp);
    break;
  }
  case 2:{
    strcpy(rname,fname);
    strcpy(hname,fname);
    strcat(rname,"/irvec.txt");
    strcat(hname,"/ham_r.txt");
    fp=fopen(rname,"r");
    if(fp==NULL){
      printf("No file!");
      return -1;
    }
    fp2=fopen(hname,"r");
    if(fp2==NULL){
      printf("No file!");
      return -1;
    }
    for(i=0; i<nr; i++){
      err=fgets(line,256,fp);
      sscanf(line,"%lf %lf %lf",&rvec[i][0],&rvec[i][1],&rvec[i][2]);
      for(j=0; j<no;j++){
        for(k=0;k<no;k++){
	  err=fgets(line,256,fp2);
	  sscanf(line,"(%lf, %lf)",&t1,&t2);
	  hop[k][j][i]=t1+I*t2;
        }
      }
    }
    fclose(fp);
    fclose(fp2);
    break;
  }
  case 3:{
    break;
  }
  }
  return 0;
}

int main(){
  const char name[128]="ham.dat";
  const int no=1, nr=4, flag=1;
  int err,i,j,k;
  double rvec[nr][3];
  double complex hop[no][no][nr];

  err=input_hamiltonian(name,no,nr,hop,rvec,flag);
  for(i=0; i<no; i++){
    for(j=0; j<no; j++){
      for(k=0; k<nr; k++){
	printf("%lf %lf %lf %lf %lf \n",rvec[k][0],rvec[k][1],rvec[k][2],
	       creal(hop[i][j][k]),cimag(hop[i][j][k]));
      }
    }
  }

  return 0;
}
