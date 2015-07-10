//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_airmarkermove.sqf"
#include "x_setup.sqf"

if (isNil "d_airmarker_counter") then {
	d_airmarker_counter = 0;
};

private ["_vec", "_markern"];
_vec = _this;
sleep 30;
if (!isNull _vec && {alive _vec} && {canMove _vec}) then {
	_markern = str _vec + str d_airmarker_counter;
	d_airmarker_counter = d_airmarker_counter + 1;
	["d_c_m_g", [_markern, [0,0,0],"ICON",d_e_marker_color,[0.5,0.5],localize "STR_DOM_MISSIONSTRING_963",0,"n_air"]] call d_fnc_NetCallEventCTS;
	while {!isNull _vec && {alive _vec} && {canMove _vec}} do {
		sleep (3 + random 1);
		_markern setMarkerPos (getPosASL _vec);
	};
	["d_d_m_g", _markern] call d_fnc_NetCallEventCTS;
};