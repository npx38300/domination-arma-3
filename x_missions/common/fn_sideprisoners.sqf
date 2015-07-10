// by Xeno
#define THIS_FILE "fn_sideprisoners.sqf"
#include "x_setup.sqf"
private ["_pos", "_newgroup", "_unit_array", "_leader", "_hostages_reached_dest", "_all_dead", "_rescued", "_units", "_nobjs", "_rescuer", "_aiver_check_fnc"];
if !(call d_fnc_checkSHC) exitWith {};

_pos = ([_this, 0] call BIS_fnc_param) select 0;

if (d_with_ranked) then {d_sm_p_pos = nil};

sleep 2;

_newgroup = [d_own_side] call d_fnc_creategroup;
_unit_array = ["civilian", "CIV"] call d_fnc_getunitlist;
[_pos, _unit_array select 0, _newgroup] call d_fnc_makemgroup;
_leader = leader _newgroup;
_leader setSkill 1;
_unit_array = nil;
sleep 2.0112;
_newgroup allowFleeing 0;
[_newgroup, 1] call d_fnc_setGState;
_units = units _newgroup;
{
	removeAllWeapons _x;
	_x setCaptive true;
	_x disableAI "MOVE";
} forEach _units;

sleep 2.333;
["specops", 2, "basic", 2, _pos, 100, true] spawn d_fnc_CreateInf;
sleep 2.333;
["aa", 1, "tracked_apc", 1, "tank", 1, _pos, 1, 140, true] spawn d_fnc_CreateArmor;

sleep 32.123;

_hostages_reached_dest = false;
_all_dead = false;
_rescued = false;

_aiver_check_fnc = {
	if (!d_with_ai) then {
		(toUpper (str _this) in d_can_use_artillery)
	} else {
		true
	}
};

if (!d_with_ai) then {
	_rescuer = objNull;
	while {!_hostages_reached_dest && {!_all_dead}} do {
		call d_fnc_mpcheck;
		if ((_units call d_fnc_GetAliveUnits) == 0) exitWith {
			_all_dead = true;
		};
		if (!_rescued) then {
			_leader = leader _newgroup;
			_nobjs = (getPosATL _leader) nearEntities ["CAManBase", 20];
			if !(_nobjs isEqualTo []) then {
				{
					if (alive _x && {isPlayer _x} && {!(_x getVariable ["xr_pluncon", false])} && {_x call _aiver_check_fnc}) exitWith {
						_rescued = true;
						_rescuer = _x;
						{
							if (!isNull _x && {alive _x}) then {
								_x setCaptive false;
								_x enableAI "MOVE";
							};
						} forEach _units;
						["d_joing", [group _rescuer, _units]] call d_fnc_NetCallEventSTO;
					};
					sleep 0.01;
				} forEach _nobjs;
			};
		} else {
			_hostages_reached_test = {!isNull _x && {alive _x} && {(vehicle _x) distance d_FLAG_BASE < 20}} count _units > 0;
		};
		if (d_with_ranked && {_hostages_reached_dest}) then {
			["d_sm_p_pos", getPosATL d_FLAG_BASE] call d_fnc_NetCallEventToClients;
		};
		sleep 5.123;
	};
};

if (_all_dead) then {
	d_sm_winner = -400;
} else {
	if ((_units call d_fnc_GetAliveUnits) > 7) then {
		d_sm_winner = 2;
	} else {
		d_sm_winner = -400;
	};
};

d_sm_resolved = true;
if (d_IS_HC_CLIENT) then {
	["d_sm_var", d_sm_winner] call d_fnc_NetCallEventCTS;
};

sleep 5.123;

{
	if (!isNull _x) then {
		if (vehicle _x != _x) then {
			["d_delvc", [vehicle _x, _x]] call d_fnc_NetCallEventSTO;
		} else {
			deleteVehicle _x;
		};
	};
} forEach _units;
sleep 0.5321;
if (!isNull _newgroup) then {deleteGroup _newgroup};

_units = nil;
