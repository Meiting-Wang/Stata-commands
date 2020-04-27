* Feather 1: get b and V by hand, then display the result like the regress command.
* Feather 2: test the constraints just like the use of the regress command afterwards.
* Author: Meiting Wang, Master, School of Economics, South-Central University for Nationalities
* Email: 2017110097@mail.scuec.edu.cn
* Created on Nov 20th, 2019

/*
note: varlist are required. b and V will be calculated first, then  P CI and the 
constraints test(if you use test command after this command) will be calculated
based on t distribution.
*/


program define bvols, eclass
version 15.1

syntax varlist(min=2) [if] [in]

*手工计算b和V
preserve
local varlist_comma = ustrregexra("`varlist'"," ",",")
qui drop if missing(`varlist_comma') //去除其中有缺漏值的部分

gettoken y x: varlist //将因变量和自变量分割开来
local x = ustrtrim("`x'")

tempname XTX yTX XTy yTy b k n df s2 V bT //设置临时性矩阵名称和标量名称

qui mat accum `XTX' = `x'  //为避免Stata普通运算中的矩阵维数灾难，我们采用了mat accum和mat vecaccum命令
mat vecaccum `yTX' = `varlist'
mat `XTy' = `yTX''
mat `b' = invsym(`XTX')*`XTy' //得到回归系数

qui matrix accum `yTy' = `y', nocons
scalar `k' = rowsof(`XTX')
scalar `n' = _N
scalar `df' = `n'-`k'
mat `s2' = (`yTy' - `b''*`XTX'*`b')/`df' //这里借用了用Stata学微观计量经济学的方法
scalar `s2' = `s2'[1,1]  //将s2转化为标量
mat `V' = `s2'*invsym(`XTX') //得到估计系数的方差协方差矩阵
restore


*通过b和V计算其余的统计量。
mat `bT' = `b''
local n_l: dis `n'
local df_l: dis `df'
eret post `bT' `V', dep(`y') obs(`n_l') dof(`df_l')
dis in g "obs = `n_l'"
dis in g "num of coef = `=rowsof(`XTX')' (include _cons)"
dis in g "t_df = `df_l'"
eret display, sformat(%5.3f)  //报告结果(基于回归中的t分布)

eret local cmd "Regress"
end
