%% Clean Up
close all; clear; clc;

%% Test OBJ files
fileName = "../Obj_Files/Skin Mold 1.obj";
fileName1 = "../Obj_Files/hand.obj";
out = readObj(fileName);

f = figure();
plotOBJ(f, out.v, out.f.v);



