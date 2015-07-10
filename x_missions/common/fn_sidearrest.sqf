// by Xeno
#define THIS_FILE "fn_sidearrest.sqf"
#include "x_setup.sqf"
private ["_is_dead","_nobjs","_officer","_offz_at_base","_rescued"];
if !(call d_fnc_checkSHC) exitWith {};

_officer = [_this, 0] call BIS_fnc_param;

_offz_at_base = false;
_is_dead = false;
_rescued = false;

if (d_with_ranked) then {d_sm_p_pos = nil};

while {!_offz_at_base && {!_is_dead}} do {
	call d_fnc_mpcheck;
	if (!alive _officer) exitWith {_is_dead = true;};
	if (!_rescued) then {
		_nobjs = (getPosATL _officer) nearEntities ["CAManBase", 20];
		if !(_nobjs isEqualTo []) then {
			{
				if (isPlayer _x && {alive _x}) exitWith {
					_rescued = true;
					_officer enableAI "MOVE";
					["d_joing", [group _x, [_officer]]] call d_fnc_NetCallEventSTO;
					["d_setcapt", [_officer, true]] call d_fnc_NetCallEvent;
				};
			} forEach _nobjs;
		};
	} else {
		if (_officer distance d_FLAG_BASE < 30) then {
			_offz_at_base = true;
		};
	};

	sleep 5.621;
};

if (_is_dead) then {
	d_sm_winner = -500;
} else {
	if (_offz_at_base) then {
		if (d_with_ranked) then {
			["d_sm_p_pos", getPosATL d_FLAG_BASE] call d_fnc_NetCallEventToClients;
		};
		d_sm_winner = 2;
		sleep 2.123;
		if (vehicle _officer != _officer) then {
			_officer action ["getOut", vehicle _officer];
			unassignVehicle _officer;
			_officer setPos [0,0,0];
		};
		sleep 0.5;
		deleteVehicle _officer;
	};
};

d_sm_resolved = true;
if (d_IS_HC_CLIENT) then {
	["d_sm_var", d_sm_winner] call d_fnc_NetCallEventCTS;
};