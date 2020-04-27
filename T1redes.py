####  Tarea 1 Redes

from math import *
import matplotlib.pyplot as plt
from random import randint, expovariate, uniform

## VARIABLES

P1 = 1
Q1 = 1

Q2 = 1

###  Datos
L_GB = [[[0,0],[0.392,-1.569],[0,0],[0.294,-1.176],[0.588,-2.353]],[[0.392,-1.569],[0,0],[0.588,-2.353],[0.392,-1.569],[0,0]],[[0,0],[0.588,-2.353],[0,0],[0,0],[0.588,-2.353]],[[0.294,-1.176],[0.392,-1.569],[0,0],[0,0],[0,0]],[[0.588,-2.353],[0,0],[0.588,-2.353],[0,0],[0,0]]]

# P , Q, V, theta
BUS_data = [[P1,Q1,1.03,0],[-0.5,-0.2,1,0],[1,Q2,1.03,0],[-0.3,-0.1,1,0],[-0.5,-0.3,1,0]]

Ptest = []
Q1test = []
Q2test = []
for i in range(5):
    Ptest.append(1.31+randint(-10,10)/10)
    Q1test.append(5.25+randint(-10,10)/10)
    Q2test.append(4.85+randint(-10,10)/10)
print("Numeros de prueba.")
print(Ptest)
print(Q1test)
print(Q2test)

ErrorP1 = []
ErrorQ1 = []
ErrorQ2 = []

 ### Ecuaciones
Psum = 0
Qsum = 0
Presult = []
Qresult = []
for i in range(0,5):
 for j in range(0,5):
     Psum += BUS_data[i][2]*BUS_data[j][2]*(L_GB[i][j][0]*cos(0)+L_GB[i][j][1]*sin(0))
     Qsum += BUS_data[i][2]*BUS_data[j][2]*(L_GB[i][j][0]*sin(0)-L_GB[i][j][1]*cos(0))
 Presult.append(Psum)
 Qresult.append(Qsum)
 Psum = 0
 Qsum = 0

errorP = []
errorQ = []
for i in range(len(Presult)):
    print(i)
    errorP.append((BUS_data[i][0]-Presult[i])/BUS_data[i][0])
    errorQ.append((BUS_data[i][1]-Presult[i])/BUS_data[i][1])

for i in range(len(Ptest)):
    ErrorP1.append((Ptest[i]-Presult[0])/Ptest[i])
    ErrorQ1.append((Q1test[i]-Qresult[0])/Q1test[i])
    ErrorQ2.append((Q2test[i]-Qresult[2])/Q2test[i])


print("Error P:")
print(errorP)
print("Error Q:")
print(errorQ)
print("Resultados P calculado Barra")
print(Presult)
print("Resultados Q calculado Barra")
print(Qresult)

print("Error barras 1 y 2")
print(ErrorP1)
print(ErrorQ1)
print(ErrorQ2)
