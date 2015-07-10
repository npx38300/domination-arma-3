//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_tkkickcheck.sqf"
#include "x_setup.sqf"

private ["_tk", "_p", "_sel", "_numtk", "_uid"];
_tk = _this select 2;
_tk addScore (d_sub_tk_points * -1);
_uid = getPlayerUID _tk;
__TRACE_2("TKKickCheck","_tk","_uid")
_p = d_player_store getVariable _uid;
if (!isNil "_p") then {
	_numtk = (_p select 7) + 1;
	_p set [7, _numtk];
	if (_numtk >= d_maxnum_tks_forkick) exitWith {
		_pna = _p select 6;
		serverCommand ("#kick " + _pna);
		diag_log format ["Player %1 was kicked automatically because of teamkilling, # team kills: %3, ArmA 2 Key: %2", _pna, _uid, _numtk];
		["d_tk_an", [_pna, _numtk]] call d_fnc_NetCallEventToClients;
		["d_em", [_tk]] call d_fnc_NetCallEventSTO;
	};
};