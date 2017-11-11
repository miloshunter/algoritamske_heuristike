function y = f2_bnlp(in)
x1 = in(1);
x2 = in(2);
x3 = in(3);
x4 = in(4);
x5 = in(5);
x6 = in(6);
x7 = in(7);
x8 = in(8);



y = 1 - (1 - f1_bnlp(in([1:6])))*(2-x4+x6-x7)*(1-x1+x3+x5)*(3-x6-x7-x8)