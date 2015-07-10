#define THIS_FILE "x_revive\xr_f\fn_carry.sqf"
#include "xr_macros.sqf"

if (isDedicated) exitWith {};

private ["_dragee", "_unit"];
_dragee	= _this select 3;
private ["_name_dragee"];
_name_dragee = localize "STR_DOM_MISSIONSTRING_906";
if (alive _dragee) then {if (name _dragee != localize "STR_DOM_MISSIONSTRING_906") then {_name_dragee = name _dragee}};
_unit = player;
xr_carry = true;
xr_drag = false;

if (xr_carryAction != -3333) then {
	_unit removeAction xr_carryAction;
	xr_carryAction = -3333;
};
if (isNull _dragee) exitWith {};
detach _dragee;
sleep 1.5;
player setVariable ["xr_pisinaction", true];
_dragee setVariable ["xr_dragged", true, true];

["xr_a1", _dragee] call d_fnc_NetCallEvent;
["xr_a2", _unit] call d_fnc_NetCallEvent;
sleep 10;
_dragee attachTo [_unit,  [-0,-0.1,-1.2], "RightShoulder"];
["xr_dir", _dragee] call d_fnc_NetCallEvent;

if (isNil "xr_loadAction") then {
	xr_loadAction = - 3333;
};

if (xr_loadAction == -3333) then {
	player removeAction xr_loadAction;
	xr_loadAction = - 3333;
};

_found_anim = false;

_anims = ["acinpercmstpsraswrfldnon","acinpercmrunsraswrfldf"];

while {xr_carry} do {
	if (!_found_anim && {animationState player in _anims}) then {
		_found_anim = true;
	};
	if (!(_dragee getVariable ["xr_pluncon", false]) && {alive _dragee}) exitWith {
		detach _dragee;
		sleep 0.5;
		["d_eswm", _unit] call d_fnc_NetCallEvent;
		["xr_wn", [_dragee,102]] call d_fnc_NetCallEvent;
		player removeAction xr_dropAction;
		xr_dropAction = -3333;
		xr_carry = false;
	};

	//check that dragged unit still exists
	if (isNull _dragee || {!alive _unit} || {(_found_anim && {!((animationState _unit) in _anims)})}) exitWith {
		player removeAction xr_dropAction;
		xr_dropAction = -3333;
		if (!isNull _dragee) then {
			detach _dragee;
			sleep 0.5;
			if ((alive _dragee && {_dragee getVariable ["xr_pluncon", false]}) || {!alive _dragee}) then {
				["xr_wn", [_dragee,101]] call d_fnc_NetCallEvent;
			} else {
				["xr_wn", [_dragee,102]] call d_fnc_NetCallEvent;
			};
		};
		["d_eswm", _unit] call d_fnc_NetCallEvent;
		xr_carry = false;
	};
	sleep 0.1;
};

player setVariable ["xr_pisinaction", false];
_dragee setVariable ["xr_dragged", false, true];
