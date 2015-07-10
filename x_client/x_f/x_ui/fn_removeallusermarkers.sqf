//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_removeallusermarkers.sqf"
#include "x_setup.sqf"

if (isDedicated || {isMultiplayer && {!d_pisadminp}}) exitWith {};

{
	if (_x select [0, 15] == "_USER_DEFINED #") then {
		deleteMarker _x;
	};
} forEach allMapMarkers;