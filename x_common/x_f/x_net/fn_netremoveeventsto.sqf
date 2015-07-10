//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_netremoveeventsto.sqf"
#include "x_setup.sqf"

__TRACE_1("","_this")
if (!isNil {d_event_holderSTO getVariable _this}) then {d_event_holderSTO setVariable [_this, nil]};
