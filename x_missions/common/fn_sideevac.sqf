// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_sideevac.sqf"
#include "x_setup.sqf"

if !(call d_fnc_checkSHC) exitWith {};

private ["_endtime", "_poss", "_wreck", "_owngroup", "_pilot1", "_pilot2", "_rescued", "_resctimestarted", "_nobjs", "_newgroup", "_units", "_leader", "_aiver_check_fnc", "_pcheck_fnc"];
_pos_array = [_this, 0] call BIS_fnc_param;
_endtime = [_this, 1] call BIS_fnc_param;

_poss = _pos_array select 0;

_wreck = createVehicle [d_sm_wrecktype, _poss, [], 0, "NONE"];
_wreck setDir (random 360);
_wreck setPos _poss;
_wreck lock true;
d_x_sm_vec_rem_ar pushBack _wreck;

sleep 2;

_owngroup = [d_side_player] call d_fnc_creategroup;
__TRACE_1("","_owngroup")
_pilot1 = _owngroup createUnit [d_sm_pilottype, _poss, [], 60, "FORM"];
__TRACE_1("","_pilot1")
_pilot1 call d_fnc_removeNVGoggles;
_pilot1 call d_fnc_removefak;

_pilot2 = _owngroup createUnit [d_sm_pilottype, getPosATL _pilot1, [], 0, "FORM"];
__TRACE_1("","_pilot2")
_pilot2 call d_fnc_removeNVGoggles;
_pilot2 call d_fnc_removefak;

[_owngroup, 1] call d_fnc_setGState;

sleep 15;
_pilot1 disableAI "MOVE";
_pilot1 setDamage 0.5;
_pilot1 setUnitPos "DOWN";
_pilot2 disableAI "MOVE";
_pilot2 setDamage 0.5;
_pilot2 setUnitPos "DOWN";

_is_dead = false;
_pilots_at_base = false;
_rescued = false;
_time_over = 3;
_enemy_created = false;
_resctimestarted = time;

_pcheck_fnc = {
	private ["_u", "_p"];
	_u = [_this, 0] call BIS_fnc_param;
	if (alive _u) then {
		_u setUnitPos "AUTO";
		_u enableAI "MOVE";
		_p = [_this, 1] call BIS_fnc_param;
		["d_joing", [group _p, [_u]]] call d_fnc_NetCallEventSTO;
	};
};

_aiver_check_fnc = {
	if (!d_with_ai) then {
		(str _this) in d_can_use_artillery
	} else {
		true
	}
};

while {!_pilots_at_base && {!_is_dead}} do {
	if (isMultiplayer) then {waitUntil {sleep (1.012 + random 1);_pnum = call d_fnc_PlayersNumber; if (_pnum == 0) then {_resctimestarted = time};_pnum > 0}};
	if (!alive _pilot1 && {!alive _pilot2}) then {
		_is_dead = true;
	} else {
		if (!_rescued) then {
			__TRACE("not rescued")
			if (alive _pilot1) then {
				__TRACE("_pilot1 alive")
				_nobjs = (getPosATL _pilot1) nearEntities ["CAManBase", 20];
				__TRACE_1("","_nobjs")
				if !(_nobjs isEqualTo []) then {
					{
						if (alive _x && {isPlayer _x} && {!(_x getVariable ["xr_pluncon", false])} && {_x call _aiver_check_fnc}) exitWith {
							_resctimestarted = time;
							_rescued = true;
							__TRACE_1("found player","_x")
							[_pilot1, _x] call _pcheck_fnc;
							[_pilot2, _x] call _pcheck_fnc;
						};
						sleep 0.01;
					} forEach _nobjs;
				};
			};
			
			if (!_rescued) then {
				if (alive _pilot2) then {
					__TRACE("_pilot2 alive")
					_nobjs = (getPosATL _pilot2) nearEntities ["CAManBase", 20];
					__TRACE_1("","_nobjs")
					if !(_nobjs isEqualTo []) then {
						{
							if (alive _x && {isPlayer _x} && {!(_x getVariable ["xr_pluncon", false])} && {_x call _aiver_check_fnc}) exitWith {
								_resctimestarted = time;
								_rescued = true;
								__TRACE_1("found player","_x")
								[_pilot1, _x] call _pcheck_fnc;
								[_pilot2, _x] call _pcheck_fnc;
							};
							sleep 0.01;
						} forEach _nobjs;
					};
				};
				
				if (!_rescued && {time - _resctimestarted > 1800}) then {
					_is_dead = true;
				};
			};
		} else {
			if (alive _pilot1 && {alive _pilot2}) then {
				if (_pilot1 distance d_FLAG_BASE < 20 && {_pilot2 distance d_FLAG_BASE < 20}) then {_pilots_at_base = true};
			} else {
				if (_pilot1 distance d_FLAG_BASE < 20 || {_pilot2 distance d_FLAG_BASE < 20}) then {_pilots_at_base = true};
			};
			if (time - _resctimestarted > 1800) then {
				_is_dead = true;
			};
		};
	};

	sleep 5.621;
	if (_time_over > 0) then {
		if (_time_over == 3) then {
			if (_endtime - time <= 600) then {
				_time_over = 2;
				["d_kbmsg", [23]] call d_fnc_NetCallEventCTS;
			};
		} else {
			if (_time_over == 2) then {
				if (_endtime - time <= 300) then {
					_time_over = 1;
					["d_kbmsg", [25]] call d_fnc_NetCallEventCTS;
				};
			} else {
				if (_time_over == 1) then {
					if (_endtime - time <= 120) then {
						_time_over = 0;
						["d_kbmsg", [27]] call d_fnc_NetCallEventCTS;
					};
				};
			};
		};
	} else {
		if (!_enemy_created) then {
			_enemy_created = true;
			_estart_pos = [_poss,250] call d_fnc_GetRanPointCircleOuter;
			_unit_array = ["basic", d_enemy_side] call d_fnc_getunitlist;
			for "_i" from 1 to ([3,5] call d_fnc_GetRandomRangeInt) do {
				_newgroup = [d_enemy_side] call d_fnc_creategroup;
				_units = [_estart_pos, _unit_array select 0, _newgroup] call d_fnc_makemgroup;
				sleep 1.045;
				_leader = leader _newgroup;
				_leader setRank "LIEUTENANT";
				_newgroup allowFleeing 0;
				[_newgroup, _poss] call d_fnc_AttackWP;
				d_x_sm_rem_ar = [d_x_sm_rem_ar, _units] call d_fnc_arrayPushStack;
				sleep 1.012;
			};
			_unit_array = nil;
		};
	};
};

if (_is_dead) then {
	d_sm_winner = -700;
} else {
	if (d_with_ranked) then {
		["d_sm_p_pos", getPosATL d_FLAG_BASE] call d_fnc_NetCallEventToClients;
	};
	d_sm_winner = 2;
};

sleep 2.123;

if (!isNull _pilot1 && {vehicle _pilot1 != _pilot1}) then {
	_pilot1 action ["getOut", vehicle _pilot1];
	unassignVehicle _pilot1;
	_pilot1 setPos [0,0,0];
};
if (!isNull _pilot2 && {vehicle _pilot2 != _pilot2}) then {
	_pilot2 action ["getOut", vehicle _pilot2];
	unassignVehicle _pilot2;
	_pilot2 setPos [0,0,0];
};
sleep 0.5;
deleteVehicle _pilot1;
deleteVehicle _pilot2;

d_sm_resolved = true;
if (d_IS_HC_CLIENT) then {
	["d_sm_var", d_sm_winner] call d_fnc_NetCallEventCTS;
};