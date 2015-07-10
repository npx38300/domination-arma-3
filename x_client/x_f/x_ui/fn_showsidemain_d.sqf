//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_showsidemain_d.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

_which = [_this, 0] call BIS_fnc_param;

if (_which == 1 && {d_current_target_index == -1}) exitWith {};
if (_which == 0 && {d_all_sm_res || {d_cur_sm_idx == -1}}) exitWith {};

_exit_it = false;

private ["_end_pos", "_markername"];
switch (_which) do {
	case 0: {
		_markername = format ["d_XMISSIONM%1", d_cur_sm_idx + 1];
		if (markerType _markername == "") then {_exit_it = true};
		_end_pos = markerPos _markername;
	};
	case 1: {
		_end_pos = markerPos "d_dummy_marker";
		_markername = (d_target_names select d_current_target_index) select 1;
	};
};

if (_exit_it) exitWith {};

disableSerialization;
_ctrlmap = (uiNamespace getVariable "d_StatusDialog") displayCtrl 11010;
ctrlMapAnimClear _ctrlmap;

_dsmd = player getVariable ["d_sidemain_m_do", []];
if !(_markername in _dsmd) then {
	_dsmd pushBack _markername;
	player setVariable ["d_sidemain_m_do", _dsmd];
	_markername spawn {
		scriptName "spawn_d_fnc_showsidemain_d_marker";
		private ["_m", "_a", "_aas"];
		_m = _this; _a = 1; _aas = -0.06;
		while {d_showstatus_dialog_open && {alive player} && {!(player getVariable ["xr_pluncon", false])}} do {
			_m setMarkerAlphaLocal _a;
			_a = _a + _aas;
			if (_a < 0.3) then {_a = 0.3; _aas = _aas * -1};
			if (_a > 1.3) then {_a = 1.3; _aas = _aas * -1};
			sleep .1;
		};
		_m setMarkerAlphaLocal 1;
		player setVariable ["d_sidemain_m_do",[]];
	};
};

_ctrlmap ctrlmapanimadd [0.0, 1.00, getPosATL d_FLAG_BASE];
_ctrlmap ctrlmapanimadd [1.2, 1.00, _end_pos];
_ctrlmap ctrlmapanimadd [0.5, 0.30, _end_pos];
ctrlmapanimcommit _ctrlmap;