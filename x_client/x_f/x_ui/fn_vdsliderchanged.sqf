//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_vdsliderchanged.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private "_newvd";
disableSerialization;
_newvd = round (_this select 1);
((uiNamespace getVariable "d_SettingsDialog") displayCtrl 1999) ctrlSetText format [localize "STR_DOM_MISSIONSTRING_358", _newvd];
setViewDistance _newvd;