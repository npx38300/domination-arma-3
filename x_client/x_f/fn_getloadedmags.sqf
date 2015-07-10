//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_getloadedmags.sqf"
#include "x_setup.sqf"

private ["_weapon", "_muzzles", "_ar_magdets", "_ar_mags"];
_weapon = [_this, 0] call BIS_fnc_param;
if (_weapon == "") exitWith {[[],[]]};
_muzzles = getArray(configFile/"cfgWeapons"/_weapon/"muzzles");
__TRACE_1("","_muzzles")
if (typeName _muzzles != "ARRAY") exitWith {[[],[]]};
_ar_magdets = [];
_ar_mags = [];
{
	_which = if (_x == "this") then {_weapon} else {_x};
	__TRACE_1("","_which")
	_p selectWeapon _which;
	_ar_magdets pushBack (currentMagazineDetail _p);
	_ar_mags pushBack (currentMagazine _p);
} forEach _muzzles;
__TRACE_1("","_ar_magdets")
__TRACE_1("","_ar_mags")
[_ar_magdets, _ar_mags]
