module AST where

import Data 

data AST = Program [Stmt]
         deriving(Eq, Ord)

data Stmt = Stmt1 BlockStmt
          | Stmt2 Exp
          | Stmt3 Assign
          | Stmt4 Declaration
          | Stmt5 FnDecl
          | Stmt6 WhDo
          | Stmt7 DoWh
          | Stmt8 Iff
          | Stmt9 Forr
          | Stmt10 TrCatch
          | Stmt11 FlCtr
          | Stmt12 Rtrn
          | Stmt13 Cmt
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

data FnCall = FCall String [Exp]
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
            | Unspec
            deriving(Eq, Ord)

data Cast   = SCast Type 
            | MCast [Range] Type
            deriving(Eq, Ord)

data Range  = CRange Exp Exp 
            | NURange Exp
            | NLRange Exp
            | ULRange
            deriving(Eq, Ord)

data Assign   = SimpleAssign NamedAssign
              | GenericAssign [Pointer] String RVal
              | DeclAssign Declaration RVal
              deriving(Eq, Ord)

data Declaration  = SimpleDecl [Pointer] String Cast
                  deriving(Eq, Ord)

data Pointer = Ptr
             deriving(Eq, Ord)

data NamedAssign  = Ass LVal AssignOp RVal
                  deriving(Eq, Ord)

data AssignOp = Assign
              | AddAssign
              | SubAssign
              | MulAssign
              | DivAssign
              deriving(Eq, Ord)

data WhDo  = WD Exp BlockStmt
           deriving(Eq, Ord)

data DoWh  = DW BlockStmt Exp
           deriving(Eq, Ord)

data Iff  = OneLineIf Exp Stmt
          | IfBlock Exp BlockStmt
          | IfElseBlock Exp BlockStmt BlockStmt
          deriving(Eq, Ord)

data Forr = ForBlk String Range BlockStmt
          | ForSmp  String Range Stmt
          deriving(Eq, Ord)

data TrCatch  = TrCh Stmt Stmt
              deriving(Eq, Ord)

data Type   = Int' String Pos 
            | Real' String Pos 
            | Char' String Pos
            | String' String Pos
            | Bool' String Pos
            | Array' Type Pos
            | Pointer' Type Pos
            | Void'
            deriving(Eq, Ord)

data BlockStmt = Blk [Stmt] 
               deriving(Eq, Ord)

data Exp   = AddExp Exp Exp
           | SubExp Exp Exp
           | MulExp Exp Exp
           | DivExp Exp Exp
           | PosExp Exp
           | RefExp Exp
           | DerExp Exp
           | EqExp Exp Exp
           | NEqExp Exp Exp
           | LTExp Exp Exp
           | GTExp Exp Exp
           | LETExp Exp Exp
           | GETExp Exp Exp
           | AndExp Exp Exp
           | OrExp Exp Exp
           | NegExp Exp
           | VExp1 Type 
           | VExp2 FnCall
           | VExp3 LVal
           deriving(Eq, Ord)

data LVal = LV String
          | ArrayLV String [Exp]
          deriving(Eq, Ord)

data RVal = SimpleRV Exp 
          | ComplexRV NamedAssign
          deriving(Eq, Ord)
