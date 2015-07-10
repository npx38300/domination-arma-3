//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_chopper_welcome2.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_state", "_vec", "_welcome_str1", "_welcome_str2", "_welcome_str3", "_welcome_str4", "_end_welcome"];
disableSerialization;
_state = [_this, 0] call BIS_fnc_param;
_vec = [_this, 1] call BIS_fnc_param;
_welcome_str1 = format [localize "STR_DOM_MISSIONSTRING_183", d_name_pl];

switch (_state) do {
	case 1: {
		_welcome_str2 = localize "STR_DOM_MISSIONSTRING_184";
		_welcome_str3 = localize "STR_DOM_MISSIONSTRING_185";
	};
	case 0: {
		_welcome_str2 = localize "STR_DOM_MISSIONSTRING_186";
		_welcome_str3 = localize "STR_DOM_MISSIONSTRING_187";
	};
	default {
		_welcome_str2 = localize "STR_DOM_MISSIONSTRING_188";
		_welcome_str3 = localize "STR_DOM_MISSIONSTRING_189";
	};
};

_welcome_str4 = if ((toUpper (typeOf _vec)) in d_check_ammo_load_vecs) then {
	localize "STR_DOM_MISSIONSTRING_190"
} else {
	localize "STR_DOM_MISSIONSTRING_191"
};

_end_welcome = time + 14;
67322 cutRsc ["d_chopper_hud", "PLAIN"];
_t = "<t color='#b5f279' size='1.9'><t align='center'>" + _welcome_str1 + "</t><br/><br/>" +
"<t color='#ffffff' size='1.5'><t align='center'>" + _welcome_str2 + "<br/><br/>" +
_welcome_str3 + "<br/><br/>" +
_welcome_str4 + "</t>";
((uiNamespace getVariable "d_chopper_hud") displayCtrl 9999) ctrlSetStructuredText parseText _t;

waitUntil {sleep 0.223;time >= _end_welcome || {vehicle player == player} || {player != driver _vec} || {!alive player} || {player getVariable ["xr_pluncon", false]}};
67322 cutRsc ["d_Empty", "PLAIN", 1];
