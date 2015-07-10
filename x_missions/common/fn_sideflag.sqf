// by Xeno
#define THIS_FILE "fn_sideflag.sqf"
#include "x_setup.sqf"
private ["_posi_array", "_ran", "_ran_pos", "_flag", "_owner", "_ownerthere"];
if !(call d_fnc_checkSHC) exitWith {};

_posi_array = [_this, 0] call BIS_fnc_param;

_ran = _posi_array call d_fnc_RandomFloorArray;
_ran_pos = _posi_array select _ran;

_posi_array = nil;

if (d_with_ranked) then {d_sm_p_pos = nil};

_flag = createVehicle [d_flag_pole, _ran_pos, [], 0, "NONE"];
_flag setPos _ran_pos;

_flag setFlagTexture (call d_fnc_getenemyflagtex);

_flag setFlagside d_side_enemy;

sleep 2.123;
["aa", 1, "tracked_apc", 1, "tank", 1, _ran_pos,1,350,true] spawn d_fnc_CreateArmor;
sleep 2.123;
["specops", 2, "basic", 1, _ran_pos,250,true] spawn d_fnc_CreateInf;

_ran_pos = nil;
_ran = nil;

sleep 15.111;

d_sm_flag_failed = false;
_ownerthere = false;

while {true} do {
	call d_fnc_mpcheck;
	_owner = flagOwner _flag;
	
	if (!isNull _owner && {isNil {_owner getVariable "d_flagowner"}}) then {
		_ownerthere = true;
		_owner setVariable ["d_flagowner", _owner addMPEventHandler ["MPKilled", {d_sm_flag_failed = true}]];
	};
	
	if (!isNull _owner && {(_owner distance d_FLAG_BASE < 20)}) exitWith {
		if (d_with_ranked) then {["d_sm_p_pos", getPosATL d_FLAG_BASE] call d_fnc_NetCallEventToClients};
		_flag setFlagOwner objNull;
		d_sm_winner = 2;
		d_sm_resolved = true;
		if (d_IS_HC_CLIENT) then {
			["d_sm_var", d_sm_winner] call d_fnc_NetCallEventCTS;
		};
	};
	
	if (d_sm_flag_failed  || {_ownerthere && {isNil "_owner" || {isNull _owner}}}) exitWith {
		_flag setFlagOwner objNull;
		d_sm_winner = -900;
		d_sm_resolved = true;
		if (d_IS_HC_CLIENT) then {
			["d_sm_var", d_sm_winner] call d_fnc_NetCallEventCTS;
		};
		if (!isNil "_owner" && {!isNull _owner}) then {
			_owner removeMPEventHandler ["MPKilled", _owner getVariable "d_flagowner"];
			_owner setVariable ["d_flagowner", nil];
		};
	};
	sleep 5.123;
};

deleteVehicle _flag;

d_sm_flag_failed = nil;