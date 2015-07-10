//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_getunitlist.sqf"
#include "x_setup.sqf"

private ["_grptype","_side","_side_char","_ulist", "_idx"];
_grptype = [_this, 0] call BIS_fnc_param;
_side = [_this, 1] call BIS_fnc_param;
_side_char = if (typeName _side == "STRING") then {
	switch (_side) do {case "OPFOR": {"E"};case "BLUFOR": {"W"};case "GUER": {"G"};case "CIV": {"W"};case "EAST": {"E"};case "WEST": {"W"};}
} else {
	switch (_side) do {case opfor: {"E"};case blufor: {"W"};case independent: {"G"};case civilian: {"W"};}
};
if (_grptype == "basic") exitWith {
	[(missionNamespace getVariable format ["d_allmen_%1",_side_char]) call d_fnc_RandomArrayVal, ""]
};
if (_grptype == "specops") exitWith {
	[missionNamespace getVariable format ["d_specops_%1",_side_char], ""]
};
if (_grptype == "artiobserver") exitWith {
	[[missionNamespace getVariable format["d_arti_observer_%1",_side_char]], ""]
};
if (_grptype == "heli") exitWith {
	[(missionNamespace getVariable format ["d_allmen_%1",_side_char]) call d_fnc_RandomArrayVal, ""]
};
_idx = ["tank", "tracked_apc", "wheeled_apc", "aa", "jeep_mg", "jeep_gl", "stat_mg", "stat_gl", "arty", "tr_fuel", "tr_rep", "tr_ammo"] find _grptype;
if (_idx != -1) exitWith {
	[[], ((missionNamespace getVariable format ["d_veh_a_%1", _side_char]) select _idx) call d_fnc_RandomArrayVal]
};
if (_grptype == "civilian") exitWith {
	_ulist = [];
	_ulist resize 11;
	for "_i" from 0 to 10 do {
		_ulist set [_i, d_civilians_t call d_fnc_RandomArrayVal]
	};
	[_ulist, ""]
};
[]