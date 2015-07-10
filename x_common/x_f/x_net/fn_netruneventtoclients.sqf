//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_netruneventtoclients.sqf"
#include "x_setup.sqf"

__TRACE_1("","_this")
private ["_ea", "_pa"];
_ea = d_event_holderToClients getVariable (_this select 0);
if (!isNil "_ea") then {
	__TRACE_1("found event","_ea")
	_pa = _this select 1;
	__TRACE_1("found event","_pa")
	if (!isNil "_pa") then {
		{_pa call _x} forEach _ea;
	} else {
		{call _x} forEach _ea;
	};
};