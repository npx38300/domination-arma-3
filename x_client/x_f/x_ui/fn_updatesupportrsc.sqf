// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_updatesupportrsc.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_ctrl"];

disableSerialization;

#define __availcol [0,1,0,0.3]
#define __notavailcol [1,0,0,0.2]

_ctrl = (uiNamespace getVariable "d_RscSupportL") displayCtrl 50;
if (d_player_can_call_arti > 0) then {
	if (d_ari_available) then {
		_ctrl ctrlShow true;
		_ctrl ctrlsettextcolor __availcol;
	} else {
		_ctrl ctrlShow false;
		//_ctrl ctrlsettextcolor __notavailcol;
	};
} else {
	_ctrl ctrlShow false;
};

_ctrl = (uiNamespace getVariable "d_RscSupportL") displayCtrl 51;
if (d_player_can_call_drop > 0) then {
	if (d_para_available) then {
		_ctrl ctrlShow true;
		_ctrl ctrlsettextcolor __availcol;
	} else {
		_ctrl ctrlShow false;
		//_ctrl ctrlsettextcolor __notavailcol;
	};
} else {
	_ctrl ctrlShow false;
};