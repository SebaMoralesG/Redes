### Load packages ###
Pkg.add("Taro")

using JuMP, GLPK, Taro

### Function for solving unit commitment ###
function UnitCommitmentFunction(Data)
    BusSet = Data[1]; TimeSet = Data[2]; GeneratorSet = Data[3]; LineSet = Data[4]; Pd = Data[5]; GeneratorBusLocation = Data[6]; GeneratorPminInMW = Data[7]; GeneratorPmaxInMW = Data[8];
    GeneratorRampInMW = Data[9]; GeneratorStartUpShutDownRampInMW = Data[10]; GeneratorMinimumUpTimeInHours = Data[11]; GeneratorMinimumDownTimeInHours = Data[12];
    GeneratorStartUpCostInUSD = Data[13]; GeneratorFixedCostInUSDperHour = Data[14]; GeneratorVariableCostInUSDperMWh = Data[15];
    GeneratorVariableCostInUSDperMWh = Data[16]; LineFromBus = Data[17]; LineToBus = Data[18]; LineReactance = Data[19]; LineMaxFlow = Data[20];

    T = length(TimeSet)

    model = Model(GLPK.Optimizer)

    @variable(model, x[GeneratorSet,TimeSet], Bin)
    @variable(model, u[GeneratorSet,TimeSet], Bin)
    @variable(model, v[GeneratorSet,TimeSet], Bin)
    @variable(model, Pg[GeneratorSet,TimeSet])
    @variable(model, Theta[BusSet,TimeSet])

    @objective(model, Min, sum(GeneratorFixedCostInUSDperHour[i] * x[i,t]
        + GeneratorStartUpCostInUSD[i] * u[i,t]
        + GeneratorVariableCostInUSDperMWh[i] * Pg[i,t] for i in GeneratorSet, t in TimeSet))

    @constraint(model, LogicConstraintBorder[i in GeneratorSet, t in 1:1], x[i,t] - 0 == u[i,t] - v[i,t])
    @constraint(model, LogicConstraint[i in GeneratorSet, t in 2:T], x[i,t] - x[i,t-1] == u[i,t] - v[i,t])

    @constraint(model, PMinConstraint[i in GeneratorSet, t in 1:T], GeneratorPminInMW[i] * x[i,t] <= Pg[i,t])
    @constraint(model, PMaxConstraint[i in GeneratorSet, t in 1:T], Pg[i,t] <= GeneratorPmaxInMW[i] * x[i,t])

    @constraint(model, FixAngleAtReferenceBusConstraint[i in 1:1, t in 1:T], Theta[i,t] == 0)

    @constraint(model, DCPowerFlowConstraint[i in BusSet, t in 1:T],
        sum(Pg[k,t] for k in GeneratorSet if GeneratorBusLocation[k] == i)
        - Pd[i][t]
        == sum( (1/LineReactance[l]) * (Theta[LineFromBus[l],t] - Theta[LineToBus[l],t]) for l in LineSet if LineFromBus[l] == i)
        + sum( (1/LineReactance[l]) * (Theta[LineToBus[l],t] - Theta[LineFromBus[l],t]) for l in LineSet if LineToBus[l] == i))

    JuMP.optimize!(model)

    return [model,x,u,v,Pg]
end

function readExcel(Filename)
    Taro.init()
    df = Taro.readxl()
end

### Unit commitment example ###
BusSet = [1,2]
TimeSet = 1:24
GeneratorSet = [1,2,3]
LineSet = [1]

Pd = [  [21.70,	17.70,	15.55,	13.94,	13.41,	16.09,	18.77,	20.91,	21.98,	23.59,	23.86,	22.52,	21.45,	20.38,	23.59,	24.13,	22.79,	23.86,	25.20,	26.27,	26.81,	24.13,	23.33,	21.98],
        [94.20,	76.81,	67.50,	60.52,	58.19,	69.83,	81.47,	90.78,	95.44,	102.42,	103.58,	97.76,	93.11,	88.45,	102.42,	104.75,	98.93,	103.58,	109.40,	114.06,	116.39,	104.75,	101.26,	95.44]]

GeneratorBusLocation = [1,1,2]
GeneratorPminInMW = [0,0,10]
GeneratorPmaxInMW = [50,50,150]
GeneratorRampInMW = [5,5,15]
GeneratorStartUpShutDownRampInMW = [50,50,150]
GeneratorMinimumUpTimeInHours = [4,4,8]
GeneratorMinimumDownTimeInHours = [4,4,8]
GeneratorStartUpCostInUSD = [1500,1500,4500]
GeneratorFixedCostInUSDperHour = [300,300,900]
GeneratorVariableCostInUSDperMWh = [20,50,80]

LineFromBus = [1]
LineToBus = [2]
LineReactance = [0.06]
LineMaxFlow = [500]

Data = [BusSet,TimeSet,GeneratorSet,LineSet,Pd,GeneratorBusLocation,GeneratorPminInMW,
GeneratorPmaxInMW,GeneratorRampInMW,GeneratorStartUpShutDownRampInMW,GeneratorMinimumUpTimeInHours,
GeneratorMinimumDownTimeInHours,GeneratorStartUpCostInUSD,GeneratorFixedCostInUSDperHour,
GeneratorVariableCostInUSDperMWh,GeneratorVariableCostInUSDperMWh,LineFromBus,LineToBus,
LineReactance,LineMaxFlow]

Results = UnitCommitmentFunction(Data)
model = Results[1]; x = Results[2]; u = Results[3]; v = Results[4]; Pg = Results[5];

println("Total cost: ", JuMP.objective_value(model))
for i in GeneratorSet
    for t in TimeSet
        println("i, t, x[i,t], Pg[i,t]: ", i, ", ", t, ", ", JuMP.value(x[i,t]), ", ", JuMP.value(Pg[i,t]))
    end
end
