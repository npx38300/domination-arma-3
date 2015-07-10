//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_createmhqenemyteletrig.sqf"
#include "x_setup.sqf"

private ["_mhq", "_trig", "_trigger"];
_mhq = _this;

_trig = _mhq getVariable "d_enemy_trigger";
if (!isNil "_trig") then {
	if (!isNull _trig) then {
		deleteVehicle _trig;
	};
	_mhq setVariable ["d_enemy_trigger", nil];
};

_trigger = [
getPosATL _mhq,
[d_NoMHQTeleEnemyNear, d_NoMHQTeleEnemyNear, 0, false],
[d_enemy_side_trigger, "PRESENT", true],
["this",
format ["%1 setVariable ['d_enemy_near', true, true]", str _mhq],
format ["%1 setVariable ['d_enemy_near', false, true]", str _mhq]
]
] call d_fnc_CreateTrigger;

_mhq setVariable ["d_enemy_trigger", _trigger];

_trigger attachTo [_mhq, [0,0,0]];