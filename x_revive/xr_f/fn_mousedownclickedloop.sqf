//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_mousedownclickedloop.sqf"
#include "xr_macros.sqf"

if (isDedicated) exitWith {};

__TRACE("on")
xr_mousecheckon = true;
while {xr_MouseButtons select 1 || {xr_MouseButtons select 0}} do {
	if (!(xr_MouseButtons select 0) && {(xr_MouseButtons select 1)}) then {
		xr_fangle = xr_fangle - ((xr_mouseDeltaPos select 0) * 360);
		xr_fangleY = xr_fangleY + ((xr_mouseDeltaPos select 1) * 180);
		if (xr_fangleY > 89) then {
			xr_fangleY = 89;
		} else {
			if (xr_fangleY < -89) then {
				xr_fangleY = -89;
			};
		};
	} else {
		if ((xr_MouseButtons select 0) && {!(xr_MouseButtons select 1)}) then {
			xr_sdistance = xr_sdistance - ((xr_mouseDeltaPos select 1) * 10);
			if (xr_sdistance > xr_maxDistance) then {
				xr_sdistance = xr_maxDistance;
			} else {
				if (xr_sdistance < -xr_maxDistance) then {
					xr_sdistance = -xr_maxDistance;
				};
			};
			if (xr_sdistance < -0.6) then {xr_sdistance = -0.6};
		} else {
			if ((xr_MouseButtons select 0) && {(xr_MouseButtons select 1)}) then {
				xr_szoom = xr_szoom - ((xr_mouseDeltaPos select 1) * 3);
				if (xr_szoom > 2) then {
					xr_szoom = 2;
				} else {
					if (xr_szoom < 0.05) then {
						xr_szoom = 0.05;
					};
				};
			};
		};
	};
	sleep 0.0034;
};
xr_mousecheckon = false;
__TRACE("off")