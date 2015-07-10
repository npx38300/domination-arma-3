// d_init include client

// position of the player ammobox at base
d_player_ammobox_pos = [markerPos "d_player_ammobox_pos", markerDir "d_player_ammobox_pos"];
deleteMarkerLocal "d_player_ammobox_pos";

call compile preprocessFileLineNumbers "i_weapons.sqf";
