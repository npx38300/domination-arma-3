// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_preinit.sqf"
#include "x_setup.sqf"
diag_log format ["############################# %1 #############################", missionName];
diag_log [diag_frameno, diag_ticktime, time, "Executing Dom fn_preinit.sqf"];

d_HeliHEmpty = "Land_HelipadEmpty_F";

// BLUFOR, OPFOR or INDEPENDENT for own side, setup in x_setup.sqf
#ifdef __OWN_SIDE_BLUFOR__
d_own_side = "BLUFOR";
d_enemy_side = "OPFOR";
d_enemy_side_trigger = "EAST";
#endif
#ifdef __OWN_SIDE_OPFOR__
d_own_side = "OPFOR";
d_enemy_side = "BLUFOR";
d_enemy_side_trigger = "WEST";
#endif
#ifdef __OWN_SIDE_INDEPENDENT__
d_own_side = "INDEPENDENT";
d_enemy_side = "OPFOR";
d_enemy_side_trigger = "EAST";
#endif

d_side_enemy = switch (d_enemy_side) do {
	case "OPFOR": {opfor};
	case "BLUFOR": {blufor};
	case "INDEPENDENT": {independent};
};

d_side_player =
#ifdef __OWN_SIDE_OPFOR__
	opfor;
#endif
#ifdef __OWN_SIDE_BLUFOR__
	blufor;
#endif
#ifdef __OWN_SIDE_INDEPENDENT__
	independent;
#endif

d_own_side_trigger =
#ifdef __OWN_SIDE_OPFOR__
	"EAST";
#endif
#ifdef __OWN_SIDE_BLUFOR__
	"WEST";
#endif
#ifdef __OWN_SIDE_INDEPENDENT__
	"GUER";
#endif

d_own_side_trigger_alt =
#ifdef __OWN_SIDE_OPFOR__
	"OPFOR";
#endif
#ifdef __OWN_SIDE_BLUFOR__
	"BLUFOR";
#endif
#ifdef __OWN_SIDE_INDEPENDENT__
	"INDEPENDENT";
#endif

d_version_string =
#ifdef __OWN_SIDE_OPFOR__
	"Opfor";
#endif
#ifdef __OWN_SIDE_BLUFOR__
	"Blufor";
#endif
#ifdef __OWN_SIDE_INDEPENDENT__
	"Independent";
#endif

d_e_marker_color =
#ifdef __OWN_SIDE_OPFOR__
	"ColorBLUFOR";
#endif
#ifdef __OWN_SIDE_BLUFOR__
	"ColorOPFOR";
#endif
#ifdef __OWN_SIDE_INDEPENDENT__
	"ColorOPFOR";
#endif

d_rep_truck_blufor = "B_Truck_01_Repair_F";
d_rep_truck_opfor = "O_Truck_03_repair_F";
d_rep_truck_indep = "I_Truck_02_box_F";

d_rep_truck = switch (d_own_side) do {
	case "OPFOR": {d_rep_truck_opfor};
	case "BLUFOR": {d_rep_truck_blufor};
	case "INDEPENDENT": {d_rep_truck_indep};
};

d_sm_bonus_vehicle_array =
switch (d_own_side) do {
	case "INDEPENDENT": {["I_Plane_Fighter_03_AA_F","I_Plane_Fighter_03_CAS_F","I_Heli_light_03_F","I_APC_Wheeled_03_cannon_F","I_APC_tracked_03_cannon_F", "I_MBT_03_cannon_F", "I_UGV_01_F","I_UGV_01_rcws_F"]};
	case "BLUFOR": {["B_Heli_Light_01_armed_F","B_Heli_Attack_01_F","B_APC_Wheeled_01_cannon_F","B_APC_Tracked_01_rcws_F","B_MBT_01_cannon_F","B_APC_Tracked_01_AA_F","B_UGV_01_F","B_UGV_01_rcws_F","B_MBT_01_TUSK_F","B_Plane_CAS_01_F"]};
	case "OPFOR": {["O_Heli_Attack_02_F","O_Heli_Attack_02_black_F","O_APC_Tracked_02_cannon_F","O_APC_Tracked_02_AA_F","O_MBT_02_cannon_F","O_UGV_01_F","O_UGV_01_rcws_F","O_Plane_CAS_02_F"]};
};

d_mt_bonus_vehicle_array =
switch (d_own_side) do {
	case "INDEPENDENT": {["I_MRAP_03_hmg_F","I_MRAP_03_gmg_F"]};
	case "BLUFOR": {["B_MRAP_01_hmg_F","B_MRAP_01_gmg_F"]};
	case "OPFOR": {["O_MRAP_02_hmg_F","O_MRAP_02_gmg_F"]};
};

for "_i" from 0 to (count d_sm_bonus_vehicle_array - 1) do {d_sm_bonus_vehicle_array set [_i, toUpper(d_sm_bonus_vehicle_array select _i)]};
for "_i" from 0 to (count d_mt_bonus_vehicle_array - 1) do {d_mt_bonus_vehicle_array set [_i, toUpper(d_mt_bonus_vehicle_array select _i)]};

// these vehicles can be lifted by the wreck lift chopper (previous chopper 4), but only, if they are completely destroyed
d_heli_wreck_lift_types = d_sm_bonus_vehicle_array + d_mt_bonus_vehicle_array;
{d_heli_wreck_lift_types set [_forEachIndex, toUpper _x]} forEach d_heli_wreck_lift_types;

d_x_drop_array =
#ifdef __OWN_SIDE_INDEPENDENT__
	[[], [localize "STR_DOM_MISSIONSTRING_22","I_MRAP_03_F"], [localize "STR_DOM_MISSIONSTRING_20", "Box_IND_Ammo_F"]];
#endif
#ifdef __OWN_SIDE_BLUFOR__
	[[], [localize "STR_DOM_MISSIONSTRING_22","B_MRAP_01_F"], [localize "STR_DOM_MISSIONSTRING_20", "Box_NATO_Ammo_F"]];
#endif
#ifdef __OWN_SIDE_OPFOR__
	[[], [localize "STR_DOM_MISSIONSTRING_22","O_MRAP_02_F"], [localize "STR_DOM_MISSIONSTRING_20", "Box_East_Ammo_F"]];
#endif

// side of the pilot that will fly the drop air vehicle
d_drop_side = d_own_side;

// d_jumpflag_vec = empty ("") means normal jump flags for HALO jump get created
// if you add a vehicle typename to d_jumpflag_vec (d_jumpflag_vec = "B_Quadbike_01_F"; for example) only a vehicle gets created and no HALO jump is available
//d_jumpflag_vec = "B_Quadbike_01_F";
d_jumpflag_vec = "";

d_player_entities = ["d_artop_1","d_artop_2","d_alpha_1","d_alpha_2","d_alpha_3","d_alpha_4","d_alpha_5","d_alpha_6","d_alpha_7","d_alpha_8","d_bravo_1","d_bravo_2","d_bravo_3","d_bravo_4","d_bravo_5","d_bravo_6","d_bravo_7","d_bravo_8","d_charlie_1","d_charlie_2","d_charlie_3","d_charlie_4","d_charlie_5","d_charlie_6","d_charlie_7","d_charlie_8","d_delta_1","d_delta_2","d_delta_3","d_delta_4","d_delta_5","d_delta_6","d_echo_1","d_echo_2","d_echo_3","d_echo_4","d_echo_5","d_echo_6","d_echo_7","d_echo_8"];

d_servicepoint_building = "Land_Cargo_House_V2_F";

d_illum_tower = "Land_TTowerBig_2_F";
d_wcamp = "Land_Cargo_Patrol_V1_F";
d_bigcontainer = "B_Truck_01_box_F";
d_ProtectionZone = "ProtectionZone_F";
d_ProtectionZone_inv = "ProtectionZone_Invisible_F";

d_mash = "Land_TentDome_F";
d_mash_flag = "Flag_RedCrystal_F";

d_dropped_box_marker = "mil_marker";

d_strongpointmarker = "mil_objective";

d_flag_str_blufor = "\a3\data_f\flags\flag_blue_co.paa";
d_flag_str_opfor = "\a3\data_f\flags\flag_red_co.paa";
d_flag_str_independent = "\a3\data_f\flags\flag_green_co.paa";

d_SlopeObject = "Logic" createVehicleLocal [0,0,0];

d_cargo_chute =
#ifdef __OWN_SIDE_BLUFOR__
	"B_Parachute_02_F";
#endif
#ifdef __OWN_SIDE_OPFOR__
	"O_Parachute_02_F";
#endif

d_flag_pole = "FlagPole_F";

d_vec_camo_net =
#ifdef __OWN_SIDE_OPFOR__
	"CamoNet_OPFOR_big_F";
#endif
#ifdef __OWN_SIDE_BLUFOR__
	"CamoNet_BLUFOR_big_F";
#endif
#ifdef __OWN_SIDE_INDEPENDENT__
	"CamoNet_INDP_big_F";
#endif

// internal
d_sm_winner = 0;
d_objectID1 = objNull;
d_objectID2 = objNull;

// no farps in A3 so we fake them
// first entry should always be a helipad because the trigger which is needed to make it work is spawned there
// second object is also needed, remove action gets added on the second object
d_farp_classes = ["Land_HelipadSquare_F", "Land_Cargo40_military_green_F"];

// artillery operators
d_can_use_artillery = ["d_artop_1","d_artop_2"];

// those units can mark artillery targets but can not call in artillery strikes (only d_can_use_artillery can call in artillery strikes and also mark arty targets)
d_can_mark_artillery = ["d_alpha_1", "d_bravo_1", "d_charlie_1", "d_echo_1"];

d_arty_m_marker =
#ifdef __OWN_SIDE_OPFOR__
	"o_art";
#endif
#ifdef __OWN_SIDE_BLUFOR__
	"b_art";
#endif
#ifdef __OWN_SIDE_INDEPENDENT__
	"n_art";
#endif

d_color_m_marker =
#ifdef __OWN_SIDE_OPFOR__
	"ColorEAST";
#endif
#ifdef __OWN_SIDE_BLUFOR__
	"ColorWEST";
#endif
#ifdef __OWN_SIDE_INDEPENDENT__
	"ColorGUER";
#endif

d_non_steer_para = "NonSteerable_Parachute_F";

private "_isserv_or_hc";
_isserv_or_hc = isServer || {!isDedicated && {!hasInterface}};

if (_isserv_or_hc) then {
	__TRACE_1("","_isserv_or_hc")
	d_player_store = d_HeliHEmpty createVehicleLocal [0, 0, 0];
	d_placed_objs_store = d_HeliHEmpty createVehicleLocal [0, 0, 0];
	d_placed_objs_store2 = d_HeliHEmpty createVehicleLocal [0, 0, 0];
};

if (isServer) then {
	call compile preprocessFileLineNumbers "x_init\x_initcommon.sqf";
};

if (_isserv_or_hc) then {
	if (isServer) then {
		if (d_weather == 0) then {
			0 setOvercast (random 1);			
			_fog = if (random 100 > 70) then {
				[random 0.1, 0.1, 20 + (random 40)]
			} else {
				[0,0.1,0]
			};
			__TRACE_1("","_fog")
			0 setFog _fog;
			forceWeatherChange;
		};
		
		if (d_timemultiplier > 1) then {
			setTimeMultiplier d_timemultiplier;
		};
	};
	// _E = Opfor
	// _W = Blufor
	// _G = Independent
	// this is what gets spawned
	d_allmen_E = [
		["East","OPF_F","Infantry","OIA_InfSquad"] call d_fnc_GetConfigGroup,
		["East","OPF_F","Infantry","OIA_InfSquad_Weapons"] call d_fnc_GetConfigGroup,
		["East","OPF_F","Infantry","OIA_InfTeam"] call d_fnc_GetConfigGroup,
		["East","OPF_F","Infantry","OIA_InfTeam_AT"] call d_fnc_GetConfigGroup,
		["East","OPF_F","Infantry","OIA_InfSentry"] call d_fnc_GetConfigGroup,
		["East","OPF_F","Infantry","OI_reconPatrol"] call d_fnc_GetConfigGroup,
		["East","OPF_F","Infantry","OI_reconSentry"] call d_fnc_GetConfigGroup,
		["East","OPF_F","Infantry","OI_reconTeam"] call d_fnc_GetConfigGroup,
		["East","OPF_F","Infantry","OI_SniperTeam"] call d_fnc_GetConfigGroup,
		["East","OPF_F","Infantry","OI_recon_EOD"] call d_fnc_GetConfigGroup,
		["East","OPF_F","Infantry","OI_support_CLS"] call d_fnc_GetConfigGroup,
		["East","OPF_F","Infantry","OI_support_ENG"] call d_fnc_GetConfigGroup,
		["East","OPF_F","Infantry","OI_support_EOD"] call d_fnc_GetConfigGroup,
		["East","OPF_F","Infantry","OI_support_Mort"] call d_fnc_GetConfigGroup,
	    ["East","OPF_F","UInfantry","OIA_GuardSquad"] call d_fnc_GetConfigGroup,
		["East","OPF_F","UInfantry","OIA_GuardTeam"] call d_fnc_GetConfigGroup,
		["East","OPF_F","UInfantry","OIA_GuardSentry"] call d_fnc_GetConfigGroup,
		["East","OPF_F","Infantry","OIA_InfTeam_AA"] call d_fnc_GetConfigGroup
	];
	d_allmen_W = [
		["West","BLU_F","Infantry","BUS_InfSquad"] call d_fnc_GetConfigGroup,
		["West","BLU_F","Infantry","BUS_InfSquad_Weapons"] call d_fnc_GetConfigGroup,
		["West","BLU_F","Infantry","BUS_InfTeam"] call d_fnc_GetConfigGroup,
		["West","BLU_F","Infantry","BUS_InfTeam_AT"] call d_fnc_GetConfigGroup,
		["West","BLU_F","Infantry","BUS_InfSentry"] call d_fnc_GetConfigGroup,
		["West","BLU_F","Infantry","BUS_ReconPatrol"] call d_fnc_GetConfigGroup,
		["West","BLU_F","Infantry","BUS_ReconSentry"] call d_fnc_GetConfigGroup,
		["West","BLU_F","Infantry","BUS_ReconTeam"] call d_fnc_GetConfigGroup,
		["West","BLU_F","Infantry","BUS_SniperTeam"] call d_fnc_GetConfigGroup,
		["West","BLU_F","Infantry","BUS_Support_EOD"] call d_fnc_GetConfigGroup,
		["West","BLU_F","Infantry","BUS_Support_CLS"] call d_fnc_GetConfigGroup,
		["West","BLU_F","Infantry","BUS_Support_ENG"] call d_fnc_GetConfigGroup,
		["West","BLU_F","Infantry","BUS_Recon_EOD"] call d_fnc_GetConfigGroup,
		["West","BLU_F","Infantry","BUS_Support_Mort"] call d_fnc_GetConfigGroup,
	    ["West","BLU_F","Infantry","BUS_Support_MG"] call d_fnc_GetConfigGroup,
		["West","BLU_F","Infantry","BUS_Support_GMG"] call d_fnc_GetConfigGroup,
		["West","BLU_F","Infantry","BUS_InfTeam_AA"] call d_fnc_GetConfigGroup
	];
	d_allmen_G = [
		["Indep","IND_F","Infantry","HAF_InfSquad"] call d_fnc_GetConfigGroup,
		["Indep","IND_F","Infantry","HAF_InfSquad_Weapons"] call d_fnc_GetConfigGroup,
		["Indep","IND_F","Infantry","HAF_InfTeam"] call d_fnc_GetConfigGroup,
		["Indep","IND_F","Infantry","HAF_InfTeam_AT"] call d_fnc_GetConfigGroup,
		["Indep","IND_F","Infantry","HAF_InfSentry"] call d_fnc_GetConfigGroup,
		["Indep","IND_F","Infantry","HAF_SniperTeam"] call d_fnc_GetConfigGroup,
		["Indep","IND_F","Infantry","HAF_Support_CLS"] call d_fnc_GetConfigGroup,
		["Indep","IND_F","Infantry","HAF_Support_ENG"] call d_fnc_GetConfigGroup,
		["Indep","IND_F","Infantry","HAF_Support_EOD"] call d_fnc_GetConfigGroup,
		["Indep","IND_F","Infantry","HAF_Support_Mort"] call d_fnc_GetConfigGroup,
	    ["Indep","IND_F","Infantry","HAF_Support_MG"] call d_fnc_GetConfigGroup,
		["Indep","IND_F","Infantry","HAF_Support_GMG"] call d_fnc_GetConfigGroup,
		["Indep","IND_F","Infantry","HAF_InfTeam_AA"] call d_fnc_GetConfigGroup
	];

	d_specops_E = ["East","OPF_F","Infantry","OI_reconTeam"] call d_fnc_GetConfigGroup;
	d_specops_W = ["West","BLU_F","Infantry","BUS_ReconTeam"] call d_fnc_GetConfigGroup;
	d_specops_G = ["Indep","IND_F","SpecOps","HAF_DiverTeam"] call d_fnc_GetConfigGroup;
	d_trucksquad_W = ["B_Soldier_TL_F","B_Soldier_F","B_Soldier_F","B_Soldier_GL_F","B_Soldier_GL_F","B_Soldier_AR_F","B_Soldier_AR_F","B_Soldier_AR_F","B_Soldier_AT_F","B_Soldier_AA_F","B_medic_F","B_engineer_F","B_Soldier_M_F", "B_Soldier_A_F"];
	d_trucksquad_E = ["O_Soldier_TL_F","O_Soldier_F","O_Soldier_F","O_Soldier_GL_F","O_Soldier_GL_F","O_Soldier_AR_F","O_Soldier_AR_F","O_Soldier_AR_F","O_Soldier_AT_F","O_Soldier_AA_F","O_medic_F","O_engineer_F","O_Soldier_M_F", "O_Soldier_A_F"];
	d_trucksquad_G = ["I_Soldier_TL_F","I_Soldier_F","I_Soldier_F","I_Soldier_F","I_Soldier_F","I_Soldier_GL_F","I_Soldier_GL_F","I_Soldier_AR_F","I_Soldier_AR_F","I_Soldier_AT_F","I_Soldier_AA_F","I_medic_F","I_engineer_F","I_Soldier_M_F", "I_Soldier_A_F"];

	d_veh_a_E =
	[
		["O_MBT_02_cannon_F"],
		["O_APC_Tracked_02_cannon_F"],
		["O_APC_Wheeled_02_rcws_F"],
		["O_APC_Tracked_02_AA_F"],
		["O_MRAP_02_hmg_F","O_MRAP_02_gmg_F"],
		["O_MRAP_02_F"],
		["O_GMG_01_F","O_GMG_01_high_F"], //O_GMG_01_A_F, removed because it creates an invisible gunner (UAV type)
		["O_HMG_01_F","O_HMG_01_high_F","O_static_AA_F","O_static_AT_F"], // O_HMG_01_A_F, removed because it creates an invisible gunner (UAV type)
		["O_Mortar_01_F"],
		["O_Truck_02_fuel_F"],
		["O_Truck_02_box_F"],
		["O_Truck_02_Ammo_F"]
	];

	d_veh_a_W =
	[
		["B_MBT_01_cannon_F","B_MBT_01_TUSK_F"],
		["B_APC_Tracked_01_rcws_F"],
		["B_APC_Wheeled_01_cannon_F"],
		["B_APC_Tracked_01_AA_F"],
		["B_MRAP_01_gmg_F","B_MRAP_01_hmg_F"],
		["B_MRAP_01_F"],
		["B_GMG_01_F","B_GMG_01_high_F"],
		["B_HMG_01_F","B_HMG_01_high_F","B_static_AA_F","B_static_AT_F"],
		["B_Mortar_01_F"],
		["B_Truck_01_fuel_F"],
		["B_Truck_01_Repair_F"],
		["B_Truck_01_ammo_F"]
	];
		
	d_veh_a_G =
	[
		["I_MBT_03_cannon_F"],
        ["I_APC_tracked_03_cannon_F"],
        ["I_APC_Wheeled_03_cannon_F"],
        ["I_MRAP_03_hmg_F"],
        ["I_G_Offroad_01_armed_F"],
        ["I_MRAP_03_gmg_F"],
        ["I_HMG_01_F"],
        ["I_GMG_01_F","I_HMG_01_high_F","I_static_AA_F","I_static_AT_F"],
        ["I_Mortar_01_F"],
        ["I_Truck_02_fuel_F"],
        ["I_Truck_02_box_F"],
        ["I_Truck_02_ammo_F"]
	];

	d_arti_observer_E = "O_recon_JTAC_F";
	d_arti_observer_W = "B_recon_JTAC_F";
	d_arti_observer_G = "I_Soldier_TL_F";
	
	d_number_attack_planes = 1;
	d_number_attack_choppers = 1;
	
	// Type of aircraft, that will air drop stuff
	d_drop_aircraft =
	#ifdef __OWN_SIDE_INDEPENDENT__
		"I_Heli_Transport_02_F";
	#endif
	#ifdef __OWN_SIDE_BLUFOR__
		"B_Heli_Transport_01_camo_F";
	#endif
	#ifdef __OWN_SIDE_OPFOR__
		"O_Heli_Light_02_unarmed_F";
	#endif
		
	if (isServer && {d_with_ai || {d_with_ai_features == 0}}) then {
		d_taxi_aircraft =
		#ifdef __OWN_SIDE_INDEPENDENT__
			"I_Heli_Transport_02_F";
		#endif
		#ifdef __OWN_SIDE_BLUFOR__
			"B_Heli_Transport_01_camo_F";
		#endif
		#ifdef __OWN_SIDE_OPFOR__
			"O_Heli_Light_02_unarmed_F";
		#endif
	};

	// max men for main target clear
	d_man_count_for_target_clear = 6;
	// max tanks for main target clear
	d_tank_count_for_target_clear = 0;
	// max cars for main target clear
	d_car_count_for_target_clear = 0;
	
	// time (in sec) between attack planes and choppers over main target will respawn once they were shot down (a random value between 0 and 240 will be added)
	d_airai_respawntime = 1200;

	d_side_missions_random = [];

	// don't remove d_recapture_indices even if you set d_WithRecapture to 1
	d_recapture_indices = [];

	// max number of cities that the enemy will recapture at once
	// if set to -1 no check is done
	d_max_recaptures = 2;
	
	d_time_until_next_sidemission = [
		[10,300], // if player number <= 10, it'll take 300 seconds = 5 minutes until the next sidemission
		[20,600], // if player number <= 20, it'll take 600 seconds = 10 minutes until the next sidemission
		[30,900], // if player number <= 30, it'll take 900 seconds = 15 minutes until the next sidemission
		[40,1200] // if player number <= 40, it'll take 1200 seconds = 20 minutes until the next sidemission
	];

	d_civilians_t = ["C_man_1","C_man_1_1_F","C_man_1_2_F","C_man_1_3_F","C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F","C_man_polo_6_F"];
	
	d_base_aa_vec =
	#ifdef __OWN_SIDE_INDEPENDENT__
	"";
	#endif
	#ifdef __OWN_SIDE_BLUFOR__
	"B_APC_Tracked_01_AA_F";
	#endif
	#ifdef __OWN_SIDE_OPFOR__
	"O_APC_Tracked_02_AA_F";
	#endif
	
	d_wreck_cur_ar = [];
	
	d_sm_fortress = "Land_Cargo_House_V2_F";
	d_functionary = "C_Nikos_aged";
	d_fuel_station = "Land_FuelStation_Build_F";//Land_FuelStation_Shed_F
	d_sm_cargo = switch (d_enemy_side) do {
		case "OPFOR": {"O_Truck_02_box_F"};
		case "BLUFOR": {"B_Truck_01_box_F"};
		case "INDEPENDENT": {"I_Truck_02_box_F"};
	};
	//d_sm_hangar = "Land_TentHangar_V1_F"; // Land_TentHangar_V1_F creates 3 objects and adding a killed eh makes it useless as the correct object might never get destroyed
	d_sm_hangar = "Land_Hangar_F";
	d_sm_tent = "Land_TentA_F";

	d_sm_land_tankbig = "Land_dp_bigTank_F";
	d_sm_land_transformer = "Land_dp_transformer_F";
	d_sm_barracks = "Land_i_Barracks_V2_F";
	d_sm_land_tanksmall = "Land_dp_smallTank_F";
	d_sm_land_factory = "Land_dp_smallFactory_F";
	d_sm_small_radar = "Land_Radar_Small_F";
	
	d_soldier_officer = switch (d_enemy_side) do {
		case "OPFOR": {"O_officer_F"};
		case "BLUFOR": {"B_officer_F"};
		case "INDEPENDENT": {"I_officer_F"};
	};
	d_sniper = switch (d_enemy_side) do {
		case "OPFOR": {"O_sniper_F"};
		case "BLUFOR": {"B_sniper_F"};
		case "INDEPENDENT": {"I_sniper_F"};
	};
	d_sm_arty = switch (d_enemy_side) do {
		case "OPFOR": {"O_MBT_02_arty_F"};
		case "BLUFOR": {"B_MBT_01_arty_F"};
		case "INDEPENDENT": {"B_MBT_01_arty_F"}; // no independent arty in Alpha 3
	};
	d_sm_plane = switch (d_enemy_side) do {
		case "OPFOR": {"O_Plane_CAS_02_F"};
		case "BLUFOR": {"B_Plane_CAS_01_F"};
		case "INDEPENDENT": {"I_Plane_Fighter_03_CAS_F"};
	};
	d_sm_tank = switch (d_enemy_side) do {
		case "OPFOR": {"O_MBT_02_cannon_F"};
		case "BLUFOR": {"B_MBT_01_cannon_F"};
		case "INDEPENDENT": {"I_MBT_03_cannon_F"};
	};
	d_sm_HunterGMG = switch (d_enemy_side) do {
		case "OPFOR": {"O_MRAP_02_gmg_F"};
		case "BLUFOR": {"B_MRAP_01_gmg_F"};
		case "INDEPENDENT": {"I_MRAP_03_hmg_F"};
	};
	d_sm_SpeedBoat = switch (d_enemy_side) do {
		case "OPFOR": {"O_Boat_Armed_01_hmg_F"};
		case "BLUFOR": {"B_Boat_Armed_01_hmg_F"};
		case "INDEPENDENT": {"I_Boat_Armed_01_hmg_F"};
	};
	d_sm_submarine = switch (d_enemy_side) do {
		case "OPFOR": {"O_SDV_01_F"};
		case "BLUFOR": {"B_SDV_01_F"};
		case "INDEPENDENT": {"I_SDV_01_F"};
	};
	d_sm_AssaultBoat = switch (d_enemy_side) do {
		case "OPFOR": {"O_Boat_Transport_01_F"};
		case "BLUFOR": {"B_Boat_Transport_01_F"};
		case "INDEPENDENT": {"I_Boat_Transport_01_F"};
	};
	d_sm_chopper = switch (d_enemy_side) do {
		case "OPFOR": {"O_Heli_Attack_02_black_F"};
		case "BLUFOR": {"B_Heli_Attack_01_F"};
		case "INDEPENDENT": {"I_Heli_light_03_F"};
	};
	d_sm_pilottype = switch (d_enemy_side) do {
		case "OPFOR": {"B_Helipilot_F"};
		case "BLUFOR": {"O_helipilot_F"};
		case "INDEPENDENT": {"I_helipilot_F"};
	};
	d_sm_wrecktype = switch (d_enemy_side) do {
		case "OPFOR": {"Land_Wreck_Heli_Attack_01_F"};
		case "BLUFOR": {"Land_UWreck_Heli_Attack_02_F"};
		case "INDEPENDENT": {"Land_Wreck_Heli_Attack_02_F"};
	};
	d_sm_ammotrucktype = switch (d_enemy_side) do {
		case "OPFOR": {"O_Truck_02_Ammo_F"};
		case "BLUFOR": {"B_Truck_01_ammo_F"};
		case "INDEPENDENT": {"I_Truck_02_ammo_F"};
	};
	
	d_intel_unit = objNull;

	d_ArtyShellsBlufor = [
		"Sh_120mm_HE", // HE
		"Smoke_120mm_AMOS_White", // Smoke
		"G_40mm_HE" // dpicm
	];

	d_ArtyShellsOpfor = [
		"Sh_120mm_HE", // HE
		"Smoke_120mm_AMOS_White", // Smoke
		"G_40mm_HE" // dpicm
	];

	d_base_aavecs_check = ["B_APC_TRACKED_01_AA_F", "O_APC_TRACKED_02_AA_F"]; // toupper! // NO AA vehicles for the independent side in Alpha 3

	d_all_simulation_stoped = false;

	d_hd_sim_types = ["SHOTPIPEBOMB", "SHOTTIMEBOMB", "SHOTDIRECTIONALBOMB", "SHOTMINE"]; // uppercase!

	// blufor, opfor, indep
	d_vec_spawn_default_Crew = ["B_crew_F", "O_crew_F", "I_crew_F"];

	d_isle_defense_marker = "n_mech_inf";

	d_air_radar = switch (d_enemy_side) do {
		case "BLUFOR": {"Land_Radar_Small_F"};
		case "OPFOR": {"Land_Radar_Small_F"};
		case "INDEPENDENT": {"Land_Radar_Small_F"};
	};

	d_enemy_hq = switch (d_enemy_side) do {
		case "OPFOR": {"Land_Cargo_HQ_V1_F"};
		case "BLUFOR": {"Land_Cargo_HQ_V1_F"};
		case "INDEPENDENT": {"Land_Cargo_HQ_V1_F"};
	};

	// type of enemy plane that will fly over the main target
	d_airai_attack_plane = switch (d_enemy_side) do {
		case "OPFOR": {["O_Plane_CAS_02_F"]};
		case "BLUFOR": {["B_Plane_CAS_01_F"]};
		case "INDEPENDENT": {["I_Plane_Fighter_03_CAS_F"]};
	};

	// type of enemy chopper that will fly over the main target
	d_airai_attack_chopper = switch (d_enemy_side) do {
		case "OPFOR": {["O_Heli_Attack_02_F"]};
		case "BLUFOR": {["B_Heli_Attack_01_F"]};
		case "INDEPENDENT": {["I_Heli_light_03_F"]};
	};

	// enemy parachute troops transport chopper
	d_transport_chopper = switch (d_enemy_side) do {
		case "OPFOR": {["O_Heli_Light_02_F"]};
		case "BLUFOR": {["B_Heli_Light_01_F"]};
		case "INDEPENDENT": {["I_Heli_Transport_02_F"]};
	};

	// light attack chopper (for example I_Heli_light_03_F with MG)
	d_light_attack_chopper = switch (d_enemy_side) do {
		case "OPFOR": {["O_Heli_Attack_02_black_F"]};
		case "BLUFOR": {["B_Heli_Light_01_F"]};
		case "INDEPENDENT": {["I_Heli_light_03_F"]};
	};
};

if (!isDedicated) then {
	__TRACE("preInit !isDedicated")
	// d_reserved_slot gives you the ability to add a reserved slot for admins
	// if you don't log in when you've chosen the slot, you'll get kicked after ~20 once the intro ended
	// default is no check, example: d_reserved_slot = "d_artop_1";
	d_reserved_slot = "d_delta_6";

	// d_uid_reserved_slots and d_uids_for_reserved_slots gives you the possibility to limit a slot
	// you have to add the var names of the units to d_uid_reserved_slots and in d_uids_for_reserved_slots the UIDs of valid players
	// d_uid_reserved_slots = ["d_alpha_1", "d_bravo_3"];
	// d_uids_for_reserved_slots = ["1234567", "7654321"];
	d_uid_reserved_slots = [];
	d_uids_for_reserved_slots = [];
	
	// this vehicle will be created if you use the "Create XXX" at a mobile respawn (old "Create Motorcycle") or at a jump flag
	// IMPORTANT !!!! for ranked version !!!!
	// if there is more than one vehicle defined in the array the vehicle will be selected by player rank
	// one vehicle only, vehicle is only available when the player is at least lieutenant
	d_create_bike =
	#ifdef __OWN_SIDE_INDEPENDENT__
	["I_Quadbike_01_F"];
	#endif
	#ifdef __OWN_SIDE_BLUFOR__
	["B_Quadbike_01_F"];
	#endif
	#ifdef __OWN_SIDE_OPFOR__
	["O_Quadbike_01_F"];
	#endif
	
	#ifdef __OWN_SIDE_BLUFOR__
	d_UAV_Small = "B_UAV_01_F";
	d_UAV_Terminal = "B_UavTerminal";
	#endif
	#ifdef __OWN_SIDE_OPFOR__
	d_UAV_Small = "O_UAV_01_F";
	d_UAV_Terminal = "O_UavTerminal";
	#endif
	#ifdef __OWN_SIDE_INDEPENDENT__
	d_UAV_Small = "I_UAV_01_F";
	d_UAV_Terminal = "I_UavTerminal";
	#endif
	
	d_still_in_intro = true;

	d_cur_sm_txt = "";
	d_current_mission_resolved_text = "";

	// ammobox handling (default, loading and dropping boxes) it means the time diff in seconds before a box can be loaded or dropped again in a vehicle
	d_drop_ammobox_time = 0;
	d_current_truck_cargo_array = 0;
	// d_check_ammo_load_vecs
	// the only vehicles that can load an ammo box are the transport choppers and MHQs__
	d_check_ammo_load_vecs =
	#ifdef __OWN_SIDE_BLUFOR__
	["B_Heli_Light_01_F","B_MRAP_01_F","B_APC_Tracked_01_CRV_F","I_Heli_light_03_unarmed_F"];
	#endif
	#ifdef __OWN_SIDE_OPFOR__
	["O_MRAP_02_F","O_Heli_Light_02_unarmed_F"];
	#endif
	#ifdef __OWN_SIDE_INDEPENDENT__
	["I_MRAP_03_F","I_Heli_light_03_unarmed_F"];
	#endif
	
	{
		d_check_ammo_load_vecs set [_forEachIndex, toUpper _x];
	} forEach d_check_ammo_load_vecs;

	d_weapon_respawn = true;

	// points needed to get a specific rank
	// gets even used in the unranked versions, though it's just cosmetic there
	d_points_needed = [
		20, // Corporal
		50, // Sergeant
		90, // Lieutenant
		140, // Captain
		200, // Major
		270 // Colonel
	];

	d_custom_layout = [];

	d_marker_vecs = [];

	// is engineer
	d_is_engineer = ["d_delta_1","d_delta_2","d_delta_3","d_delta_4","d_delta_5","d_delta_6"];

	// can build mash
	d_is_medic = ["d_alpha_6","d_bravo_6","d_charlie_6","d_echo_6"];

	// can call in air drop
	d_can_call_drop_ar = ["d_alpha_1","d_charlie_1","d_echo_1"];

	d_prim_weap_player = "";
	d_last_telepoint = 0;
	d_chophud_on = true;

	d_jump_helo =
	#ifdef __OWN_SIDE_BLUFOR__
	"B_Heli_Transport_01_F";
	#endif
	#ifdef __OWN_SIDE_OPFOR__
	"O_Heli_Light_02_unarmed_F";
	#endif
	#ifdef __OWN_SIDE_INDEPENDENT__
	"I_Heli_light_03_unarmed_F";
	#endif

	d_headbug_vehicle = "B_Quadbike_01_F";
	
	d_drop_max_dist = 500;

	// if the array is empty, anybody with a pilot uniform and headgear can fly (if the latter is enabled)
	// if you add the string name of playable units (var name in the editor) only those players get a pilot uniform and headgear
	// makes only sense when only pilots can fly is enabled
	// for example: ["pilot_1","pilot_2"];, case sensitiv
	d_only_pilots_can_fly = [];
	
	d_the_box = switch (d_own_side) do {
		case "INDEPENDENT": {"Box_IND_Wps_F"};
		case "OPFOR": {"Box_East_Wps_F"};
		case "BLUFOR": {"Box_NATO_Wps_F"};
	};
	d_the_base_box = switch (d_own_side) do {
		case "INDEPENDENT": {"I_supplyCrate_F"};//Box_IND_WpsSpecial_F
		case "OPFOR": {"O_supplyCrate_F"};//Box_East_WpsSpecial_F
		case "BLUFOR": {"B_supplyCrate_F"};//Box_NATO_WpsSpecial_F
	};
	
	d_rev_respawn_vec_types = [d_the_box, "B_MRAP_01_F", "O_MRAP_02_F", "I_MRAP_03_F"];

	// internal variables
	d_do_ma_update_n = false;
	d_sqtmgmtblocked = false;
	d_flag_vec = objNull;
	d_rscspect_on = false;
	d_player_can_call_drop = 0;
	d_player_can_call_arti = 0;
	d_backpack_helper = [];
	d_eng_can_repfuel = false;
	d_there_are_enemies_atbase = false;
	d_enemies_near_base = false;
	d_player_is_medic = false;
	d_vec_end_time = -1;
	d_rscCrewTextShownTimeEnd = -1;
	d_commandingMenuIniting = false;
	d_DomCommandingMenuBlocked = false;
	d_playerInMHQ = false;
	d_player_in_vec = false;
	d_clientScriptsAr = [false, false];
	d_areArtyVecsAvailable = false;
	d_ao_arty_vecs = [];
	d_misc_store = d_HeliHEmpty createVehicleLocal [0,0,0];
	
	d_prl_fin_id = ["DOM_PRL_ID", "onPreloadFinished", {
		d_preloaddone = true;
		diag_log [diag_frameno, diag_ticktime, time, "Preload finished"];
		[d_prl_fin_id, "onPreloadFinished"] call bis_fnc_removeStackedEventHandler;
		d_prl_fin_id = nil;
	}] call bis_fnc_addStackedEventHandler;
	
	d_client_check_init = ["DOM_CLIENT_INIT_ID", "onEachFrame", {
		if (isMultiplayer && {!isNull player} && {isNil "xr_phd_invulnerable"}) then {
			xr_phd_invulnerable = true;
			player setVariable ["d_p_ev_hd_last", time];
		};
		if (!isNull player && {!isNil "d_init_processed"} && {time > 0} && {!isNil "d_preloaddone"} && {!isNull (findDisplay 46)}) then {
			diag_log [diag_frameno, diag_tickTime, time, "Executing Dom local player JIP trigger"];call compile preprocessFileLineNumbers "x_client\x_jip.sqf";
			[d_client_check_init, "onEachFrame"] call bis_fnc_removeStackedEventHandler;
			d_client_check_init = nil;
		};
	}] call bis_fnc_addStackedEventHandler;
	execVM "tasks.sqf";
};

diag_log [diag_frameno, diag_ticktime, time, "Dom fn_preinit.sqf processed"];