//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_kickplayerbs.sqf"
#include "x_setup.sqf"

private ["_pl", "_uid", "_reason"];
_pl = [_this, 0] call BIS_fnc_param;
_pl_name = [_this, 1] call BIS_fnc_param;
_reason = [_this, 2] call BIS_fnc_param;
_uid = getPlayerUID _pl;
serverCommand ("#kick " + _pl_name);
["d_em", [_pl]] call d_fnc_NetCallEventSTO;
if (_reason != -1) then {
	switch (_reason) do {
		case 0: {
			diag_log format [localize "STR_DOM_MISSIONSTRING_943", _pl_name, _uid];
		};
		case 1: {
			diag_log format [localize "STR_DOM_MISSIONSTRING_944", _pl_name, _uid];
		};
		case 2: {
			diag_log format [localize "STR_DOM_MISSIONSTRING_945", _pl_name, _uid];
		};
		case 3: {
			diag_log format [localize "STR_DOM_MISSIONSTRING_946", _pl_name, _uid];
		};
	};
	["d_ps_an", [_pl_name, _reason]] call d_fnc_NetCallEventToClients;
};