//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_xmarkerplayers.sqf"
#include "x_setup.sqf"

if (isDedicated || {!isNil "d_is_sat_on"}) exitWith {};

private ["_ap"];
{
	_ap = missionNamespace getVariable _x;
	if (!isNil "_ap" && {alive _ap} && {isPlayer _ap} && {!(_ap getVariable ["xr_pluncon", false])}) then {
		if (markerAlpha _x < 1) then {
			_x setMarkerAlphaLocal 1;
		};
		_x setMarkerPosLocal (visiblePositionASL _ap);
		// _Vehicle_Name = getText (configFile >> "CfgVehicles" >> typeOf vehicle _ap >> "displayName");
		_x setMarkerTextLocal (switch (d_show_player_marker) do {
			case 1: {name _ap};
			case 2: {""};
			case 3: {d_mark_loc280 + str(9 - round(9 * damage _ap))};
			default {""};
		});
		_x setMarkerDirLocal (getDirVisual _ap);
	} else {
		if (markerAlpha _x > 0) then {
			_x setMarkerAlphaLocal 0;
		};
	};
} forEach d_player_entities;
