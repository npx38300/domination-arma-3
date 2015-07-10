//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_hintchatmsg.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

// displays a hint and a chat message, \n get removed for the chat text
// parameters: text (with \n for hints), type of chat ("HQ","SIDE","GLOBAL" or "GROUP")
// example: ["My nice text\n\nHello World", "HQ"] call d_fnc_HintChatMsg;
private ["_msg", "_type_chat", "_msg_chat"];
_msg = [_this, 0] call BIS_fnc_param;
_type_chat = [_this, 1] call BIS_fnc_param;
hintSilent _msg;
_msg_chat = _msg call d_fnc_RemoveLineBreak;

switch (toUpper _type_chat) do {
	case "HQ": {[playerSide, "HQ"] sideChat _msg_chat};
	case "SIDE": {player sideChat _msg_chat};
	case "GLOBAL": {systemChat _msg_chat};
	case "GROUP": {player groupChat _msg_chat};
};