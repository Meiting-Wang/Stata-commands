cd X:\exercise
sysuse nlsw88.dta, clear
tab race, gen(race_num)
drop race_num1


*构建回归结果
reg wage age married occupation
est store m1
reg wage age married collgrad occupation
est store m2
reg wage age married collgrad occupation race_num*
est store m3
reg wage age married collgrad occupation hours race_num*
est store m4


*构建矩阵
set seed 123456
mat A = 2563*matuniform(6,5)
mat list A


wmtsum //输出所有数值型变量的描述性统计
wmtsum wage age race hours //报告所输入变量的描述性统计
wmtsum wage age race hours, s(N sd(3) min(%9.2f) p99(%9.3fc)) //报告指定统计量和指定数值格式的描述性统计
wmtsum wage age race hours, s(N sd(3) min(%9.2f) p99(%9.3fc)) ti(this is a title) //为表格添加自定义标题
wmtsum wage age race hours using Myfile.rtf, replace s(N sd(3) min(%9.2f) p99(%9.3fc)) ti(this is a title) //将结果导入到Word文件中
wmtsum wage age race hours using Myfile.tex, replace s(N sd(3) min(%9.2f) p99(%9.3fc)) ti(this is a title) a(math) //将结果导入到LaTeX中，并设置列格式为传统数学模式


wmttest wage age race hours, by(south) //依据south对变量进行分组T均值检验
wmttest wage age race hours, by(south) s(mean_diff(%9.2f) p(star 4)) //自定义数值格式和star要显示的位置
wmttest wage age race hours, by(south) s(mean_diff(%9.2f) p(star 4)) ti(this is a title) //自定义表格标题
wmttest wage age race hours using Myfile.rtf, replace by(south) s(mean_diff(%9.2f) p(star 4)) ti(this is a title) //导出结果至Word
wmttest wage age race hours using Myfile.tex, replace by(south) s(mean_diff(%9.2f) p(star 4)) ti(this is a title) a(math) //导出结果至LaTeX，并设置列格式为传统数学模式

wmtcorr //输出所有数值型变量的相关系数矩阵
wmtcorr wage age race hours //输出制定变量的相关系数矩阵
wmtcorr wage age race hours, b(2) //设置相关系数的数值格式
wmtcorr wage age race hours, b(2) p(%9.3f) //报告p值并设定p值的数值格式
wmtcorr wage age race hours, b(2) p(%9.3f) staraux //将星号标注在p值上
wmtcorr wage age race hours, b(2) p(%9.3f) nostar //不标注星号
wmtcorr wage age race hours, b(2) p(%9.3f) corr //以corr默认方式计算相关系数
wmtcorr wage age race hours, b(2) p(%9.3f) ti(this is a title) //设置表格标题
wmtcorr wage age race hours using Myfile.rtf, replace b(2) p(%9.3f) ti(this is a title) //将结果导出至Word中
wmtcorr wage age race hours using Myfile.tex, replace b(2) p(%9.3f) ti(this is a title) a(math) //将结果导出至LaTeX中，并设置列格式为传统的数学模式

wmtreg //展示所有已经储存的回归结果
wmtreg m1 m2 m3 m4 //展示指定的系列回归结果
wmtreg m1 m2 m3 m4, drop(_cons hours) //不报告常数项和hours变量
wmtreg m1 m2 m3 m4, keep(age married) //只报告age和married变量
wmtreg m1 m2 m3 m4, order(married hours) //将变量married和hours置于报告变量的最上方
wmtreg m1 m2 m3 m4, b(%9.2f) //设定回归系数的格式，且默认下报告系数的标准误
wmtreg m1 m2 m3 m4, b(%9.2f) onlyb //只报告系数值
wmtreg m1 m2 m3 m4, b(%9.2f) t(3) //不报告默认下的se值，换而报告t值
wmtreg m1 m2 m3 m4, b(%9.2f) p(%9.3f) //不报告默认下的se值，换而报告p值
wmtreg m1 m2 m3 m4, b se(%9.3f) staraux //在标准误上标注星号
wmtreg m1 m2 m3 m4, b se(%9.3f) nostar //不在任何地方标注星号
wmtreg m1 m2 m3 m4, b se(%9.3f) ind(race=race_num*) //不报告race_num*系列变量，换之以Yes或No的形式展示race变量是否在回归中出现
wmtreg m1 m2 m3 m4, b se(%9.3f) s(r2(2) ar2(%11.4f) aic F ll N(%9.0fc)) //报告特定的scalars，以及设定它们的数值格式
wmtreg m1 m2 m3 m4, b se(%9.3f) nonum //不报告回归所在序号
wmtreg m1 m2 m3 m4, b se(%9.3f) nomt //不报告每个回归模型的名称
wmtreg m1 m2 m3 m4, b se(%9.3f) mt(model1 model2 model3 model4) //自定义每个回归模型的名称
wmtreg m1 m2 m3 m4, b se(%9.3f) ti(this is a title) //自定义表格标题
wmtreg m1 m2 m3 m4, b se(%9.3f) mg(A B 2 2) //设置前两个回归为组别A，后两个回归为组别B
wmtreg m1 m2 m3 m4, b se(%9.3f) mg("Urban people" B 2 2) //设置前两个回归为组别Urban people，后两个回归为组别B
wmtreg m1 m2 m3 m4 using Myfile.rtf, replace b se(%9.3f) //将回归结果导入至Word
wmtreg m1 m2 m3 m4 using Myfile.tex, replace b se(%9.3f) a(math) //将回归结果导入至LaTeX，并设定列格式为传统数学模式

wmtmat A //Stata界面输出矩阵A的内容
wmtmat A, fmt(4) //设置整体矩阵的数值格式为小数点后4位
wmtmat A, rowsfmt(1 2 3 4 5 6) //分别设置矩阵每一行数值的格式
wmtmat A, colsfmt(5 4 3 2 1) //分别设置矩阵每一列数值的格式
wmtmat A, ti(this is a title) //自定义表格标题
wmtmat A using Myfile.rtf, replace //将矩阵输出至Word
wmtmat A using Myfile.tex, replace a(math) //将矩阵输出至LaTeX，并设定列格式为传统的数学模式

wmtsum wage age married grade using Myfile.rtf, replace
wmttest wage age married grade using Myfile.rtf, by(south) append
wmtcorr wage age married grade using Myfile.rtf, append
wmtreg m1 m2 m3 m4 using Myfile.rtf, append
wmtmat A using Myfile.rtf, append

wmtsum wage age married grade using Myfile.tex, replace
wmttest wage age married grade using Myfile.tex, by(south) append
wmtcorr wage age married grade using Myfile.tex, append
wmtreg m1 m2 m3 m4 using Myfile.tex, append
wmtmat A using Myfile.tex, append

