* Feather: calculate the regular statistics when you know the b and V in the structural parameters
* Author: Meiting Wang, Master, School of Economics, South-Central University for Nationalities
* Email: 2017110097@mail.scuec.edu.cn
* Created on Nov 21th, 2019

/*
note: only b and V are required. P CI and the constraints test(if you use test command
after this command) will be calculated based on normal distribution.
*/


program define bvstru, eclass
version 15.1

syntax namelist(id="b V" min=2 max=2) [if] [in] [, ///
	obs(numlist >0 min=1 max=1 integer) DEPname(string)]
/*
optional illustration:
obs(): set the number of observations the estimation uses to get the results.
depname(): set the name of model you estimate this time.
*/

tempname b bT V //设置临时性矩阵名称和标量名称
local mat1_inp: word 1 of `namelist' //提取输入项的第一个单词
local mat2_inp: word 2 of `namelist' //提取输入项的第二个单词

*判断所输入的元素是否为矩阵
cap local temp1 = det(`mat1_inp')
cap local rc1 = _rc
cap local temp2 = det(`mat2_inp')
cap local rc2 = _rc
if (`rc1'!=0)|(`rc2'!=0) {
	dis "{error:only matrices required}"
	exit
}

*分别提取里面的b和V
local mat1_inp_cols = colsof(`mat1_inp')
local mat1_inp_rows = rowsof(`mat1_inp')
local mat2_inp_cols = colsof(`mat2_inp')
local mat2_inp_rows = rowsof(`mat2_inp')
if (`mat1_inp_cols'!=1)&(`mat2_inp_cols'!=1) {
	dis "{error:a parametric column vector required in the input elements}"
	exit
}
else if (`mat1_inp_cols'==1)&(`mat2_inp_cols'==1) {
	dis "{error:the number of parameters be greater than 1}"
	exit
} //该条件确保两个矩阵中只有一个矩阵的列数为1
if (`mat1_inp_rows'!=`mat2_inp_rows') {
	dis "{error:The number of parameters does not match the order of the variance covariance matrix}"
	exit
}
else if (`mat1_inp_rows' == 1) {
	dis "{error:the number of parameters should be greater than 1}"
	exit
} //该条件确保两个矩阵的行数相等且不等于1
if (`mat1_inp_cols'==1) {
	mat `b' = `mat1_inp'
	mat `V' = `mat2_inp'
}
else {
	mat `b' = `mat2_inp'
	mat `V' = `mat1_inp'
}
if (~issymmetric(`V')) {
	dis "{error: A symmetric matrix required in the variance covariance matrix}"
	exit
} 
else if ~det(`V') {
	dis "{error: A non-singular matrix required in the variance covariance matrix}"
	exit
} //此条件确保所输入的方差协方差矩阵为对称非奇异矩阵矩阵

*构建obs和depname的联合语句
local obs_st ""
if ("`obs'"!="") {
	local obs_st "obs(`obs')"
}
local depname_st ""
if ("`depname'"!="") {
	local depname_st "dep(`depname')"
}
local obs_depname_st ""
if ("`obs'"!="")|("`depname'"!="") {
	local obs_depname_st ", `obs_st' `depname_st'"
}

*计算结构参数的常规统计量
mat `bT' = `b''
eret post `bT' `V' `obs_depname_st'
if ("`obs'"!="") {
	dis in g "obs = `obs'"
}
eret display, sformat(%5.3f)  //报告结果(基于结构参数-正态分布)

eret local cmd "Structural parameters"
end
