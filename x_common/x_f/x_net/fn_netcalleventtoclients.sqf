//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_netcalleventtoclients.sqf"
#include "x_setup.sqf"

__TRACE_1("","_this")
d_nstc = _this; publicVariable "d_nstc";
if (isServer && {!isDedicated}) then {
	_this call d_fnc_NetRunEventToClients;
};