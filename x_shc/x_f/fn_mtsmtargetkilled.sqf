//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_mtsmtargetkilled.sqf"
#include "x_setup.sqf"

d_side_main_done = true;
if (d_IS_HC_CLIENT) then {
	["d_sSetVar", ["d_side_main_done", true]] call d_fnc_NetCallEventCTS;
};
["d_kbmsg", [42, (if (side (_this select 1) == d_side_player) then {_this select (count _this - 1)} else {"sec_over"}) call d_fnc_GetSMTargetMessage]] call d_fnc_NetCallEventCTS;
d_sec_kind = 0; publicVariable "d_sec_kind";