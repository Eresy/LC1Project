// This program SHOULD print N numbers

var user_input$ : int;

proc main() {
   try {
      user_input$ = readInt();
   } catch {
      var error : string;
      writeString(error);
   }

   if (user_input$ != -1) then print(user_input$);
   else return -1; 
}

proc print(v : int) {
   do {
      writeInt(v);
      v -= 1;
   } while (v > 0);
}
