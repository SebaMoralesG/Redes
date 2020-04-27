###### Problema 1 ######
using LinearAlgebra

## Parametros enunciado

R = zeros(9,9)
R[4,5] = 0.017
R[4,9] = 0.01
R[5,6] = 0.039
R[6,7] = 0.0119
R[7,8] = 0.0085
R[8,9] = 0.032
R[5,4] = 0.017
R[9,4] = 0.01
R[6,5] = 0.039
R[7,6] = 0.0119
R[8,7] = 0.0085
R[9,8] = 0.032
X = zeros(9,9)
X[1,4] = 0.0576
X[2,8] = 0.0625
X[3,6] = 0.0586
X[4,5] = 0.092
X[4,9] = 0.085
X[5,6] = 0.17
X[6,7] = 0.1008
X[7,8] = 0.072
X[8,9] = 0.161
X[4,1] = 0.0576
X[8,2] = 0.0625
X[6,3] = 0.0586
X[5,4] = 0.092
X[9,4] = 0.085
X[6,5] = 0.17
X[7,6] = 0.1008
X[8,7] = 0.072
X[9,8] = 0.161

Y = zeros(ComplexF64,9,9)
G = zeros(9,9)
B = zeros(9,9)


# Funciones utiles
function Adm(r,x)
    y = 0
    if r == 0
        if x == 0
            y = 0 + 0im
        end
    else
        y = round(r/(r^2+x^2),digits = 4)-round(x/(r^2+x^2), digits = 4)im
    end
    return y
end

function Admitance(r,x)
    G = 0
    B = 0
    if r == 0
        if x ==0
            G = 0
            B = 0
        end
    else
        G = round(r/(r^2+x^2),digits = 4)
        B = -round(x/(r^2+x^2), digits = 4)  
    end
    return G,B
end

## main

# Funciones Y, G,B 
for i in 1:9
    for j in 1:9
        if i == j
            for k in 1:9
                Y[i,j] = Y[i,j] + Adm(R[i,k],X[i,k])
                GB = Admitance(R[i,k],X[i,k])
                G[i,j] = G[i,j] + GB[1]
                B[i,j] = B[i,j] + GB[2]
            end
        else
            Y[i,j] = -Adm(R[i,j],X[i,j])
            GB = Admitance(R[i,j],X[i,j])
            G[i,j] =  -GB[1]
            B[i,j] =  GB[2]
        end
    end
end


# for i in 1:9
#     println(Y[i,:])
# end

# for i in 1:9
#     println(G[i,:])
# end

# for i in 1:9
#     println(B[i,:])
# end
Y
B
Binv =inv(B)
C = [1 2 3;4 9 6;5 8 9]
inv(C)