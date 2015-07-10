// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_handledeadvec.sqf"
#include "x_setup.sqf"

private "_v";
_v = [_this, 0] call BIS_fnc_param;
{
	_v deleteVehicleCrew _x;
} forEach (crew _v); // TODO: Use fullCrew _v once 1.34 is out?
_v setFuel ((fuel _v) / 3);
_v setVariable ["d_ddeadt", diag_tickTime];
