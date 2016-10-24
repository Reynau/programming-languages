 
myLength ::[Int] -> Int
myLength [] = 0
myLength (x:xs) = 1 + myLength(xs)

myMaximum :: [Int] -> Int
myMaximum (x:xs) = max x (myMaximum xs)

average :: [Int] -> Float
average xs = (fromIntegral $ sumElements xs) / (fromIntegral $ myLength xs)
  
sumElements :: [Int] -> Int
sumElements [] = 0
sumElements (x:xs) = x + sumElements xs

buildPalindrome :: [Int] -> [Int]
buildPalindrome [] = []
buildPalindrome xs = (reverse xs) ++ xs

primeDivisors :: Int -> [Int]