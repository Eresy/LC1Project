// While and Do-While loops are basically the same in every language.
var j: int = 1;
var jSum: int = 0;
while( j <= 1000 ){
  jSum += j;
  j += 1;
}
writeInt( jSum );

// Do-While loop
do{
  jSum += j;
  j += 1;
}while( j <= 10000 );
writeInt( jSum );

// For loops are much like those in python in that they iterate over a range.
// Ranges themselves are types, and can be stuffed into variables
// (more about that later)
for i in 1..10 do writeInt( i );
writeInt(i );

var iSum: int = 0;
for i in 1..1000 {
  iSum += i;
}
writeInt( iSum );

for x in 1..10 {
  for y in 1..10 {
    writeInt( (x,y) );
  }
  writeln(i );
}

