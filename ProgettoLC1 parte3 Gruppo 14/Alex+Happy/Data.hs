module Data where

data Token =    Int String Pos
                | Double String Pos
                | Char String Pos
                | String String Pos
                | Label String Pos
                | Comment String Pos
                | BrakOpen Pos
                | BrakClose Pos
                | SBrakOpen Pos
                | SBrakClose Pos
                | CBrakOpen Pos
                | CBrakClose Pos
                | AssignOp Pos
                | EqualsOp Pos
                | DiffOp Pos
                | LessThanOp Pos
                | GreaterThanOp Pos
                | ELessThanOp Pos
                | EGreaterThanOp Pos
                | AddOp Pos
                | SubOp Pos
                | MulOp Pos
                | DivOp Pos
                | IncOp Pos
                | DecOp Pos
                | Comma Pos
                | Semicolon Pos
                | Dereference Pos
                | And Pos
                | Or Pos
                | NegOp Pos
                | Break Pos
                | Continue Pos
                | Return Pos
                | IntLabel Pos
                | FloatLabel Pos
                | CharLabel Pos
                | StringLabel Pos
                | VoidLabel Pos
                | ReadIntPF Pos
                | WriteIntPF Pos
                | ReadFloatPF Pos
                | WriteFloatPF Pos
                | ReadCharPF Pos
                | WriteCharPF Pos
                | ReadStringPF Pos
                | WriteStringPF Pos
                | ValRes Pos
                | If Pos
                | Else Pos
                | While Pos
                | For Pos
                deriving (Eq, Ord, Show)
                
type Pos = ( Int , Int )

data Type =     IntType
                | DoubleType
                | CharType
                | StringType
                | PointerType Type 
                | ArrayType Type
                | VoidType
                deriving(Eq, Ord, Show)

data TypeResult = Correct Type | Error Type Type | Null deriving (Show)

