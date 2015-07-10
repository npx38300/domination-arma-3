// by Xeno
#define THIS_FILE "fn_checkhelipilot.sqf"
#include "x_setup.sqf"
private ["_listin", "_vec", "_enterer", "_exit_it", "_may_fly"];

if (isDedicated) exitWith {};

_listin = [_this, 0] call BIS_fnc_param;
_enterer = _listin select 2;
if (_enterer != player) exitWith {};

_vec = _listin select 0;
_exit_it = false;

if (_listin select 1 == "driver") then {
	_may_fly = true;
	if (d_pilots_only == 0 && {!(call d_fnc_isPilotCheck)}) then {
		_may_fly = false;
		_exit_it = true;
	};
	if (_may_fly) then {
		if (_this select 1 == 0) then {
			if (d_chophud_on) then {
				player setVariable ["d_hud_id", _vec addAction [(localize "STR_DOM_MISSIONSTRING_176") call d_fnc_GreyText, {_this call d_fnc_sethud},0,-1,false]];
			} else {
				player setVariable ["d_hud_id", _vec addAction [(localize "STR_DOM_MISSIONSTRING_177") call d_fnc_GreyText, {_this call d_fnc_sethud},1,-1,false]];
			};
			
			[_vec] spawn d_fnc_helilift;
		};
	};
};

if (_exit_it) then {
	_enterer action["getOut", _vec];
};