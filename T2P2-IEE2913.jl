using PowerModels
using Ipopt
using JuMP

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
            return y
        end
    end
    y = r/(r^2+x^2)-x/(r^2+x^2)*im
    return y

end

function Admitance(r,x)
    G = 0
    B = 0
    G = round(r/(r^2+x^2),digits = 4)
    B = -x/(r^2+x^2) 
    if r == 0
        if x ==0
            G = 0
            B = 0
        end
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

Flac1 = zeros(9,9)
Fqac1 = zeros(9,9)
Fldc1 = zeros(9,9)
Flac2 = zeros(5,5)
Fqac2 = zeros(5,5)
Fldc2 = zeros(5,5)

resultAC = run_ac_opf("system.m",Ipopt.Optimizer)
resultDC = run_dc_opf("system.m",Ipopt.Optimizer)

Dict(name => data["va"] for (name, data) in resultAC["solution"]["bus"])
Dict(name => data["vm"] for (name, data) in resultAC["solution"]["bus"])
loss_ac =  Dict(name => data["pt"]+data["pf"] for (name, data) in resultAC["solution"]["branch"])
loss_dc =  Dict(name => data["pt"]+data["pf"] for (name, data) in resultDC["solution"]["dcline"])

print_summary(resultAC["solution"])
print_summary(resultDC["solution"])

VmAC = [1.1 1.09737 1.08634 1.09508 1.08524 1.1  1.08946 1.1 1.07331]
VaAC = [-2.18026e-28 0.0318994 0.0448906 -0.0514524  -0.0809507 -0.00659958 -0.0504675 -0.0226838 -0.0991892]
VaDC = [0 0.044 0.059 -0.060 -0.096 -0.003 -0.057 -0.022 -0.118]


resultAC1 = run_ac_opf("system2.m",Ipopt.Optimizer)
resultDC1 = run_dc_opf("system2.m",Ipopt.Optimizer)
print_summary(resultAC1["solution"])
print_summary(resultDC1["solution"])

VmAC1 = [1.078 1.084 1.1 1.064 1.069]
VaAC1 = [0.049 -0.013 -0.01 0 0.063]
VaDC1 = [0.057 -0.014 -0.008 0.0 0.072]

loss_ac2 =  Dict(name => data["pt"]+data["pf"] for (name, data) in resultAC1["solution"]["branch"])
loss_dc2 =  Dict(name => data["pt"]+data["pf"] for (name, data) in resultDC1["solution"]["branch"])

println("Flujo potencias Caso1")

for i in 1:9
    for j in 1:9
        Flac1[i,j] = VmAC[i]*VmAC[j]*sin(VaAC[i]-VaAC[j])/X[i,j]
        Fqac1[i,j] = VmAC[i]*VmAC[j]*(G[i,j]*sin(VaAC[i]-VaAC[j])-B[i,j]*cos(VaAC[i]-VaAC[j]))
        Fldc1[i,j] = (VaDC[i]-VaDC[j])/X[i,j]
    end
end


network_data = PowerModels.parse_file("system2.m")
pm = instantiate_model(network_data,ACPPowerModel, PowerModels.build_opf)

instance = optimize_model!(pm, optimizer = with_optimizer(Ipopt.Optimizer))

dual1 = all_constraints(pm.model,AffExpr,MOI.EqualTo{Float64})

has_duals(pm.model)
for i in dual1
    println(dual(i))
end

pmDC = instantiate_model(network_data,DCPPowerModel, PowerModels.build_opf)
instanceDC = optimize_model!(pmDC, optimizer = with_optimizer(Ipopt.Optimizer))