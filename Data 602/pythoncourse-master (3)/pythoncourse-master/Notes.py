# -*- coding: utf-8 -*-
"""
Created on Sat Dec 12 15:02:00 2020

@author: gabre
"""

import numpy as np

#Array creation

# a = np.ones(5) #ones array
# b = np.zeros(20) #zero array
#c = np.eye(5) #identity matrix

# a = np.linspace(0,15)
# b = np.linspace(0, 15, 5)
# c = np.linspace(0, 10, 5)

#a = np.arange(0,50) # 0 -14 array

l = [1,2,3,4,5]

b = np.array(l) # converts list to array


#Referencing 

# print(a[5:10]) #prints 5,6,7,8,9

# print(a[::5])#prints 0, 5, 10, 15, 20, 25, 30, 35, 40, 45

# print(a[5:]) #prints starting at 5 until the end

# print(c[3,2]) #print row index 3 and column index 2 (so fourth row, third column value)

# print(c[2,2]) 

#Reshaping --> change dimensions of an array

#print(c.shape) #prints (5,5)

#c = c.reshape(2,5) #won't work because it implies that there are 10 items, the array has 25 items 

#c = np.eye(6) # this has 36 items

#c = c.reshape(2,18)
 
#one liner
c = np.eye(6).reshape(2, 18)

 
#Broadcast 

a = np.arange(1,12)

a1 = a.copy() # nullifies broadcast

#a1 = a[0:3] #a1 is a reference to a in memory so changing the value in a1 changes a

# print(a1)

# a1[0] = 100

# print(a1)

#Modify 

# a2 = np.arange(0,30)

# a2[12:15] = 100

# print(a2)


#Calcs

# a3 = np.arange(5, 300)

# print(a3.max()) #print max value

# print(a3.min()) #print min value

# print(a3.argmax()) #print index number of max value

# print(a3.argmin())# print index number of min value

# print(a + a) #add to itself, doubling every respective item

# print(a * a)

# print(a/a)

# print(a ** 5)


# a = a - 1

# print(a)


#Random

# b = np.random.rand(50).reshape(10, 5)

# #randn gives a standard distribution vs rand

# print(b)




#2D






#Conditional Selection


# a = np.arange(0, 101)

# #a = a > 50 # makes array into array of booleans


# b = a[a>80] # shows actual values that meet condition



# print(a)
# #print(type(a))
# #print(a.dtype)
# print(b)
#print(c)


#Numpy universal functions
# Create Function

def myadd(x, y):
  return x+y

myadd = np.frompyfunc(myadd, 2, 1)

print(myadd([1, 2, 3, 4], [5, 6, 7, 8]))



