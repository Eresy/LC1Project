/* Hello World in Chapel */
var fst = "hello";
var snd : string = "world";

proc main() {
   // print world before hello to be
   writeString(snd); //              original!
   writeString(fst);
}
