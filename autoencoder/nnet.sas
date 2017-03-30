
data mycaslib.mnist_train_10;
    set mnist_train;
    if _N_<=10;
run;

proc nnet data=mycaslib.mnist_train_10 standardize=midrange;
    input var2-var785;
    architecture MLP;
    hidden 400  / act=tanh;
    train outmodel=mycaslib.nnetModel seed=23451 ;
    score out=mycaslib.mnist_train_10_autoencoder_score copyvar=var1;
    optimization algorithm=LBFGS maxiters=500;
run;
