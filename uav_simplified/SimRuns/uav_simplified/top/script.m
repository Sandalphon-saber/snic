cd D:\software\CppSim\CppSim\SimRuns\uav_simplified\top
cd D:\科研\工作汇报研三上\uav

res = loadsig_cppsim('test.tr0');
list =lssig(res);
plotsig(res,'xi0_s');
s = evalsig(res,'xi0_s');
sc = evalsig(res,'xi0_sc');

p1 = evalsig(res,'xi0_xi0_is_1');
p2 = evalsig(res,'xi0_xi0_is_2');
p3 = evalsig(res,'xi1_xi0_is_1');
p4 = evalsig(res,'xi1_xi0_is_2');

subplot(4,1,1);
plot(p1*0.2)
subplot(4,1,2);
plot(p2*0.2)
subplot(4,1,3);
plot(p3*0.2)
subplot(4,1,4);
plot(p4*0.2)

x1 = evalsig(res,'xi0_xi3_x_signed');
x2 = evalsig(res,'xi0_xi4_x_signed');
x3 = evalsig(res,'xi1_xi3_x_signed');
x4 = evalsig(res,'xi1_xi4_x_signed');
subplot(4,1,1);
plot(x1)
subplot(4,1,2);
plot(x2)
subplot(4,1,3);
plot(x3)
subplot(4,1,4);
plot(x4)

y11 = evalsig(res,'xi0_xi10_y');
y12 = evalsig(res,'xi0_xi11_y');
y1 = y11-y12;
z1n = evalsig(res,'xi0_xi10_zn');
z1p = evalsig(res,'xi0_xi10_zp');
z1 = z1n+z1p;
z2n = evalsig(res,'xi0_xi11_zn');
z2p = evalsig(res,'xi0_xi11_zp');
z2 = z2n+z2p;
subplot(3,1,1);
plot(y1)
subplot(3,1,2);
plot(z1)
subplot(3,1,3);
plot(z2)

y21 = evalsig(res,'xi1_xi10_y');
y22 = evalsig(res,'xi1_xi11_y');
y2 = y21-y22;
z3n = evalsig(res,'xi1_xi10_zn');
z3p = evalsig(res,'xi1_xi10_zp');
z3 = z3n+z3p;
z4n = evalsig(res,'xi1_xi11_zn');
z4p = evalsig(res,'xi1_xi11_zp');
z4 = z4n+z4p;
subplot(3,1,1);
plot(y2)
subplot(3,1,2);
plot(z3)
subplot(3,1,3);
plot(z4)