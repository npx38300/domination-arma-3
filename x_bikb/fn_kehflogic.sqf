//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_kehflogic.sqf"
#include "x_setup.sqf"

private ["_killed", "_kgrp", "_var", "_type", "_kdata"];
_killed = [_this, 0] call BIS_fnc_param;
_var = _killed getVariable "d_hq_logic_name";
_side = _killed getVariable "d_hq_logic_side";
_kdata = _killed getVariable "d_kddata";
_type = typeOf _killed;
_kgrp = group _killed;
_killed removeAllEventHandlers "killed";
_killed removeAllEventHandlers "handleDamage";
deleteVehicle _killed;
if (isNull _kgrp) then {
	_kgrp = [_side] call d_fnc_creategroup;
};
_unit = _kgrp createUnit [_type,[0,0,0],[],0,"NONE"];
missionNamespace setVariable [_var, _unit];
[_unit] joinSilent _kgrp;
_unit addEventHandler ["handleDamage",{0}];
["d_e_s_g", [_unit, false]] call d_fnc_NetCallEventCTS;
publicVariable _var;
_unit setVariable ["d_hq_logic_name", _var];
_unit setVariable ["d_hq_logic_side", _side];
_unit setVariable ["d_kddata", _kdata];

{
	_unit kbAddTopic[_x,"x_bikb\domkba3.bikb"];
} forEach (_kdata select 0);
_unit setIdentity (_kdata select 1);
_unit setRank "COLONEL";
_unit setGroupId [_kdata select 2];
_unit addEventHandler ["killed", {_this call d_fnc_kEHflogic}];
removeAllWeapons _unit;
["d_kbunits", [_var, _side]] call d_fnc_NetCallEventToClients;