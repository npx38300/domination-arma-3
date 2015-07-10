// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_xai_markers.sqf"
#include "x_setup.sqf"

if (isDedicated || {!isNil "d_is_sat_on"}) exitWith {};

#define __MAALPHA if (markerAlpha _mkr > 0) then {_mkr setMarkerAlphaLocal 0}

 private ["_units","_mkr","_unit","_plobj","_ai"];
 __TRACE_1(""."d_string_player")
_plobj = missionNamespace getVariable [d_string_player, objNull];
__TRACE_1(""."_plobj")
if (!isNull _plobj) then {
	_units = units (group _plobj) - [player];
	for "_ai" from 2 to 40 do {
		_mkr = format["d_AI_X%1%2", d_string_player, _ai];
		if (_ai - 1 <= count _units) then {
			_unit = _units select _ai - 2;
			if (alive _unit && {!isPlayer _unit}) then {
				_mkr setMarkerAlphaLocal 1;
				_mkr setMarkerPosLocal (visiblePositionASL _unit);
				_mkr setMarkerTextLocal (switch (d_show_player_marker) do {
					case 1: {_ut = str _unit; _ut select [count _ut - 1]};
					case 2: {""};
					case 3: {d_mark_loc280 + str(9 - round(9 * damage _unit))};
					default {""};
				});
				_mkr setMarkerDirLocal (getDirVisual (vehicle _unit));
			} else {
				__MAALPHA;
			};
		} else {
			__MAALPHA;
		};
	};
};