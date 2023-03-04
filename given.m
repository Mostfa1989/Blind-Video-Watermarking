function [ R Q ] = given( H )
%% save H in Q
    R = H;
    I = eye(2);
%% look the first subdiagonal
    Q = eye(length(R));
for i = 2:length(R)
    if R (i, i-1) ~= 0
%% Compute r, c and s
    r = sqrt (R(i-1, i-1)^2 + R(i, i-1)^2);
    c = R(i-1, i-1)/r;
    s = R(i, i-1)/r;
        
%% create temporal Givens matrix (2x2)
    tempGivens(1,1) = c;
    tempGivens(2,1) = -s;
    tempGivens(1,2) = s;
    tempGivens(2,2) = c;
%% multiply the affected lines
    R(i-1:i, :) = tempGivens * R(i-1:i, :);
    R(i, i-1) = 0;
%% build R
    newEye = eye(length(R));
    newEye(i-1:i, i-1:i) = tempGivens;
    newEye = inv(newEye);
    Q = Q*newEye;
    end
    
end