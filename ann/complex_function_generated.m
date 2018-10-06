function [Y,Xf,Af] = complex_function_generated(X,~,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 22-Sep-2018 17:52:14.
%
% [Y] = myNeuralNetworkFunction(X,~,~) takes these arguments:
%
%   X = 1xTS cell, 1 inputs over TS timesteps
%   Each X{1,ts} = Qx4 matrix, input #1 at timestep ts.
%
% and returns:
%   Y = 1xTS cell of 1 outputs over TS timesteps.
%   Each Y{1,ts} = Qx1 matrix, output #1 at timestep ts.
%
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = [0;0;0;0];
x1_step1.gain = [2;2;2;2];
x1_step1.ymin = -1;

% Layer 1
b1 = [2.7271601509209211;-2.0653080479876316;-1.2998455955827324;1.7665587115850077;-0.69464718188321928;0.82282630117239453;1.6035560022120179;1.5684581716896169;-1.8854915167774797;-2.6364527593549156];
IW1_1 = [-1.1185332054338606 0.43824973233286402 -0.88484669276290961 -1.623046307446077;0.12776067654762155 -0.094209311258586101 1.8120668624073191 1.5947170877192858;0.97059711760794198 1.3745969021513078 -1.2865571095624104 1.368773455794934;-1.6150607997314808 0.34985522016873055 2.1087296103925834 -0.11725446630989489;1.4551844162383767 -0.25954297688776595 2.0015772230903508 0.21994150743267954;0.65754645628297725 -2.0018783384609851 -0.069515982445262275 -1.2288084601281166;1.2313481837415587 -1.2800319268592919 -1.536254395449719 -0.57402549744882081;0.78990204037038936 1.4859577148829477 -1.075423639293809 1.2600405722939616;-2.1717205383650247 0.60824888565093216 1.1666932724079144 0.80217216864908047;-0.66689735841632491 1.3127740712169886 1.673933941123692 -1.1822304977754308];

% Layer 2
b2 = -0.46847668010034366;
LW2_1 = [0.69282241907820763 -0.58033816312672415 0.084093059205280249 -0.91022378501496082 1.1435241344059881 0.037320374809543956 -1.1838369125868744 0.14797552033840311 -0.91090697408128463 -0.4892061635550819];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = 2;
y1_step1.xoffset = 0;

% ===== SIMULATION ========

% Format Input Arguments
isCellX = iscell(X);
if ~isCellX
    X = {X};
end

% Dimensions
TS = size(X,2); % timesteps
if ~isempty(X)
    Q = size(X{1},1); % samples/series
else
    Q = 0;
end

% Allocate Outputs
Y = cell(1,TS);

% Time loop
for ts=1:TS
    
    % Input 1
    X{1,ts} = X{1,ts}';
    Xp1 = mapminmax_apply(X{1,ts},x1_step1);
    
    % Layer 1
    a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*Xp1);
    
    % Layer 2
    a2 = repmat(b2,1,Q) + LW2_1*a1;
    
    % Output 1
    Y{1,ts} = mapminmax_reverse(a2,y1_step1);
    Y{1,ts} = Y{1,ts}';
end

% Final Delay States
Xf = cell(1,0);
Af = cell(2,0);

% Format Output Arguments
if ~isCellX
    Y = cell2mat(Y);
end
end

% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings)
y = bsxfun(@minus,x,settings.xoffset);
y = bsxfun(@times,y,settings.gain);
y = bsxfun(@plus,y,settings.ymin);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n,~)
a = 2 ./ (1 + exp(-2*n)) - 1;
end

% Map Minimum and Maximum Output Reverse-Processing Function
function x = mapminmax_reverse(y,settings)
x = bsxfun(@minus,y,settings.ymin);
x = bsxfun(@rdivide,x,settings.gain);
x = bsxfun(@plus,x,settings.xoffset);
end
