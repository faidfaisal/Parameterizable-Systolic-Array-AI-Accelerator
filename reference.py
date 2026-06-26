import numpy as np

A = np.array([[1, 2],
              [3, 4]])

B = np.array([[5, 6],
              [7, 8]])

C = A @ B

print("A =")
print(A)
print("B =")
print(B)
print("C = A @ B =")
print(C)
