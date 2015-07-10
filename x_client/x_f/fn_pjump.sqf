#define THIS_FILE "fn_pjump.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_startLocation","_jumphelo","_obj_jump"];

_startLocation = [_this, 0] call BIS_fnc_param;

if (d_HALOWaitTime > 0) then {d_next_jump_time = time + d_HALOWaitTime};

titleText ["","Plain"];
_jumphelo = createVehicle [d_jump_helo, _startLocation, [], 0, "FLY"];
_jumphelo setPos _startLocation;
_jumphelo engineOn true;
_obj_jump = player;
_obj_jump moveInCargo _jumphelo;
if (vehicle player == player) exitWith {};

_obj_jump setVelocity [0,0,0];
_obj_jump action["eject", vehicle _obj_jump];

player addAction ["<t color='#FF0000'>Open Parachute</t>", {Parahute_Opened = true; (_this select 0) removeAction (_this select 2);}, [], 0, true, true, "", "vehicle _this == _this && alive _this"];

sleep 3;

deleteVehicle _jumphelo;
if (d_with_ai && {alive player} && {!(player getVariable ["xr_pluncon", false])}) then {[getPosATL player, velocity player, getDirVisual player] spawn d_fnc_moveai};

waitUntil {Parahute_Opened};
_Parachute = createVehicle ["Steerable_Parachute_F", getPosATL player, [], 0, "NONE"];
player moveInDriver _Parachute;
sleep 1;
Parahute_Opened = false;
waitUntil {getPos player select 2 < 2};
deleteVehicle _Parachute;