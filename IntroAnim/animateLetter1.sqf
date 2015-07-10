#define THIS_FILE "animateLetter1.sqf"
#include "x_setup.sqf"
private ["_ctrl", "_char", "_pos", "_Slot"];

disableSerialization;

_ctrl = [_this, 0] call BIS_fnc_param;
_char = [_this, 1] call BIS_fnc_param;
_pos = [_this, 2] call BIS_fnc_param;
_Slot = [_this, 3] call BIS_fnc_param;

d_animL_controls = d_animL_controls - [_ctrl];
_ctrl ctrlSetTextColor d_intro_color;
_ctrl ctrlSetText _char;
_ctrl ctrlSetPosition [(_pos * 0.025) + 0.13,0.05 + _Slot / 330];
_ctrl ctrlSetFade 0;
_ctrl ctrlSetScale 10;
_ctrl ctrlCommit 0;
_ctrl ctrlSetScale 1.2;
_ctrl ctrlCommit 0.5;
sleep 15;
_ctrl ctrlSetFade 1;
_ctrl ctrlCommit 1;
sleep 2;
d_animL_controls pushBack _ctrl;

true