// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_handlenet.sqf"
#include "xr_macros.sqf"

__TRACE_1("","_this")
switch (_this select 1) do {
	case 100: {
		if (local (_this select 0)) then {
			__TRACE("Die case 100")
			(_this select 0) playActionNow "Die";
		};
	};
	case 101: {
		(_this select 0) switchmove "AmovPpneMstpSnonWnonDnon_healed";
		(_this select 0) playMoveNow "AmovPpneMstpSnonWnonDnon_healed";
		if (local (_this select 0)) then {
			__TRACE("Die case 101")
			(_this select 0) playActionNow "Die";
		};
	};
	case 102: {(_this select 0) switchmove "AmovPpneMstpSnonWnonDnon_healed";(_this select 0) playMoveNow "AmovPpneMstpSnonWnonDnon_healed"};
	case 103: {(_this select 0) switchmove "";if (local (_this select 0)) then {(_this select 0) moveInCargo (_this select 2)}};
	case 104: {if (local (_this select 0)) then {unassignVehicle (_this select 0)}};
	case 105: {(_this select 0) switchmove ""};
};