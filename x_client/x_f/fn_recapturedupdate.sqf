// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_recapturedupdate.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

__TRACE_1("","_this")

private ["_index", "_tgt_name", "_state"];
_index = [_this, 0] call BIS_fnc_param;
_state = [_this, 1] call BIS_fnc_param;
_tgt_name = (d_target_names select _index) select 1;
__TRACE_1("","_tgt_name")
switch (_state) do {
	case 0: {
		hint composeText[
			parseText("<t color='#f0ff0000' size='2'>" + (localize "STR_DOM_MISSIONSTRING_659") + "</t>"), lineBreak,
			parseText("<t size='1'>" + format [localize "STR_DOM_MISSIONSTRING_660", _tgt_name] + "</t>")
		];
		[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_661", _tgt_name];
	};
	case 1: {
		hint composeText[
			parseText("<t color='#f00000ff' size='2'>" + (localize "STR_DOM_MISSIONSTRING_662") + "</t>"), lineBreak,
			parseText("<t size='1'>" + format [localize "STR_DOM_MISSIONSTRING_663", _tgt_name] + "</t>")
		];
	};
};