// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_initx.sqf"
#include "x_setup.sqf"
if (!isServer) exitWith{};

call compile preprocessFileLineNumbers "x_shc\x_shcinit.sqf";

0 spawn {
	scriptName "spawn_x_initx_createbase";
	waitUntil {time > 0};
	sleep 2;
	
	_mmm = markerPos "d_base_sb_ammoload";
	__TRACE_1("","_mmm")
	
	if !(_mmm isEqualTo [0,0,0]) then {
		_ammop = createVehicle [d_servicepoint_building, _mmm, [], 0, "NONE"];
		_ammop setDir (markerDir "d_base_sb_ammoload");
		_ammop setPos _mmm;
		_ammop addEventHandler ["handleDamage", {0}];
	};
	
	if (d_base_aa_vec == "") exitWith {};
	
	if (isNil "d_HC_CLIENT_OBJ") then {
		for "_io" from 1 to 20 do {
			_mmm = format ["d_base_anti_air%1", _io];
			
			if (markerType _mmm == "") exitWith {};
		
			_ret = [1, markerPos _mmm, d_base_aa_vec, [d_own_side] call d_fnc_creategroup, markerDir _mmm] call d_fnc_makevgroup;
			_av = (_ret select 0) select 0;
			_av lock true;
			if (!isNull (driver _av)) then {
				_av lockDriver true;
				_av deleteVehicleCrew (driver _av);
				_av lock 2;
			};
		};
	} else {
		["d_cgraa", [d_HC_CLIENT_OBJ, d_own_side, d_base_aa_vec]] call d_fnc_NetCallEventSTO;
	};
};
