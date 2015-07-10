//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_checkmtshothd.sqf"
#include "x_setup.sqf"

__TRACE_1("","_this")

private ["_tower", "_r", "_val"];
_tower = [_this, 0] call BIS_fnc_param;
if (!alive _tower) exitWith {
	_tower removeAllEventHandlers "handleDamage";
};
_r = 0;
if (toUpper(getText(configFile/"CfgAmmo"/(_this select 4)/"simulation")) in d_hd_sim_types) then {
	_r = (_this select 2) / 1.4;
} else {
	if (d_MTTowerSatchelsOnly == 1 && {getText(configFile/"CfgAmmo"/(_this select 4)/"CraterEffects") == "BombCrater"}) then {
		_r = _this select 2;
	};
};
__TRACE_1("_r new","_r")
if (_r > 0) then {
	_val = _tower getVariable ["d_damt", 0];
	__TRACE_1("","_val")
	if (_val > 0) then {_r = _r + _val};
	_tower setVariable ["d_damt", _r];
	__TRACE_1("_r result","_r")
};
_r