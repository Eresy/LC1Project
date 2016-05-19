module Data where

data Token = Comment String Pos
           | Int String Pos
           | Real String Pos
           | Char String Pos
           | String String Pos
           | Label String Pos
           | TS_Int Pos
           | TS_Real Pos       
           | TS_Char Pos
           | TS_String Pos
           | TS_Void Pos
           | PM_Value Pos
           | PM_Reference Pos
           | PM_Constant Pos
           | If Pos
           | Then Pos
           | Else Pos
           | For Pos
           | In Pos
           | While Pos
           | Do Pos
           | Break Pos
           | Continue Pos
           | Try Pos
           | Catch Pos
           | PF_readInt Pos
           | PF_writeInt Pos
           | PF_readReal Pos
           | PF_writeReal Pos
           | PF_readChar Pos
           | PF_writeChar Pos
           | PF_readString Pos
           | PF_writeString Pos
           | BK_NOpen Pos
           | BK_NClos Pos
           | BK_SOpen Pos
           | BK_SClos Pos
           | BK_COpen Pos
           | BK_CClos Pos
           | OP_Assign Pos
           | OP_Equal Pos
           | OP_NEqual Pos
           | OP_LesThn Pos
           | OP_LesThnEq Pos
           | OP_GrtThn Pos
           | OP_GrtThnEq Pos
           | OP_Add Pos
           | OP_Sub Pos
           | OP_Mul Pos
           | OP_Div Pos
           | OP_Deref Pos
           | OP_And Pos
           | OP_Or Pos
           | OP_Negt Pos
           | Comma Pos
           | Semicolon Pos
           | CHP_Var Pos
           | CHP_Func Pos
           | CHP_Cast Pos
           | CHP_Range Pos
           deriving(Eq, Ord, Show)

type Pos = (Int, Int)
