//#define __DEBUG__
// by Xeno
#define THIS_FILE "x_netinit.sqf"
#include "x_setup.sqf"

d_event_holder = d_HeliHEmpty createVehicleLocal [0, 0, 0];
if (isServer) then {
	d_event_holderCTS = d_HeliHEmpty createVehicleLocal [0, 0, 0];
};
d_event_holderSTO = d_HeliHEmpty createVehicleLocal [0, 0, 0];
if (!isDedicated) then {
	d_event_holderToClients = d_HeliHEmpty createVehicleLocal [0, 0, 0];
};

"d_negl" addPublicVariableEventHandler {
	(_this select 1) call d_fnc_NetRunEvent;
};

if (isServer) then {
	"d_ncts" addPublicVariableEventHandler {
		(_this select 1) call d_fnc_NetRunEventCTS;
	};
};

"d_nsto" addPublicVariableEventHandler {
	(_this select 1) call d_fnc_NetRunEventSTO;
};

if (!isDedicated) then {
	"d_nstc" addPublicVariableEventHandler {
		(_this select 1) call d_fnc_NetRunEventToClients;
	};
};