#define THIS_FILE "fn_taskDefend.sqf"
#include "x_setup.sqf"
/*
	File: taskDefend.sqf
	Author: Joris-Jan van 't Land

	Description:
	Group will man nearby static defenses and guard the position.

	Parameter(s):
	_this select 0: group (Group)
	_this select 1: defense position (Array)
	
	Returns:
	Boolean - success flag
*/

if (count _this < 2) exitWith {false};

private ["_grp", "_pos"];
_grp = [_this, 0] call BIS_fnc_param;
_pos = [_this, 1] call BIS_fnc_param;

if (typeName _grp != "GROUP" || {typeName _pos != "ARRAY"}) exitWith {false};

_grp setBehaviour "SAFE";

private ["_units"];
_units = (units _grp) - [leader _grp];
_staticWeapons = [];

{if ((_x emptyPositions "gunner") > 0) then {_staticWeapons pushBack _x}} forEach (_pos nearEntities ["StaticWeapon", 100]);

{
	if (!(_units isEqualTo []) && {random 1 > 0.2}) then {
		private "_unit";
		_unit = _units select ((count _units) - 1);
		_unit assignAsGunner _x;
		[_unit] orderGetIn true;
		_units resize ((count _units) - 1);
	};
} forEach _staticWeapons;

private "_wp";
_wp = _grp addWaypoint [_pos, 10];
_wp setWaypointType "GUARD";

_units spawn {
	scriptName "spawn_x_taskDefend_sitdown";
	sleep 5;
	{
		if (random 1 > 0.4) then {
			doStop _x;
			sleep 0.5;
			_x action ["SitDown", _x];
		};
	} forEach _this;
};
true