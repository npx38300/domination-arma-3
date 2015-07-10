// by Xeno
#define THIS_FILE "fn_getsidemissionclient.sqf"
private ["_do_hint"];
#include "x_setup.sqf"
if (isDedicated || {d_IS_HC_CLIENT}) exitWith{};

_do_hint = [_this, 0] call BIS_fnc_param;

if (d_cur_sm_idx == -1) exitWith {};

if !(isServer && {!isDedicated}) then {call compile preprocessFileLineNumbers format ["x_missions\ma3a\%2%1.sqf", d_cur_sm_idx, d_sm_fname]};

if (d_with_ranked) then {
	d_was_at_sm = false;
	d_sm_running = true;

	if (d_cur_sm_idx != -1 && {d_x_sm_type == "normal"}) then {
		(d_x_sm_pos select 0) spawn {
			private "_posione";
			_posione = _this;
			while {d_sm_running} do {
				if (player distance _posione < (d_ranked_a select 12)) exitWith {
					d_was_at_sm = true;
					d_sm_running = false;
				};
				sleep 3.012 + random 3;
			};
		};
	};
};

if (_do_hint) then {
	playSound "d_IncomingChallenge2";
	hint composeText[
		parseText("<t color='#f000ffff' size='1'>" + (localize "STR_DOM_MISSIONSTRING_710") + "</t>"), lineBreak,lineBreak,
		d_cur_sm_txt
	];
};
