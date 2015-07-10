//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_getgroup.sqf"
#include "x_setup.sqf"

if (typeName _this == "GROUP") exitwith {_this};
group _this