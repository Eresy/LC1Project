/* arrays & pointers */

var * p : char;

proc main() {
   var myArr : [1..5, 1..7] int;  // controlla forma del cast con array
   myArr[1][7] = 99;

   proc incrPointer() {
      var **ptn2 : void;
      p += 1;
   }
}
