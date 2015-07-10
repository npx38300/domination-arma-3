//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_hasnvgoggles.sqf"
#include "x_setup.sqf"

if (d_without_nvg != 0) exitWith {};

private "_hmd";
_hmd = hmd _this;
(_hmd == "NVGoggles" || {_hmd == "NVGoggles_OPFOR"} || {_hmd == "NVGoggles_INDEP"})
