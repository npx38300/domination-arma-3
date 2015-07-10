// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_addtoclean.sqf"
#include "x_setup.sqf"

private "_vec";
_vec = [_this, 0] call BIS_fnc_param;
d_allunits_add pushBack _vec;
if (d_with_ai && {d_with_ranked}) then {
	_vec addEventHandler ["MPKilled", {if (isServer) then {[8, _this select 1] call d_fnc_AddKillsAI;(_this select 0) removeAllEventHandlers "MPKilled"}}];
};
if (d_LockAir == 0) then {_vec lock true};