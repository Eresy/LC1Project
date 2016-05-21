module AST where

import Data 

data AST = Program [Stmt]
         deriving(Eq, Ord)

data Stmt = Stmt1 BlockStmt Pos
          | Stmt2 Exp Pos
          | Stmt3 Assign Pos
          | Stmt4 Declaration Pos
          | Stmt5 FnDecl Pos
          | Stmt6 WhDo Pos
          | Stmt7 DoWh Pos
          | Stmt8 Iff Pos
          | Stmt9 Forr Pos
          | Stmt10 TrCatch Pos
          | Stmt11 FlCtr Pos
          | Stmt13 Rtrn Pos
          | Stmt14 Cmt Pos
          deriving(Eq, Ord)

data FlCtr  = Cont 
            | Brk
            deriving(Eq, Ord) 

data Rtrn = Ret1 Exp
          | Ret2 NamedAssign
          deriving(Eq, Ord)

data Cmt  = SCmt String
          | MCmt String
          deriving(Eq, Ord)

data FnCall = FCall String [Exp] Pos
            | ReadInt Pos
            | ReadReal Pos
            | ReadChar Pos
            | ReadString Pos
            | WriteInt Exp Pos
            | WriteReal Exp Pos
            | WriteChar Exp Pos
            | WriteString Exp Pos
            deriving(Eq, Ord)

data FnDecl  = FullDecl String [FormParam] Cast BlockStmt Pos
             | NoCastDecl String [FormParam] BlockStmt Pos
             | NoParamDecl String Cast BlockStmt Pos
             | NakedDecl String BlockStmt Pos
             deriving(Eq, Ord)

data FormParam = FParam Mode String Cast
                      deriving(Eq, Ord)

data Mode   = Value 
            | Reference 
            | Constant 
            deriving(Eq, Ord)

data Cast   = SCast Type 
            | MCast [Range] Type
            deriving(Eq, Ord)

data Range  = CRange String String
            | NURange String
            | NLRange String
            | ULRange
            deriving(Eq, Ord)

data Assign   = SimpleAssign NamedAssign Pos
                  | GenericAssign [Pointer] String RVal Pos
                  | DeclAssign Declaration RVal Pos
                  deriving(Eq, Ord)

data Declaration  = SimpleDecl [Pointer] String Cast Pos
                  deriving(Eq, Ord)

data Pointer = Ptr
             deriving(Eq, Ord)

data NamedAssign  = Ass LVal AssignOp RVal Pos
                  deriving(Eq, Ord)

data AssignOp = Assign
              | AddAssign
              | SubAssign
              | MulAssign
              | DivAssign
              deriving(Eq, Ord)

data WhDo  = WD Exp BlockStmt Pos
           deriving(Eq, Ord)

data DoWh  = DW BlockStmt Exp Pos
           deriving(Eq, Ord)

data Iff  = OneLineIf Exp BlockStmt Pos
          | IfBlock BlockStmt Pos
          | IfElseBlock BlockStmt BlockStmt Pos
          deriving(Eq, Ord)

data Forr = ForBlk String Range BlockStmt Pos
          | ForSmp  String Range Stmt Pos
          deriving(Eq, Ord)

data TrCatch  = TrCh Stmt Stmt Pos
              deriving(Eq, Ord)

data Type   = Int' 
            | Real' 
            | Char' 
            | String' 
            | Array' Type 
            | Pointer' Type 
            | Void'
            deriving(Eq, Ord)

data BlockStmt = Blk [Stmt] 
               deriving(Eq, Ord)

data Exp   = AddExp Exp Exp Pos
           | SubExp Exp Exp Pos
           | MulExp Exp Exp Pos
           | DivExp Exp Exp Pos
           | PosExp Exp Pos
           | RefExp Exp Pos
           | EqExp Exp Exp Pos
           | NEqExp Exp Exp Pos
           | LTExp Exp Exp Pos
           | GTExp Exp Exp Pos
           | LETExp Exp Exp Pos
           | GETExp Exp Exp Pos
           | AndExp Exp Exp Pos
           | OrExp Exp Exp Pos
           | NegExp Exp Pos
           | VExp1 String
           | VExp2 FnCall
           | VExp3 LVal
           deriving(Eq, Ord)

data LVal = LV String Pos
          | ArrayLV String [String] Pos
          deriving(Eq, Ord)

data RVal = SimpleRV Exp 
          | ComplexRV NamedAssign
          deriving(Eq, Ord)
