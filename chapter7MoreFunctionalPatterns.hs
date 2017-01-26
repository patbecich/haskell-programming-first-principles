--7.1
--7.2
-- Functions can be used as arguments to other functions "First class values"


myNum :: Integer
myNum = 1

myVal f = myNum + f

bindExp :: Integer -> String
bindExp x = let y = 5 in
              "the integer was: " ++ show x ++ " and y was: " ++ show y

-- This won't work

-- bindExp' :: Integer -> String
-- bindExp' x = let z = y + x in
--              let y = 5 in "The integer was: " ++ show x ++ " and y was: " ++ show y ++ " and z was: " ++ show z

-- Shadowing example
bindExp' :: Integer -> String
bindExp' x = let x = 10; y = 5 in "The integer was: " ++ show x ++ " and y was: " ++ show y

-- 7.3 Anonymous Functions

triple :: Integer -> Integer
triple x = x * 3

-- is equivalent to

--(\x -> x * 3) :: Integer -> Integer


-- Exercises:

-- 1
-- all are the same mTh x y z = x * y * z = mTh = \x -> \y -> \z -> x * y * z

-- 2
-- mTh 3 :: Num a => a -> a -> a
-- why doesn't the input of an integer change all the types?

--3
--addOne x = x + 1
addOne = (\x -> x + 1)

-- a

addOneIfOdd n = case odd n of
  True  -> f n
  False -> n
  where f = (\x -> x + 1)

-- b

addFive = \x -> \y -> (if x > y then y else x) + 5

-- c

mflip f x y = f y x

-- 7.4 pattern matching

isItTwo :: Integer -> Bool
isItTwo 2 = True
isItTwo _ = False

-- module RegisteredUser where

newtype Username = Username String
newtype AccountNumber = AccountNumber Integer

data User = UnregisteredUser | RegisteredUser Username AccountNumber

printUser :: User -> IO ()
printUser UnregisteredUser = putStrLn "UnregisteredUser"
printUser (RegisteredUser (Username name)
                          (AccountNumber acctNum))
          = putStrLn $ name ++ " " ++ show acctNum

data WherePenguinsLive = Galapagos | Antarctica | Australia | SouthAfrica | SouthAmerica deriving ( Eq, Show)

data Penguin = Peng WherePenguinsLive deriving (Eq, Show)

isSouthAfrica :: WherePenguinsLive -> Bool
isSouthAfrica SouthAfrica  = True
isSouthAfrica Galapagos    = False
isSouthAfrica Antarctica   = False
isSouthAfrica Australia    = False
isSouthAfrica SouthAmerica = False

-- is the same as

isSouthAfrica' :: WherePenguinsLive -> Bool
isSouthAfrica' SouthAfrica = True
isSouthAfrica' _           = False

-- use pattern matching to unpack Penguin

gimmeWhereTheyLive :: Penguin -> WherePenguinsLive
gimmeWhereTheyLive (Peng whereitlives) = whereitlives

humboldt = Peng SouthAmerica
gentoo = Peng Antarctica
macaroni = Peng Antarctica
little = Peng Australia
galapagos = Peng Galapagos

galapagosPenguin :: Penguin -> Bool
galapagosPenguin (Peng Galapagos) = True
galapagosPenguin _                = False

antarcticPenguin :: Penguin -> Bool
antarcticPenguin (Peng Antarctica) = True
antarcticPenguin _                 = False

antarcticOrGalapagos :: Penguin -> Bool
antarcticOrGalapagos p = (galapagosPenguin p) || (antarcticPenguin p)

-- tuples

f :: (a, b) -> (c, d) -> ((b, d), (a, c))
f (a, b) (c, d) = ((b, d), (a, c))

addEmUp2 :: Num a => (a,a) -> a
addEmUp2 (x, y) = x + y

addEmUp2' :: Num a => (a,a) -> a
addEmUp2' tup = (fst tup) + (snd tup)

fst3 :: (a,b,c) -> a
fst3 (x, _, _) = x

third3 :: (a,b,c) -> c
third3 (_,_, x) = x

-- Exercises: variety pack

--1

k (x, y) = x
k1 = k ((4-1), 10)
k2 = k ("three", (1+2))
k3 = k (3,True)

--a
-- k :: (a, b) -> a
-- k2 :: String
-- k3 returns 3

-- 2

fTuple :: (a, b, c) -> (d, e, f) -> ((a, d), (c, f))
fTuple (a, _, c) (d, _ , f) = ((a, d), (c, f))

-- 7.5 Case Expressions

-- if x + 1 == 1 then "Awesome" else "wut"

funcZ x = case x + 1 == 1 of
            True  -> "Awesome"
            False -> "Wut"

pal xs = case xs == reverse xs of
           True  -> "yes"
           False -> "no"

-- is the same as

pal' xs = case y of
            True  -> "yes"
            False -> "no"
          where y = xs == reverse xs

greetIfCool :: String -> IO ()
greetIfCool coolness = case cool of
                         True  -> putStrLn "eyyyyy. What's shakin'?"
                         False -> putStrLn "pshhhhh."
                       where cool = coolness == "downright frosty yo"

-- Exercises: Case Practice

--1

--functionC x y = if (x > y) then x else y

functionC x y = case a of
                  True  -> x
                  False -> y
                where a = x > y
-- 2

--ifEvenAdd2 n = if even n then (n+2) else n

ifEvenAdd2 n = case a of
                 True  -> (n + 2)
                 False -> n
               where a = even n
-- 3
nums x = case compare x 0 of
           LT -> -1
           GT -> 1
           EQ -> 0

-- 7.6 Higher Order Functions -- functions that accept functions as arguments

data Employee = Coder | Manager | Veep | CEO deriving (Eq, Ord, Show)

reportBoss :: Employee -> Employee -> IO ()
reportBoss e e' = putStrLn $ show e ++ " is the boss of " ++ show e'

codersRuleCEOsDrool :: Employee -> Employee -> Ordering
codersRuleCEOsDrool Coder Coder = EQ
codersRuleCEOsDrool Coder _     = GT
codersRuleCEOsDrool _ Coder     = LT
codersRuleCEOsDrool e e'        = compare e e'

employeeRank :: (Employee -> Employee -> Ordering) -> Employee -> Employee -> IO ()
employeeRank f e e' = case f e e' of
                      GT -> reportBoss e e'
                      EQ -> putStrLn "Neither employee is the boss"
                      LT -> (flip reportBoss) e e'


-- Exercises: Artfull Dodgy

dodgy x y = x + y * 10
oneIsOne = dodgy 1
oneIsTwo = (flip dodgy) 2

--2 dodgy 1 1 = 11
--3 dodgy 2 2 = 22
--4 dodgy 1 2 = 21
--5 dodgy 2 1 = 12
--6 oneIsOne 1 = 11
--7 oneIsOne 2 = 21
--8 oneIsTwo 1 = 21
--9 oneIsTwo 2 = 22
--10 oneIsOne 3 = 31
--11 oneIsTwo 3 = 23

-- 7.7 Guards

myAbs :: Integer -> Integer
myAbs x = if x < 0 then (-x) else x

-- is equivalent to

myAbs' :: Integer -> Integer
myAbs' x
  | x < 0 = (-x)
  | otherwise = x

bloodNa :: Integer -> String
bloodNa x
  | x < 135 = "too low"
  | x > 145 = "too high"
  | otherwise = "just right"
