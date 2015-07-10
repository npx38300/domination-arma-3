//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_netremoveeventservertoclients.sqf"
#include "x_setup.sqf"

__TRACE_1("","_this")
if (!isNil {d_event_holderToClients getVariable _this}) then {d_event_holderToClients setVariable [_this, nil]};
