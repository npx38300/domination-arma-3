//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_showppos.sqf"
#include "xr_macros.sqf"

if (isDedicated) exitWith {};

disableSerialization;

_ctrlmap = (uiNamespace getVariable "XR_SpectDlg") displayCtrl 900;
ctrlMapAnimClear _ctrlmap;

_end_pos = getPosATL player;

_ctrlmap ctrlMapAnimAdd [0, 1, getPosATL d_FLAG_BASE];
_ctrlmap ctrlMapAnimAdd [1.2, 1, _end_pos];
_ctrlmap ctrlMapAnimAdd [0.8, 0.1, _end_pos];
ctrlMapAnimCommit _ctrlmap;