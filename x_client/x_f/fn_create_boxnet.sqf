// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_create_boxnet.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_box", "_unit", "_boxcargo"];
_pos = [_this, 0] call BIS_fnc_param;
_unit = [_this, 1] call BIS_fnc_param;
__TRACE_2("","_pos","_unit")
_box = d_the_box createVehicleLocal _pos;
_box setPos _pos;
__TRACE_2("","_box","_pos")
player reveal _box;
_box allowDamage false;
_box addAction ["<t color='#FF0000'>Virtual Ammobox System (VAS)</t>", "VAS\open.sqf", [], 6, true, true, "", "vehicle _this == _this && _this distance getPos _target < 6"];
_boxcargo = _unit getVariable "d_boxcargo";
__TRACE_1("","_boxcargo")
if (isNil "_boxcargo") then {
	[_box] call d_fnc_weaponcargo;
} else {
	[_box, _boxcargo] call d_fnc_fillDropedBox;
	_unit setVariable ["d_boxcargo", nil];
};