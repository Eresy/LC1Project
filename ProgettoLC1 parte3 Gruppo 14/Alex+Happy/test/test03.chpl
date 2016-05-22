var                         a : real;
var *p : void;
var arr: [1..4] char;

proc b4r: void { 
   try {
      return 2+2;
   } catch {
      a+2;
   }
}

proc main() {
   for i in 29..77 do writeReal(a);
}

