module Data where

data Token =	Int String
		| Double String
		| Char String
		| String String 
		| Label String
		| BrakOpen 
		| BrakClose 
		| SBrakOpen 
		| SBrakClose 
		| CBrakOpen 
		| CBrakClose 
		| AssignOp 
		| CompareOp
		| LessThanOp
		| GreaterThanOp
		| ELessThanOp
		| EGreaterThanOp
		| AddOp 
		| SubOp 
		| MulOp 
		| DivOp 
		| IncOp
		| DecOp
		| Comma 
		| Semicolon
		| Dereference
		| And
		| Or
		| NegOp 
      | Break
      | Continue
      | Return
      | IntLabel
      | FloatLabel
      | CharLabel
      | StringLabel
      | VoidLabel
      | ReadIntPF
      | WriteIntPF
      | ReadFloatPF
      | WriteFloatPF
      | ReadCharPF
      | WriteCharPF
      | ReadStringPF
      | WriteStringPF
      | ValRes
		deriving (Eq, Ord, Show)


data Type =	IntType Int
		| DoubleType Double 
		| CharType Char
		| StringType String
		| PointerType Type 
		| ArrayType Type
		deriving(Eq, Ord, Show)
