//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_squadmanagementfill.sqf"
#include "x_setup.sqf"

#define CTRL(A) (_disp displayCtrl A)
// 28 controls in controls group currently (0-27)
#define __NUM_CTRLS 27

if (isDedicated) exitWith {};

private ["_disp", "_units", "_i", "_helper", "_ctrl", "_ctrl2", "_sidegrppl", "_grptxtidc", "_grplbidc", "_grpbutidc", "_curgrp", "_leader", "_unitsar", "_name", "_isppp", "_index", "_pic", "_diff"];
disableSerialization;
_disp = (uiNamespace getVariable "d_SquadManagementDialog");

_units = if (isMultiplayer) then {(playableUnits - [objNull])} else {switchableUnits};
if (isNil "d_SQMGMT_grps") then {
	d_SQMGMT_grps = [];
} else {
	for "_i" from 0 to (count d_SQMGMT_grps - 1) do {
		_helper = d_SQMGMT_grps select _i;
		if (isNull _helper) then {
			d_SQMGMT_grps set [_i, -1];
		} else {
			if ((units _helper) isEqualTo []) then {
				d_SQMGMT_grps set [_i, -1];
			};
		};
	};
	d_SQMGMT_grps = d_SQMGMT_grps - [-1];
};

for "_i" from 0 to __NUM_CTRLS do {
	_ctrl = _disp displayCtrl (4000 + _i);
	_ctrl ctrlShow true;
	_ctrl = _disp displayCtrl (3000 + _i);
	_ctrl ctrlShow true;
	_ctrl ctrlSetText (localize "STR_DOM_MISSIONSTRING_1429");
	_ctrl ctrlEnable true;
	_ctrl = _disp displayCtrl (2000 + _i);
	_ctrl ctrlShow true;
	_ctrl = _disp displayCtrl (1000 + _i);
	_ctrl ctrlShow true;
	_ctrl = _disp displayCtrl (6000 + _i);
	_ctrl ctrlShow false;
	_ctrl = _disp displayCtrl (7000 + _i);
	_ctrl ctrlShow false;
	_ctrl = _disp displayCtrl (8000 + _i);
	_ctrl ctrlShow false;
};

_sidegrppl = side (group player);
{
	if (!((group _x) in d_SQMGMT_grps) && {side (group _x) getFriend _sidegrppl >= 0.6}) then {
		d_SQMGMT_grps pushBack (group _x);
	};
} forEach _units;

_grptxtidc = 4000;
_grplbidc = 2000;
_grpbutidc = 3000;
_grplockidc = 6000;
_grplockbutidc = 7000;
_grpframeidc = 8000;
{
	_ctrl = CTRL(_grptxtidc);
	if (group player != _x) then {
		_ctrl ctrlSetText (groupID _x);
	} else {
		_ctrl ctrlSetText (groupID _x + " *");
	};
	
	_lockedgr = _x getVariable ["d_locked", false];
	if (_lockedgr) then {
		CTRL(_grplockidc) ctrlShow true;
	};
	if (player == leader _x) then {
		CTRL(_grplockbutidc) ctrlShow true;
		CTRL(_grplockbutidc) ctrlSetText (if (_lockedgr) then {"Unlock"} else {"Lock"});	
	};
	
	_curgrp = _x;
	_leader = objNull;
	_unitsar = [];
	{
		if (_x != leader _curgrp) then {
			_unitsar pushBack _x;
		} else {
			_leader = _x;
		};
	} forEach (units _curgrp);
	if (!isNull _leader) then {
		_unitsar = [_leader] + _unitsar;
	};
	
	_ctrl = CTRL(_grplbidc);
	lbClear _ctrl;
	_ctrl lbSetCurSel -1;
	{
		_name = name _x;
		if (!isPlayer _x) then {
			_name = _name + " (" + (localize "STR_DOM_MISSIONSTRING_1431") + ")";
		};
		_name_data = name _x;
		_isppp = false;
		if (_x == player) then {
			_isppp = true;
			_ctrl2 = CTRL(_grpbutidc);
			if (count _unitsar > 1) then {
				_ctrl2 ctrlSetText (localize "STR_DOM_MISSIONSTRING_1430");
			} else {
				_ctrl2 ctrlShow false;
			};
		};
		_index = _ctrl lbAdd _name;
		_ctrl lbSetData [_index, _name_data];
		if (_isppp) then {
			_ctrl lbSetColor [_index, [1,1,1,1]];
		};
		_ipic = getText (configFile/"cfgVehicles"/typeOf _x/"icon");
		_pic = if (_ipic == "") then {
			"#(argb,8,8,3)color(1,1,1,0)"
		} else {
			getText(configFile/"CfgVehicleIcons"/_ipic)
		};
		_ctrl lbSetPicture [_index, _pic];
	} forEach _unitsar;
	if (count (units _x) >= 32) then {
		_ctrl2 = CTRL(_grpbutidc);
		_ctrl2 ctrlEnable false;
	};
	_grptxtidc = _grptxtidc + 1;
	_grplbidc = _grplbidc + 1;
	_grpbutidc = _grpbutidc + 1;
	_grplockidc = _grplockidc + 1;
	_grplockbutidc = _grplockbutidc + 1;
} forEach d_SQMGMT_grps;

if (_grptxtidc < (4000 + __NUM_CTRLS)) then {
	_diff = (4000 + __NUM_CTRLS) - _grptxtidc;
	for "_i" from (__NUM_CTRLS - _diff) to __NUM_CTRLS do {
		_ctrl = _disp displayCtrl (8000 + _i);
		_ctrl ctrlShow false;
		_ctrl = _disp displayCtrl (4000 + _i);
		_ctrl ctrlShow false;
		_ctrl = _disp displayCtrl (3000 + _i);
		_ctrl ctrlShow false;
		_ctrl = _disp displayCtrl (2000 + _i);
		_ctrl ctrlShow false;
		_ctrl = _disp displayCtrl (1000 + _i);
		_ctrl ctrlShow false;
	};
};
ctrlSetFocus CTRL(9999);