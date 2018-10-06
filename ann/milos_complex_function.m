% My complex function is: (x1*x2 + (x3*x4)^)*x1

N = 4;
temp = 0;
length = 2^N;

decimal = 0 : length-1;

binary = de2bi(decimal);

y = and(binary(:,1), ...
                or(...
                    and(binary(:,1), binary(:,2)), ...
                    not(and(binary(:,3), binary(:,4)))));


Y = double(y);

%Make bigger dataset
input = vertcat(binary, binary, binary, binary);
target = vertcat(Y, Y, Y, Y);


hiddenLayerSize = 1;
net = fitnet(hiddenLayerSize);

net.divideParam.trainRatio = 70/100;
net.divideParam.testRatio = 15/100;
net.divideParam.valRatio = 15/100;

[net, tr] = train(net, input.', target.');
