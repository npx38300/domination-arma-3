//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_createmarkerglobal.sqf"
#include "x_setup.sqf"

// create a global marker, returns created marker
// parameters: marker name, marker pos, marker shape, marker color, marker size;(optional) marker text, marker dir, marker type, marker brush
// example: ["my marker",  position player, "hd_dot", "ColorBlue", [0.5,0.5]] call d_fnc_CreateMarkerGlobal;
private ["_m_name","_m_pos","_m_shape","_m_col","_m_size"];
_m_name = [_this, 0] call BIS_fnc_param;
_m_pos = [_this, 1] call BIS_fnc_param;
_m_shape = [_this, 2] call BIS_fnc_param;
_m_col = [_this, 3] call BIS_fnc_param;
_m_size = [_this, 4] call BIS_fnc_param;

_marker = createMarker [_m_name, _m_pos];
if (_m_shape != "") then {_marker setMarkerShape _m_shape};
if (_m_col != "") then {_marker setMarkerColor _m_col};
if !(_m_size isEqualTo []) then {_marker setMarkerSize _m_size};
if (count _this > 5) then {
	_marker setMarkerText (_this select 5);
	if (count _this > 6) then {
		_marker setMarkerDir (_this select 6);
		if (count _this > 7) then {
			_marker setMarkerType (_this select 7);
			if (count _this > 8) then {
				_marker setMarkerBrush (_this select 8);
				if (count _this > 9) then {_marker setMarkerAlpha (_this select 9)};
			};
		};
	};
};
_marker