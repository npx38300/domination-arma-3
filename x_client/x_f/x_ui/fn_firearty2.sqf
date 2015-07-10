//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_firearty2.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_ctrl", "_idx"];
_ctrl = (uiNamespace getVariable "d_MarkArtilleryDialog") displayCtrl 889;
_idx = lbCurSel _ctrl;
if (_idx == -1) exitWith {};
d_ari_salvos = _idx + 1;

_ctrl = (uiNamespace getVariable "d_MarkArtilleryDialog") displayCtrl 888;
_idx = lbCurSel _ctrl;
if (_idx == -1) exitWith {};
d_ari_type = _ctrl lbData _idx;
