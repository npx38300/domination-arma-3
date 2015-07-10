//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_unloadsetcargo.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_index"];
disableSerialization;
_index = lbCurSel ((uiNamespace getVariable "d_UnloadDialog") displayCtrl 101115);
if (_index < 0) exitWith {closeDialog 0};
d_cargo_selected_index = _index;
closeDialog 0;