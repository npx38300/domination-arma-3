//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_sidemissionresolved.sqf"
#include "x_setup.sqf"

if (isNil "d_HC_CLIENT_OBJ") then {
	execFSM "fsms\XClearSidemission.fsm";
} else {
	["d_smclear", d_HC_CLIENT_OBJ] call d_fnc_NetCallEventSTO;
};
["d_d_sm_mar", d_cur_sm_idx + 1] call d_fnc_NetCallEventCTS;

d_cur_sm_idx = -1; publicVariable "d_cur_sm_idx";
__TRACE_2("","d_sm_winner","d_current_sm_bonus_vec")
if (d_sm_winner > 0) then {
	["d_smgetbonus", [d_sm_winner, d_current_sm_bonus_vec]] call d_fnc_NetCallEventCTS;
};
if (d_sm_winner in [-1,-2,-300,-400,-500,-600,-700,-878,-879,-880,-881,-900]) then {
	["d_sm_res_client", [d_sm_winner, ""]] call d_fnc_NetCallEventToClients;
	["d_kbmsg", [35]] call d_fnc_NetCallEventCTS;
	if !(isServer && {!isDedicated}) then {d_sm_winner = 0};
};