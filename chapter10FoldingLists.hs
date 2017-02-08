import           Data.List
import           Data.Time

-- 10.1 Folds (catamorphisms)
-- a means of deconstructing data

-- 10.2 Bringing you into the fold

-- foldr :: Foldable t => (a -> b -> b) -> b -> t a -> b

listFoldr = foldr :: (a -> b -> b) -> b -> [] a -> b

-- map applis a function to each member of a list and returns a list, while a fold replaces the cons constructors with the function and reduces the list

-- 10.3 Recursive patterns - base case is identity of the function

-- 10.4 Fold Right

-- right fold because fold is right associative; it associates to the right

foldr' :: (a -> b -> b) -> b -> [a] -> b
foldr' f acc []     = acc
foldr' f acc (x:xs) = f x (foldr' f acc xs)

-- acc is the accumulator, usually the identity of a function, i.e. 0 for (+) and 1 for (*)

foldrr :: (a -> b -> b) -> b -> [a] -> b
foldrr f acc xs =
  case xs of
    []     -> acc
    (x:xs) -> f x (foldrr f acc xs)


anon = (\_ _ -> 9001)

-- const :: a -> b -> a
-- const x _ = x

-- 10.5 Fold Left

-- foldl :: (b -> a -> b) -> b -> [a] -> b
-- foldl f acc [] = acc
-- foldl f acc (x:xs) = foldl f (f acc x) xs

--foldr (+) 0 [1..5] vs foldl (+) 0 [1..5]
--(1 +(2 +(3 +(4 +(5+0))))) vs (((((0+1)+ 2)+ 3)+ 4)+ 5)

-- arithmetic operation that is not associative (^)

--foldr (^) 2 [1..3] = 1
--(1 ^ (2 ^ (3 ^ 2)))

--foldl (^) 2 [1..3] = 64
--(((2 ^ 1) ^ 2) ^ 3)

-- folding a list into a new list:

listFoldr' = foldr (:) [] [1..3]

listFoldl' = foldl (flip (:)) [] [1..3]

-- const with foldr

-- foldr const 0 [1..5] = 1
-- does not bother with rest of fold

-- foldr (flip const) 0 [1..5] = 0
-- only evaluated acc value

-- const with foldl

foldlConst = foldl (flip const) 0 [1..5]
-- = 5
-- continuously reads each value and forgets the rest of the fold

foldlConst' = foldl const 0 [1..5]
-- = 0
-- only remembers acc value


-- Exercises: Understanding Folds

--1

foldrE1 = foldr (*) 1 [1..5]
-- will return the same result
foldlE1 = foldl (*) 1 [1..5]

-- 2

foldlE2 = foldl (flip (*)) 1 [1..3]
-- (((3 * 1) * 2) * 1) = 6
-- double check this...

-- 3

-- one difference between foldr and foldl is:
-- foldr but not foldl associates tot he right

-- 4

-- folds are catamorphisms, meaning they are used to reduce structure

-- 5

-- a
foldr5a = foldr (++) [] ["woot", "WOOT", "woot"]

-- b
foldr5b = foldr max 'a' "fear is the little death"

-- c
andHelper :: Bool -> Bool -> Bool
andHelper a b = a && b

foldr5c = foldr andHelper True [False, True]

-- foldr f acc [] = acc
-- foldr f acc (x:xs) = f x (foldr f acc xs)
-- and operator requires elements to still be in a list... foldr takes elements out of list... && operator is better suited

-- d

foldr5d = foldr (||) True [False, False, False]

-- will never return false unless acc is false and all list values are false

-- e

foldr5e = foldr ((++) . show) "" [1..5]
-- what is the error with this problem?

-- f

foldr5f = foldr const 0 [1..5]

-- g

foldr5g = foldr const 'a' "tacos"

-- h

foldr5h = foldl (flip const) 'a' "burritos"

-- i

foldr5i = foldl (flip const) 0 [1..5]

-- Unconditional Spine Recursion

-- foldl has the successive steps of the fold as its first argument, while foldr does not
-- foldr const 0 ([1..5] ++ undefined) = 1

-- foldr (flip const) 0 ([1..5] ++ undefined) -- does not work

-- foldl unconditionall evaluates the spine, but you can still selectively evaluate teh values in the list

-- foldl is generally inappropriate with lists that are or could be infinite, also less appropriate for long lists because of forced evaluation (foldl must evaluate its whole spine before its starts evaluating values in each cell)

-- most cases where you need a left fold can be handled with foldl', which is strict (forces evaluation of the values inside cons cell as it traverses spine, insead of gathering many unevaluated expressions)

-- 10.6 How to write fold functions

-- what is start value? usually the identity of the function

threeLetters = foldr (\ a b -> take 3 a ++ b) ""  ["Pizza", "Apple", "Banana"]

-- Exercises: Database Processing

data DatabaseItem = DbString String | DbNumber Integer | DbDate UTCTime deriving (Eq, Ord, Show)

theDatabase :: [DatabaseItem]
theDatabase =
  [ DbDate (UTCTime
            (fromGregorian 1911 5 1)
    (secondsToDiffTime 34123))
  , DbNumber 9001
  , DbString "Hello, world!"
  , DbDate (UTCTime
            (fromGregorian 1921 5 1)
            (secondsToDiffTime 34123))]

-- 1

checkDate :: DatabaseItem -> Bool
checkDate (DbDate _) = True
checkDate _          = False

check2Date :: DatabaseItem -> Bool -> Bool
check2Date dI b = checkDate dI || b

check2Date' :: DatabaseItem -> [UTCTime] -> [UTCTime]
check2Date' (DbDate t) utcTimes = t : utcTimes
--check2Date' dbt@(DbDate _) utcTimes = dbt:utcTimes
check2Date' _ utcTimes          = utcTimes


listNonEmpty :: [a] -> Bool
listNonEmpty (_:_) = True
listNonEmpty []    = False

filterDbDate :: [DatabaseItem] -> [UTCTime]
filterDbDate database = foldr check2Date' [] database
