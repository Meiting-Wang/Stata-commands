* Feather: install commands of Meiting Wang in gitee.com
* Author: Meiting Wang, Master, School of Economics, South-Central University for Nationalities
* Email: 2017110097@mail.scuec.edu.cn
* Created on Oct 27th, 2019


program define wmtinstall
version 15.1

syntax name(id="a wmt's command name") [, replace]
/*
optional illustration:
1. name: you can input one of commands including itself wmtsum wmttest wmtcorr 
   wmtreg wmtmat wmtbvols or wmtbvstru
2. replace: replace the existing .ado file
*/

*-------------前期语句处理----------
if "`namelist'" == "itself" {
	local namelist "wmtinstall"
}
local dld_web "https://gitee.com/wangmeiting/personal_public_warehouse/raw/master/ado_files/`namelist'.ado"
local install_path `"`c(sysdir_plus)'`=ustrleft("`namelist'",1)'"'
local install_path_file `"`c(sysdir_plus)'`=ustrleft("`namelist'",1)'/`namelist'.ado"'


*----------主程序--------------
*判断需要安装的命令在相应的plus文件夹中是否存在
local judge: dir "`install_path'" files "`namelist'.ado", respectcase
if (`"`judge'"'!="")&("`replace'"=="") {
	dis "{error:{bf:`namelist'} already exists}"
	exit
}

*安装命令
cap copy `dld_web' `install_path_file'
if _rc == 0 {
	if `"`judge'"'!="" {
		dis "{result:{bf:`namelist'} updated successfully}"
	}
	else {
		dis "{result:{bf:`namelist'} installed successfully.}"
	}
}
else {
	dis "{error:{bf:`namelist'} not found.}"
}

end
