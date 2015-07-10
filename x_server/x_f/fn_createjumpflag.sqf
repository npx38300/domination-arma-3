// by Xeno
#define THIS_FILE "fn_createjumpflag.sqf"
#include "x_setup.sqf"
private ["_posi", "_flag"];
if (!isServer) exitWith {};

// create random position
_posi = [d_old_target_pos, d_old_radius select 0] call d_fnc_GetRanPointCircleOld;
while {_posi isEqualTo []} do {
	_posi = [d_old_target_pos, d_old_radius select 0] call d_fnc_GetRanPointCircleOld;
	sleep 0.04;
};

if !(_posi isEqualTo []) then {
	_flag = createVehicle [d_flag_pole, _posi, [], 0, "NONE"];
	_flag setFlagTexture
#ifdef __OWN_SIDE_BLUFOR__
	d_flag_str_blufor;
#endif
#ifdef __OWN_SIDE_OPFOR__
	d_flag_str_opfor;
#endif
#ifdef __OWN_SIDE_INDEPENDENT__
	d_flag_str_independent;
#endif

	[format ["d_paraflag%1", count d_resolved_targets], getPosASL _flag, "ICON", "ColorYellow", [0.5,0.5], if (d_jumpflag_vec == "") then {"Parajump"} else {"Vehicle"}, 0, "mil_flag"] call d_fnc_CreateMarkerGlobal;
	
	["d_n_jf", _flag] call d_fnc_NetCallEventToClients;
	d_kb_logic1 kbTell [d_kb_logic2, d_kb_topic_side, if (d_jumpflag_vec == "") then {"NewJumpFlag"} else {"NewJumpVehFlag"}, "SIDE"];
	
	_flag setVariable ["d_is_jf", true, true];
};