// by Xeno
#define THIS_FILE "x_delaiserv.sqf"
#include "x_setup.sqf"
private ["_group"];
if (!isServer) exitWith {};

sleep 60;

while {true} do {
	call d_fnc_mpcheck;
	{
		if (!isNull _x) then {
			_group = _x;
			if ({isPlayer _x} count (units _group) == 0 && {isNull (d_player_groups_lead select _forEachIndex)}) then {
				{
					if (!isPlayer _x) then {
						if (vehicle _x != _x) then {
							moveOut _x;
							unassignVehicle _x;
							_x setPos [0,0,0];
						};
						sleep 0.01;
						deleteVehicle _x;
					};
					sleep 0.01;
				} forEach units _group;
				d_player_groups set [_forEachIndex, grpNull];
				d_player_groups_lead set [_forEachIndex, -1];
			};
		} else {
			d_player_groups set [_forEachIndex, grpNull];
			d_player_groups_lead set [_forEachIndex, -1];
		};
	} forEach d_player_groups;
	d_player_groups = d_player_groups - [grpNull, objNull];
	d_player_groups_lead = d_player_groups_lead - [-1];
	sleep 5.321;
};