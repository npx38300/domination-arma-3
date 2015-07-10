//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_netremoveeventcts.sqf"
#include "x_setup.sqf"

__TRACE_1("","_this")
if (!isNil {d_event_holderCTS getVariable _this}) then {d_event_holderCTS setVariable [_this, nil]};
