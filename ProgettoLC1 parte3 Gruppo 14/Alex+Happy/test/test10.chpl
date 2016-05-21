// Associative domains act like sets
var stringSet: string; // empty set of strings
stringSet += "a";
stringSet += "b";
stringSet += "c";
stringSet += "a"; // Redundant add "a"
stringSet -= "c"; // Remove "c"
writeString( stringSet );
