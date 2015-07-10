//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_tkr.sqf"
#include "x_setup.sqf"

_unit = [_this, 0] call BIS_fnc_param;
_killer = [_this, 1] call BIS_fnc_param;
_par = d_player_store getVariable (getPlayerUID _unit);
__TRACE_1("_unit",_par)
_namep = if (isNil "_par") then {"Unknown"} else {_par select 6};
_par = d_player_store getVariable (getPlayerUID _killer);
__TRACE_1("_killer",_par)
_namek = if (isNil "_par") then {"Unknown"} else {_par select 6};
[_namek, _namep, _killer] call d_fnc_TKKickCheck;
["d_unit_tk2", [_namep,_namek]] call d_fnc_NetCallEventToClients;