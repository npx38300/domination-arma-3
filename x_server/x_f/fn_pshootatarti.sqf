//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_pshootatarti.sqf"
#include "x_setup.sqf"

private ["_shooter", "_vec"];

_shooter = _this select 3;
if (!isPlayer _shooter) exitWith {};

_vec = [_this, 0] call BIS_fnc_param;

if (time >= (_vec getVariable ["d_ncuttoft", 0])) then {
	diag_log format [localize "STR_DOM_MISSIONSTRING_1461", name _shooter, getPlayerUID _shooter];
	["d_saat", _shooter] call d_fnc_NetCallEventToClients;
	_vec setVariable ["d_ncuttoft", time + 1];
};