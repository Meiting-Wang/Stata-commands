* Feather: achieve more matrix operations comparing to matrix command. see below for some examples.
* Author: Meiting Wang, Master, School of Economics, South-Central University for Nationalities
* Email: 2017110097@mail.scuec.edu.cn
* Created on Nov 25th, 2019
/*
更新日志：
2019年12月16日：解决了matmh A = A[1 2,:]之类的bug；添加了矩阵行列名的传递
*/

program define matmh
version 15.1

syntax anything(equalok id="matrix operation expression") [, Display Displayfmt(string)]
/*
注意：通篇程序没有进入过mata环境
for instance:
mat A = (4,6,8,10\10,12,14,16\16,18,20,22\24,26,28,30)
mat B = (3,2,2,5\5,6,7,8\8,3,4,11\6,13,14,6)

1. 从一个矩阵中提取子矩阵
matmh test = A                         //复制矩阵A
matmh test = A[2,3]                    //提取矩阵A第2行第3列的元素
matmh test = A[1:3,2]                  //提取矩阵A第1至3行，第2列的元素
matmh test = A[1:,2]                   //提取矩阵A第1至最后一行，第二列的元素
matmh test = A[:,2]                    //提取矩阵A所有行，第二列的元素
matmh test = A[1:3,2:4]                //提取矩阵A第1至3行，第2至4列的元素
matmh test = A[1:3,2:]                 //提取矩阵A第1至3行，第2至最后一列的元素
matmh test = A[1:3,:]                  //提取矩阵A第1至3行，所有列的元素
matmh test = A[1:3,1 3 4]              //提取矩阵A第1至3行，第1、3、4列的元素
matmh test = A[1 3 4,1 3 4]            //提取矩阵A第1、3、4行，第1、3、4列的元素
matmh test = A[1 3 4,1 3 4], d         //求得矩阵test后并把其展示出来
matmh test = A[1 3 4,1 3 4], d(%9.3f)  //求得矩阵test后并把其以%9.3f的格式展示出来

2. 矩阵的点乘、点除、点幂运算
matmh test = A.+B     //点加
matmh test = A.-B     //点减
matmh test = A.*B     //点乘
matmh test = A./B     //点除
matmh test = A.^D     //点幂

3. 矩阵的逻辑运算
matmh test = A>B      //不等式逻辑值
matmh test = A>=B
matmh test = A==B
matmh test = A<=B
matmh test = A<B
matmh test = A!=B
matmh test = A~=B
matmh test = A&B      //逻辑与
matmh test = A|B      //逻辑或
matmh test = !A       //逻辑非
matmh test = ~A

4. 矩阵的数学函数运算
matmh test = reverse(A)    //将矩阵A中的所有元素转化为其倒数(自创函数)
matmh test = ln(A)         //求自然对数  
matmh test = log10(A)      //求以10为底的对数
matmh test = abs(A)        //求绝对值
matmh test = exp(A)        //求以自然数为底的指数
matmh test = floor(A)      //求矩阵A的"地板"
matmh test = round(A)      //求与矩阵A最近的板
matmh test = ceil(A)       //求与矩阵A的"天花板"
help mathematical functions  //可以在这里找到常见的Stata内置的数学函数

5. 矩阵的幂运算
matmh test = A^2           //2个方阵A相乘(输入的A必须为方阵)
matmh test = A^10          //10个方阵A相乘
matmh test = A^(10)
matmh test = A^-1          //方阵A的逆
matmh test = A^(-1)

6. 等差或等比列向量的构建
apd: arithmetic progression containing delta
ape: arithmetic progression containing end_number
gpd: geometric progression containing delta
gpe: geometric progression containing end_number
matmh test = apd(begin_num,quantity_of_numbers,delta) 
matmh test = ape(begin_num,quantity_of_numbers,end_num)
matmh test = gpd(begin_num,quantity_of_numbers,delta) 
matmh test = gpe(begin_num,quantity_of_numbers,end_num)

matmh test = 1::10   //生成等差列向量：[1,2,3,4,5,6,7,8,9,10]'
matmh test = 1:2:11  //生成等差列向量：[1,3,5,7,9,11]'
matmh test = 1:2:12  //生成等差列向量：[1,3,5,7,9,11]'

matmh test = apd(1,6,3)   //生成等差列向量：[1,4,7,10,13,16]'
matmh test = ape(1,5,21)  //生成等差列向量：[1,6,11,16,21]'
matmh test = gpd(1,6,2)   //生成等比列向量：[1,2,4,8,16,32]'
matmh test = gpe(1,5,81)  //生成等比列向量：[1,3,9,37,81]'

7. 除此之外，matmh能运行所有mat能运行的计算(即搭载了mat系统)
*/


*----------------------程序报错--------------------------
if ("`display'"!="")&("`displayfmt'"!="") {
	dis "{error:display syntax error}"
	exit
}

if "`displayfmt'" != "" {
	if ~ustrregexm("`displayfmt'","^\%(-|)\d+\.\d+(f|g|e|fc|gc)$") {
		dis "{error:display syntax error}"
		exit
	}
}

*----------------设定单纯的mat语句不能实现的矩阵运算类型------------------------
*situ1-situ4: 提取子矩阵运算中的各种情况
local part "\w+\s*=\s*\w+"  //符合类似于"test = A"
local part1_1 "(\s*\d+\s*|\s*\d+\s*\:\s*\d+\s*|\s*\d+\s*\:\s*|\s*\:\s*\d+\s*|\s*\:\s*)" //符合类似于"5"、"1:3"、"1:"、":5"或":"
local part1_2 "\s*\d+\s+\d+(\s*\d+)*\s*" //符合类似于"1 3"、"1 3 5"、"1 3 5 7"等
local part2_1 "`part1_1'"
local part2_2 "`part1_2'"

local situ1 "^`part'\[`part1_1',`part2_1'\]$" //"test=A[1,3]"、"test=A[1,3:5]"、"test=A[1,3:]"等
local situ2 "^`part'\[`part1_1',`part2_2'\]$" //"test=A[1,3 5 7]"、"test=A[1:5,3 5]"等
local situ3 "^`part'\[`part1_2',`part2_1'\]$" //"test=A[3 5 7,1]"、"test=A[3 5,1:5]"等
local situ4 "^`part'\[`part1_2',`part2_2'\]$" //"test=A[3 5,1 3]"、"test=A[3 5 7,1 3 6]"等


*case1-case4: 分别对应矩阵(与矩阵之间)的元素运算、逻辑运算、数学函数运算和幂运算
local sub "(\w+)\s*=\s*"  //符合类似于"test="
local sub1_1 "(\(\s*|)(\w+)\s*(\.\+|\.\-|\.\*|\.\/|\.\^|>|>=|==|<=|<|!=|~=|&|\|)\s*(\w+)(\s*\)|)" //符合"A.*B"、"A./B"、"(A.*B)"、"A>=B"等
local sub1_2 "(\(\s*|)(~|!)\s*(\w+)(\s*\)|)" //符合"~A"、"!A"、"(~A)"等
local sub1_3 "(\w+)\(\s*(\w+)\s*\)"   //符合"ln(A)"、"log10(A)"、"exp(A)"等
local sub1_4 "(\w+)\s*(\^)\s*(\(\s*|)([1-9]\d*|-1)(\s*\)|)" //符合"A^2"、"A^10"、"A^(10)"、"A^-1"、"A^(-1)"等

local case1 "^`sub'`sub1_1'$" //"test=A.*B"、"test=A./B"、"test=(A./B)"、"test=A>=B"等
local case2 "^`sub'`sub1_2'$" //"test=~A"、"test=!A"、"test=(!A)"等
local case3 "^`sub'`sub1_3'$" //"test=ln(A)"、"test=log10(A)"、"test=exp(A)"等
local case4 "^`sub'`sub1_4'$" //"test=A^2"、"test=A^10"、"test=A^(10)"、"test=A^-1"、"test=A^(-1)"等

//记录非mata环境下Stata自带的只有一个参数的矩阵函数，如cholesky(M)，或某些返回矩阵，如r(table)，
//由于这种情况与`case3'语法一致，所以我们单独拿出来，好在程序运行到`case3'环节时进行分类
local matfun_part1 "cholesky corr diag get I inv invsym nullmat vec vecdiag"
local matfun_part2 "colnfreeparms colsof det diag0cnt issymmetric"
local matfun_part3 "matmissing rownfreeparms rowsof trace"
local matfun_part4 "r e"
local matfun "`matfun_part1' `matfun_part2' `matfun_part3' `matfun_part4'"


*status1-status3：用于生成等差列向量和等比列向量
local portion "(\w+)\s*=\s*"   //符合类似于"test="
local real "((0|[1-9]\d*)|(0|[1-9]\d*)\.\d+|-[1-9]\d*|-(0|[1-9]\d*)\.\d+)" //实数
local realn0 "([1-9]\d*|(0|[1-9]\d*)\.\d+|-[1-9]\d*|-(0|[1-9]\d*)\.\d+)" //不包括0的实数
local positive_int "([1-9]\d*)" //正整数

local status1 "^`portion'`real'\s*\:\:\s*`real'$" //"test=1::9"、"test=-12::6"、"A=-0.123::66.3"等
local status2 "^`portion'`real'\s*\:\s*`realn0'\s*\:\s*`real'$" //"A = 1:1:5"、"test = -15.3:-1:-300"等
local status3 "^`portion'(apd|ape|gpd|gpe)\(\s*`real'\s*,\s*`positive_int'\s*,\s*`real'\s*\)$" //"A=apd(0,6,1)"、"A=ape(0,6,1)"等


*------------------------------主程序-----------------------------------
if ustrregexm("`anything'","^(\w+)\s*=.*") {
	local mat_name = ustrregexs(1) //获得可能要生成的矩阵名
}
else if ustrregexm("`anything'","^\w+\s+(\w+)\s*=.*") {
	local mat_name = ustrregexs(1) //获得可能要修改的矩阵名
}


if ustrregexm("`anything'", "(`situ1')|(`situ2')|(`situ3')|(`situ4')") {    //situ1-situ4情况处理
	local rmat_name = ustrregexra("`anything'","(^\w+\s*=\s*)|(\[.*\]$)","") //获得旧矩阵名

	local part1_st = ustrregexra("`anything'","(`part'\[\s*)|(\s*,.*)","")
	local part2_st = ustrregexra("`anything'","(.*,\s*)|(\s*\])","")
	
	forvalues i = 1/2 {
		if ustrregexm("`part`i'_st'", "^\:\s*\d+$") {
			local part`i'_st = "1`part`i'_st'"
		} 
	} //将`part1_st'和`part2_st'的":6"改为"1:6"
	
	forvalues i = 1/2 {
		if ~ustrregexm("`part`i'_st'", "\:") {
			local part`i'_st "`part`i'_st'"
		} 
		else if ~ustrregexm("`part`i'_st'", "\d") {
			local part`i'_st = ustrregexra("`part`i'_st'","\:","....")
		}
		else if ustrregexm("`part`i'_st'", "^\d+\s*\:$") {
			local part`i'_st = ustrregexra("`part`i'_st'","\:","...")
		}
		else {
			local part`i'_st = ustrregexra("`part`i'_st'","\:","..")
		}
	} //将`part1_st'和`part2_st'的"5:7"、"1:"、":"改为对应的点(以使其符合mat语句)
	
	
	tempname temp xx //设置临时性的矩阵名
	if ustrregexm("`anything'", "`situ1'") {
		mat `mat_name' = `rmat_name'[`part1_st',`part2_st']
	} //situ1
	else if ustrregexm("`anything'", "`situ2'") {
		mat `temp' = `rmat_name'[`part1_st',1]
		local rowna: rownames `temp'  //提取行名
		local mat_rows = rowsof(`temp') //获得新矩阵的行数
		local mat_cols: word count `part2_st' //获得新矩阵的列数
		mat `temp' = J(`mat_rows',`mat_cols',.)
		//这里用`temp'矩阵进行过渡，以应对类似matmh A = A[:,1 3]的情况
		
		tokenize "`part2_st'"
		local i = 1
		local colna "" //用来提取矩阵列名
		while "``i''" != "" {
			local temp1_`i' = ``i''	
			mat `xx' = `rmat_name'[`part1_st',``i''] //过渡提取列名的临时矩阵
			local colna_sub: colnames `xx'
			local colna "`colna'`colna_sub' "
			mat `temp'[1,`i'] = `xx'
			local `i' "" //置空`i'
			local i = `i' + 1
		} //这里要注意temp1_`i'没有被置空。
		mat `mat_name' = `temp'
		mat rownames `mat_name' = `rowna'
		mat colnames `mat_name' = `colna'
	} //situ2
	else if ustrregexm("`anything'", "`situ3'") {
		mat `temp' = `rmat_name'[1,`part2_st']
		local colna: colnames `temp'  //提取列名
		local mat_rows: word count `part1_st' //获得新矩阵的行数
		local mat_cols = colsof(`temp') //获得新矩阵的列数
		mat `temp' = J(`mat_rows',`mat_cols',.)
			
		tokenize "`part1_st'"
		local i = 1
		local rowna "" //用来提取矩阵行名
		while "``i''" != "" {
			local temp2_`i' = ``i''	
			mat `xx' = `rmat_name'[``i'',`part2_st'] //过渡提取行名的临时矩阵
			local rowna_sub: rownames `xx'
			local rowna "`rowna'`rowna_sub' "
			mat `temp'[`i',1] = `xx'
			local `i' "" //置空`i'
			local i = `i' + 1
		} //这里要注意temp2_`i'没有被置空。
		mat `mat_name' = `temp'
		mat rownames `mat_name' = `rowna'
		mat colnames `mat_name' = `colna'
	}
	else if ustrregexm("`anything'", "`situ4'") {
		local mat_rows: word count `part1_st' //获得新矩阵的行数
		local mat_cols: word count `part2_st' //获得新矩阵的列数
		mat `temp' = J(`mat_rows',`mat_cols',.) 
		
		tokenize "`part1_st'"
		local i = 1
		local rowna "" //用来提取矩阵行名
		while "``i''" != "" {
			mat `xx' = `rmat_name'[``i'',....] //过渡提取行名的临时矩阵
			local rowna_sub: rownames `xx'
			local rowna "`rowna'`rowna_sub' "
			local temp3_`i' = ``i''
			local `i' ""
			local i = `i' + 1
		} //将`part1_st'分割于各个temp3_`i'中
		
		tokenize "`part2_st'"
		local i = 1
		local colna "" //用来提取矩阵列名
		while "``i''" != "" {
			mat `xx' = `rmat_name'[....,``i''] //过渡提取列名的临时矩阵
			local colna_sub: colnames `xx'
			local colna "`colna'`colna_sub' "
			local temp4_`i' = ``i''
			local `i' ""
			local i = `i' + 1
		} //将`part2_st'分割于各个temp4_`i'中
		
		local i = 1
		while "`temp3_`i''" != "" {
			local j = 1
			while "`temp4_`j''" != "" {
				mat `temp'[`i',`j'] = `rmat_name'[`temp3_`i'',`temp4_`j'']
				local j = `j' + 1
			}
			local i = `i' + 1
		} //这里要注意temp3_`i'和temp4_`i'没有被置空。
		mat `mat_name' = `temp'
		mat rownames `mat_name' = `rowna'
		mat colnames `mat_name' = `colna'
	}
}
else if ustrregexm("`anything'", "(`case1')|(`case2')|(`case3')|(`case4')") { // case1-case4情况处理
	tempname temp //设置临时性的矩阵名
	if ustrregexm("`anything'", "`case1'") {     
		local rmat_name1 = ustrregexs(3)  //旧矩阵名1
		local operator = ustrregexs(4)    //运算符
		local rmat_name2 = ustrregexs(5)  //旧矩阵名2  
		
		local rmat_name1_r = rowsof(`rmat_name1') //计算矩阵`rmat_name1'的行数，顺带可以判断该矩阵是否存在
		local rmat_name1_c = colsof(`rmat_name1') //计算矩阵`rmat_name1'的列数
		local rmat_name2_r = rowsof(`rmat_name2') //计算矩阵`rmat_name2'的行数，顺带可以判断该矩阵是否存在
		local rmat_name2_c = colsof(`rmat_name2') //计算矩阵`rmat_name2'的列数
		if ~((`rmat_name1_r'==`rmat_name2_r')&(`rmat_name1_c'==`rmat_name2_c')) {
			dis "{error:consistency error}"
			exit
		}

		local rowna: rownames `rmat_name1' //获得旧矩阵名1的行名
		local colna: colnames `rmat_name1' //获得旧矩阵名1的列名
		mat `temp' = J(`rmat_name1_r',`rmat_name1_c',.)
		local operator = ustrregexra("`operator'","\.","") //去除运算符中的点
		forvalues i = 1/`rmat_name1_r' {
			forvalues j = 1/`rmat_name1_c' {
				mat `temp'[`i',`j'] = `rmat_name1'[`i',`j'] `operator' `rmat_name2'[`i',`j']
			}
		} //核心程序
		mat `mat_name' = `temp'
		mat rownames `mat_name' = `rowna'
		mat colnames `mat_name' = `colna'
	}
	else if ustrregexm("`anything'", "`case2'") {
		local operator = ustrregexs(3)    //运算符
		local rmat_name = ustrregexs(4)  //旧矩阵名 
		
		local rmat_name_r = rowsof(`rmat_name') //计算矩阵`rmat_name'的行数，顺带可以判断该矩阵是否存在
		local rmat_name_c = colsof(`rmat_name') //计算矩阵`rmat_name'的列数
		
		local rowna: rownames `rmat_name' //获得旧矩阵名的行名
		local colna: colnames `rmat_name' //获得旧矩阵名的列名
		mat `temp' = J(`rmat_name_r',`rmat_name_c',.)
		forvalues i = 1/`rmat_name_r' {
			forvalues j = 1/`rmat_name_c' {
				mat `temp'[`i',`j'] = `operator'`rmat_name'[`i',`j']
			}
		} //核心程序
		mat `mat_name' = `temp'
		mat rownames `mat_name' = `rowna'
		mat colnames `mat_name' = `colna'
	}
	else if ustrregexm("`anything'", "`case3'") {
		local fun_name = ustrregexs(2)    //运算符
		local rmat_name = ustrregexs(3)  //旧矩阵名 
		
		if ustrregexm("`matfun'","\b`fun_name'\b") {
			mat `anything'
		} //这里不能删除，否则类似test=e(V)或test=trace(A)的输入将不会返回任何结果
		else {
			local rmat_name_r = rowsof(`rmat_name') //计算矩阵`rmat_name'的行数，顺带可以判断该矩阵是否存在
			local rmat_name_c = colsof(`rmat_name') //计算矩阵`rmat_name'的列数
			
			local rowna: rownames `rmat_name' //获得旧矩阵名的行名
			local colna: colnames `rmat_name' //获得旧矩阵名的列名
			mat `temp' = J(`rmat_name_r',`rmat_name_c',.)
			forvalues i = 1/`rmat_name_r' {
				forvalues j = 1/`rmat_name_c' {
					if "`fun_name'" == "reverse" {
						mat `temp'[`i',`j'] = 1/`rmat_name'[`i',`j']
					}
					else {
						mat `temp'[`i',`j'] = `fun_name'(`rmat_name'[`i',`j'])
					}
				}
			} //核心程序
			mat `mat_name' = `temp'
			mat rownames `mat_name' = `rowna'
			mat colnames `mat_name' = `colna'
		}
	}
	else if ustrregexm("`anything'", "`case4'") {  //这里不能写成else {  },因为后面需要引用ustrregexm()的分组结果
		local rmat_name = ustrregexs(2)  //旧矩阵名 
		local power = ustrregexs(5)    //矩阵的幂
		
		if `power'==-1 {
			mat `mat_name' = inv(`rmat_name')
		}
		else if `power' == 1 {
			mat `mat_name' = `rmat_name'
		}
		else {     //若程序运行到这里，则`power'的值将大于等于2
			mat `temp' = `rmat_name'
			forvalues i = 2/`power' {
				mat `temp' = `temp'*`rmat_name'
			}
			mat `mat_name' = `temp'
		}
	}
}
else if ustrregexm("`anything'", "(`status1')|(`status2')|(`status3')") {
	if ustrregexm("`anything'", "`status1'") { 
		local num1 = ustrregexs(2)
		local num2 = ustrregexs(6)
		if ~(`num1'<=`num2') {
			dis "{error:the begin number should be less than or equal to the end number}"
			exit
		}
		local rows = floor(`num2'-`num1') + 1
		
		mat `mat_name' = J(`rows',1,.)
		mat `mat_name'[1,1] = `num1'
		if `rows'>=2 {
			forvalues i = 2/`rows' {
				mat `mat_name'[`i',1] = `mat_name'[`i'-1,1] + 1
			}
		}
	}
	else if ustrregexm("`anything'", "`status2'") { 
		local num1 = ustrregexs(2)
		local delta = ustrregexs(6)
		local num2 = ustrregexs(9)
		local rows = floor((`num2'-`num1')/`delta') + 1
		if `rows'<1 {
			dis "{error:syntax error}"
			exit
		}
		
		mat `mat_name' = J(`rows',1,.)
		mat `mat_name'[1,1] = `num1'
		if `rows'>=2 {
			forvalues i = 2/`rows' {
				mat `mat_name'[`i',1] = `mat_name'[`i'-1,1] + `delta'
			}
		}
	}
	else if ustrregexm("`anything'", "`status3'") { //这里不能写成else {  },因为后面需要引用ustrregexm()的分组结果
		local function = ustrregexs(2)
		local begin_num = ustrregexs(3)
		local quantity_of_numbers = ustrregexs(7)
		local delta_or_end_num = ustrregexs(8)
		
		mat `mat_name' = J(`quantity_of_numbers',1,.)
		mat `mat_name'[1,1] = `begin_num'
		if `quantity_of_numbers' > 1 {
			if "`function'" == "apd" {  //"test=apd(begin_num,n,△)"
				forvalues i = 2/`quantity_of_numbers' {
					mat `mat_name'[`i',1] = `mat_name'[`i'-1,1] + `delta_or_end_num'
				}
			}
			else if "`function'" == "ape" { //"test=ape(begin_num,n,end_num)"
				local delta=(`delta_or_end_num'-`begin_num')/(`quantity_of_numbers'-1)
				forvalues i = 2/`quantity_of_numbers' {
					mat `mat_name'[`i',1] = `mat_name'[`i'-1,1] + `delta'
				}
			}
			else if "`function'" == "gpd" { //"test=gpd(begin_num,n,△)"
				forvalues i = 2/`quantity_of_numbers' {
					mat `mat_name'[`i',1] = `mat_name'[`i'-1,1] * `delta_or_end_num'
				}
			}
			else { //"test=gpd(begin_num,n,end_num)"
				if `begin_num' == 0 {
					dis "{error:begin number in the gpd() shouldn't be 0}"
					exit
				}
				if `delta_or_end_num'/`begin_num'<0 {
					if ~mod(`quantity_of_numbers'-1,2) {
						dis "{error:the number of end_num/begin_num cannot be a radical}"
						exit
					}
					else {
						local delta=-(-`delta_or_end_num'/`begin_num')^(1/(`quantity_of_numbers'-1))
					}
				}
				else {
					local delta=(`delta_or_end_num'/`begin_num')^(1/(`quantity_of_numbers'-1))
				}
				
				forvalues i = 2/`quantity_of_numbers' {
					mat `mat_name'[`i',1] = `mat_name'[`i'-1,1] * `delta'
				}
			}
		}
	}
}
else {   //这里将搭载mat运算系统
	mat `anything'
}

if "`display'" != "" {
	mat list `mat_name'
}
else if "`displayfmt'" != "" {
	mat list `mat_name', format(`displayfmt')
}

end
