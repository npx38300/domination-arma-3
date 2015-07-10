//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_placedobjkilled.sqf"
#include "x_setup.sqf"

private ["_val", "_ar", "_obj"];
_obj = [_this, 0] call BIS_fnc_param;
_val = _obj getVariable "d_owner";
if (!isNil "_val") then {
	_ar = d_placed_objs_store getVariable _val;
	if (!isNil "_ar") then {
		{
			if ((_x select 1) == _obj) exitWith {
				deleteMarker (_ar select 1);
				_ar deleteAt _forEachIndex;
			};
		} forEach _ar;
		d_placed_objs_store setVariable [_val, _ar];
	};
	["d_p_o_an", _val] call d_fnc_NetCallEventToClients;
};
_obj removeAllMPEventHandlers "MPKilled";
_content = _obj getVariable ["d_objcont", []];
if !(_content isEqualTo []) then {
	{
		deleteVehicle _x;
	} forEach _content;
};
deleteVehicle _obj;