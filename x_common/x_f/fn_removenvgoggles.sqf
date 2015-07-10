//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_removenvgoggles.sqf"
#include "x_setup.sqf"

if (d_without_nvg != 0) exitWith {};

private "_hmd";
_hmd = hmd _this;

if (_hmd == "NVGoggles" || {_hmd == "NVGoggles_OPFOR"} || {_hmd == "NVGoggles_INDEP"}) then {
	_this unlinkItem _hmd;
};
