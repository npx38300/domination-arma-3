//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_remabox.sqf"
#include "x_setup.sqf"

private ["_bpos"];
_bpos = [_this, 0] call BIS_fnc_param;
if (typeName _bpos == "SCALAR") exitWith {};
{
	if ((_x select 0) distance _bpos < 5) exitWith {
		deleteMarker (_x select 1);
		d_ammo_boxes deleteAt _forEachIndex;
	};
} forEach d_ammo_boxes;
publicVariable "d_ammo_boxes";