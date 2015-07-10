// by Xeno
#define THIS_FILE "fn_playervectrans.sqf"
#include "x_setup.sqf"
if (isDedicated) exitWith {};

#define __vaeh _vec addEventHandler
#define __vreh _vec removeEventHandler

private ["_vec", "_eindex", "_egoindex"];
_vec = vehicle player;
_eindex = -1;
_egoindex = -1;
while {d_player_in_vec && {alive player} && {!(player getVariable ["xr_pluncon", false])}} do {
	if (player == driver _vec) then {
		if (_egoindex == -1) then {
			_egoindex = __vaeh ["getout", {_this call d_fnc_getOutEHPoints}];
			{if (_x != player && {isPlayer _x}) then {_x setVariable ["d_TRANS_START", getPosATL _vec]}} forEach (crew _vec);
		};
		if (_eindex == -1) then {
			_eindex = __vaeh ["getin",{if (isPlayer (_this select 2)) then {(_this select 2) setVariable ["d_TRANS_START", getPosATL (_this select 0)]}}];
		};
	};
	if (player != driver _vec) then {
		if (_eindex != -1) then {
			__vreh ["getin",_eindex];
			_eindex = -1;
		};
		if (_egoindex != -1) then {
			__vreh ["getout",_egoindex];
			_egoindex = -1;
		};
	};
	sleep 0.812;
};
if (_eindex != -1) then {
	__vreh ["getin",_eindex];
};
if (_egoindex != -1) then {
	__vreh ["getout",_egoindex];
};
