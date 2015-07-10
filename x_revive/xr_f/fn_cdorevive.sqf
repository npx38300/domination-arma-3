// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_revive\xr_f\fn_cdorevive.sqf"
#include "xr_macros.sqf"

if (isDedicated) exitWith {};

player setVariable ["xr_cursorTarget", _this select 0];
(_this select 0) setVariable ["xr_busyt", time + 10, true];

0 spawn xr_fnc_dorevive