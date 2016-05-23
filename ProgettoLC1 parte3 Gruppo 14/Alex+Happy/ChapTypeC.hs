module ChapTypeC where
import AST

data TypeCorrect        = Correct Type
                        | Error Type Type
                        | Mismatch Type Type
                        | Null Type
                        | Ret Type
                        | Unknown
                        deriving (Eq, Show, Ord)

checkTypeProgram :: AST -> String
checkTypeProgram (Program lst) =  foldr (++) [] (map (evalTypeError . typeCheckStmt) lst)

--evalTypeError :: TypeCorrect -> String
evalTypeError x = case x of
        (Correct a)     ->      []
        (Mismatch a b)  ->      "Type Error: " ++ show a ++ " " ++ show (getTypePos a) ++ " and " ++ show b ++ " " ++ show (getTypePos b) ++ "are of incompatible types.\n"
        (Error a b)     ->      "Type Error: at " ++ show (getTypePos a) ++ " type given: "++ show a ++", expected "++ show b++".\n"
        (Ret a)         ->      []
        (Unknown)       ->      []
        (Null a)        ->      []

--typeCheckStmt :: Stmt -> TypeCorrect Type
typeCheckStmt a = case a of
    (Stmt1 x)           -> foldr1 (collapse) (map (typeCheckStmt) (getList x))
    (Stmt2 x)           -> typeCheckExp x
    (Stmt3 x)           -> typeCheckAssign x
    (Stmt5 x)           -> typeCheckFnDecl x
    (Stmt6 x)           -> typeCheckWhDo x
    (Stmt7 x)           -> typeCheckDoWh x
    (Stmt8 x)           -> typeCheckIf x
    (Stmt9 x)           -> typeCheckFor x
    (Stmt10 x)          -> typeCheckTrCatch x
    (Stmt12 x)          -> (getRet x)
    _                   -> (Correct Void')
    where       getList (Blk val) = val
                
getRet (Ret1 exp) = typeCheckExp exp
getRet (Ret2 _) = (Correct Void')

--collapse :: TypeCorrect -> TypeCorrect -> TypeCorrect
collapse a b = case (a,b) of
         ((Error _ _), _)               ->      a
         (_, (Error _ _))               ->      b
         ((Mismatch _ _), _)            ->      a
         (_, (Mismatch _ _))            ->      b
         _                              ->      a

typeCheckWhDo (WD exp _) = compareTypeErr (typeCheckExp exp) (Correct (Bool' "" (0,0)))

typeCheckDoWh (DW _ exp) = compareTypeErr (typeCheckExp exp) (Correct (Bool' "" (0,0)))

typeCheckIf ifs = case ifs of
        (OneLineIf exp _)       ->      compareTypeErr (typeCheckExp exp) (Correct (Bool' "" (0,0)))
        (IfBlock exp _)         ->      compareTypeErr (typeCheckExp exp) (Correct (Bool' "" (0,0)))
        (IfElseBlock exp _ _)   ->      compareTypeErr (typeCheckExp exp) (Correct (Bool' "" (0,0)))

typeCheckFor for = case for of
        (ForBlk _ _ block)      ->      typeCheckStmt (Stmt1 block)
        (ForSmp _ _ stm)        ->      typeCheckStmt stm

typeCheckTrCatch (TrCh x y) = typeCheckStmt (Stmt1 (Blk [x,y]))

--typeCheckFnDecl :: FnDecl -> TypeCorrect Type
typeCheckFnDecl dcl = case dcl of
        (FullDecl _ _ cast (Blk lst))   ->      compareTypeMis (typeCheckCast cast) (getReturn lst)


--getReturn :: [Stmt] -> TypeCorrect Type
getReturn m = case m of
          (Stmt12 rt):_ -> getRet rt
          _:xs  -> getReturn xs
          _ -> (Ret Void')

{-
getReturn (x:xs) = case x of
          (Stmt12 rt)     ->      getRet rt
          _               ->      getReturn xs
getReturn (x:[]) = case x of
          (Stmt12 rt)     ->      getRet rt
          _               ->      (Ret Void')
getReturn _ = (Ret Void')

-}
--typeCheckAssign :: Assign -> TypeCorrect Type
typeCheckAssign assign = case assign of
        (DeclAssign (SimpleDecl _ _ x) y)       ->      compareTypeMis (typeCheckCast x) (typeCheckRVal y)
        _                                       ->      (Correct Void')

--typeCheckCast :: Cast -> TypeCorrect Type
typeCheckCast cst = case cst of
        (SCast x)       ->      (Correct (specConvert x))
        (MCast _ x)     ->      (Correct (specConvert x))

specConvert x = case x of
        IntSpec a       ->      (Int' "int" a)
        RealSpec a      ->      (Real' "real" a)
        CharSpec a      ->      (Char' "char" a)
        StringSpec a    ->      (String' "string" a)
        BoolSpec a      ->      (Bool' "bool" a)
        VoidSpec a      ->      (Void')

--typeCheckRVal :: RVal -> TypeCorrect Type
typeCheckRVal rv =  case rv of
        (SimpleRV x)    ->      typeCheckExp x
        (ComplexRV x)   ->      (Correct Void')

--typeCheckExp :: Exp -> TypeCorrect Type
typeCheckExp exp = case exp of
        (AddExp x y _)    ->    compareTypeMis (typeCheckExp x) (typeCheckExp y)        
        (SubExp x y _)    ->    compareTypeMis (typeCheckExp x) (typeCheckExp y)        
        (MulExp x y _)    ->    compareTypeMis (typeCheckExp x) (typeCheckExp y)        
        (DivExp x y _)    ->    compareTypeMis (typeCheckExp x) (typeCheckExp y)        
        (PosExp x _)      ->    compareTypeErr (typeCheckExp x) (Correct (Int' "" (0,0)))       
        (NegExp x _)      ->    compareTypeErr (typeCheckExp x) (Correct (Int' "" (0,0)))
        (RefExp x _)      ->    compareTypeErr (typeCheckExp x) (Correct Void') 
        (EqExp x y pos)   ->    compareTypeForce (typeCheckExp x) (typeCheckExp y) (Bool' (show exp) pos)       
        (NEqExp x y pos)    ->  compareTypeForce (typeCheckExp x) (typeCheckExp y) (Bool' (show exp) pos)
        (LTExp x y pos)     ->  compareTypeForce (typeCheckExp x) (typeCheckExp y) (Bool' (show exp) pos)
        (GTExp x y pos)     ->  compareTypeForce (typeCheckExp x) (typeCheckExp y) (Bool' (show exp) pos)
        (LETExp x y pos)    ->  compareTypeForce (typeCheckExp x) (typeCheckExp y) (Bool' (show exp) pos)
        (GETExp x y pos)    ->  compareTypeForce (typeCheckExp x) (typeCheckExp y) (Bool' (show exp) pos)
        (AndExp x y pos)    ->  compareTypeErr (compareTypeMis (typeCheckExp x) (typeCheckExp y)) (Correct (Bool' (show exp) pos))
        (OrExp x y pos)     ->  compareTypeErr (compareTypeMis (typeCheckExp x) (typeCheckExp y)) (Correct (Bool' (show exp) pos))
        (NotExp x pos)      ->  compareTypeErr (typeCheckExp x) (Correct (Bool' (show exp) pos))
        (VExp1 x)         ->    (Correct x)
        (VExp2 x)         ->    (Unknown)
        (VExp3 x)         ->    (Unknown)


--compareTypeMis :: TypeCorrect Type -> TypeCorrect Type -> TypeCorrect Type
compareTypeMis a b = case (a,b) of
        (Correct x, Correct y)  ->      case (x,y) of
                                                (Int' _ _,Int' _ _)             ->      a
                                                (Real' _ _,Real' _ _)           ->      a       
                                                (Char' _ _,Char' _ _)           ->      a       
                                                (String' _ _,String' _ _)       ->      a       
                                                (Array' lst1 _,Array' lst2 _)           ->      compareArrays x y
                                                (Pointer' t ,Pointer' d)                ->      compareTypeMis (Correct t) (Correct d)
                                                (Void',Void')                   ->      a
                                                (Int' _ _,Real' _ _)            ->      b
                                                (Real' _ _,Int' _ _)            ->      a
                                                _                               ->      (Mismatch x y)
        (Error _ _, _)          ->      a
        (_, Error _ _)          ->      b
        (Mismatch _ _, _)       ->      a
        (_, Mismatch _ _)       ->      b
        (Unknown, _)            ->      b
        (_, Unknown)            ->      a
        (Null _, _)             ->      b
        (_, Null _)             ->      a
        (Ret _, _)              ->      a
        (_, Ret _)              ->      b
        _                       ->      Unknown

{-      (Correct (Int' _ _), Correct (Int' _ _))        -> a
        (Correct (Real' _ _), Correct (Real' _ _))      -> a
        (Correct (Char' _ _), Correct (Char' _ _))      -> a
        (Correct (String' _ _), Correct (String' _ _))  -> a
        (Correct (Bool' _ _), Correct (Bool' _ _))      -> a
        (Correct x@(Array' lst1 _), Correct y@(Array' lst2 _)) -> compareArrays x y
        (Correct (Pointer' t), Correct (Pointer' d))    -> compareTypeMis (Correct t) (Correct d)
        (Correct (Void'), Correct (Void'))              -> a 
        (Correct (Int' _ _), Correct (Real' _ _))       -> b
        (Correct (Real' _ _), Correct (Int' _ _))       -> a
        (Error _ _, _)                                  -> a
        (_, Error _ _)                                  -> b
        (Unknown, x)                                    -> x
        (x, Unknown)                                    -> x
        (x@(_ ,y)                                       -> (Mismatch x y) 
-}

compareTypeForce a b force = case compareTypeMis a b of
        (Correct a)     ->      (Correct force)
        (Mismatch a b)  ->      (Mismatch a b)
        (Error a b)     ->      (Error a b)
        (Unknown)       ->      (Unknown)

compareTypeErr a b = case compareTypeMis a b of
        (Correct a)     ->      (Correct a)
        (Mismatch a b)  ->      (Error a b)
        (Error a b)     ->      (Error a b)
{-
--compareArrays :: Type -> Type -> TypeCorrect Type
compareArrays (Array' (x:xs) _) (Array' (y:ys) _) = case compareTypeMis (typeCheckExp x) (typeCheckExp y) of
        (Correct a)     ->      compareArrays xs ys
        (Error a b)     ->      (Error a b)
-}

compareArrays (Array' a pos1) (Array' b pos2) = case (a,b) of
        ((x:[]),(y:[]))  ->      compareTypeMis (typeCheckExp x) (typeCheckExp y)
        ((x:xs),(y:ys)) ->      case compareTypeMis (typeCheckExp x) (typeCheckExp y) of
                                        (Correct _)     ->      compareArrays (Array' xs pos1) (Array' ys pos2)
                                        (Error z v)     ->      (Error z v)
        

getTypePos x = case x of
        Int' _ pos      -> show pos
        Real' _ pos     -> show pos
        Char' _ pos     -> show pos
        String' _ pos   -> show pos
        Bool' _ pos     -> show pos
        Array' _ pos    -> show pos
        Pointer' t      -> ""
        Void'           -> ""

