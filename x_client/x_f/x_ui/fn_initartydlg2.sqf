// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_initartydlg2.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_ctrllb"];
disableSerialization;

_markers = [];
{
	if (_x select [0, 9] == "d_arttmx|") then {
		_markers pushBack _x;
	};
} forEach allMapMarkers;

d_cur_art_marker_ar = [];
d_arti_did_fire = nil;

//d_arttmx|1|32Rnd_155mm_Mo_shells|1

{
	_ar = _x;
	__TRACE_1("","_ar")
	_idx = 0; // 0 = netId, 1 = type, 2 = rounds
	_netid_ar = "";
	_type_ar = "";
	_rounds_ar = "";
	_start_idx = 9;
	_car = count _ar;
	for "_i" from 9	to (_car - 1) do {
		_c = _ar select [_i, 1];
		if (_c == "|" || {_i == (_car - 1)}) then { // 124 = |
			switch (_idx) do {
				case 0: {_netid_ar = _ar select [_start_idx, _i - _start_idx]};
				case 1: {_type_ar = _ar select [_start_idx, _i - _start_idx]};
				case 2: {_rounds_ar = _ar select [_start_idx, _car - _start_idx]};
			};
			_start_idx = _i + 1;
			_idx = _idx + 1;
		};
	};
	__TRACE_3("","_netid_ar","_type_ar","_rounds_ar")
	if !(_netid_ar isEqualTo []) then {
		d_cur_art_marker_ar pushBack [_x, _netid_ar, _type_ar, parseNumber _rounds_ar];
	};
} forEach _markers;

__TRACE_1("","d_cur_art_marker_ar")

d_cur_artm_map_startpos = getPosASL player;

_disp = (uiNamespace getVariable "d_ArtilleryDialog2");

_ctrllb = _disp displayCtrl 1000;
lbClear _ctrllb;

if !(d_cur_art_marker_ar isEqualTo []) then {
	{
		_name = if (isMultiplayer) then {
			name (objectFromNetId  (_x select 1))
		} else {
			name player
		};
		_lbAdd = _ctrllb lbAdd _name;
		_ctrllb lbSetvalue [_lbAdd, _forEachIndex];
		_ctrllb lbSetData [_lbAdd, _x select 0];
	} foreach d_cur_art_marker_ar;
	_ctrllb lbSetcursel 0;
} else {
	_ctrl = _disp displayCtrl 1002;
	_ctrl ctrlEnable false;
	_lbAdd = _ctrllb lbAdd "<< No Targets >>";
	_ctrllb ctrlEnable false;
};
