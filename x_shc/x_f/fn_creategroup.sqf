//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_creategroup.sqf"
#include "x_setup.sqf"

private ["_grp","_side","_side_str"];
_side = [_this, 0] call BIS_fnc_param;
_side_str = if (typeName _side == "SIDE") then {
	_side
} else {
	if (typeName _side == "STRING") then {
		switch (_side) do {
			case "OPFOR": {opfor};
			case "BLUFOR": {blufor};
			case "INDEPENDENT": {independent};
			default {civilian};
		}
	} else {
		if (typeName _side == "OBJECT") then {
			side _side
		} else {
			_side
		};
	};
};
_grp = createGroup _side_str;
// d_gstate
// 0 = created
// 1 = filled with units
// 2 = reduced
[_grp, 0] call d_fnc_setGState;
#ifdef __GROUPDEBUG__
if (isNil "d_all_marker_groups") then {
	d_all_marker_groups = [];
	0 spawn d_fnc_map_group_count_marker;
};
[_grp] spawn d_fnc_groupmarker;
#endif
__TRACE_1("creategroup","_grp")
_grp