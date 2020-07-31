* Description: return the row and column names of the matrix in consideration of the equation name
* Author: Meiting Wang, Doctor, Institute for Economic and Social Research, Jinan University
* Email: wangmeiting92@gmail.com
* Created on July 30, 2020

program define mat_rcfn, rclass
version 16
syntax name(name=name id="a matrix name") //选择name而不是anything可以确保其符合矩阵的命名规则
/*
*-实例：
mat A=(1,4,5\4,5,6\7,8,4)
mat rown A = price mpg trunk
mat coln A = hello hi huohuo
mat B =(45,7,45,7\7,4,5,7\45,65,45,12\451,457,1274,54)
mat rown B = 1:asd 2:fge 2:weg Total:asd
mat coln B = 1:csajd 1:cghas 2:cgdf Total:cjad

mat_rcfn A
ret list
mat_rcfn B
ret list

*-注意事项
1. 该程序与local xx: rowfullnames A、local xx: colfullnames A发生了重复，就当做练习吧。
*/

*程序报错信息
cap mat list `name'
if _rc {
	dis "{error:matrix `name' not found}"
	exit
} //确保矩阵`name'存在


*常规方法提取矩阵的行列方程名、行列名
local roweq_`name': roweq `name'
local rown_`name': rown `name'
local coleq_`name': coleq `name'
local coln_`name': coln `name'


*在考虑方程名的情况下，输出矩阵的行列名
local rown ""
local rowsof_`name' = rowsof(`name')
forvalues i = 1 / `rowsof_`name'' {
	local roweq_c: word `i' of `roweq_`name''
	local rown_c: word `i' of `rown_`name''
	local rown "`rown'`roweq_c':`rown_c' "
}
local rown = strtrim(stritrim(ustrregexra("`rown'","_:","")))

local coln ""
local colsof_`name' = colsof(`name')
forvalues i = 1 / `colsof_`name'' {
	local coleq_c: word `i' of `coleq_`name''
	local coln_c: word `i' of `coln_`name''
	local coln "`coln'`coleq_c':`coln_c' "
}
local coln = strtrim(stritrim(ustrregexra("`coln'","_:","")))


*将结果输出至Stata界面上
mat list `name'
dis _n "{text:matrix `name''s rownames: }{result:`rown'}"
dis "{text:matrix `name''s colnames: }{result:`coln'}"

*返回值
return local coln "`coln'"
return local rown "`rown'"
end