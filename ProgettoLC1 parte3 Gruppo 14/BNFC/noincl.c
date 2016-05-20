/* print the first 12 factorials */

int main () {

  int i ;
  int k ;
  i = 1 ;
  k = i ;
  int a[2]={1,3,4};
  double b[];
  int c[]={12,13};

  int *s;
  int *S= c[0] - 1;
  int p = c[0] - 1;
  while (i+p < 13) {
    k = k * i ;
    i++;
    writeInt (k) ;
  }

  return 0 ;

  }
