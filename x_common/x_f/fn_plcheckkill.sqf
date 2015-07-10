// by Xeno
#define THIS_FILE "fn_plcheckkill.sqf"
#include "x_setup.sqf"
private "_killed";
_killed = [_this, 0] call BIS_fnc_param;

if (local _killed) then {
	[0] call d_fnc_playerspawn;
};

if (!isServer) exitWith {};

private "_killer";
_killer = [_this, 1] call BIS_fnc_param;

if (d_with_ranked && {!(side (group _killer) == side (group _killed))} && {d_sub_kill_points != 0}) then {
	_killed addScore d_sub_kill_points;
};

if (d_with_ai) then {
	if (!isNull _killer && {!isPlayer _killer} && {side (group _killer) == side (group _killed)} && {vehicle _killed != vehicle _killer}) then {
		_leader_killer = leader _killer;
		if (isPlayer _leader_killer) then {
			_par = d_player_store getVariable (getPlayerUID _killed);
			_namep = if (isNil "_par") then {"Unknown"} else {_par select 6};
			_par = d_player_store getVariable (getPlayerUID _leader_killer);
			_namek = if (isNil "_par") then {"Unknown"} else {_par select 6};
			[_namek, _namep, _killer] call d_fnc_TKKickCheck;
		};
	};
};

if (!isNull _killer && {isPlayer _killer} && {vehicle _killer != vehicle _killed}) then {
	_par = d_player_store getVariable (getPlayerUID _killed);
	__TRACE_1("_killed",_par)
	_namep = if (isNil "_par") then {"Unknown"} else {_par select 6};
	_par = d_player_store getVariable (getPlayerUID _killer);
	__TRACE_1("_killer",_par)
	_namek = if (isNil "_par") then {"Unknown"} else {_par select 6};
	[_namek, _namep, _killer] call d_fnc_TKKickCheck;
	["d_unit_tk", [_namep,_namek]] call d_fnc_NetCallEventToClients;
};
