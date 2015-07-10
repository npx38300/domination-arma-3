//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_getranjumppoint.sqf"
#include "x_setup.sqf"

private ["_center", "_radius", "_angle"];
_center = [_this, 0] call BIS_fnc_param;
_radius = [_this, 1] call BIS_fnc_param;
_angle = floor (random 360);
[(_center select 0) - ((random ((random _radius) max 50)) * sin _angle), (_center select 1) - ((random ((random _radius) max 50)) * cos _angle), if (count _this > 2) then {_this select 2} else {0}]