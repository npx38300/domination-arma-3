//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_adminspectate.sqf"
#include "x_setup.sqf"
#include "\A3\ui_f\hpp\defineDIKCodes.inc"

if (isDedicated) exitWith {};

if (isMultiplayer && {!d_pisadminp}) exitWith {d_commandingMenuIniting = false};

if (isNil {RscSpectator_camera}) then {
	xr_phd_invulnerable = true;
	RscSpectator_allowFreeCam = true;
	uiNamespace setVariable ["RscSpectator_hints", nil];
	RscSpectator_allowedGroups = [];
	{
		_unit = missionNamespace getVariable _x;
		if (!isNil "_unit" && {!isNull _unit}) then {
			_gr = group _unit;
			if !(_gr in RscSpectator_allowedGroups) then {
				RscSpectator_allowedGroups pushBack _gr;
			};
		};
	} forEach d_player_entities;
	777477 cutRsc ["RscSpectator", "plain"];
	d_rscspect_on = true;
	d_spect_disp_handler = (findDisplay 46) displayAddEventHandler ["KeyDown", {
		if (_this select 1 == DIK_ESCAPE) then {
			777477 cutRsc ["d_Empty", "plain"];
			xr_phd_invulnerable = false;
			(findDisplay 46) displayRemoveEventHandler ["KeyDown" ,d_spect_disp_handler];
			d_commandingMenuIniting = false;
			d_rscspect_on = nil;
			true
		} else {
			false
		};
	}];
	123126 cutText [localize "STR_DOM_MISSIONSTRING_1511", "PLAIN"];
} else {
	777477 cutRsc ["d_Empty", "plain"];
	xr_phd_invulnerable = false;
	d_commandingMenuIniting = false;
	d_rscspect_on = nil;
};