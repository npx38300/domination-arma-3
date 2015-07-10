//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_netremoveevent.sqf"
#include "x_setup.sqf"

__TRACE_1("","_this")
if (!isNil {d_event_holder getVariable _this}) then {d_event_holder setVariable [_this, nil]};
