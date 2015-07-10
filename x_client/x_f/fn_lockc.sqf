// by Xeno
#define THIS_FILE "x_lockc.sqf"
#include "x_setup.sqf"
private ["_vec", "_arg"];

if (isDedicated) exitWith {};

if (vehicle player != player) exitWith {
	systemChat (localize "STR_DOM_MISSIONSTRING_274")
};

_vec = [_this, 0] call BIS_fnc_param;
_arg = [_this, 3] call BIS_fnc_param;

if (_arg == 0 && {_vec call d_fnc_isVecLocked}) exitWith {systemChat (localize "STR_DOM_MISSIONSTRING_275")};

if (_arg == 1 && {!(_vec call d_fnc_isVecLocked)}) exitWith {systemChat (localize "STR_DOM_MISSIONSTRING_276")};

if (_arg == 1 && {_vec getVariable ["d_MHQ_Deployed", false]}) exitWith {
	systemChat (localize "STR_DOM_MISSIONSTRING_277");
};

if (_arg == 0 && {!((crew _vec) isEqualTo [])}) then {{_x action ["getOut", vehicle _x]} forEach ((crew _vec) - [player])};

switch (_arg) do {
	case 0: {["d_l_v", [_vec, true]] call d_fnc_NetCallEventCTS; systemChat (localize "STR_DOM_MISSIONSTRING_278")};
	case 1: {["d_l_v", [_vec, false]] call d_fnc_NetCallEventCTS; systemChat (localize "STR_DOM_MISSIONSTRING_279")};
};

d_adm_currentvec = objNull;
_vec removeAction (_this select 2);
d_admin_idd =  -9999;
