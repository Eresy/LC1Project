module Data where

data Token =	Type String	| BrakOpen | BrakClose | SBrakOpen 
				| SBrakClose | CBrakOpen | CBrakClose | AssignOp 
				| AddOp | SubOp | MulOp | DivOp | Comma | Semicolon
				| CompOp | NegOp | IncOp | DecOp

data Type = 	Integer | Float | Character | String | Pointer Type 
				| Array Type
