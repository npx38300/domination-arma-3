// by Xeno
#define THIS_FILE "fn_sethud.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_vec", "_state"];
_vec = [_this, 0] call BIS_fnc_param;
_state = [_this, 3] call BIS_fnc_param;

switch (_state) do {
	case 0: {
		d_chophud_on = false;
		_vec removeAction (player getVariable "d_hud_id");
		player setVariable ["d_hud_id", _vec addAction [(localize "STR_DOM_MISSIONSTRING_177") call d_fnc_GreyText, {_this call d_fnc_sethud},1,-1,false]];
	};
	case 1: {
		d_chophud_on = true;
		_vec removeAction (player getVariable "d_hud_id");
		player setVariable ["d_hud_id", _vec addAction [(localize "STR_DOM_MISSIONSTRING_176") call d_fnc_GreyText, {_this call d_fnc_sethud},0,-1,false]];
	};
};