#define THIS_FILE "x_revive\xr_f\fn_drop_body.sqf"
#include "xr_macros.sqf"

if (isDedicated) exitWith {};

private ["_dragee", "_switchm"];

_dragee	= (_this select 3) select 0;
_switchm = (_this select 3) select 1;

if (xr_dropAction != -3333) then {
	player removeAction xr_dropAction;
	xr_dropAction = -3333;
};
if (!isNil "xr_xr_carryAction" && {xr_carryAction != -3333}) then {
	player removeAction xr_carryAction;
	xr_carryAction = -3333;
};
xr_drag = false;
xr_carry = false;

detach player;
detach _dragee;

["xr_wn", [_dragee,101]] call d_fnc_NetCallEvent;
if (_switchm == 0) then {
	["d_eswm", player] call d_fnc_NetCallEvent;
};
