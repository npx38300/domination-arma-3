//#define __DEBUG__
#define THIS_FILE "fn_dirto.sqf"
#include "x_setup.sqf"

/************************************************************
	Direction To
	By Andrew Barron

Parameters: [object or position 1, object or position 2]

Returns the compass direction from object/position 1 to
object/position 2. Return is always >=0 <360.

Example: [player, getpos dude] call d_fnc_DirTo
************************************************************/
private ["_pos1","_pos2","_ret"];
_pos1 = [_this, 0] call BIS_fnc_param;
_pos2 = [_this, 1] call BIS_fnc_param;

if (typename _pos1 == "OBJECT") then {_pos1 = getPosASL _pos1};
if (typename _pos2 == "OBJECT") then {_pos2 = getPosASL _pos2};

_ret = ((_pos2 select 0) - (_pos1 select 0)) atan2 ((_pos2 select 1) - (_pos1 select 1));
if (_ret < 0) then {_ret = _ret + 360};
(_ret % 360)