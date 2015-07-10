// by Xeno
#define THIS_FILE "fn_checkhelipilot_wreck.sqf"
#include "x_setup.sqf"
private ["_vec","_position","_enterer"];

if (isDedicated) exitWith {};

_enterer = _this select 2;
if (_enterer != player) exitWith {};

_vec = [_this, 0] call BIS_fnc_param;
_position = [_this, 1] call BIS_fnc_param;
_exit_it = false;

if (_position == "driver") then {
	if (d_with_ranked) then {
		if (rankId player < (d_wreck_lift_rank call d_fnc_GetRankIndex)) exitWith {
			[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_179", rank player, d_wreck_lift_rank call d_fnc_GetRankString];
			_exit_it = true;
		};
	};
	if (_exit_it) exitWith {};
	_may_fly = true;
	if (d_pilots_only == 0 && {!(call d_fnc_isPilotCheck)}) then {
		_may_fly = false;
		_exit_it = true;
	};
	if (_may_fly) then {
		if (d_chophud_on) then {
			player setVariable ["d_hud_id", _vec addAction [(localize "STR_DOM_MISSIONSTRING_176") call d_fnc_GreyText, {_this call d_fnc_sethud},0,-1,false]];
		} else {
			player setVariable ["d_hud_id", _vec addAction [(localize "STR_DOM_MISSIONSTRING_177") call d_fnc_GreyText, {_this call d_fnc_sethud},1,-1,false]];
		};
		[_vec] spawn d_fnc_helilift_wreck;
	};
};

if (_exit_it) then {
	_enterer action["getOut", _vec];
};