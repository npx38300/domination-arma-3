// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_jip.sqf"
#include "x_setup.sqf"
if (isDedicated || {!isNil "d_jip_started"}) exitWith {};
d_jip_started = true;

if (d_IS_HC_CLIENT) exitWith {
	__TRACE("Headless client found")
	call compile preprocessFileLineNumbers "x_shc\x_setuphc.sqf";
};

call compile preprocessFileLineNumbers "x_client\x_setupplayer.sqf";

diag_log [diag_frameno, diag_ticktime, time, "Dom local player JIP trigger processed"];