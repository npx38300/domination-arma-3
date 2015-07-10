// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_dokbmsg.sqf"
#include "x_setup.sqf"

__TRACE_1("","_this")

switch (_this select 0) do {
	case 0: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"TellAirSUAttack","SIDE"]};
	case 1: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"TellAirAttackChopperAttack","SIDE"]};
	case 2: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"TellAirLightAttackChopperAttack","SIDE"]};
	case 3: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"AllObserversDown","SIDE"]};
	case 6: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"TellNrObservers",["1","",str(_this select 1),[]],"SIDE"]};
	case 9: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"MTRadioTower","SIDE"]};
	case 12: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,'MTSightedByEnemy',"SIDE"]};
	case 15: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"CampAnnounce",["1","",str(_this select 1),[]],"SIDE"]};
	case 17: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"Dummy",["1","",_this select 1,[]],"GLOBAL"]};
	case 18: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"TellSecondaryMTM",["1","",_this select 1,[]],"SIDE"]};
	case 20: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"CounterattackStarts","SIDE"]};
	case 22: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"Captured3",["1","",_this select 1,[_this select 2]],"SIDE"]};
	case 23: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"TimeLimitSM",["1","","10",[]],"SIDE"]};
	case 25: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"TimeLimitSM",["1","","5",[]],"SIDE"]};
	case 27: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"TimeLimitSMTwoM","SIDE"]};
	case 29: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"TimeLimitSM",["1","","10",[]],"SIDE"]};
	case 31: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"TimeLimitSM",["1","","5",[]],"SIDE"]};
	case 33: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"TimeLimitSMTwoM","SIDE"]};
	case 35: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"MissionFailure","SIDE"]};
	case 37: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"MTRadioTowerDown","SIDE"]};
	case 42: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"Dummy",["1","",_this select 1,[]],"SIDE"]};
	case 43: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"TellAirDropAttack","SIDE"]};
	case 44: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,_this select 1,"SIDE"]};
	case 46: {d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"Lost",["1","",_this select 1,[_this select 2]],"SIDE"]};
};