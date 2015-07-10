//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_guardwp.sqf"
#include "x_setup.sqf"

private ["_ggrp"];
_ggrp = _this;
_ggrp setCombatMode "YELLOW";
_ggrp setFormation (["COLUMN","STAG COLUMN","WEDGE","ECH LEFT","ECH RIGHT","VEE","LINE","FILE","DIAMOND"] call d_fnc_RandomArrayVal);
_ggrp setFormDir (floor random 360);
_ggrp setSpeedMode "NORMAL";
_ggrp setBehaviour "SAFE";