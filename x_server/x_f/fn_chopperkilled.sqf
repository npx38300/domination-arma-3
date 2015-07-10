// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_chopperkilled.sqf"
#include "x_setup.sqf"

private ["_ropes", "_dummy"];

_this call d_fnc_fuelCheck;
_ropes = (_this select 0) getVariable "d_ropes";
if (!isNil "_ropes") then {
	{
		if (!isNull _x) then {
			ropeDestroy _x;
		};
	} forEach _ropes;
};
_dummy = (_this select 0) getVariable "d_dummy_lw";
if (!isNil "_dummy") then {deleteVehicle _dummy};