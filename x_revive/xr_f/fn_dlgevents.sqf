//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_dlgevents.sqf"
#include "xr_macros.sqf"

if (isDedicated) exitWith {};

private "_param";
_param = _this select 1;
switch (_this select 0) do {
	case "MouseMoving": {
		xr_MouseCoord = [_param select 1, _param select 2];
	};
	case "MouseButtonDown": {
		__TRACE_1("DlgEvents MouseButtonDown","_param")
		xr_MouseButtons set [_param select 1, true];
		if (!xr_mousecheckon) then {
			0 spawn xr_fnc_MouseDownClickedLoop;
		};
	};
	case "MouseButtonUp": {
		xr_MouseButtons set[_param select 1, false];
	};
	case "MouseZChanged": {
		xr_MouseScroll = xr_MouseScroll + (_param select 1);
	};
};