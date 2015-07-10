//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_netcalleventcts.sqf"
#include "x_setup.sqf"

__TRACE_1("","_this")
if (isServer) then { // for hosted and HC environment
	_this call d_fnc_NetRunEventCTS;
} else {
	d_ncts = _this;
	publicVariableServer "d_ncts";
};