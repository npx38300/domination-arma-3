//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_nostreaming.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

sleep 3;

while {true} do {
	waitUntil {sleep 0.71;isStreamFriendlyUIEnabled};
	cutText [localize "STR_DOM_MISSIONSTRING_1456","BLACK"];
	waitUntil {sleep 0.71;!isStreamFriendlyUIEnabled};
	cutText ["","PLAIN"];
};