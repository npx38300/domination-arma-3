// by Xeno
#define THIS_FILE "fn_spect_oneframe.sqf"
#include "xr_macros.sqf"

private ["_player_has_no_lifes","_fangle","_fangleY","_sdistance"];

#define __dspctrl(ctrlid) (_disp displayCtrl ctrlid)
#define __spectdlg1006e ((uiNamespace getVariable "xr_SpectDlg") displayCtrl 1006)

__TRACE("start one frame")
_player_has_no_lifes = (player getVariable "xr_lives") == -1;
_fangle = xr_fangle;
_fangleY = xr_fangleY;
xr_mouseDeltaPos set [0, xr_mouseLastX - (xr_MouseCoord select 0)];
xr_mouseDeltaPos set [1, xr_mouseLastY - (xr_MouseCoord select 1)];
xr_mouseLastX = xr_MouseCoord select 0;
xr_mouseLastY = xr_MouseCoord select 1;
if (xr_MouseScroll != 0) then {
	xr_sdistance = xr_sdistance - (xr_MouseScroll * 0.11);
	xr_MouseScroll = xr_MouseScroll * 0.75;
	if (xr_sdistance > xr_maxDistance) then {
		xr_sdistance = xr_maxDistance;
	} else {
		if (xr_sdistance < -xr_maxDistance) then {
			xr_sdistance = -xr_maxDistance;
		};
	};
	if (xr_sdistance < -0.6) then {xr_sdistance = -0.6};
};
_sdistance = xr_sdistance;

if (time > xr_spect_timer) then {
	if (!_player_has_no_lifes) then {
		xr_x_pllist = if (xr_x_withresp) then {[str player]} else {[]};
		xr_x_plnamelist = if (xr_x_withresp) then {[xr_name_player]} else {[]};
	} else {
		xr_x_pllist = [];
		xr_x_plnamelist = [];
	};
	_helperls = [];
	if (!_player_has_no_lifes) then {
		_vecpplxp = visiblePositionASL (vehicle player);
		{
			_u = missionNamespace getVariable _x;
			if (!isNil "_u" && {!isNull _u} && {alive _u} && {side (group _u) == xr_side_pl} && {_u != player}) then {
				_uc = _u getVariable ["xr_pluncon", false];
				if (!_uc) then {
					_add = true;
					_distup = -1;
					if (xr_x_withresp) then {
						_distup = (visiblePositionASL (vehicle _u)) distance _vecpplxp;
						if (_distup > xr_near_player_dist) then {_add = false};
					};
					if (_add) then {
						_helperls pushBack [_distup, str _u, name _u];
					};
				};
			};
		} forEach d_player_entities;
	} else {
		_sfm = markerPos "xr_playerparkmarker";
		{
			_u = missionNamespace getVariable _x;
			if (!isNil "_u" && {!isNull _u} && {alive _u} && {side (group _u) == xr_side_pl} && {_u != player}) then {
				_distup = _u distance _sfm;
				if (_distup > 100) then {
					_helperls pushBack [_distup, str _u, name _u];
				};
			};
		} forEach d_player_entities;
	};
	if !(_helperls isEqualTo []) then {
		_helperls = [_helperls, 0] call d_fnc_SortAR;
		{
			xr_x_pllist pushBack (_x select 1);
			xr_x_plnamelist pushBack (_x select 2);
		} forEach _helperls;
	};
	xr_x_updatelb = true;
	xr_spect_timer = time + 10;
	_helperls = nil;
};
//if (xr_x_updatelb && {!isNil {(uiNamespace getVariable "xr_SpectDlg")}} && {ctrlShown ((uiNamespace getVariable "xr_SpectDlg") displayCtrl 1000)}) then {
if (xr_x_updatelb && {!isNil {(uiNamespace getVariable "xr_SpectDlg")}}) then {
	__TRACE_1("","xr_x_updatelb")
	xr_x_updatelb = false;
	lbClear ((uiNamespace getVariable "xr_SpectDlg") displayCtrl 1000);
	_setidx = -1;
	{
		_idx = lbAdd [1000, xr_x_plnamelist select _forEachIndex];
		lbSetData [1000, _idx, _x];
		if (xr_spectcamtargetstr == _x) then {_setidx = _forEachIndex};
	} forEach xr_x_pllist;
	if (_setidx != -1) then {lbSetCurSel [1000, _setidx]};
};
// user pressed ESC
_spectdisp = (uiNamespace getVariable "xr_SpectDlg");
if ((isNil "_spectdisp" || {!ctrlShown (_spectdisp displayCtrl 1002)}) && {!xr_stopspect} && {player getVariable "xr_pluncon"}) then {
	__TRACE("ctrl not shown anymore, black out")
	172 cutText ["","BLACK OUT", 1];
	/*sleep 3;
	if (!alive player) then { // should not happen
		__TRACE("player not alive")
		waitUntil {alive player};
		sleep 0.1;
	};*/
	__TRACE("creating new dialog")
	createDialog "xr_SpectDlg";
	_disp = (uiNamespace getVariable "xr_SpectDlg");
	#define __dspctrl(ctrlid) (_disp displayCtrl ctrlid)
	__dspctrl(1000) ctrlShow false;
	__dspctrl(3000) ctrlShow false;
	if (xr_respawn_available) then {
		__spectdlg1006e ctrlSetText xr_x_loc_922;
		__spectdlg1006e ctrlSetTextColor [1,1,0,1];
		__spectdlg1006e ctrlCommit 0;
	};
	if (!_player_has_no_lifes) then {
		xr_spectcamtarget = player;
		xr_spectcamtargetstr = str player;
		xr_spectcam cameraEffect ["INTERNAL", "Back"];
		xr_spectcamrelpos = [-2, -2, 2];
		xr_spectcam camCommit 0;
		__dspctrl(1010) ctrlSetText xr_name_player;
	} else {
		_sfm = markerPos "xr_playerparkmarker";
		_visobj = objNull;
		{
			if (!isNull _u && {alive _u} && {side (group _u) == xr_side_pl} && {_u != player} && {_u distance _sfm > 100}) exitWith {
					_visobj = _u;
			};
		} forEach d_player_entities;
		if (isNull _visobj) then {_visobj = player};
		/*_vppv = vehicle _visobj;
		_nposvis = if (!surfaceIsWater (getPosASL _vppv)) then {
			ASLToATL (visiblePositionASL _vppv)
		} else {
			visiblePosition _vppv
		};*/
		_nposvis = ASLToATL (visiblePositionASL (vehicle _visobj));
		_campos = [(_nposvis select 0) - 1 + random 2, (_nposvis select 1) - 1 + random 2, 2];
		xr_spectcam = "camera" camCreate _campos;
		xr_spectcamtarget = _visobj;
		xr_spectcamtargetstr = str _visobj;
		xr_spectcam cameraEffect ["INTERNAL", "Back"];
		xr_spectcamrelpos = [-2, -2, 2];
		xr_spectcam camCommit 0;
		__dspctrl(1010) ctrlSetText (name _visobj);
	};
	xr_spect_timer = -1;
	__TRACE("ctrl not shown anymore, black in")
	172 cutText ["","BLACK IN", 1];
};
if (isNull xr_spectcamtarget) then { // player disconnect !?!
	/*_vppv = vehicle player;
	_nposvis = if (!surfaceIsWater (getPosASL _vppv)) then {
		ASLToATL (visiblePositionASL _vppv)
	} else {
		visiblePosition _vppv
	};*/
	_nposvis = ASLToATL (visiblePositionASL (vehicle player));
	_campos = [(_nposvis select 0) - 1 + random 2, (_nposvis select 1) - 1 + random 2, 2];
	xr_spectcamtarget = player;
	xr_spectcamtargetstr = str player;
	xr_spectcam cameraEffect ["INTERNAL", "Back"];
	xr_spectcamrelpos = [-2, -2, 2];
	xr_spectcam camCommit 0;
	__dspctrl(1010) ctrlSetText xr_name_player;
};

_bb = boundingBoxreal vehicle xr_spectcamtarget;
_l = ((_bb select 1) select 1) - ((_bb select 0) select 1);
_hstr = 0.15;
if (isNil "_h") then {_h = 2};
_h = ((((_bb select 1) select 2) - ((_bb select 0) select 2)) * _hstr) + (_h * (1 - _hstr));

/*_vppv = vehicle xr_spectcamtarget;
_vpmtw = if (!surfaceIsWater (getPosASL _vppv)) then {
	ASLToATL (visiblePositionASL _vppv)
} else {
	visiblePosition _vppv
};*/
_vpmtw = ASLToATL (visiblePositionASL (vehicle xr_spectcamtarget));
_cxpos = _vpmtw select 0;
_cypos = _vpmtw select 1;
_czpos = _vpmtw select 2;

_gjp = [_cxpos, _cypos, _czpos + (_h * 0.6)];
xr_spectcam camSetTarget _gjp;
xr_spectcam camSetFov xr_szoom;

_lsdist = _l * (0.3 max _sdistance);
_d = -_lsdist;
_co = cos _fangleY;
xr_spectcam camSetRelPos [(sin _fangle * _d) * _co, (cos _fangle * _d) * _co, sin _fangleY * _lsdist];
xr_spectcam camCommit 0;
//if (!(player getVariable "xr_pluncon") && {!_player_has_no_lifes}) exitWith {xr_stopspect = true};
__TRACE("end one frame")