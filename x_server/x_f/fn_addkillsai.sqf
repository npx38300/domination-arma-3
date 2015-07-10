//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_addkillsai.sqf"
#include "x_setup.sqf"

private ["_killer","_lead"];
_killer = [_this, 1] call BIS_fnc_param;
if (!isPlayer _killer) then {
	_lead = leader _killer;
	if (!isNull _lead && {isPlayer _lead} && {side (group _killer) != d_side_enemy}) then {
		_lead addScore ([_this, 0] call BIS_fnc_param);
	};
};