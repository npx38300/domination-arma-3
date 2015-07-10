// Created by: Tankbuster
// Modified by: Dirty Haz

#define THIS_FILE "End_MT.sqf"
#include "x_setup.sqf"

if (!isServer) exitWith {};

private ["_Target_Array", "_Current_Target_Name", "_MT_Position", "_Tower", "_Objective_1", "_Objective_2"];

while {!d_main_target_ready} do {sleep 2.321};
sleep 2;
_Target_Array = d_target_names select d_current_target_index;
_Current_Target_Name = _Target_Array select 1;
_MT_Position = d_mt_loc;
d_campscaptured = d_sum_camps;
sleep 2;
_Tower = d_mt_loc nearObjects ["Land_TTowerBig_2_F", 800];
d_mt_radio_down = true; {_x setDamage 1;} forEach _Tower;
sleep 2;
switch (d_sec_kind) do {
case 1: {
Object_Type = switch (d_enemy_side) do {
case "BLUFOR": {"B_officer_F"};
case "OPFOR": {"O_officer_F"};
case "INDEPENDENT": {"I_officer_F"};
};
};
case 2: {
Object_Type = "Land_Radar_Small_F"
};
case 3: {
_Objective_1 = switch (d_enemy_side) do {
case "BLUFOR": {"B_Truck_01_ammo_F"};
case "OPFOR": {"O_Truck_02_Ammo_F"};
case "INDEPENDENT": {"I_Truck_02_ammo_F"};
};
};
case 4: {
Object_Type = switch (d_enemy_side) do {
case "BLUFOR": {"B_Truck_01_medical_F"};
case "OPFOR": {"O_Truck_02_medical_F"};
case "INDEPENDENT": {"I_Truck_02_medical_F"};
};
};
case 5: {Object_Type = d_enemy_hq};
case 6: {Object_Type = "Land_dp_transformer_F"};
case 7: {Object_Type = "Land_spp_transformer_F"};
case 8: {Object_Type = d_air_radar};
case 9: {Object_Type = "C_man_polo_6_F"};
case 10: {Object_Type = "C_man_1_3_F"};
};
_Objective_2 = d_mt_loc nearObjects [Object_Type, 800]; {_x setDamage 1;} forEach _Objective_2;
d_side_main_done = true;
sleep 2;
{if (side _x == opfor) then {_x setDamage 1;};} forEach (nearestObjects [d_mt_loc, ["Land", "Air", "Ship"], 800]);
sleep 2;
{deleteGroup _x} forEach allGroups;
[{systemChat "The Main Target has been ended by the server admin.";}, "BIS_fnc_spawn", nil, false] call BIS_fnc_MP;