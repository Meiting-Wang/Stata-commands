clear all
cd "X:\exercise\Stata\"
sysuse nlsw88.dta, clear
tab race, gen(race_num)
drop race_num1


*------------------回归领域(bvols)------------------
/*
说明：
1. 命令bvols对于P CI 和约束检验(如果后面用到了test命令的情况下)的计算均基于t分布，
因此对应的约束检验为F检验。
2. 其结果可以用est store储存，然后可以用wmtreg将结果统一导出至Stata界面或Word或LaTeX。
*/


*检验两者的各项报告值是否一致，约束的F检验是否一致。
bvols wage age married collgrad occupation race_num*
test age married
ret list
reg wage age married collgrad occupation race_num*, sformat(%5.3f)
test age married
ret list //可见两者的各项报告值和约束的F检验均一致。


*用wmtreg命令统一输出多个估计结果
bvols wage age married occupation
est store m1
bvols wage age married collgrad occupation
est store m2
bvols wage age married collgrad occupation race_num*
est store m3
wmtreg m1 m2 m3, s(N)


reg wage age married occupation
est store m4
reg wage age married collgrad occupation
est store m5
reg wage age married collgrad occupation race_num*
est store m6
wmtreg m4 m5 m6, s(N)




*------------------结构参数领域(bvstru)------------------
/*
说明：
1. 命令bvstru对于P CI 和约束检验(如果后面用到了test命令的情况下)的计算均基于正态分布，
因此对应的约束检验为Wald检验(服从卡方分布)。
2. 其结果可以用est store储存，然后可以用wmtreg将结果统一导出至Stata界面或Word或LaTeX。
*/


*查看bvstru的约束Wald检验得到的P值与普通回归约束F检验得到的P值的差异
reg wage age married collgrad occupation race_num*, sformat(%5.3f)
test age married
test age married race_num3
test (age+married=0) (race_num3=0)


mat b = e(b)'
mat V = e(V)


bvstru b V, obs(2237)
test age married
test age married race_num3
test (age+married=0) (race_num3=0)
//可见两者的P值只有从小数点第4位开始才有差别，说明虽然Wald检验只有在样本量趋向于
//无穷时才为卡方分布，但其有限样本下的检验也很稳健，所以将其应用于非回归情况下的
//结构参数领域(只有b和V提供)也是可行的。


*假设b V均从非回归领域获得的(虽然我们的操作过程不是这样)，这里wmtreg命令统一输出多个估计结果
reg wage age married occupation
mat b = e(b)'
mat V = e(V)
bvstru b V, obs(2237) dep(wage)
est store m1
reg wage age married collgrad occupation
mat b = e(b)'
mat V = e(V)
bvstru b V, obs(2237) dep(wage)
est store m2
reg wage age married collgrad occupation race_num*
mat b = e(b)'
mat V = e(V)
bvstru b V, obs(2237) dep(wage)
est store m3
wmtreg m1 m2 m3, s(N) ti(Structural Estimation)


reg wage age married occupation
est store m4
reg wage age married collgrad occupation
est store m5
reg wage age married collgrad occupation race_num*
est store m6
wmtreg m4 m5 m6, s(N) ti(Regression Estimation)


*实践练习——基本实现Santaeulàlia-Llopis & Zheng(2018) table 3的自动输出
clear all
#delimit ;
mat B = (0.099,0.035,0.104,0.035,0.132,0.060,0.119,0.037\
0.065,0.058,0.062,0.066,0.071,0.077,0.068,0.045\
0.082,0.035,0.070,0.044,0.092,0.026,0.077,0.032\
0.105,0.047,0.094,0.086,0.108,0.149,0.092,0.045\
0.132,0.103,0.117,0.058,0.155,0.239,0.092,0.078\
0.295,0.122,0.283,0.133,0.292,0.142,0.291,0.146\
0.397,0.248,0.385,0.237,0.353,0.183,0.354,0.172\
0.478,0.296,0.448,0.259,0.490,0.372,0.467,0.172\
0.476,0.357,0.466,0.401,0.478,0.389,0.401,0.245\
0.499,0.304,0.418,0.323,0.460,0.272,0.423,0.289\
0.393,0.202,0.390,0.249,0.386,0.224,0.383,0.165) ;
mat SE = (0.016,0.013,0.019,0.016,0.018,0.018,0.017,0.014\
0.014,0.021,0.013,0.020,0.015,0.030,0.013,0.013\
0.020,0.023,0.015,0.029,0.021,0.027,0.017,0.017\
0.015,0.017,0.016,0.029,0.015,0.032,0.013,0.014\
0.020,0.030,0.024,0.024,0.022,0.043,0.019,0.028\
0.024,0.019,0.025,0.020,0.025,0.027,0.022,0.024\
0.039,0.038,0.031,0.041,0.038,0.043,0.037,0.033\
0.050,0.082,0.046,0.075,0.047,0.103,0.046,0.046\
0.049,0.066,0.037,0.067,0.045,0.066,0.047,0.046\
0.035,0.047,0.043,0.051,0.035,0.078,0.039,0.032\
0.029,0.041,0.031,0.041,0.029,0.062,0.035,0.040) ;
mat obs = (16550\7760\16520\7749\16543\7749\16501\7710) ;
mat rownames B = Permanent,1992-1993 1994-1997 1998-2000 2001-2004 2005-2006
Transitory,1991 1993 1997 2000 2004 2006 ;
mat rownames SE = Permanent,1992-1993 1994-1997 1998-2000 2001-2004 2005-2006
Transitory,1991 1993 1997 2000 2004 2006 ;
mat VAR_hat = hadamard(SE,SE) ;
#delimit cr


local est_store_names ""
forvalues i = 1/`=colsof(B)' {
if mod(`i',2) {
local mt "Rural"
}
else {
local mt "Urban"
}
mat b = B[....,`i']
mat V = diag(VAR_hat[....,`i'])
qui bvstru b V, obs(`=obs[`i',1]') dep(`mt')
est store m`i'
}


//Stata界面和Word输出
#delimit ;
wmtreg m* using Myfile.rtf, replace s(N) nonum nostar mgroups("Disposable income"
"Earnings + public transfers" "Earnings + private transfers" "Earnings only" 2 2 2 2)
ti(Income Risk, Minimum Distance Estimates: Various Income Measures);
#delimit cr


//LaTeX输出
//必须添加宏包makecell，否则无法编译
//由于表格列数较多，可以使页面横置以观看的更舒服，只需在导言区加上
//\usepackage[landscape,a4paper]{geometry}即可
#delimit ;
wmtreg m* using Myfile.tex, replace s(N) nonum nostar mgroups("\makecell{Disposable\\income}"
"\makecell{Earnings +\\public transfers}" "\makecell{Earnings +\\private transfers}"
"\makecell{Earnings\\only}" 2 2 2 2) a(math) page(makecell)
ti(Income Risk, Minimum Distance Estimates: Various Income Measures);
#delimit cr
