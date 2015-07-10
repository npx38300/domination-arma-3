// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_disdeadvec.sqf"
#include "x_setup.sqf"

#ifndef __DEBUG__
sleep 60;
#endif

__TRACE("Starting disdeadvec")

while {true} do {
	{
		if (!isNull _x && {!alive _x} && {simulationEnabled _x} && {!(toUpper (typeOf _x) in d_heli_wreck_lift_types)}) then {
			__TRACE_1("disable sim","_x")
			_x enableSimulationGlobal false;
		};
		sleep 0.7;
	} forEach vehicles;
	sleep 7;
};