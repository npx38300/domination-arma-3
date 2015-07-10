//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_netcallevent.sqf"
#include "x_setup.sqf"

__TRACE_1("","_this")
d_negl = _this; publicVariable "d_negl";
_this call d_fnc_NetRunEvent;