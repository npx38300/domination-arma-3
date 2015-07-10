// by Xeno
#define THIS_FILE "fn_heli_release.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_vehicle","_caller","_id"];
_vehicle = [_this, 0] call BIS_fnc_param;
_caller = [_this, 1] call BIS_fnc_param;
_id = [_this, 2] call BIS_fnc_param;

if (_caller == driver _vehicle) then {
	_vehicle removeAction _id;
	_vehicle setVariable ["d_Vehicle_Released", true];
};