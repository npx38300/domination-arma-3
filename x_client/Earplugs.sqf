// Created by: Dirty Haz

if (soundVolume > 0.6) then {
0.4 fadeSound 0.2;
titleText ["Earplugs in.", "PLAIN DOWN"];
} else {
if (soundVolume < 0.6) then {
0.4 fadeSound 1.0;
titleText ["Earplugs out.", "PLAIN DOWN"];
};
};