module AST where


import Data 

{- DATA TYPES -}

data AST = Program [Stmt]
         deriving(Eq, Ord)

instance Show AST where
   show (Program xs) = show xs



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

instance Show Stmt where
   show (Stmt1 x) = show x
   show (Stmt2 x) = show x ++ ";"
   show (Stmt3 x) = show x ++ ";"
   show (Stmt4 x) = show x ++ ";"
   show (Stmt5 x) = show x
   show (Stmt6 x) = show x
   show (Stmt7 x) = show x
   show (Stmt8 x) = show x
   show (Stmt9 x) = show x
   show (Stmt10 x) = show x
   show (Stmt11 x) = show x
   show (Stmt12 x) = show x
   show (Stmt13 x) = show x



data FlCtr  = Cont 
            | Brk
            deriving(Eq, Ord) 

instance Show FlCtr where
   show Cont = "continue;"
   show Brk = "break";



data Rtrn = Ret1 Exp
          | Ret2 NamedAssign
          deriving(Eq, Ord)

instance Show Rtrn where
   show (Ret1 x) = "return " ++ show x ++ ";"
   show (Ret2 x) = "return " ++ show x ++ ";"


-- Optionally, you can keep the comments
data Cmt  = SCmt String
          | MCmt String
          deriving(Eq, Ord)

instance Show Cmt where
   show (SCmt x) = "" -- OPT: show x ++ ";"
   show (MCmt x) = "" -- OPT: show x ++ ";"



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

instance Show FnCall where 
   show (FCall x ys) = x ++ "( " ++ (readExp ys) ++ " );"
   show (ReadInt _) = "readInt();"
   show (WriteInt x _) = "writeInt( " ++ show x ++ " );"
   show (ReadReal _) = "readReal();"
   show (WriteReal x _) = "writeReal( " ++ show x ++ " );"
   show (ReadChar _) = "readChar();"
   show (WriteChar x _) = "writeChar( " ++ show x ++ " );"
   show (ReadString _) = "readString();"
   show (WriteString x _) = "writeString( " ++ show x ++ " );"



data FnDecl  = FullDecl String [FormParam] Cast BlockStmt
             | NoCastDecl String [FormParam] BlockStmt
             | NoParamDecl String Cast BlockStmt
             | NakedDecl String BlockStmt
             deriving(Eq, Ord)

instance Show FnDecl where
   show (FullDecl x ys z w) = "proc " ++ x ++ " (" ++ (readFormParam ys) ++ ") " ++ show z ++ show w
   show (NoCastDecl x ys z) = "proc " ++ x ++ " (" ++ (readFormParam ys) ++ ") " ++ show z
   show (NoParamDecl x y z) = "proc " ++ x ++ show y ++ show z
   show (NakedDecl x y) = "proc " ++ x ++ show y



data FormParam = FParam Mode String Cast
                      deriving(Eq, Ord)

instance Show FormParam where
   show (FParam x y z) = show x ++ " " ++ y ++ show z



data Mode   = Val 
            | Ref 
            | Con 
            | Uns
            deriving(Eq, Ord)

instance Show Mode where
   show Val = "val"
   show Ref = "ref"
   show Con = "const"
   show Uns = "" -- or "val"



data Cast   = SCast TypeSpec
            | MCast [Range] TypeSpec
            deriving(Eq, Ord)

instance Show Cast where
   show (SCast x) = ": " ++ show x
   show (MCast xs y) = ": " ++ (readRange xs) ++ " " ++ show y



data Range  = CRange Exp Exp 
            | NURange Exp
            | NLRange Exp
            | ULRange
            deriving(Eq, Ord)

instance Show Range where
   show (CRange x y) = show x ++ ".." ++ show y ++ " "
   show (NURange x) = show x ++ ".. "
   show (NLRange x) = ".." ++ show x
   show ULRange = ".. "



data Assign   = SimpleAssign NamedAssign
              | GenericAssign [Pointer] String RVal
              | DeclAssign Declaration RVal
              deriving(Eq, Ord)

instance Show Assign where
   show (SimpleAssign x) = show x 
   show (GenericAssign xs y z) = (readPointer xs) ++ y ++ " = " ++ show z 
   show (DeclAssign x y) = show x ++ " = " ++ show y



data Declaration  = SimpleDecl [Pointer] String Cast
                  deriving(Eq, Ord)

instance Show Declaration where
   show (SimpleDecl xs y z) = "var " ++ (readPointer xs) ++ y ++ show z 



data Pointer = Ptr
             deriving(Eq, Ord)

instance Show Pointer where
   show Ptr = "*"



data NamedAssign  = Ass LVal AssignOp RVal
                  deriving(Eq, Ord)

instance Show NamedAssign where
   show (Ass x y z) = show x ++ show y ++ show z



data AssignOp = Assign
              | AddAssign
              | SubAssign
              | MulAssign
              | DivAssign
              deriving(Eq, Ord)

instance Show AssignOp where
   show Assign    = " = "
   show AddAssign = " += "
   show SubAssign = " -= "
   show MulAssign = " *= "
   show DivAssign = " /= "



data WhDo  = WD Exp BlockStmt
           deriving(Eq, Ord)

instance Show WhDo where
   show (WD x y) = "while (" ++ show x ++ ") " ++ show y



data DoWh  = DW BlockStmt Exp
           deriving(Eq, Ord)

instance Show DoWh where
   show (DW x y) = "do " ++ show x ++ "while (" ++ show y ++ ");"



data Iff  = OneLineIf Exp Stmt
          | IfBlock Exp BlockStmt
          | IfElseBlock Exp BlockStmt BlockStmt
          deriving(Eq, Ord)

instance Show Iff where
   show (OneLineIf x y) = "if (" ++ show x ++") then " ++ show y
   show (IfBlock x y) = "if (" ++ show x ++ ") " ++ show y
   show (IfElseBlock x y z) = "if (" ++ show x ++ ") " ++ show y ++ " else " ++ show z



data Forr = ForBlk String Range BlockStmt
          | ForSmp  String Range Stmt
          deriving(Eq, Ord)

instance Show Forr where
   show (ForBlk x y z) = "for " ++ x ++ " in " ++ show y ++ show z
   show (ForSmp x y z) = "for " ++ x ++ " in " ++ show y ++ " do " ++ show z



data TrCatch  = TrCh Stmt Stmt
              deriving(Eq, Ord)

instance Show TrCatch where
   show (TrCh x y) = "try " ++ show x ++ " catch " ++ show y



data Type   = Int' String Pos 
            | Real' String Pos 
            | Char' String Pos
            | String' String Pos
            | Bool' String Pos
            | Array' [Exp] Pos
            | Pointer' Type
            | Void'
            deriving(Eq, Ord)

instance Show Type where
   show (Int' x _) = x
   show (Real' x _) = x 
   show (Char' x _) = x 
   show (String' x _) = x
   show (Bool' x _) = "TRUE/FALSE" -- DA FIXARE ASAP!!!!!!!!!!!!!!!!!!!!!
   show (Array' xs _) = "( " ++ (readExp xs) ++ " )"
   show (Pointer' x) = show x
   show Void' = ""


data TypeSpec = IntSpec Pos
              | RealSpec Pos
              | CharSpec Pos
              | StringSpec Pos
              | BoolSpec Pos
              | VoidSpec Pos
              deriving(Eq, Ord)

instance Show TypeSpec where
   show (IntSpec _)     = "int"
   show (RealSpec _)    = "real"
   show (CharSpec _)    = "char"
   show (StringSpec _)  = "string"
   show (BoolSpec _)    = "bool"
   show (VoidSpec _)    = "void"



data BlockStmt = Blk [Stmt] 
               deriving(Eq, Ord)

instance Show BlockStmt where
   show (Blk xs) = "{" ++ show xs ++ "}"



data Exp   = AddExp Exp Exp Pos
           | SubExp Exp Exp Pos
           | MulExp Exp Exp Pos
           | DivExp Exp Exp Pos
           | PosExp Exp Pos
           | NegExp Exp Pos
           | RefExp Exp Pos
           | DerExp Exp Pos
           | EqExp Exp Exp Pos
           | NEqExp Exp Exp Pos
           | LTExp Exp Exp Pos
           | GTExp Exp Exp Pos
           | LETExp Exp Exp Pos
           | GETExp Exp Exp Pos
           | AndExp Exp Exp Pos
           | OrExp Exp Exp Pos
           | NotExp Exp Pos
           | VExp1 Type 
           | VExp2 FnCall
           | VExp3 LVal
           deriving(Eq, Ord)

instance Show Exp where
   show (AddExp x y _) = show x ++ " + " ++ show y
   show (SubExp x y _) = show x ++ " - " ++ show y
   show (MulExp x y _) = show x ++ " * " ++ show y
   show (DivExp x y _) = show x ++ " / " ++ show y
   show (PosExp x _) = "+" ++ show x
   show (NegExp x _) = "-" ++ show x
   show (RefExp x _) = "&" ++ show x
   show (EqExp x y _) = show x ++ " == " ++ show y
   show (NEqExp x y _) = show x ++ " != " ++ show y
   show (LTExp x y _) = show x ++ " < " ++ show y
   show (GTExp x y _) = show x ++ " > " ++ show y
   show (LETExp x y _) = show x ++ " <= " ++ show y
   show (GETExp x y _) = show x ++ " >= " ++ show y
   show (AndExp x y _) = show x ++ " && " ++ show y
   show (OrExp x y _) = show x ++ " || " ++ show y
   show (NotExp x _) = "!" ++ show x
   show (VExp1 x) = show x
   show (VExp2 x) = show x
   show (VExp3 x) = show x



data LVal = LV String
          | ArrayLV String [Exp]
          deriving(Eq, Ord)

instance Show LVal where
   show (LV x) = x
   show (ArrayLV x xs) = x ++ " [" ++ (readExp xs) ++ "] "



data RVal = SimpleRV Exp 
          | ComplexRV NamedAssign
          deriving(Eq, Ord)

instance Show RVal where
   show (SimpleRV x) = show x
   show (ComplexRV x) = show x



{- FUNCTIONS -}
readAST :: AST -> String
readAST (Program lst) = case lst of
   []     -> ""
   (x:[]) -> show x ++ ""
   (x:xs) -> show x ++ "" ++ readAST (Program xs)

readExp :: [Exp] -> String
readExp lst = case lst of
   []     -> ""
   (x:[]) -> show x
   (x:xs) -> show x ++ readExp xs
 
readStmt :: [Stmt] -> String
readStmt lst = case lst of
   []     -> ""
   (x:[]) -> show x
   (x:xs) -> show x ++ readStmt xs
 
readFormParam :: [FormParam] -> String
readFormParam lst = case lst of
   []     -> ""
   (x:[]) -> show x
   (x:xs) -> show x ++ readFormParam xs

readPointer :: [Pointer] -> String
readPointer lst = case lst of
   []     -> ""
   (x:[]) -> show x
   (x:xs) -> show x ++ readPointer xs

readRange :: [Range] -> String
readRange lst = case lst of
   []     -> ""
   (x:[]) -> show x
   (x:xs) -> show x ++ readRange xs

-- indentation
addSpace :: Int -> String
addSpace 0 = ""
addSpace n = "   " ++ addSpace (n-1)

indent :: Int -> String -> String
indent n txt
   | strlen > 0 = subindent n txt
   | otherwise  = txt
   where
      strlen = length txt

subindent :: Int -> String -> String
subindent n txt
   | fs == '{' = (fs : "\n") ++ (addSpace (n+1)) ++ (indent (n+1) (tail txt))
   | fs == '}' = (fs : "\n") ++ (addSpace (n-1)) ++ (indent (n-1) (tail txt))
   | fs == ';' && nxt == '}' = (fs : "\n") ++ (addSpace (n-1)) ++ (indent n (tail txt))
   | fs == ';' = (fs : "\n") ++ (addSpace n) ++ (indent n (tail txt))
   | otherwise = (fs : "") ++ (indent n (tail txt))
   where
      fs = head txt
      nxt = txt !! 1
