//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_checkrespawn.sqf"
#include "xr_macros.sqf"

if (isDedicated) exitWith {};

private ["_pos"];
_pos = getPosATL _this;
_pos set [2, _this distance _pos];
__TRACE_2("","_this","_pos")
player setVariable ["xr_death_pos", [_pos, getDirVisual _this]];