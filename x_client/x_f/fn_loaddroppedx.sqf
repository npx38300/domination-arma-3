// by Xeno
#define THIS_FILE "fn_loaddroppedx.sqf"
#include "x_setup.sqf"
private ["_unit", "_caller", "_chatfunc", "_nobjs"];

if (isDedicated) exitWith {};

_unit = [_this, 0] call BIS_fnc_param;
_caller = [_this, 1] call BIS_fnc_param;

_chatfunc = {
	if (vehicle (_this select 1) == (_this select 0)) then {
		(_this select 0) vehicleChat (_this select 2);
	} else {
		(_this select 1) sideChat (_this select 2);
	};
};

if (_unit == _caller) then {_unit = d_curvec_dialog};

if (_caller != driver _unit && {!isNil {_unit getVariable "d_choppertype"}}) exitWith {};

if ((_unit call d_fnc_GetHeight) > 3) exitWith {_unit vehicleChat (localize "STR_DOM_MISSIONSTRING_267")};

if (speed _unit > 3) exitWith {_unit vehicleChat (localize "STR_DOM_MISSIONSTRING_268")};

if (_unit getVariable ["d_ammobox", false]) exitWith {[_unit, _caller, localize "STR_DOM_MISSIONSTRING_269"] call _chatfunc};

if (_unit getVariable ["d_ammobox_next", -1] > time) exitWith {[_unit, _caller, format [localize "STR_DOM_MISSIONSTRING_270", round ((_unit getVariable "d_ammobox_next") - time)]] call _chatfunc};

_nobjs = nearestObjects [_unit, [d_the_box], 20];
if (_nobjs isEqualTo []) exitWith {[_unit, _caller, localize "STR_DOM_MISSIONSTRING_271"] call _chatfunc};
[_unit, _caller, localize "STR_DOM_MISSIONSTRING_272"] call _chatfunc;
["d_r_box", [getPosATL (_nobjs select 0), _unit]] call d_fnc_NetCallEvent;
_unit setVariable ["d_ammobox", true, true];
_unit setVariable ["d_ammobox_next", time + d_drop_ammobox_time, true];
[_unit, _caller, localize "STR_DOM_MISSIONSTRING_273"] call _chatfunc;