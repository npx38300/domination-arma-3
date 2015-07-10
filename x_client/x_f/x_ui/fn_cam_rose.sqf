// by Xeno
#define THIS_FILE "fn_cam_rose.sqf"
#include "x_setup.sqf"

private ["_radius", "_disp", "_width", "_height", "_dir", "_x1", "_y1", "_y", "_correctit_fnc"];

1234 cutRsc ["d_cam_rose","PLAIN"];

disableSerialization;

_center_x = SafeZoneX + SafeZoneW - 0.2;
_center_y = SafeZoneY + SafeZoneH - 0.3;
_radius = 0.05;
_x_offset = 0.003;
_y_offset = 0.003;

#define _disp (uiNamespace getVariable "d_cam_rose")
_char_n = _disp displayCtrl 64432;
_char_e = _disp displayCtrl 64433;
_char_s = _disp displayCtrl 64434;
_char_w = _disp displayCtrl 64435;

_ctp = ctrlPosition _char_n;
_width = _ctp select 2;
_height = _ctp select 3;

_correctit_fnc = {
	_pos = _this select 0;
	_dir = _this select 1;
	if (_dir >= 270 || {_dir <= 90}) then {
		_pos set [1, (_pos select 1) + _y_offset]
	};
	if (_dir >= 0 && {_dir <= 180}) then {
		_pos set [0, (_pos select 0) - _x_offset]
	};
	if (_dir >= 90 && {_dir <= 270}) then {
		_pos set [1, (_pos select 1) - _y_offset]
	};
	if (_dir >= 180 && {_dir <= 360}) then {
		_pos set [0, (_pos select 0) + _x_offset]
	};
	_pos
};

while {!isNil "d_do_end_rose"} do {
	_dir = getDirVisual BIS_fnc_establishingShot_fakeUAV;
	_x1 = _center_x - (_radius * sin _dir);
	_y1 = _center_y - (_radius * cos _dir);
	_pos = [[_x1, _y1], _dir] call _correctit_fnc;
	_char_n ctrlSetPosition [_pos select 0, _pos select 1, _width, _height];
	_char_n ctrlCommit 0;

	_x1 = _center_x - (_radius * sin (_dir + 90));
	_y1 = _center_y - (_radius * cos (_dir + 90));
	_pos = [[_x1, _y1], _dir] call _correctit_fnc;
	_char_w ctrlSetPosition [_pos select 0, _pos select 1, _width, _height];
	_char_w ctrlCommit 0;

	_x1 = _center_x - (_radius * sin (_dir + 180));
	_y1 = _center_y - (_radius * cos (_dir + 180));
	_pos = [[_x1, _y1], _dir] call _correctit_fnc;
	_char_s ctrlSetPosition [_pos select 0, _pos select 1, _width, _height];
	_char_s ctrlCommit 0;

	_x1 = _center_x - (_radius * sin (_dir + 270));
	_y1 = _center_y - (_radius * cos (_dir + 270));
	_pos = [[_x1, _y1], _dir] call _correctit_fnc;
	_char_e ctrlSetPosition [_pos select 0, _pos select 1, _width, _height];
	_char_e ctrlCommit 0;

	sleep 0.01;
};

1234 cutRsc ["d_Empty","PLAIN"];