//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_getwreck.sqf"
#include "x_setup.sqf"

private ["_no","_rep_station","_types"];
_rep_station = [_this, 0] call BIS_fnc_param;
_types = [_this, 1] call BIS_fnc_param;
_no = nearestObjects [_rep_station, _types, 8];
if (_no isEqualTo []) exitWith {objNull};
if (damage (_no select 0) >= 1) then {_no select 0} else {objNull}
