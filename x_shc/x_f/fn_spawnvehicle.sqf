//#define __DEBUG__
#define THIS_FILE "fn_spawnvehicle.sqf"
#include "x_setup.sqf"
/*
	File: spawnVehicle.sqf
	Author: Joris-Jan van 't Land

	Description:
	Function to spawn a certain vehicle type with all crew (including turrets).
	The vehicle can either become part of an existing group or create a new group.

	Parameter(s):
	_this select 0: desired position (Array).
	_this select 1: desired azimuth (Number).
	_this select 2: type of the vehicle (String).
	_this select 3: side or existing group (Side or Group).

	Returns:
	Array:
	0: new vehicle (Object).
	1: all crew (Array of Objects).
	2: vehicle's group (Group).
*/

private ["_posv1", "_azi", "_typev1", "_param4", "_grp", "_side", "_newGrp"];
_posv1 = [_this, 0] call BIS_fnc_param;
_azi = [_this, 1] call BIS_fnc_param;
_typev1 = [_this, 2] call BIS_fnc_param;
_param4 = [_this, 3] call BIS_fnc_param;
__TRACE_1("","_this")

if (typeName _param4 == "SIDE") then {
	_side = _param4;
	_grp = [_side] call d_fnc_creategroup;
	_newGrp = true;
} else {
	_grp = _param4;
	_side = side _grp;
	_newGrp = false;
};

private ["_sim", "_veh", "_crew"];
_sim = toUpper getText(configFile/"CfgVehicles"/_typev1/"simulation");
__TRACE_1("","_sim")

if (_sim in ["AIRPLANE", "HELICOPTER", "AIRPLANEX", "HELICOPTERX", "HELICOPTERRTD"]) then {
	if (count _posv1 == 2) then {_posv1 pushBack 0};
	_posv1 set [2, (_posv1 select 2) max 200];

	_veh = createVehicle [_typev1, _posv1, [], 0, "FLY"];

	if (_sim == "AIRPLANEX" || {_sim == "AIRPLANE"}) then {
		_veh setVelocity [100 * (sin _azi), 100 * (cos _azi), 0];
	};
} else {
	_veh = createVehicle [_typev1, _posv1, [], 0, "NONE"];
	_svec = sizeOf _typev1;
	_isFlat = (getPosATL _veh) isFlatEmpty [_svec / 2, 150, 0.7, _svec, 0, false, _veh];
	if (count _isFlat > 1) then {
		_posv1 = _isFlat;
		_posv1 set [2, 0];
	};
	if (random 100 > 50) then {_veh allowCrewInImmobile true};
};

_veh setDir _azi;
_veh setPos _posv1;

_crew = [_veh, _grp] call d_fnc_spawnCrew;
_grp addVehicle _veh;

// TODO: Not available in 1.34, add again for 1.36
//_veh setUnloadInCombat [(random 100 > 40), false];

if (_newGrp) then {_grp selectLeader (commander _veh)};

[_veh, _crew, _grp]