//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_netaddevent.sqf"
#include "x_setup.sqf"

// multiple events per type
__TRACE_1("","_this")
if ([true, isServer, !isDedicated, isDedicated, !isServer, true] select (_this select 0)) then {
	private ["_ea"];
	_ea = d_event_holder getVariable [_this select 1, []];
	_ea pushBack (_this select 2);
	__TRACE_1("","_ea")
	d_event_holder setVariable [_this select 1, _ea];
};