// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_createdrop.sqf"
#include "x_setup.sqf"
#define __announce \
d_para_available = true; publicVariable "d_para_available";\
["d_upd_sup"] call d_fnc_NetCallEventToClients; \
{_chopper deleteVehicleCrew _x} forEach _crew;\
deleteVehicle _chopper;\
deleteMarker #d_drop_marker

#define __del \
{_chopper deleteVehicleCrew _x} forEach _crew;\
deleteVehicle _chopper;\
deleteMarker #d_drop_marker

#define __exit if (!alive _unit || {!alive _chopper} || {!canMove _chopper}) exitWith {[_crew,_chopper] spawn _delete_chop;_may_exit = true}
private ["_player", "_crew", "_chopper", "_grp", "_spos", "_veca", "_wp", "_wp2", "_para", "_doit", "_vehicle", "_starttime", "_unit", "_endtime"];
if (!isServer) exitWith {};

_drop_type = [_this, 0] call BIS_fnc_param;
_drop_pos = [_this, 1] call BIS_fnc_param;
_player = [_this, 2] call BIS_fnc_param;

__TRACE_3("","_drop_type","_drop_pos","_player")

["d_dropansw", [_player, 0]] call d_fnc_NetCallEventSTO;

_drop_pos = [_drop_pos select 0, _drop_pos select 1, 120];

d_para_available = false; publicVariable "d_para_available";
["d_upd_sup"] call d_fnc_NetCallEventToClients;

_end_pos = call d_fnc_GetRanPointOuterAir;
_dstart_pos = call d_fnc_GetRanPointOuterAir;

_delete_chop = {
	private ["_crew","_chopper"];
	_crew = [_this, 0] call BIS_fnc_param;
	_chopper = [_this, 1] call BIS_fnc_param;
	d_para_available = true; publicVariable "d_para_available";
	["d_upd_sup"] call d_fnc_NetCallEventToClients;
	sleep 180 + random 100;
	__del;
};

_grp = [d_drop_side] call d_fnc_creategroup;

_spos = [_dstart_pos select 0, _dstart_pos select 1, 300];
_cdir = [_spos, _drop_pos] call d_fnc_DirTo;
_veca = [_spos, _cdir, d_drop_aircraft, _grp] call d_fnc_spawnVehicle;
_chopper = _veca select 0;
d_allunits_add pushBack _chopper;
_chopper lock true;
removeAllWeapons _chopper;
["d_drop_marker", [0,0,0],"ICON","ColorBlue",[0.5,0.5],localize "STR_DOM_MISSIONSTRING_940",0,"hd_dot"] call d_fnc_CreateMarkerGlobal;
sleep 0.1;
_crew = _veca select 1;
{_x setCaptive true} forEach _crew;
_unit = driver _chopper;

_wp = _grp addWaypoint [_drop_pos, 0];
_wp setWaypointBehaviour "CARELESS";
_wp setWaypointSpeed "NORMAL";
_wp setWaypointtype "MOVE";

_wp2 = _grp addWaypoint [_end_pos, 0];
_wp2 setWaypointtype "MOVE";
_wp2 setWaypointBehaviour "CARELESS";
_wp2 setWaypointSpeed "NORMAL";

_chopper flyInHeight 120;
_dist_to_drop = 250;
_may_exit = false;
sleep 12 + random 12;
["d_dropansw", [_player, 1]] call d_fnc_NetCallEventSTO;
_starttime = time + 300;
_endtime = time + 600;
while {_chopper distance _drop_pos > 1000} do {
	sleep 3.512;
	"d_drop_marker" setMarkerPos (getPosASL _chopper);
	if (time > _endtime) then {
		_chopper setDamage 1;
	};
	__exit;
	if (time > _starttime && {_chopper distance _dstart_pos < 500}) exitWith {__announce;_may_exit = true};
};
if (_may_exit) exitWith {["d_dropansw", [_player, 3]] call d_fnc_NetCallEventSTO};

["d_dropansw", [_player, 2]] call d_fnc_NetCallEventSTO;
_endtime = time + 600;
while {_chopper distance _drop_pos > _dist_to_drop} do {
	sleep 0.556;
	"d_drop_marker" setMarkerPos (getPosASL _chopper);
	if (time > _endtime) then {
		_chopper setDamage 1;
	};
	__exit;
	_unit doMove _drop_pos;
};
if (_may_exit) exitWith {["d_dropansw", [_player, 3]] call d_fnc_NetCallEventSTO};

//_unit doMove _end_pos;

[_chopper,_drop_type,_player,_drop_pos] spawn {
	scriptName "spawn_x_createdrop_spawndrop";
	private ["_para","_chopper","_doit","_vehicle","_drop_type","_player","_drop_pos"];
	_chopper = [_this, 0] call BIS_fnc_param;
	_drop_type = [_this, 1] call BIS_fnc_param;
	_player = [_this, 2] call BIS_fnc_param;
	_drop_pos = [_this, 3] call BIS_fnc_param;
	
	sleep 1.512;
	_vehicle = objNull;
	_is_ammo = false;
	_para = objNull;
	_chopposx = getPosATL _chopper;
	_chopposx set [2, (_chopposx select 2) - 10];
	if (_drop_type isKindOf "ReammoBox_F") then {
		_is_ammo = true;
		_para = createVehicle [d_cargo_chute, _chopposx, [], 0, "FLY"];
		_para setPos _chopposx;
		_para setVelocity (velocity _chopper);
	} else {
		_vehicle = createVehicle [_drop_type, _chopposx, [], 0, "NONE"]; // dunno if this all still works, needs check
		_vehicle setPos _chopposx;
		_para = createVehicle [d_cargo_chute, _chopposx, [], 0, "FLY"];
		_para setPos (_vehicle modelToWorld [0,0,2]);
		_vehicle attachTo [_para,[0,0,0]];
		_para setVelocity (velocity _chopper);
		d_allunits_add pushBack _vehicle;
	};
	
	["d_dropansw", [_player, 4]] call d_fnc_NetCallEventSTO;
	[_vehicle, _para, _is_ammo, _drop_pos] spawn d_fnc_supplydrop;
};

_drop_pos = nil;

_starttime = time + 300;

sleep 0.512;

while {time < _starttime && {canMove _chopper} && {_chopper distance _end_pos > 400}} do {
	"d_drop_marker" setMarkerPos (getPosASL _chopper);
	sleep 3.7;
};

__announce;
