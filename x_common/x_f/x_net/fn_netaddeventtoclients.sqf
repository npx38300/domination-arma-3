//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_netaddeventtoclients.sqf"
#include "x_setup.sqf"

__TRACE_1("","_this")
private ["_ea"];
_ea = d_event_holderToClients getVariable [_this select 0, []];
_ea pushBack (_this select 1);
d_event_holderToClients setVariable [_this select 0, _ea];
