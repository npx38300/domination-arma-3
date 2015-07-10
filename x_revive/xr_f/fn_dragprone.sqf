// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_revive\xr_f\fn_dragprone.sqf"
#include "xr_macros.sqf"

if (isDedicated) exitWith {};

private ["_dragee", "_unit", "_pullanims"];
_dragee = player getVariable "xr_cursorTarget";

if (isNull _dragee || {!alive player}) exitWith {};

player setVariable ["xr_pisinaction", true];
player setVariable ["xr_is_dragging", true];

_unit = player;
private "_name_dragee";
_name_dragee = localize "STR_DOM_MISSIONSTRING_906";
if (alive _dragee && {name _dragee != localize "STR_DOM_MISSIONSTRING_906"}) then {_name_dragee = name _dragee};

_dragee setVariable ["xr_dragged", true, true];
 
sleep 2;

["xr_a4", _dragee] call d_fnc_NetCallEvent;

_dragee attachto [_unit, [0, 2, 0]];
sleep 0.02;
["xr_sd", _dragee] call d_fnc_NetCallEvent;

xr_drag = true;

if (xr_dropAction != -3333) then {player removeAction xr_dropAction;xr_dropAction = -3333};
xr_dropAction = player addAction [format["<t color='#FF0000'>Drop %1</t>",_name_dragee], {_this call xr_fnc_drop_body}, [_dragee, 1], 0, false, true];
xr_dragprone_keyDownEHId = (findDisplay 46) displayAddEventHandler ["KeyDown", {((_this select 1) in (actionKeys "moveForward" + actionKeys "moveFastForward"))}];
sleep 0.5;

_found_anim = false;

_pullanims = ["amovppnemstpsraswrfldnon","amovppnemrunslowwrfldf","amovppnemsprslowwrfldfl","amovppnemsprslowwrfldfr","amovppnemrunslowwrfldb","amovppnemsprslowwrfldbl","amovppnemsprslowwrfldr","amovppnemstpsraswrfldnon_turnl","amovppnemstpsraswrfldnon_turnr","amovppnemrunslowwrfldl","amovppnemrunslowwrfldr","amovppnemsprslowwrfldb","amovppnemrunslowwrfldbl","amovppnemsprslowwrfldl","amovppnemsprslowwrfldbr"];

while {xr_drag} do {
	if (!_found_anim && {animationState player in _pullanims}) then {
		_found_anim = true;
	};
	if (!alive _dragee || {!(_dragee getVariable ["xr_pluncon", false])}) exitWith {
		player removeAction xr_dropAction;
		xr_dropAction = -3333;
		detach _dragee;
		sleep 0.5;
		if ((alive _dragee && {_dragee getVariable ["xr_pluncon", false]}) || {!alive _dragee}) then {
			["xr_wn", [_dragee,101]] call d_fnc_NetCallEvent;
		} else {
			["xr_wn", [_dragee,102]] call d_fnc_NetCallEvent;
		};
		sleep 1;
		xr_drag = false;
	};
	
	if (_found_anim && {!((animationState _unit) in _pullanims)}) exitWith {
		player removeAction xr_dropAction;
		xr_dropAction = -3333;
		detach _dragee;
		sleep 0.5;
		if ((alive _dragee && {_dragee getVariable ["xr_pluncon", false]}) || {!alive _dragee}) then {
			["xr_wn", [_dragee,101]] call d_fnc_NetCallEvent;
		} else {
			["xr_wn", [_dragee,102]] call d_fnc_NetCallEvent;
		};
		sleep 1;
		xr_drag = false;
	};

	if (!alive _unit) exitWith {
		player removeAction xr_dropAction;
		xr_dropAction = -3333;
		detach _unit;
		if ((alive _dragee && {_dragee getVariable ["xr_pluncon", false]}) || {!alive _dragee}) then {
			["xr_wn", [_dragee,101]] call d_fnc_NetCallEvent;
		} else {
			["xr_wn", [_dragee,102]] call d_fnc_NetCallEvent;
		};
		sleep 1;
		xr_drag = false;
	};
	
	if (isNull _dragee) then {
		player removeAction xr_dropAction;
		xr_dropAction = -3333;
		detach _unit;
		sleep 1;
		xr_drag = false;
	};
	
	sleep 0.1;
};

player setVariable ["xr_pisinaction", false];
player setVariable ["xr_is_dragging", false];
_dragee setVariable ["xr_dragged", false, true];

(findDisplay 46) displayRemoveEventHandler ["KeyDown", xr_dragprone_keyDownEHId];

if (xr_dropAction != -3333) then {
	player removeAction xr_dropAction;
	xr_dropAction = -3333;
};