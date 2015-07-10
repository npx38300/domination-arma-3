//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_fixheadbug.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_dir","_pos","_vehicle", "_posasl"];
_unit = _this;
if (vehicle _unit != _unit) exitWith {hintSilent (localize "STR_DOM_MISSIONSTRING_632")};
titleCut [localize "STR_DOM_MISSIONSTRING_633", "black faded", 0];
_pos = getPosATLVisual _unit;
_dist = _pos distance _unit;
__TRACE_1("Fixheadbug","_dist")
if (surfaceIsWater _pos) then {_posasl = getPosASL _unit};
_dir = getDirVisual _unit;
_vehicle = d_headbug_vehicle createVehicleLocal _pos;
if (surfaceIsWater _pos) then {_vehicle setPosASL _posasl};
_unit moveincargo _vehicle;
waitUntil {vehicle _unit != _unit};
unassignVehicle _unit;
_unit action ["getOut", vehicle _unit];
waitUntil {vehicle _unit == _unit};
deleteVehicle _vehicle;
["d_eswm", player] call d_fnc_NetCallEvent;
_pos set [2,_dist];
if (surfaceIsWater _pos) then {_unit setPosASL _posasl} else {_unit setPos _pos};
_unit setDir _dir;
titleCut["", "BLACK IN", 2];