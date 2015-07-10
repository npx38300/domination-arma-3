//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_dragkeydown.sqf"
#include "xr_macros.sqf"

#include "\a3\editor_f\Data\Scripts\dikCodes.h"

if (!(_this select 2) && {!(_this select 3)} && {!(_this select 4)}) then {
	((_this select 1) in ([DIK_C] + (actionKeys "NetworkStats") + (actionKeys "Crouch") + (actionKeys "Stand")))
}