/* Check digits */
var globInt : int;
var globReal : real;

proc mySum(a : int, b : real) {
   return a += b;
   // cool stuff
}

proc mySub() {
   var tmp : real = globInt - globReal;

   for index in 1..17 {
      writeReal(tmp);
      readChar();
   }

   return tmp;
}

proc main() {
   globInt = 9999;
   globReal = 66.6;

   mySub();

   var z = 50;

   mySum(50, 50);
}
