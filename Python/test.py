
import sys

def diffElements(l) :
  k = []
  for el in l:
    if not el in k:
      k.append(el)
  return len(k)
  
def maxList(l) :
  k = l[0]
  for el in l:
    if el > k:
      k = el
  return k
  
def mitList(l) :
  k = l[0]
  for el in l[1:]:
    k += el
  k /= len(l)
  return k



def planList(l) :
  k = []
  for el in l:
    if isinstance(el, list) :
      k = k+planList(el)
    else :
      k.append(el)
  return k
      
      
def ordCreix(l,el):
  k = 0
  for elm in l:
    if(elm > el):
      l.insert(k,el)
      return l
    k = k+1
  return l+el

def parIsen(l):
  A = []
  B = []
  for el in l:
    if(el%2 == 0):
      A.append(el)
    else:
      B.append(el)
  return (A,B)
  
def listProd(l):
  return reduce(lambda x,y: x*y, l)

def pairListProd(l):
  return reduce(lambda x,y: (x%2 == 0) and (y%2 == 0) and x*y, l)
  

print pairListProd([1,2,3,4,5,6,7])