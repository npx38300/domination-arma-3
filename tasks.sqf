//#define __DEBUG__
#define THIS_FILE "x_tasks.sqf"
#include "x_setup.sqf"

__TRACE("Before !isNull player")
waitUntil {!isNull player};
waitUntil {!isNil "d_MaxNumAmmoboxes"};
__TRACE("After !isNull player")

#define __BR "<br/>"
#define __BRBR "<br/><br/>"

_briefing = format [
(localize "STR_DOM_MISSIONSTRING_23") + __BR + 
"<font face='PuristaMedium' size=52 color='#ffffff'>Domination! 3</font>" + __BRBR +
(localize "STR_DOM_MISSIONSTRING_24") + __BR + 
(localize "STR_DOM_MISSIONSTRING_25") + __BR + __BRBR +
(localize "STR_DOM_MISSIONSTRING_26") + __BRBR +
(localize "STR_DOM_MISSIONSTRING_27") + __BRBR +
(localize "STR_DOM_MISSIONSTRING_28") + __BRBR +
(localize "STR_DOM_MISSIONSTRING_29") + __BR +
(localize "STR_DOM_MISSIONSTRING_30") + __BR +
(localize "STR_DOM_MISSIONSTRING_31") + __BR +
(localize "STR_DOM_MISSIONSTRING_32") + __BR +
(localize "STR_DOM_MISSIONSTRING_33") + __BRBR +
(localize "STR_DOM_MISSIONSTRING_34") + __BR +
(localize "STR_DOM_MISSIONSTRING_35") + __BR +
(localize "STR_DOM_MISSIONSTRING_36") + __BR +
(localize "STR_DOM_MISSIONSTRING_37") + __BRBR
,d_MaxNumAmmoboxes];

_briefing = _briefing +
(localize "STR_DOM_MISSIONSTRING_40") + __BRBR +
(localize "STR_DOM_MISSIONSTRING_41") + __BR +
(localize "STR_DOM_MISSIONSTRING_42") + __BRBR +
(localize "STR_DOM_MISSIONSTRING_43") + __BRBR +
(localize "STR_DOM_MISSIONSTRING_44") + __BR +
(localize "STR_DOM_MISSIONSTRING_46") + __BRBR +
(localize "STR_DOM_MISSIONSTRING_47") + __BR +
(localize "STR_DOM_MISSIONSTRING_48") + __BRBR +
(localize "STR_DOM_MISSIONSTRING_49") + __BRBR +
(localize "STR_DOM_MISSIONSTRING_51") + __BR +
(localize "STR_DOM_MISSIONSTRING_52") + __BR +
(localize "STR_DOM_MISSIONSTRING_54") + __BRBR +
(localize "STR_DOM_MISSIONSTRING_55") + __BR +
(localize "STR_DOM_MISSIONSTRING_56") + __BRBR +
(localize "STR_DOM_MISSIONSTRING_57") + __BRBR +
(localize "STR_DOM_MISSIONSTRING_56a") + __BRBR +
(localize "STR_DOM_MISSIONSTRING_58") + __BRBR +
(localize "STR_DOM_MISSIONSTRING_61");

player createDiaryRecord ["Diary", ["Briefing",_briefing]];

waitUntil {!isNil "d_current_target_index"};

d_task1 = player createSimpleTask ["obj1"];
d_task1 setSimpleTaskDescription [localize "STR_DOM_MISSIONSTRING_62", localize "STR_DOM_MISSIONSTRING_62", localize "STR_DOM_MISSIONSTRING_62"];
if (d_current_target_index == -1) then {
	d_task1 settaskstate "Created";
} else {
	d_task1 settaskstate "Succeeded";
};


