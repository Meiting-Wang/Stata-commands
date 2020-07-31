* Description: return the row and column names of the matrix in consideration of the equation name
* Author: Meiting Wang, Doctor, Institute for Economic and Social Research, Jinan University
* Email: wangmeiting92@gmail.com
* Created on July 31, 2020

program define mat_rcnum, rclass
version 16
syntax anything(id=`"like A["r2","c3"]"')
/*
*-实例
mat A=(1,4,5\4,5,6\7,8,4)
mat rown A = r10 r12 r14
mat B =(45,7,45,7\7,4,5,7\45,65,45,12\451,457,1274,54)
mat rown B = 1:asd 2:fge 2:weg Total:asd
mat coln B = 1:csajd 1:cghas 2:cgdf Total:cjad
mat list A
mat list B

mat_rcnum A[2,1]
mat_rcnum A["r12",1]
mat_rcnum A[2,"c1"]
mat_rcnum A["r12","c1"]
ret list

mat_rcnum B[2,1]
mat_rcnum B["2:fge",1]
mat_rcnum B[2,"1:csajd"]
mat_rcnum B["2:fge","1:csajd"]
ret list

*-注意事项
1. 该程序的作用在于根据所输入信息对应出矩阵的行列号
2. 该程序仅仅用来练习用
*/


*设定所输入语句的格式，并从中提取关键信息(矩阵名、矩阵行信息、矩阵列信息)
if ustrregexm(`"`anything'"',`"^([A-Za-z_]\w*)\[\s*([1-9]\d*|"(\w|\(|\))+"|"(\w+:(\w|\(|\))+)")\s*\,\s*([1-9]\d*|"(\w|\(|\))+"|"(\w+:(\w|\(|\))+)")\s*\]$"') {
	local mat_name = ustrregexs(1) //提取矩阵名称(考虑到了Stata矩阵名的命名规则)
	local row_info = ustrregexs(2) //提取矩阵行信息
	local col_info = ustrregexs(6) //提取矩阵列信息
	cap mat list `mat_name'
	if _rc {
		dis "{error:matrix `mat_name' not found}"
		exit
	} //保证所涉及矩阵存在
}
else {
	dis "{error:syntax error}"
	exit
}
/*
要求anything必须符合以下类似语法，否则报错：
A[2,1]
A["r12",1]
A[2,"c1"]
A["r12","c1"]
A["min(trunk)","mean(price)"]
B[2,1]
B["2:fge",1]
B[2,"1:csajd"]
B["2:fge","1:csajd"]
B["Total:asd","1:csajd"]
B["Total:asd","Total:cjad"]
B["0:mean(price)","Total:cjad"]
B["Total:mean(price)","Total:cjad"]
B["Total:cjad","0:mean(price)"]
B["Total:cjad","Total:mean(price)"]
*/


*根据矩阵行列信息计算出其所对应的行列号(已经考虑到了方程名存在的情况)
if ustrregexm(`"`row_info'"',"^[1-9]\d*$") {
	local row_num = `row_info'
}
else {
	local mat_name_rown: rowfullnames `mat_name'
	local count = 1
	foreach i of local mat_name_rown {
		if `""`i'""' == `"`row_info'"' {
			local row_num = `count'
			continue, break
		}
		local count = `count' + 1
	}
}

if ustrregexm(`"`col_info'"',"^[1-9]\d*$") {
	local col_num = `col_info'
}
else {
	local mat_name_coln: colfullnames `mat_name'
	local count = 1
	foreach i of local mat_name_coln {
		if `""`i'""' == `"`col_info'"' {
			local col_num = `count'
			continue, break
		}
		local count = `count' + 1
	}
}


*当无法获得矩阵行列号或所输入行列号超过矩阵最大行列号时的返回信息
if ("`row_num'"=="") {
	dis "{error:cannot get matrix row number from the matrix row information}"
	exit
}
else if (`row_num'>`=rowsof(`mat_name')') {
	dis "{error:the row number inputted exceeds the maximum number of rows in the matrix}"
	exit
}

if ("`col_num'"=="") {
	dis "{error:cannot get matrix column number from the matrix column information}"
	exit
}
else if (`col_num'>`=colsof(`mat_name')') {
	dis "{error:the column number inputted exceeds the maximum number of columns in the matrix}"
	exit
}


*输出结果至Stata界面上
mat list `mat_name'
dis _n `"{text:row_num in `anything': }{result:`row_num'}"'
dis    `"{text:col_num in `anything': }{result:`col_num'}"'


*返回值
return local col_num = `col_num'
return local row_num = `row_num'
end