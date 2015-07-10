// by Xeno
//#define __DEBUG__
#define THIS_FILE "initPlayerServer.sqf"
#include "x_setup.sqf"
//diag_log [diag_frameno, diag_ticktime, time, "Executing MPF initPlayerServer.sqf"];
__TRACE_1("","_this")
private ["_pl","_id","_name", "_uid", "_p"];
_pl = [_this, 0] call BIS_fnc_param;
_name = name _pl;

if (isNil "d_HC_CLIENT_OBJ" && {str _pl == "HC_D_UNIT"}) exitWith {
	d_HC_CLIENT_OBJ = _pl;
	d_HC_CLIENT_OBJ_NAME = _name;
};

_uid = getPlayerUID _pl;
_id = -1; // not used

_p = d_player_store getVariable _uid;
if (isNil "_p") then {
	_p = [d_AutoKickTime, time, _uid, 0, str _pl, _id, _name, 0, (if (xr_max_lives != -1) then {xr_max_lives} else {-2}), 0, ""];
	d_player_store setVariable [_uid, _p];
	__TRACE_3("Player not found","_uid","_name","_p")
	d_scda = _p;
} else {
	__TRACE_1("player store before change","_p")
	if (_name != (_p select 6)) then {
		["d_w_n", [_name, _p select 6]] call d_fnc_NetCallEventToClients;
		diag_log (format [localize "STR_DOM_MISSIONSTRING_942", _name, _p select 6, _uid]);
	};
	if (time - (_p select 9) > 600) then {
		_p set [8, xr_max_lives];
	};
	_p set [1, time];
	_p set [4, str _pl];
	_p set [6, _name];
	__TRACE_1("player store after change","_p")
	d_scda = _p;
};

_opl = owner _pl;
_opl publicVariableClient "d_scda";
__TRACE_2("","_opl","d_scda")

//diag_log [diag_frameno, diag_ticktime, time, "MPF initPlayerServer.sqf processed"];