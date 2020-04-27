using PowerModels
using Ipopt

resultAC = run_ac_opf("system.m",Ipopt.Optimizer)
resultDC = run_dc_opf("system.m",Ipopt.Optimizer)

Dict(name => data["va"] for (name, data) in resultAC["solution"]["bus"])
Dict(name => data["vm"] for (name, data) in resultAC["solution"]["bus"])
loss_ac =  Dict(name => data["pt"]+data["pf"] for (name, data) in resultAC["solution"]["branch"])
loss_dc =  Dict(name => data["pt"]+data["pf"] for (name, data) in resultAC["solution"]["dcline"])

print_summary(resultAC["solution"])
print_summary(resultDC["solution"])

resultAC1 = run_ac_opf("system2.m",Ipopt.Optimizer)
resultDC1 = run_dc_opf("system2.m",Ipopt.Optimizer)
print_summary(resultAC1["solution"])
print_summary(resultDC1["solution"])