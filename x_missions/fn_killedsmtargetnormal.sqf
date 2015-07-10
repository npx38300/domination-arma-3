//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_killedsmtargetnormal.sqf"
#include "x_setup.sqf"

private ["_dvec", "_killer"];
_dvec = [_this, 0] call BIS_fnc_param;
_killer = [_this, 1] call BIS_fnc_param;
if !(_dev isKindOf "CAManBase") then {
	d_allunits_add pushBack _dvec;
};
if (!isNull _killer && {_killer != _dvec}) then {
	d_sm_winner = if (side (group _killer) == d_side_player) then {2} else {-1};
} else {
	d_sm_winner = -1;
};
_dvec removeAllEventHandlers "killed";
d_sm_resolved = true;
if (d_IS_HC_CLIENT) then {
	["d_sm_var", d_sm_winner] call d_fnc_NetCallEventCTS;
};