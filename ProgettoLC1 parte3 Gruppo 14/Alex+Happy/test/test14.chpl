proc f() {}

var fst :string = "hello";
var snd : string = "world";
var * p : void = &fst;

proc main() {
   // print world before hello to be
   writeString(snd); //              original!
   writeString(fst);
}
