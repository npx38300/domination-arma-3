//#define __DEBUG__
#define THIS_FILE "fn_removefak.sqf"
#include "x_setup.sqf"

if (d_no_faks == 0) then {
	_this removeItem "FirstAidKit";
};