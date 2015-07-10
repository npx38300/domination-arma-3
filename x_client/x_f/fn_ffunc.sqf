//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_ffunc.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_l","_vUp"];
if (alive player && {!(player getVariable ["xr_pluncon", false])} && {vehicle player == player}) then {
	d_objectID1 = cursorTarget;
	if (isNull d_objectID1 || {!(d_objectID1 isKindOf "LandVehicle")} || {!alive d_objectID1} || {player distance d_objectID1 > 8}) exitWith {false};
	_vUp = vectorUpVisual d_objectID1;
	if ((_vUp select 2) < 0 && {player distance ((getPosATLVisual player) nearestObject d_rep_truck) < 20}) then {
		true
	} else {
		_l = sqrt((_vUp select 0)^2 + (_vUp select 1)^2);
		if (_l != 0) then {
			(((_vUp select 2) atan2 _l) < 30 && {player distance ((getPosATLVisual player) nearestObject d_rep_truck) < 20})
		} else {
			false
		};
	};
} else {
	false
}