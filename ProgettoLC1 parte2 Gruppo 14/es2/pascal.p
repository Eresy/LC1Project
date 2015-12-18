program esercizio ;
const IMAX = 9 ; UNKNOWN = ...;
type harray = array [ 0.. IMAX , 0.. IMAX ] of integer ;
...
...
var target , aim : integer ;
mainharray : harray ;
history = ^ harray ;
procedure init ( i , j : integer ; h : history ; var z : integer );
var u : integer ;
begin
for u := 0 to min ( IMAX , j ) do
begin
end ;
function f ( n : real ) : integer ;
begin ...
... end ;
procedure p ( x : integer ; var y : integer );
begin
	y := f ( f ( x ));
	while ( y = 0) and ( x > target ) do
		p (y , y )
end ;
function min (x , y : integer ): integer ;
begin ...
... end ;
function alt ( i : integer ; x : real ) : real ;
function f ( x : real ) : real ;
begin f := 1 + 1/ x end ;
begin
	if odd ( i ) then
		alt := alt ( i -1 , f ( x ) )
	else
		alt := alt ( i -1 , x )
end ;
begin
	...;
	p ( target , aim );
	init ( 20 , 30 , @mainharray , target );
	...
	end .
