{smcl}
{right:Updated time: May 11, 2020}
{* -----------------------------title------------------------------------- *}{...}
{p 0 16 2}
{bf:[W-6] matmh} {hline 2} Achieve more matrix operations comparing to matrix command. The source code can be gained in {browse "https://github.com/Meiting-Wang/matmh":github}.


{* -----------------------------Syntax------------------------------------ *}{...}
{title:Syntax}

{p 8 8 2}
{bf:matmh} {it:expression} [, {it:{help wmtmat##Options:options}}]

{p 4 4 2}
where the subcommands can be :

{synoptset 20}{...}
{synopthdr:subcommand}
{synoptline}
{synopt :{it:expression}}A matrix operation expression required, like A = (1,2\3,4){p_end}
{synoptline}


{* -----------------------------Contents------------------------------------ *}{...}
{title:Contents}

{p 4 4 2}
{help matmh##Description:Description}{break}
{help matmh##Options:Options}{break}
{help matmh##Examples:Examples}{break}
{help matmh##Author:Author}{break}
{help matmh##Also_see:Also see}{break}


{* -----------------------------Description------------------------------------ *}{...}
{marker Description}{title:Description}

{p 4 4 2}
{bf:matmh}, Extended version of command {help matrix}, can realize more matrix operations, which include what command {help matrix} can do. It is worth noting that this command can only be used in version 15.1 or later.


{* -----------------------------Options------------------------------------ *}{...}
{marker Options}{title:Options}

{synoptset 20}{...}
{synopthdr}
{synoptline}
{synopt :{opth d:isplay(format:fmt)}}Format the matrix{p_end}
{synopt :{opt nd:isplay}}Do not display the matrix. {bf:matmh} will display the matrix by default{p_end}
{synoptline}


{* -----------------------------Examples------------------------------------ *}{...}
{marker Examples}{title:Examples}

{p 4 4 2}Setup{p_end}
{p 8 8 2}. {stata matmh A = (4,6,8,10\-1,0,1,16\1.2,1.3,1.4,1.5\3.6,-1.6,-1.4,-1.5)}{break}
. {stata matmh B = (3,2,2,5\5,6,7,8\8,3,4,11\6,13,14,6)}{p_end}

{p 4 4 2}Extract submatrix from a matrix{p_end}
{p 8 8 2}. {stata matmh test = A}{break}
. {stata "matmh test = A[2,3]"}{break}
. {stata "matmh test = A[1:3,2]"}{break}
. {stata "matmh test = A[1:,2]"}{break}
. {stata "matmh test = A[:,2]"}{break}
. {stata "matmh test = A[1:3,2:4]"}{break}
. {stata "matmh test = A[1:3,2:]"}{break}
. {stata "matmh test = A[1:3,:]"}{break}
. {stata "matmh test = A[1:3,1 3 4]"}{break}
. {stata "matmh test = A[1 3 4,1 3 4]"}{break}
. {stata "matmh test = A[1 3 4,1 3 4], nd"}{break}
. {stata "matmh test = A[1 3 4,1 3 4], d(%9.3f)"}{p_end}

{p 4 4 2}Element operation for matrix{p_end}
{p 8 8 2}. {stata "matmh test = A.+B"}{break}
. {stata "matmh test = A.-B"}{break}
. {stata "matmh test = A.*B"}{break}
. {stata "matmh test = A./B"}{break}
. {stata "matmh test = A.^B"}{p_end}

{p 4 4 2}Logic operation for matrix{p_end}
{p 8 8 2}. {stata "matmh test = (A>B)"}{break}
. {stata "matmh test = A>=B"}{break}
. {stata "matmh test = A==B"}{break}
. {stata "matmh test = A<=B"}{break}
. {stata "matmh test = A<B"}{break}
. {stata "matmh test = A!=B"}{break}
. {stata "matmh test = A~=B"}{break}
. {stata "matmh test = A&B"}{break}
. {stata "matmh test = A|B"}{break}
. {stata "matmh test = !A"}{break}
. {stata "matmh test = ~A"}{p_end}

{p 4 4 2}Mathematical function operation for matrix, you can find more mathematical function in {help mathematical functions:here}{p_end}
{p 8 8 2}. {stata "matmh test = reverse(A)"}{break}
. {stata "matmh test = ln(A)"}{break}
. {stata "matmh test = log10(A)"}{break}
. {stata "matmh test = abs(A)"}{break}
. {stata "matmh test = exp(A)"}{break}
. {stata "matmh test = floor(A)"}{break}
. {stata "matmh test = round(A)"}{break}
. {stata "matmh test = ceil(A)"}{p_end}

{p 4 4 2}Power operation for matrix{p_end}
{p 8 8 2}. {stata "matmh test = A^2"}{break}
. {stata "matmh test = A^10"}{break}
. {stata "matmh test = A^(10)"}{break}
. {stata "matmh test = A^-1"}{break}
. {stata "matmh test = A^(-1)"}{p_end}

{p 4 4 2}Construction of arithmetic progression(ap) or geometric progression(gp){p_end}
{p 8 8 2}. matmh test = apd(begin_num,quantity_of_numbers,delta){break}
. matmh test = ape(begin_num,quantity_of_numbers,end_num){break}
. matmh test = gpd(begin_num,quantity_of_numbers,delta){break}
. matmh test = gpe(begin_num,quantity_of_numbers,end_num){break}
. {stata "matmh test = 1::10"}{break}
. {stata "matmh test = 1:2:11"}{break}
. {stata "matmh test = 1:2:12"}{break}
. {stata "matmh test = apd(1,6,3)"}{break}
. {stata "matmh test = ape(1,5,21)"}{break}
. {stata "matmh test = gpd(1,6,2)"}{break}
. {stata "matmh test = gpe(1,5,81)"}{p_end}

{p 4 4 2}Including what {help matrix} can do, like, but not limited to:{p_end}
{p 8 8 2}. {stata "matmh test = A + B"}{break}
. {stata "matmh test = A * B"}{break}
. {stata "matmh test = A # B"}{break}
. {stata "matmh test = A \ B"}{break}
. {stata "matmh test = (A, B)"}{break}
. {stata "matmh test = A / 3"}{break}
. {stata "matmh test = hadamard(A,B)"}{break}
. {stata "matmh test = J(2,3,9)"}{break}
. {stata "matmh test = matuniform(4,5)"}{break}
. {stata "matmh test = trace(A)"}{break}
. {stata "matmh test = rowsof(A)"}{break}
. {stata "matmh A[1,1] = 100"}{break}
. {stata "matmh rown A = row1 row2 row3 row4"}{break}
. {stata "matmh dir"}{break}
. {stata "matmh drop test"}{break}
. {stata "matmh rename A new_A"}{break}
. {stata "matmh list new_A"}{break}
. {stata "matmh test = (6,2,4\2,3,2\4,2,6)"}{break}
. {stata "matmh symeigen X v = test"}{break}
. {stata "matmh svd U W V = test"}{p_end}


{* -----------------------------Author------------------------------------ *}{...}
{marker Author}{title:Author}

{p 4 4 2}
Meiting Wang{break}
Institute for Economic and Social Research, Jinan University{break}
Guangzhou, China{break}
wangmeiting92@gmail.com


{* -----------------------------Also see------------------------------------ *}{...}
{marker Also_see}{title:Also see}

{space 4}{help matrix}
