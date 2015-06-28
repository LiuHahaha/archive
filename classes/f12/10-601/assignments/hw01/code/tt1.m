load testdata
[X,Y] = generate_data(10, 0.9);
tree = train_tree(X, Y, 3);
print_tree(tree);

trainpred = classify_with_tree(tree, X);
disp('Training Accuracy:');
mean(trainpred==Y)

testpred = classify_with_tree(tree, testX);
disp('Test Accuracy:');
mean(testpred==testY)

