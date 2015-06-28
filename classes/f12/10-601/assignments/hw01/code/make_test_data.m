clear
testTheta = 0.9;
testN = 5000;
[testX, testY] = generate_data(testN, testTheta, 1111);
disp('created new test data.');
save testdata
