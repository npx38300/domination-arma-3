//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_arraypushstack.sqf"
#include "x_setup.sqf"

{
	(_this select 0) pushBack _x;
} foreach (_this select 1);
(_this select 0)