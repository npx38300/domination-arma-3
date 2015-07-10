// by Xeno and Carl Gustaffa
#define THIS_FILE "fn_searchbody.sqf"
#include "x_setup.sqf"

if (isDedicated || {isNull d_searchbody}) exitWith {};

_body = [_this, 0] call BIS_fnc_param;

if (alive _body) exitWith {systemChat (localize "STR_DOM_MISSIONSTRING_343")};
if (player distance _body > 3) exitWith {systemChat (localize "STR_DOM_MISSIONSTRING_344")};

systemChat (localize "STR_DOM_MISSIONSTRING_345");
player playMove "AinvPknlMstpSlayWrflDnon_medic";
sleep 1;
waitUntil {animationState player != "AinvPknlMstpSlayWrflDnon_medic"};
if (!alive player) exitWith {systemChat (localize "STR_DOM_MISSIONSTRING_346")};

if (isNull d_searchbody) exitWith {systemChat (localize "STR_DOM_MISSIONSTRING_347")};

["d_rem_sb_id"] call d_fnc_NetCallEventToClients;
sleep 0.1;
d_searchbody = objNull; publicVariable "d_searchbody";

_intelnum = d_searchintel call d_fnc_RandomFloorArray;

if (random 1 < 0.8) then {
	if ((d_searchintel select _intelnum) != 1) then {
		switch (_intelnum) do {
			case 0: {
				systemChat (localize "STR_DOM_MISSIONSTRING_349");
				sleep 2;
				d_searchintel set [1, 1];
				publicVariable "d_searchintel";
				["d_intel_upd", [1, d_name_pl]] call d_fnc_NetCallEventToClients;
			};
			case 1: {
				systemChat (localize "STR_DOM_MISSIONSTRING_350");
				sleep 2;
				d_searchintel set [2, 1];
				publicVariable "d_searchintel";
				["d_intel_upd", [2, d_name_pl]] call d_fnc_NetCallEventToClients;
			};
			case 2: {
				systemChat (localize "STR_DOM_MISSIONSTRING_351");
				sleep 2;
				d_searchintel set [3, 1];
				publicVariable "d_searchintel";
				["d_intel_upd", [3, d_name_pl]] call d_fnc_NetCallEventToClients;
			};
			case 3: {
				systemChat (localize "STR_DOM_MISSIONSTRING_352");
				sleep 2;
				_intelar set [4, 1];
				d_searchintel = _intelar; publicVariable "d_searchintel";
				["d_intel_upd", [4, d_name_pl]] call d_fnc_NetCallEventToClients;
			};
			case 4: {
				systemChat (localize "STR_DOM_MISSIONSTRING_353");
				sleep 2;
				d_searchintel set [5, 1];
				publicVariable "d_searchintel";
				["d_intel_upd", [5, d_name_pl]] call d_fnc_NetCallEventToClients;
			};
			case 5: {
				systemChat (localize "STR_DOM_MISSIONSTRING_354");
				sleep 2;
				d_searchintel set [6, 1];
				publicVariable "d_searchintel";
				["d_intel_upd", [6, d_name_pl]] call d_fnc_NetCallEventToClients;
			};
		};
	} else {
		systemChat (localize "STR_DOM_MISSIONSTRING_355");
	};
} else {
	systemChat (localize "STR_DOM_MISSIONSTRING_356");
};