//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_closespectcontrols.sqf"
#include "xr_macros.sqf"

if (isDedicated) exitWith {};

disableSerialization;
private ["_disp"];
_disp = uiNamespace getVariable ["XR_SpectDlg", displayNull];
if (!isNull _disp) then {
	if (ctrlShown (_disp displayCtrl 3000)) then {ctrlShow [3000, false]};
	if (ctrlShown (_disp displayCtrl 1000)) then {ctrlShow [1000, false]};
};