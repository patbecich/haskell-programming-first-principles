-- 6.1 typeclasses (Eq, Num, Ord, Enum, Show)

-- 6.2 What are typeclasses

-- 6.3 Back to Bool
-- instance Bounded Bool - have upper and lower bound
-- instance Enum Bool - can be enumerated
-- instance Eq Bool - can be checked for equality
-- instance Ord Bool - can be ordered
-- instance Read Bool - can be parsed from string to something else
-- instance Show Bool - renders things into strings

-- 6.4 Eq
-- 6.5 Num

divideThenAdd :: Fractional a => a -> a -> a
divideThenAdd x y = (x / y) + 1

-- 6.6 Type defaulting typeclasses

-- default Num Integer
-- default Real Integer
-- default Enum Integer
-- default Integral Integer
-- default Fractional Double
-- default RealFrac Double
-- default Floating Double
-- default RealFloat Double

-- (/) :: Fractional a => a -> a -> a -> a changes to (/) :: Double -> Double -> Double

-- div :: Integral a => a -> a -> a changes to div :: Integer -> Integer -> Integer

-- types can be made more specific, but not more general or polymorphic

-- 6.7 Ord

--Exercises: Will they work?

-- max (length [1,2,3]) (length [8,9,10,11,12])
-- This function will work because it supplies max with two Int values

-- compare (3 * 4) (3 * 5)
-- this function will work because it supplies compare with Num values

-- compare "Julie" True
-- This function will not work because String and Bool can't be compared (not the same type)

-- (5+3) > (3+6)
-- this will work because we are comparing two instances of Num typeclass

-- 6.8 Enum
-- 6.9 Show

data Mood = Blah

instance Show Mood where
    show _ = "Blah"

-- 6.10 Read - takes a string and turns it into a thing, no way this will always work.

-- 6.11 Instances are dispatched by type
-- a typeclass defines a set of functions and/or values
-- types have instances of that typeclass
-- the instances specify the ways that type uses the functions of the typeclass

-- 6.12 Writing typeclass instances

data Trivial = Trivial'

instance Eq Trivial where
  Trivial' == Trivial' = True

data DayOfWeek =
  Mon | Tue | Wed | Thu | Fri | Sat | Sun

data Date =
  Date DayOfWeek Int

instance Eq DayOfWeek where
  (==) Mon Mon = True
  (==) Tue Tue = True
  (==) Wed Wed = True
  (==) Thu Thu = True
  (==) Fri Fri = True
  (==) Sat Sat = True
  (==) Sun Sun = True
  (==) _ _     = False

instance Eq Date where
  (==) (Date weekday dayOfMonth)
       (Date weekday' dayOfMonth') =
    weekday == weekday' && dayOfMonth == dayOfMonth'

data Identity a = Identity a

-- instance Eq (Identity a) where
--   (==) (Identity v) (Identity v') = v == v'
