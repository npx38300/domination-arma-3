//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_hcaddvec.sqf"
#include "x_setup.sqf"

if (d_IS_HC_CLIENT) then {
	["d_ad", _this] call d_fnc_NetCallEventCTS;
};