//#define __DEBUG__
#define THIS_FILE "fn_postinit.sqf"
#include "x_setup.sqf"
diag_log [diag_frameno, diag_ticktime, time, "Executing Dom fn_postinit.sqf"];

// NOTE
// DO NOT USE POSTINIT UNTIL THE FOLLOWING IS ISSUE IS FIXED!!!!
// http://feedback.arma3.com/view.php?id=14741

// MOTE 2
// funny enough as of 1.12 it seems postinit is always running after init now.
// but when it comes to BI nobody really knows if it will stay this way because of their chaotic developement

/*
Initialization Order
When mission is starting, its components are initialized in the following order:
1. Functions with recompile param set to 1 are recompiled
2. Functions with preInit param set to 1 are called
3. Object Init Event Handlers are called
4. Object initialization fields are called
5. init.sqs is executed in singleplayer
6. init.sqf is executed in singleplayer
7. Persistent multiplayer functions are called (client only)
8. Modules are initialized
9. initServer.sqf is executed (server only)
10. initPlayerLocal.sqf is executed
11. initPlayerServer.sqf is executed (server only)
12. Functions with postInit param set to 1 are called
13. BIS_fnc_init" variable is set to true
14. init.sqs is executed in multiplayer
15. init.sqf is executed in multiplayer
*/

diag_log [diag_frameno, diag_ticktime, time, "Dom fn_postinit.sqf processed"];