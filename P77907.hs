
absValue :: Int -> Int
absValue n
  | n > 0 = n
  | otherwise = n * (-1)

power :: Int -> Int -> Int
power n m
  | m == 0 = 1
  | m == 1 = n
  | otherwise = n * power n (m-1)

isPrime :: Int -> Bool
isPrime n 
  | n <= 1 = False
  | otherwise = isPrime2 n 2

isPrime2 :: Int -> Int -> Bool 
isPrime2 n m 
  | m == n = True
  | otherwise = 
    if(mod n m) == 0 then False
    else isPrime2 n (m+1)

slowFib :: Int -> Int
slowFib n
  | n == 0 = 0
  | n == 1 = 1
  | otherwise = slowFib(n-1) + slowFib(n-2)

quickFib :: Int -> Int
quickFib n
  | n == 0 = 0
  | n == 1 = 1
  | otherwise = quickFib2 (n-1) 1 1

quickFib2 :: Int -> Int -> Int -> Int
quickFib2 a n m 
  | a == 1 = m
  | otherwise = quickFib2 (a-1) m (n+m)


