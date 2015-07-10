// by Xeno
#define THIS_FILE "fn_getoutehpoints.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_unit", "_var"];
_unit = _this select 2;
if (!isPlayer _unit) exitWith {};
if (alive player && {_unit != player} && {alive _unit}) then {
	_var = _unit getVariable "d_TRANS_START";
	if (!isNil "_var" && {_var distance _unit > d_transport_distance}) then {
		["d_pas", [player, d_ranked_a select 18]] call d_fnc_NetCallEventCTS;
	};
};