// by Xeno
#define THIS_FILE "fn_dropammoboxdx.sqf"
#include "x_setup.sqf"
private ["_unit", "_caller", "_chatfunc", "_boxpos"];

if (isDedicated) exitWith {};

_unit = [_this, 0] call BIS_fnc_param;
_caller = [_this, 1] call BIS_fnc_param;

if (_unit == _caller) then {_unit = d_curvec_dialog};

_chatfunc = {
	if (vehicle (_this select 1) == (_this select 0)) then {
		(_this select 0) vehicleChat (_this select 2);
	} else {
		(_this select 1) sideChat (_this select 2);
	};
};

if (_caller != driver _unit && {!isNil {_unit getVariable "d_choppertype"}}) exitWith {
	[_unit, _caller, localize "STR_DOM_MISSIONSTRING_1428"] call _chatfunc;
};

if (_unit distance d_AMMOLOAD < 20) exitWith {[_unit, _caller, localize "STR_DOM_MISSIONSTRING_217"] call _chatfunc};

if ((_unit call d_fnc_GetHeight) > 3) exitWith {_unit vehicleChat (localize "STR_DOM_MISSIONSTRING_218")};

if (speed _unit > 3) exitWith {_unit vehicleChat (localize "STR_DOM_MISSIONSTRING_219")};

if (d_num_ammo_boxes >= d_MaxNumAmmoboxes) exitWith {
	[_unit, _caller, format [localize "STR_DOM_MISSIONSTRING_220", d_MaxNumAmmoboxes]] call _chatfunc;
};

if !(_unit getVariable ["d_ammobox", false]) exitWith {[_unit, _caller, localize "STR_DOM_MISSIONSTRING_222"] call _chatfunc};

if ((_unit getVariable ["d_ammobox_next", -1]) > time) exitWith {[_unit, _caller, format [localize "STR_DOM_MISSIONSTRING_223", round ((_unit getVariable "d_ammobox_next") - time)]] call _chatfunc};

[_unit, _caller, localize "STR_DOM_MISSIONSTRING_224"] call _chatfunc;

_unit setVariable ["d_ammobox", false, true];
_unit setVariable ["d_ammobox_next", time + d_drop_ammobox_time, true];

_boxpos = _unit modelToWorldVisual [4,0,0];
_boxpos set [2, 0];

["d_m_box", [_boxpos, _unit]] call d_fnc_NetCallEvent;

[_unit, _caller, localize "STR_DOM_MISSIONSTRING_225"] call _chatfunc;