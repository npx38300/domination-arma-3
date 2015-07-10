//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_player_name_huddo.sqf"
#include "x_setup.sqf"

private ["_u", "_ali", "_targetPos", "_position", "_vehu", "_tex", "_col", "_o", "_distu", "_pheight", "_eyepos_u", "_scale"];
disableSerialization;
if (d_show_pname_hud && {!visibleMap} && {isNil "d_is_sat_on"}) then {
	_pheight = switch (stance player) do {
		case "PRONE": {0.2};
		case "CROUCH": {0.9};
		case "STAND": {1.7};
		default {0.9};
	};
	{
		_u = missionNamespace getVariable _x;
		if (!isNil "_u" && {!isNull _u}) then {
			_distu = (positionCameraToWorld [0,0,0]) distance _u;
			if (_u != player && {_distu <= d_dist_pname_hud} && {alive player} && {alive _u}) then {
				_epp = eyePos player;
				_epu = eyePos _u;
				if (terrainIntersectASL [_epp, _epu] || {lineIntersects [_epp, _epu]}) exitWith {};
				_ali = alive _u;
				_vehu = vehicle _u;
				
				/*_targetPos = if (!surfaceIsWater (getPosASL _u)) then {
					ASLToATL (visiblePositionASL _u)
				} else {
					visiblePosition _u
				};*/
				_targetPos = ASLToATL (visiblePositionASL _vehu);

				if (!(_targetPos isEqualTo []) && {(_vehu == _u || {(_vehu != _u && {_u == driver _vehu})})}) then {
					_targetPos set [2 , (_targetPos select 2) + (if (_ali) then {2} else {1})];
					private "_tex";
					
					if (_distu <= 50) then {
						_tex = switch (d_show_player_namesx) do {
							case 1: {
								if (_ali) then {
									private "_unc";
									_unc = _u getVariable ["xr_pluncon", false];
									if (_unc) then {(name _u) + d_phud_loc883} else {(name _u) + (if (getNumber (configFile/"CfgVehicles"/typeOf _u/"attendant") == 1) then {d_phud_loc884} else {""})}
								} else {d_phud_loc885}
							};
							case 2: {str(9 - round(9 * damage _u))};
							default {d_phud_loc886};
						};
						if (isNil "_tex") then {_tex = d_phud_loc886};
						_scale = if (_distu == 0) then {
							1.2
						} else {
							(1.2 - ((_distu / 50) * .65)) max 0.8;
						};
					} else {
						_tex = "*";
						_scale = 0.4;
					};
					_scale = _scale / 50;
					_col = if (!_ali) then {
						d_pnhuddeadcolor
					} else {
						if (group _u == group player) then {d_pnhudgroupcolor} else {d_pnhudothercolor}
					};
					_targetPos set [2 , (_targetPos select 2) + (_distu/40)];
					drawIcon3D ["#(argb,8,8,3)color(0,0,0,0)", _col, _targetPos, 1, 1, 0, _tex, 1, _scale, "TahomaB"];
				};
			};
		};
	} foreach d_phud_units;
} else {
	if (!d_show_pname_hud) then {
		removeMissionEventHandler ["Draw3D", d_phudraw3d];
		d_phudraw3d = -1;
	};
};