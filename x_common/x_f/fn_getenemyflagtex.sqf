// by Xeno
#define THIS_FILE "fn_getenemyflagtex.sqf"
#include "x_setup.sqf"

switch (d_enemy_side) do {
	case "OPFOR": {d_flag_str_opfor};
	case "BLUFOR": {d_flag_str_blufor};
	case "INDEPENDENT": {d_flag_str_independent};
};