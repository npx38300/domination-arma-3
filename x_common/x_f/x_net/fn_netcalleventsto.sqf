//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_netcalleventsto.sqf"
#include "x_setup.sqf"

__TRACE_1("","_this")
private ["_tt", "_obj"];
_tt = _this select 1;
_obj = if (typeName _tt == "ARRAY") then {_tt select 0} else {_tt};
if (isNil "_obj" || {isNull _obj}) exitWith {};
if !(local _obj) then {
	d_nsto = _this;
	publicVariableServer "d_nsto";
} else {
	_this call d_fnc_NetRunEventSTO;
};