//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_linemaker2.sqf"
#include "x_setup.sqf"

// _p1 and _p2 = positions, _mname = marker name
private ["_p1", "_p2", "_mname", "_radius", "_dir", "_dirn", "_x1", "_y1", "_curnum"];
_p1 = [_this, 0] call BIS_fnc_param;
_p2 = [_this, 1] call BIS_fnc_param;
_mname = [_this, 2] call BIS_fnc_param;
_radius = (_p1 distance _p2) / 2;
_dir = [_p1, _p2] call d_fnc_DirTo;
_dirn = _dir + 180;
_x1 = (_p1 select 0) - (_radius * sin _dirn);
_y1 = (_p1 select 1) - (_radius * cos _dirn);
if (markerType _mname == "") then {
	[_mname,[_x1, _y1],"RECTANGLE","ColorBlack",[_radius, 0.9],"",_dir + 90] call d_fnc_CreateMarkerLocal;
} else {
	_mname setMarkerPosLocal [_x1, _y1];
	_mname setMarkerSizeLocal [_radius, 0.9];
	_mname setMarkerDirLocal _dir + 90;
};