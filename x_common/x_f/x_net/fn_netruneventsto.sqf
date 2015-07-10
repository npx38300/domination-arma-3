//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_netruneventsto.sqf"
#include "x_setup.sqf"

__TRACE_1("","_this")
private ["_ea", "_pa", "_obj", "_tt"];
_tt = _this select 1;
_obj = if (typeName _tt == "ARRAY") then {_tt select 0} else {_tt};
if (isNil "_obj" || {isNull _obj}) exitWith {};
if (local _obj) then {
	_ea = d_event_holderSTO getVariable (_this select 0);
	if (!isNil "_ea") then {
		__TRACE_1("found event","_ea")
		_pa = _this select 1;
		if (!isNil "_pa") then {
			{_pa call _x} forEach _ea;
		} else {
			{call _x} forEach _ea;
		};
	};
} else {
	__TRACE_1("_obj not local","_obj")
	d_nsto = _this;
	if (isServer) then {
		_owner = if (typeName _obj != "GROUP") then {
			owner _obj
		} else {
			owner (leader _obj)
		};
		__TRACE_1("owner _obj","_obj")
		_owner publicVariableClient "d_nsto";
	} else { // not needed... redundant, who cares
		__TRACE_1("not server send","_obj")
		publicVariableServer "d_nsto";
	};
};