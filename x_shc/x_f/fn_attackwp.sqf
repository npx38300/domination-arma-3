//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_attackwp.sqf"
#include "x_setup.sqf"

private ["_ggrp","_gtarget_pos","_gwp"];
_ggrp = [_this, 0] call BIS_fnc_param;
_gtarget_pos = [_this, 1] call BIS_fnc_param;
_ggrp setBehaviour "AWARE";
_gwp = _ggrp addWaypoint [_gtarget_pos,30];
_gwp setWaypointtype "SAD";
_gwp setWaypointCombatMode "YELLOW";
_gwp setWaypointSpeed "FULL";