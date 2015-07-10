// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_update_telerespsel.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_target","_display","_text","_end_pos","_ctrl","_sel","_wone","_cparams"];

_cparams = [_this, 0] call BIS_fnc_param;
_wone = [_this, 1] call BIS_fnc_param;
_ctrl = _cparams select 0;
_sel = _cparams select 1;

__TRACE_1("","_this")

if (_sel == -1) exitWith {};

disableSerialization;

#define __CTRL(A) (_display displayCtrl A)

_data = _ctrl lbData _sel;

d_beam_target = _data;

#define __COLRED [1,0,0,0.7]
_mravailable = false;
_display = if (_wone == 0) then {(uiNamespace getVariable "d_TeleportDialog")} else {(uiNamespace getVariable "XR_SpectDlg")};

if (_data != "D_BASE_D") then {
	_logtxt = ctrlText __CTRL(11002);

	_mrs = missionNamespace getVariable [_data, objNull];
	__TRACE_1("","_mrs")
	if (!isNull _mrs) then {
		_lbcolor = switch (true) do {
			case (_mrs getVariable ["d_in_air", false]): {_logtxt = format [localize "STR_DOM_MISSIONSTRING_592",  _ctrl lbText _sel] + "\n" + _logtxt; __COLRED};
			case (speed _mrs > 4): {_logtxt = format [localize "STR_DOM_MISSIONSTRING_593", _ctrl lbText _sel] + "\n" + _logtxt; __COLRED};
			case (surfaceIsWater (getPosASL _mrs)): {_logtxt = format [localize "STR_DOM_MISSIONSTRING_594", _ctrl lbText _sel] + "\n" + _logtxt; __COLRED};
			case (!alive _mrs): {_logtxt = format [localize "STR_DOM_MISSIONSTRING_595", _ctrl lbText _sel] + "\n" + _logtxt; __COLRED};
			case !(_mrs getVariable ["d_MHQ_Deployed", false]): {_logtxt = format [localize "STR_DOM_MISSIONSTRING_596", _ctrl lbText _sel] + "\n" + _logtxt; __COLRED};
			case (_mrs getVariable ["d_enemy_near", false]): {_logtxt = format [localize "STR_DOM_MISSIONSTRING_597", _ctrl lbText _sel] + "\n" + _logtxt; __COLRED};
			default {_mravailable = true; [1,1,1,1.0]};
		};
		_ctrl lbSetColor [_sel, _lbcolor];
		
		if (_logtxt != "" && {!d_lb_tele_first}) then {
			__CTRL(11002) ctrlSetText _logtxt;
		};
	};
};

d_lb_tele_first = false;

_end_pos = if (_data == "D_BASE_D") then {
	getPosATL d_FLAG_BASE;
} else {
	visiblePosition (missionNamespace getVariable _data);
};

if (_wone == 1 && {!xr_respawn_available}) then {
	_mravailable = false;
	_data = "";
};

if (_mravailable || {_data == "D_BASE_D"}) then {
	_text = if (_wone == 1 || {d_tele_dialog == 0}) then {
		format [localize "STR_DOM_MISSIONSTRING_607", _ctrl lbText _sel]
	} else {
		format [localize "STR_DOM_MISSIONSTRING_605", _ctrl lbText _sel]
	};
	__CTRL(100110) ctrlSetText _text;
	__CTRL(100102) ctrlEnable true;
} else {
	__CTRL(100110) ctrlSetText "";
	__CTRL(100102) ctrlEnable false;
};

_ctrlmap = _display displayCtrl 900;
ctrlMapAnimClear _ctrlmap;

_ctrlmap ctrlMapAnimAdd [0, 1, getPosATL player];
_ctrlmap ctrlMapAnimAdd [1.2, 1, _end_pos];
_ctrlmap ctrlMapAnimAdd [0.8, 0.1, _end_pos];
ctrlMapAnimCommit _ctrlmap;