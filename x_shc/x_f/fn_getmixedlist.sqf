//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_getmixedlist.sqf"
#include "x_setup.sqf"

private ["_side", "_ret_list", "_list"];
_side = [_this, 0] call BIS_fnc_param;
_ret_list = [];
{
	_list = [_x, _side] call d_fnc_getunitlist;
	_ret_list pushBack [_list select 1, _list select 2];
} forEach [switch (floor random 2) do {case 0: {"wheeled_apc"};case 1: {"jeep_mg"};}, "tracked_apc", "tank", "aa"];
_ret_list