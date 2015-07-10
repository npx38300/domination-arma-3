//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_removediscusermarkers.sqf"
#include "x_setup.sqf"

if (isDedicated || {isMultiplayer && {!d_pisadminp}}) exitWith {};

private "_del_markers";
_del_markers = [];
{
	if (_x select [0, 15] == "_USER_DEFINED #") then {
		_id_s = "";
		for "_i" from 0 to (count _x - 1) do {
			if (_x select [_i, 1] == "#") exitWith {
				for "_c" from (_i + 1) to (count _x - 1) do {
					_char = _x select [_c, 1];
					if (_char == "/") exitWith {};
					_id_s = _id_s + _char;
				};
			};
		};
		
		if (_id_s != "") then {
			_unit = objectFromNetId _id_s;
			if (isNil "_unit" || {isNull _unit}) then {
				_del_markers pushBack _x;
			};
		};
	};
} forEach allMapMarkers;

if !(_del_markers isEqualTo []) then {
	{
		deleteMarker _x;
	} forEach _del_markers;
};
