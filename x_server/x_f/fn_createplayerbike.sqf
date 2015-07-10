//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_createplayerbike.sqf"
#include "x_setup.sqf"

private ["_unit","_vtype","_pos","_vehicle","_b_mode"];
_unit = [_this, 0] call BIS_fnc_param;
_vtype = [_this, 1] call BIS_fnc_param;
_b_mode = [_this, 2] call BIS_fnc_param;
_pos = getPosATL _unit;
_vehicle = createVehicle [_vtype, _pos, [], 0, "CAN_COLLIDE"];
_vehicle setDir direction _unit;
_vehicle setPos _pos;
["d_stocbike", [_unit, _vehicle]] call d_fnc_NetCallEventSTO;
if (_b_mode != 1) then {
	_vehicle setVariable ["d_end_time", _this select 3];
};
d_allunits_add pushBack _vehicle;