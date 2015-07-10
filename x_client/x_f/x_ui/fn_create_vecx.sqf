//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_create_vecx.sqf"
#include "x_setup.sqf"

if (isDedicated || {!alive player} || {player getVariable ["xr_pluncon", false]}) exitWith {};

private "_index";
disableSerialization;
_index = lbCurSel ((uiNamespace getVariable "d_VecDialog") displayCtrl 44449);
closeDialog 0;
if (_index < 0) exitWith {};
[0,0,0, [d_create_bike select _index, 0]] spawn d_fnc_bike;