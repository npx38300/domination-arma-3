// by Xeno
#define THIS_FILE "fn_sideconvoy.sqf"
#include "x_setup.sqf"
private ["_direction", "_numconfv", "_newgroup", "_reta", "_vehicles", "_nextpos", "_leader", "_i", "_wp", "_endtime", "_onevec"];
if !(call d_fnc_checkSHC) exitWith {};

_pos_start = [_this, 0] call BIS_fnc_param;
_pos_end = [_this, 1] call BIS_fnc_param;
_direction = [_this, 2] call BIS_fnc_param;

_crew_member = "";

if (d_with_ranked) then {d_sm_p_pos = nil};

d_confvdown = 0;
_numconfv = count d_sm_convoy_vehicles;
_newgroup = [d_side_enemy] call d_fnc_creategroup;
_reta = [1, _pos_start, (d_sm_convoy_vehicles select 0), _newgroup, _direction] call d_fnc_makevgroup;
_vehicles = _reta select 0;
_onevec = _vehicles select 0;
_onevec lock true;
_onevec allowCrewInImmobile true;
_nextpos = _onevec modeltoworld [0, -9, 0];
_nextpos set [2,0];
_onevec addEventHandler ["killed", {d_confvdown = d_confvdown + 1; (_this select 0) removeAllEventHandlers "killed"; {(_this select 0) deleteVehicleCrew _x} forEach (crew (_this select 0))}];

d_x_sm_vec_rem_ar = [d_x_sm_vec_rem_ar, _vehicles] call d_fnc_arrayPushStack;
d_x_sm_rem_ar = [d_x_sm_rem_ar, _reta select 1] call d_fnc_arrayPushStack;
_leader = leader _newgroup;
_leader setRank "LIEUTENANT";
_newgroup allowFleeing 0;
_newgroup setCombatMode "GREEN";
_newgroup setFormation "COLUMN";
_newgroup setSpeedMode "LIMITED";
sleep 1.933;
_vehicles = nil;
_allSMVecs = [_onevec];
for "_i" from 1 to (_numconfv - 1) do {
	_reta = [1, _nextpos, (d_sm_convoy_vehicles select _i), _newgroup, _direction] call d_fnc_makevgroup;
	_vehicles = _reta select 0;
	_onevec = _vehicles select 0;
	_onevec lock true;
	_nextpos = _onevec modeltoworld [0, -9, 0];
	_nextpos set [2,0];
	_onevec addEventHandler ["killed", {d_confvdown = d_confvdown + 1; (_this select 0) removeAllEventHandlers "killed"; {(_this select 0) deleteVehicleCrew _x} forEach (crew (_this select 0))}];
	_allSMVecs pushBack _onevec;
	d_x_sm_vec_rem_ar = [d_x_sm_vec_rem_ar, _vehicles] call d_fnc_arrayPushStack;
	d_x_sm_rem_ar = [d_x_sm_rem_ar, _reta select 1] call d_fnc_arrayPushStack;
	sleep 1.933;
	_vehicles = nil;
};

_wp =_newgroup addWaypoint[_pos_start, 0];
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "NORMAL";
_wp setwaypointtype "MOVE";
_wp setWaypointFormation "COLUMN";
_wp setWaypointTimeout [60,80,70];
_wp = _newgroup addWaypoint[_pos_end, 0];

sleep 20.123;

_convoy_reached_dest = false;
_convoy_destroyed = false;
_endtime = time + 3600;

while {true} do {
	call d_fnc_mpcheck;
	if (d_confvdown == _numconfv || {{canMove _x} count _allSMVecs == 0}) exitWith {
		_convoy_destroyed = true;
	};
	if ((getPosATL (leader _newgroup)) distance _pos_end < 40) exitWith {
		_convoy_reached_dest = true;
	};
	if (d_with_ranked) then {["d_sm_p_pos", getPosATL _leader] call d_fnc_NetCallEventToClients};
	if (time > _endtime) exitWith {_convoy_reached_dest = true};
	sleep 5.123;
};

d_sm_winner = if (_convoy_reached_dest) then {
	-300
} else {
	2
};

d_sm_resolved = true;
if (d_IS_HC_CLIENT) then {
	["d_sm_var", d_sm_winner] call d_fnc_NetCallEventCTS;
};