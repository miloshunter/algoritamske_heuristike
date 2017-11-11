function y = f3_bnlp(in)
x1 = in(1);
x2 = in(2);
x3 = in(3);
x4 = in(4);
x5 = in(5);
x6 = in(6);
x7 = in(7);
x8 = in(8);
x9 = in(9);
x10 = in(10);
x11 = in(11);



y = 1 - (1 - f2_bnlp(in([1:8])))*(1-x4+x9+x10)*(2-x4-x6+x11)*(3-x9-x10-x11)