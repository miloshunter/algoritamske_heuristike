% In this example, training of the artificial neural network will be done
% Dataset is generated (and copied few times so it can be split)


N = 4;  % Number input neurons

% Generating DATASET for the training
temp = 0;
length = 2^N;
decimal = [0 : length-1];
binary = de2bi(decimal);


for i = 1:length
    for j = 1:N
        temp = temp + binary(i, j);
    end
    if mod(temp, 2)
        parity4 (i, 1) = 1;
    else
        parity4 (i, 1) = 0;
    end
    temp = 0;
end

% Copy dataset few times so it can be split for validating and testing
input = vertcat(binary, binary, binary, binary);
target = vertcat(parity4, parity4, parity4, parity4);

% Define the number of neurons in hidden layer
hiddenLayerSize = 4;
net = fitnet(hiddenLayerSize);

net.divideParam.trainRatio = 70/100;
net.divideParam.testRatio = 15/100;
net.divideParam.valRatio = 15/100;

[net, tr] = train(net, input.', target.');



