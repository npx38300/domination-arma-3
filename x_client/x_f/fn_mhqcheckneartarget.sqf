//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_mhqcheckneartarget.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_vec"];
_vec = vehicle player;
while {d_player_in_vec} do {
	if (fuel _vec != 0 && {player == driver _vec} && {!(_vec in list d_base_trigger)}) then {
		if (d_current_target_index != -1) then {
			_cur_tgt_pos = (d_target_names select d_current_target_index) select 0;
			if (_vec distance _cur_tgt_pos <= d_MHQDisableNearMT) then {
				_vec setVariable ["d_vecfuelmhq", fuel _vec, true];
				_vec setFuel 0;
				_vname = _vec getVariable "d_vec_name";
				["d_mqhtn", _vname] call d_fnc_NetCallEventToClients;
				[format [localize "STR_DOM_MISSIONSTRING_520", d_MHQDisableNearMT, _vname], "HQ"] call d_fnc_HintChatMsg;
			};
		};
	};
	sleep 0.531;
};
d_playerInMHQ = false;
