//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_sfunc.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private "_objs";
if (alive player && {!(player getVariable ["xr_pluncon", false])} && {vehicle player == player}) then {
	d_objectID2 = cursorTarget;
	if (!(d_objectID2 isKindOf "LandVehicle") && {!(d_objectID2 isKindOf "Air")}) exitWith {false};
	if (!alive d_objectID2) exitWith {false};	
	(damage d_objectID2 > 0.05 || {fuel d_objectID2 < 1})
} else {
	false
}
