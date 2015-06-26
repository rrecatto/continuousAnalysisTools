function receptiveFieldModel

cR2SurrR = 1/8;
cSt2SurrSt = 8;
space = -100:0.01:100;
centre = exp(-space.*space/2);
surr = -(1/cSt2SurrSt)*exp(-(space.*space/2)*(cR2SurrR)^2);
plot(space,centre+surr);
end