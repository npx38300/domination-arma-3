//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_removelinebreak.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

// removes linebreaks from strings (\n or \N)
// parameters: text
// example: "My nice text\n\nHello World" call d_fnc_RemoveLineBreak;
private ["_msg_chat_a"];
_msg_chat_a = toArray _this;
for "_i" from 0 to (count _msg_chat_a - 2) do {
	if ((_msg_chat_a select _i) == 92 && {(_msg_chat_a select (_i + 1)) in [78,110]}) then {
		_msg_chat_a set [_i, 32];
		_i = _i + 1;
		_msg_chat_a set [_i, -1];
	};
};
_msg_chat_a = _msg_chat_a - [-1];
toString _msg_chat_a