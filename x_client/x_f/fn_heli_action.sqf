// by Xeno
#define THIS_FILE "fn_heli_action.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private "_vehicle";
_vehicle = [_this, 0] call BIS_fnc_param;

if (([_this, 1] call BIS_fnc_param) == driver _vehicle) then {
	_vehicle removeAction ([_this, 2] call BIS_fnc_param);
	_vehicle setVariable ["d_Vehicle_Attached", true];
};