{

module Parser (main) where

import Lexer (alexScanTokens)
import Data (Token(..), Type(..), Pointer(..))

}

%name parseCLike
%tokentype { Token }
%error { parseError }

%token
	int		{ Int $$ }
	double	{ Double $$ }
	char	{ Char $$ }
	string	{ LitString $$ }
	label	{ Label $$ }
	braketOpen	{ BrakOpen }
	brakClose	{ BrakClose }
	sBrakOpen	{ SBrakOpen }
	sBrakClose	{ SBrakClose }
	cBrakOpen	{ CBrakOpen }
	cBrakClose	{ CBrakClose }
	assignOp	{ AssignOp }
	addOp		{ AddOp }
	subOp		{ SubOp }
	mulOp		{ MulOp	}
	divOp		{ DivOp }
	dereference	{ Dereference }
	
%%



{



}
