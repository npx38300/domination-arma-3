//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_createdroppedbox.sqf"
#include "x_setup.sqf"

private ["_the_box_pos","_boxes","_mname"];
_the_box_pos = [_this, 0] call BIS_fnc_param;
_mname = "bm_" + str _the_box_pos;
d_ammo_boxes pushBack [_the_box_pos, _mname];
publicVariable "d_ammo_boxes";
[_mname, _the_box_pos, "ICON", "ColorBlue", [0.5,0.5], localize "STR_DOM_MISSIONSTRING_523", 0, d_dropped_box_marker] call d_fnc_CreateMarkerGlobal;
