// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_teleupdate_dlg.sqf"
#include "x_setup.sqf"
private ["_display", "_listctrl", "_wone"];

if (isDedicated || {d_x_loop_end}) exitWith {};

disableSerialization;

#define __CTRL(A) (_display displayCtrl A)

_wone = [_this, 0] call BIS_fnc_param;

_display = if (_wone == 0) then {(uiNamespace getVariable "d_TeleportDialog")} else {(uiNamespace getVariable "xr_SpectDlg")};

_listctrl = __CTRL(1500);

#define __COLRED [1,0,0,0.7]

for "_i" from 0 to ((lbSize _listctrl) - 1) do {
	_lbdata = _listctrl lbData _i;
	if (_lbdata != "D_BASE_D") then {
		_mrs = missionNamespace getVariable [_lbdata, objNull];
		if (!isNull _mrs) then {
			_mravailable = false;
			_lbcolor = switch (true) do {
				case (_mrs getVariable ["d_in_air", false]): {__COLRED};
				case (speed _mrs > 4): {__COLRED};
				case (surfaceIsWater (getPosASL _mrs)): {__COLRED};
				case (!alive _mrs): {__COLRED};
				case !(_mrs getVariable ["d_MHQ_Deployed", false]): {__COLRED};
				case (_mrs getVariable ["d_enemy_near", false]): {__COLRED};
				default {_mravailable = true; [1,1,1,1.0]};
			};
			_listctrl lbSetColor [_i, _lbcolor];
			if (lbCurSel _listctrl == _i) then {
				if (_mravailable) then {
					_text = if (_wone == 1 || {d_tele_dialog == 0}) then {
						format [localize "STR_DOM_MISSIONSTRING_607", _listctrl lbText _i]
					} else {
						format [localize "STR_DOM_MISSIONSTRING_605", _listctrl lbText _i]
					};
					__CTRL(100102) ctrlEnable true;
					__CTRL(100110) ctrlSetText _text;
				} else {
					__CTRL(100102) ctrlEnable false;
					__CTRL(100110) ctrlSetText "";
				};
			};
		};
	};
};

if (_wone == 1 && {xr_respawn_available} && {!ctrlEnabled __CTRL(100102)}) then {
	__CTRL(100102) ctrlEnable true;
};
