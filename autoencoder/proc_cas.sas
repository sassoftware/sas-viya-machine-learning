
proc cas;

    loadactionset "neuralNet";
    run;
   
    annTrain / table={name='mnist_train_10'},
               inputs =${var2-var785},
               casOut={name='nnetmodel',replace=true}, 
               hiddens={400},
               acts={'tanh'},
               arch='mlp',
               std='midrange',
               seed=23451,
               randDist='uniform',
               scaleInit=1,               
               nloOpts={algorithm='lbfgs', optmlOpt={maxIters=500, fConv=1E-10}},
               encodeName=true;


    annScore / table={name='mnist_train_10'},
               modelTable={name='nnetmodel'},
               copyVars={'var1'},
               casOut={name='mnist_train_10_autoencoder_score', replace=true},
               listNode='output',
               encodeName=true;   
quit;

