//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_waterfix.sqf"
#include "xr_macros.sqf"

if (isDedicated) exitWith {};

private ["_helpero", "_radius", "_endpos", "_markerpos", "_angle"];
__TRACE("black out")
173 cutText [localize "STR_DOM_MISSIONSTRING_920", "PLAIN"];
_helpero = d_HeliHEmpty createVehicleLocal (getPosASL player);
_radius = 20;
_endpos = getPosASL _helpero;
_markerpos = markerPos "xr_center";
while {surfaceIsWater _endpos} do {
	_endpos = getPosASL _helpero;
	_angle = [_endpos, _markerpos] call d_fnc_DirTo;
	_angle = _angle + 180;
	_endpos = [(_endpos select 0) - (_radius * sin _angle), (_endpos select 1) - (_radius * cos _angle), 0];
	_helpero setPos _endpos;
	sleep 0.01;
};
player setPos _endpos;
deleteVehicle _helpero;