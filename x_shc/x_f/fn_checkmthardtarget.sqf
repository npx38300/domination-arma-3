//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_checkmthardtarget.sqf"
#include "x_setup.sqf"

private "_vec";
_vec = [_this, 0] call BIS_fnc_param;
[_vec] execFSM "fsms\XRemoveVehiExtra.fsm";
_vec addEventHandler ["killed", {
	d_mt_spotted = false;
	if (d_IS_HC_CLIENT) then {
		["d_sSetVar", ["d_mt_spotted", false]] call d_fnc_NetCallEventCTS;
	};
	d_mt_radio_down = true;
	["d_sSetVar", ["d_mt_radio_down", true]] call d_fnc_NetCallEventCTS;
	["d_d_m_g", "d_main_target_radiotower"] call d_fnc_NetCallEventCTS;
	["d_kbmsg", [37]] call d_fnc_NetCallEventCTS;
	(_this select 0) removeAllEventHandlers "killed";
}];
_vec addEventHandler ["handleDamage", {_this call d_fnc_CheckMTShotHD}];