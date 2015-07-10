// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_teleportdialoginit.sqf"
#include "x_setup.sqf"
private ["_display", "_addbase", "_listctrl", "_cidx", "_logtxt", "_dtype"];

if (isDedicated) exitWith {};

disableSerialization;

#define __CTRL(A) (_display displayCtrl A)

_display = [_this, 0] call BIS_fnc_param;
_dtype = [_this, 1] call BIS_fnc_param;

if (_dtype == 0) then {
	if (d_tele_dialog > 0) then {
		__CTRL(100111) ctrlSetText (localize "STR_DOM_MISSIONSTRING_586");
		__CTRL(100102) ctrlSetText (localize "STR_DOM_MISSIONSTRING_533");
	} else {
		__CTRL(100111) ctrlSetText (localize "STR_DOM_MISSIONSTRING_299");
		__CTRL(100102) ctrlSetText (localize "STR_DOM_MISSIONSTRING_298");
	};
} else {
	if (!xr_respawn_available) then {
		__CTRL(100102) ctrlEnable false;
	};
};

_addbase = true;
if (d_WithTeleToBase == 1 && {d_tele_dialog > 0} && {_dtype == 0}) then {
	_addbase = false;
};

_listctrl = __CTRL(1500);
lbClear _listctrl;

_cidx = -1;

if (_addbase) then {
	_cidx = _listctrl lbAdd (localize "STR_DOM_MISSIONSTRING_1251");
	_listctrl lbSetData [_cidx, "D_BASE_D"];
};

__TRACE_1("","d_mob_respawns")

#define __COLRED [1,0,0,0.7]
_logtxt = "";

{
	_mrs = missionNamespace getVariable [_x select 0, objNull];
	__TRACE_2("","_mrs","_x")
	if (!isNull _mrs) then {
		_lbcolor = switch (true) do {
			case (_mrs getVariable ["d_in_air", false]): {_logtxt = format [localize "STR_DOM_MISSIONSTRING_592", _x select 1] + "\n" + _logtxt; __COLRED};
			case (speed _mrs > 4): {_logtxt = format [localize "STR_DOM_MISSIONSTRING_593", _x select 1] + _logtxt + "\n"; __COLRED};
			case (surfaceIsWater (getPosASL _mrs)): {_logtxt = format [localize "STR_DOM_MISSIONSTRING_594", _x select 1] + "\n" + _logtxt; __COLRED};
			case (!alive _mrs): {_logtxt = format [localize "STR_DOM_MISSIONSTRING_595", _x select 1] + "\n" + _logtxt; __COLRED};
			case !(_mrs getVariable ["d_MHQ_Deployed", false]): {_logtxt = format [localize "STR_DOM_MISSIONSTRING_596", _x select 1] + "\n" + _logtxt; __COLRED};
			case (_mrs getVariable ["d_enemy_near", false]): {_logtxt = format [localize "STR_DOM_MISSIONSTRING_597", _x select 1] + "\n" + _logtxt; __COLRED};
			default {[1,1,1,1.0]};
		};
		_cidx = _listctrl lbAdd (_x select 1);
		_listctrl lbSetData [_cidx, _x select 0];
		_listctrl lbSetColor [_cidx, _lbcolor];
	};
} forEach d_mob_respawns;

__TRACE_1("","_logtxt")

if (_logtxt != "") then {
	__CTRL(11002) ctrlSetText _logtxt;
};

d_lb_tele_first = true;

if (_cidx > -1) then {
	_listctrl lbSetCurSel 0;
};
