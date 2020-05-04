using Printf

function ErrorPQ(G,B,PG,PD,QG,QD,V,Theta)
    #println(G,B,PG,PD,QG,QD,V,Theta)
    N = length(PG)
    ErrorP = zeros(Float64, N)
    ErrorQ = zeros(Float64, N)
    for i = 1:N
        for j = 1:N
            ErrorP[i] += V[i] * V[j] * (G[i,j] * cos(Theta[i]-Theta[j]) + B[i,j] * sin(Theta[i]-Theta[j]))
            ErrorQ[i] += V[i] * V[j] * (G[i,j] * sin(Theta[i]-Theta[j]) - B[i,j] * cos(Theta[i]-Theta[j]))
            #println("Iter i=", i, ", j=", j, ": ErrorP=", ErrorP, ", ErrorQ=", ErrorQ)
        end
        ErrorP[i] -= PG[i]-PD[i]
        ErrorQ[i] -= QG[i]-QD[i]
    end
    return [ErrorP,ErrorQ]
end

function ErrorPcasoDC(B,PG,PD,Theta)
    N = length(PG)
    ErrorP = zeros(Float64, N)
    for i = 1:N
        for j = 1:N
            ErrorP[i] += B[i,j] * (Theta[i]-Theta[j])
        end
        ErrorP[i] -= PG[i]-PD[i]
    end
    return ErrorP
end

N=2
G = zeros(Float64, N, N)
B = zeros(Float64, N, N)
PG = zeros(Float64, N)
PD = zeros(Float64, N)
QG = zeros(Float64, N)
QD = zeros(Float64, N)
V = zeros(Float64, N)
Theta = zeros(Float64, N)

G[1,2] = -0.4
G[2,1] = G[1,2]

B[1,2] = 1.3
B[2,1] = B[1,2]

i=1
for i = 1:N
    for j = 1:N
        if j != i
            G[i,i] -= G[i,j]
            B[i,i] -= B[i,j]
        end
    end
end

#################
### Parte (b) ###
#################

### Item (i) ###
println("\nCaso con PG1 = 1")

PG[1] = 1.0; PG[2] = 0; PD[1] = 0; PD[2] = 1.0;
QG[1] = 0; QG[2] = 0; QD[1] = 0; QD[2] = 0.1;
V[1] = 1.0; V[2] = 1.0; Theta[1] = 0; Theta[2] = 0;

Theta[2] = 10 * 2*pi/360; Error = ErrorPQ(G,B,PG,PD,QG,QD,V,Theta); ErrorP = Error[1]; ErrorQ = Error[2];
println("Theta2=", Theta[2]*360/(2*pi), ": ErrorP=", ErrorP, "; ErrorQ=", ErrorQ)

Theta[2] = -10 * 2*pi/360; Error = ErrorPQ(G,B,PG,PD,QG,QD,V,Theta); ErrorP = Error[1]; ErrorQ = Error[2];
println("Theta2=", Theta[2]*360/(2*pi), ": ErrorP=", ErrorP, "; ErrorQ=", ErrorQ)

Theta[2] = -30 * 2*pi/360; Error = ErrorPQ(G,B,PG,PD,QG,QD,V,Theta); ErrorP = Error[1]; ErrorQ = Error[2];
println("Theta2=", Theta[2]*360/(2*pi), ": ErrorP=", ErrorP, "; ErrorQ=", ErrorQ)

Theta[2] = -43 * 2*pi/360; Error = ErrorPQ(G,B,PG,PD,QG,QD,V,Theta); ErrorP = Error[1]; ErrorQ = Error[2];
println("Theta2=", Theta[2]*360/(2*pi), ": ErrorP=", ErrorP, "; ErrorQ=", ErrorQ)

Theta[2] = -43.3 * 2*pi/360; Error = ErrorPQ(G,B,PG,PD,QG,QD,V,Theta); ErrorP = Error[1]; ErrorQ = Error[2];
println("Theta2=", Theta[2]*360/(2*pi), ": ErrorP=", ErrorP, "; ErrorQ=", ErrorQ)

### Item (ii) ###
PG[1] = 1.0; PG[2] = 0; PD[1] = 0; PD[2] = 1.0;
QG[1] = 0; QG[2] = 0; QD[1] = 0; QD[2] = 0.1;
V[1] = 1.0; V[2] = 1.0; Theta[1] = 0; Theta[2] = 0;

Theta[2] = -43.3 * 2*pi/360;

QG[1] = 0.079568; Error = ErrorPQ(G,B,PG,PD,QG,QD,V,Theta); ErrorP = Error[1]; ErrorQ = Error[2];
println("QG1=", QG[1], ": ErrorP=", ErrorP, "; ErrorQ=", ErrorQ)

### Item (iii) ###
PG[1] = 1.0; PG[2] = 0; PD[1] = 0; PD[2] = 1.0;
QG[1] = 0; QG[2] = 0; QD[1] = 0; QD[2] = 0.1;
V[1] = 1.0; V[2] = 1.0; Theta[1] = 0; Theta[2] = 0;

Theta[2] = -43.3 * 2*pi/360; QG[1] = 0.079568;

PG[2] = 0.217327; QG[2] = 0.728223; Error = ErrorPQ(G,B,PG,PD,QG,QD,V,Theta); ErrorP = Error[1]; ErrorQ = Error[2];
println("PG2=", PG[2], ", QG2=", QG[2], ": ErrorP=", ErrorP, "; ErrorQ=", ErrorQ)

### Item (iv) ###
PG[1] = 1.0; PG[2] = 0; PD[1] = 0; PD[2] = 1.0;
QG[1] = 0; QG[2] = 0; QD[1] = 0; QD[2] = 0.1;
V[1] = 1.0; V[2] = 1.0; Theta[1] = 0; Theta[2] = 0;

Theta[2] = -43.3 * 2*pi/360; QG[1] = 0.079568; PG[2] = 0.217327; QG[2] = 0.728223;

println("Perdidas totales = ", PG[1]+PG[2]-PD[1]-PD[2])

### Caso con PG1 = 0.9 ###
println("\nCaso con PG1 = 0.9")
PG[1] = 0.9; PG[2] = 0; PD[1] = 0; PD[2] = 1.0;
QG[1] = 0; QG[2] = 0; QD[1] = 0; QD[2] = 0.1;
V[1] = 1.0; V[2] = 1.0; Theta[1] = 0; Theta[2] = 0;

Theta[2] = -38.7 * 2*pi/360; Error = ErrorPQ(G,B,PG,PD,QG,QD,V,Theta); ErrorP = Error[1]; ErrorQ = Error[2];
println("Theta2=", Theta[2]*360/(2*pi), ": ErrorP=", ErrorP, "; ErrorQ=", ErrorQ)

QG[1] = 0.035343; Error = ErrorPQ(G,B,PG,PD,QG,QD,V,Theta); ErrorP = Error[1]; ErrorQ = Error[2];
println("QG1=", QG[1], ": ErrorP=", ErrorP, "; ErrorQ=", ErrorQ)

PG[2] = 0.275012; QG[2] = 0.635537; Error = ErrorPQ(G,B,PG,PD,QG,QD,V,Theta); ErrorP = Error[1]; ErrorQ = Error[2];
println("PG2=", PG[2], ", QG2=", QG[2], ": ErrorP=", ErrorP, "; ErrorQ=", ErrorQ)

println("Perdidas totales = ", PG[1]+PG[2]-PD[1]-PD[2])

#################
### Parte (c) ###
#################
### Caso con PG1 = 1 y PG2 = 0.9 ###
println("\nCaso DC con PG1 = 1 y PG2 = 0.9")

PG[1] = 1.0; PG[2] = 0.9; PD[1] = 0; PD[2] = 1.0;
QG[1] = 0; QG[2] = 0; QD[1] = 0; QD[2] = 0.1;
V[1] = 1.0; V[2] = 1.0; Theta[1] = 0; Theta[2] = 0;

Theta[2] = -30 * 2*pi/360; ErrorP=ErrorPcasoDC(B,PG,PD,Theta);
println("Theta2=", Theta[2]*360/(2*pi), ": ErrorP=", ErrorP)

Theta[2] = -40 * 2*pi/360; ErrorP=ErrorPcasoDC(B,PG,PD,Theta);
println("Theta2=", Theta[2]*360/(2*pi), ": ErrorP=", ErrorP)

Theta[2] = -44.1 * 2*pi/360; ErrorP=ErrorPcasoDC(B,PG,PD,Theta);
println("Theta2=", Theta[2]*360/(2*pi), ": ErrorP=", ErrorP)

println("Imposible cumplir con balance de potencia activa en ambos nodos!")

### Caso con PG1 = 1 ###
println("\nCaso DC con PG1 = 1 y PG2 = 0")

PG[1] = 1.0; PG[2] = 0; PD[1] = 0; PD[2] = 1.0;
QG[1] = 0; QG[2] = 0; QD[1] = 0; QD[2] = 0.1;
V[1] = 1.0; V[2] = 1.0; Theta[1] = 0; Theta[2] = 0;

Theta[2] = -44.1 * 2*pi/360; ErrorP=ErrorPcasoDC(B,PG,PD,Theta);
println("Theta2=", Theta[2]*360/(2*pi), ": ErrorP=", ErrorP)

println("Haciendo PG2 = 0 se cumplen ambas ecuaciones de potencia activa!")

println("Perdidas totales = ", PG[1]+PG[2]-PD[1]-PD[2])
