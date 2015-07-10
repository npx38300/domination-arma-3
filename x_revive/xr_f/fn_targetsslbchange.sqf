//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_targetsslbchange.sqf"
#include "xr_macros.sqf"

if (isDedicated) exitWith {};

private ["_selIdx", "_data", "_unit"];
disableSerialization;
_selIdx = _this select 1;
if (_selIdx == -1) exitWith {};
_data = lbData [1000, _selIdx];
if (_data == xr_spectcamtargetstr) exitWith {};
_unit = missionNamespace getVariable _data;
if (isNil "_unit" || {isNull _unit}) exitWith {};
xr_spectcamtargetstr = _data;
_posunit = ASLToATL (visiblePositionASL (vehicle _unit));
_posunit set [2, 2];
xr_spectcamtarget = _unit;
xr_spectcam camSetTarget xr_spectcamtarget;
xr_spectcam camSetPos _posunit;
xr_spectcam cameraEffect ["INTERNAL", "Back"];
xr_spectcam camCommit 0;
ctrlSetText [1010, lbText [1000, _selIdx]];