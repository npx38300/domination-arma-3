// by Xeno
#define THIS_FILE "x_intro.sqf"
#include "x_setup.sqf"
private ["_s","_str"];
if (isDedicated) exitWith {};

diag_log [diag_frameno, diag_ticktime, time, "Dom intro started"];

enableRadio false;

disableSerialization;

waitUntil {sleep 0.112;!isNil "d_preloaddone"};
sleep 0.01;
1 fadeSound 1;

d_still_in_intro = true;

showCinemaBorder true;

createDialog "d_RscAnimatedLetters";
setMousePosition [1, 1];
_line = 0;
d_animL_i = 0;
titleText ["", "BLACK IN",0];
88 cutrsc ["RscStatic","PLAIN"];

_pspsxx = getPosASL player;
_arrow_over_head = "Sign_Arrow_Large_F" createVehicleLocal [_pspsxx select 0, _pspsxx select 1, 2.2];
_arrow_over_head setPos [_pspsxx select 0, _pspsxx select 1, 2.2];
_arrow_over_head spawn {
	private ["_dir", "_arr"];
	_dir = 0;
	_arr = _this;
	while {!isNull _arr} do {
		_arr setDir _dir;
		_dir = _dir + 1;
		if (_dir == 360) then {_dir = 0};
		sleep 0.005;
	};
};

"dynamicBlur" ppEffectEnable true;
"dynamicBlur" ppEffectAdjust [6];
"dynamicBlur" ppEffectCommit 0;
"dynamicBlur" ppEffectAdjust [0.0];
"dynamicBlur" ppEffectCommit 15;

playMusic "LeadTrack01b_F";

if (sunOrMoon < 0.99) then {camUseNVG true};

d_intro_color = switch (d_own_side) do {case "BLUFOR": {[0.85,0.88,1,1]};case "OPFOR": {[1,0.36,0.34,1]};case "INDEPENDENT": {[1,1,0,1]};};
_camstart = markerPos "d_camstart";
deleteMarkerLocal "d_camstart";

private "_camera";
_camera = "camera" camCreate [_camstart select 0, (_camstart select 1) + 1, 120];
_camera camSetTarget [_pspsxx select 0, _pspsxx select 1 , 1.5];
_camera camSetFov 0.7;
_camera cameraEffect ["INTERNAL", "Back"];
_camera camCommit 1;
waitUntil {camCommitted _camera};

_str = "One Team - " + d_version_string;
_start_pos = 4;
_str2 = "";
if (d_with_ai) then {if (_str2 != "") then {_str2 = _str2 + " AI"} else {_str2 = _str2 + "AI"}};
if (d_with_ranked) then {if (_str2 != "") then {_str2 = _str2 + " RA"} else {_str2 = _str2 + "RA"}};
if (d_WithRevive == 0) then {if (_str2 != "") then {_str2 = _str2 + " REVIVE"} else {_str2 = _str2 + "REVIVE"}};
_start_pos2 = switch (count _str2) do {
	case 2: {11};
	case 3: {11};
	case 4: {10};
	case 5: {10};
	case 6: {9};
	case 7: {9};
	case 8: {8};
	case 9: {8};
	case 10: {8};
	case 11: {7};
	case 12: {6};
	case 13: {5};
	case 14: {5};
	case 15: {4};
	case 16: {3};
	default {0};
};

2 cutRsc ["d_DomLabel", "PLAIN", 2];
4 cutRsc ["d_DomThree", "PLAIN", 2];
5 cutRsc ["d_ArmaLogo", "PLAIN", 2];
[_start_pos, _str, 5] execVM "IntroAnim\animateLettersX.sqf";_line = _line + 1; waitUntil {d_animL_i == _line};
if (_str2 != "") then {[_start_pos2, _str2, 6] execVM "IntroAnim\animateLettersX.sqf";_line = _line + 1; waitUntil {d_animL_i == _line}};
switch (d_MissionType) do {
	case 2: {
		[4, localize "STR_DOM_MISSIONSTRING_263", 4] execVM "IntroAnim\animateLettersX.sqf";_line = _line + 1; waitUntil {d_animL_i == _line};
	};
	case 1: {
		[4, localize "STR_DOM_MISSIONSTRING_264", 4] execVM "IntroAnim\animateLettersX.sqf";_line = _line + 1; waitUntil {d_animL_i == _line};
	};
};

_camera camSetTarget player;
_p_tpos = [_pspsxx select 0, _pspsxx select 1, 2];
_camera camSetPos _p_tpos;
_camera camCommit 18;

0 spawn {
	private ["_control", "_posdom", "_control2", "_pos", "_oldy"];
	disableSerialization;
	sleep 3;
	_control = (uiNamespace getVariable "d_DomLabel") displayCtrl 50;
	_posdom = ctrlPosition _control;
	_control ctrlSetPosition [(_posdom select 0) - 0.1, _posdom select 1];
	_control ctrlCommit 0.3;
	waitUntil {ctrlCommitted _control};
	_control2 = (uiNamespace getVariable "d_DomThree") displayCtrl 50;
	_pos = ctrlPosition _control2;
	_control2 ctrlSetPosition [0.69, _pos select 1];
	_control2 ctrlCommit 0.5;
	waitUntil {ctrlCommitted _control2};
	0 cutRsc ["d_Lightning1","PLAIN"];
	11 cutRsc ["d_Eyeflare","PLAIN"];
	sleep 0.1;
	playSound "d_Thunder";
};
55 cutRsc ["d_Xlabel","PLAIN"];
sleep 6;
waitUntil {camCommitted _camera};
deleteVehicle _arrow_over_head;
player cameraEffect ["terminate","back"];
camDestroy _camera;
closeDialog 0;

enableRadio true;
showChat true;
"dynamicBlur" ppEffectEnable false;

private "_uidcheck_done";
_uidcheck_done = false;
if (d_reserved_slot != "" && {str player == d_reserved_slot}) then {
	_uidcheck_done = true;
	execVM "x_client\x_reservedslot.sqf";
};
if (!_uidcheck_done && {!(d_uid_reserved_slots isEqualTo [])} && {!(d_uids_for_reserved_slots isEqualTo [])}) then {
	for "_xi" from 0 to (count d_uid_reserved_slots - 1) do {
		d_uid_reserved_slots set [_xi, toUpper (d_uid_reserved_slots select _xi)];
	};
	if ((toUpper str player) in d_uid_reserved_slots) then {
		if !(getPlayerUID player in d_uids_for_reserved_slots) then {
			execVM "x_client\x_reservedslot2.sqf";
		};
		d_uid_reserved_slots = nil;
		d_uids_for_reserved_slots = nil;
	};
};

d_still_in_intro = false;

sleep 5;

[[[localize "STR_DOM_MISSIONSTRING_265","<t size='1.0' font='PuristaMedium'>%1</t><br/>",0],[name player,"<t size='1.0' font='PuristaBold'>%1</t><br/>",5],[localize "STR_DOM_MISSIONSTRING_266","<t size='0.9'>%1</t><br/>",27]],-safezoneX,0.85,"<t color='#FFFFFFFF' align='right'>%1</t>"] spawn bis_fnc_typeText;

sleep 8;
123123 cutText [format [localize "STR_DOM_MISSIONSTRING_1434", actionKeysNames "TeamSwitch"], "PLAIN"];
xr_phd_invulnerable = false;

sleep 12;
123125 cutText ["You are not allowed to monetize videos or streams made while playing Domination in any form!!!\nIf you want to make money make your own content @youtube and twitch heroes!!!", "PLAIN"];

0 spawn {
	sleep 20;
	while {true} do {
		sleep (280 + random 280);
		467 cutRsc ["d_restrict", "PLAIN"];
	};
};

diag_log [diag_frameno, diag_ticktime, time, "Dom intro ended"];