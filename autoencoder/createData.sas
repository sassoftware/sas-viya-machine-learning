filename decomp "~/data/train-images.idx3-ubyte";
filename decomp2 "~/data/train-labels.idx1-ubyte";

data train_images;
   infile decomp recfm=n;
   input var PIB1.;
   array vars var2-var785;
   retain vars;
   if _n_>16 then do;
      index=mod(_n_-17,784)+1;
      vars[index]=var;
      if index=784 then output;
  end;
  drop var index;
run;

data train_labels;
   infile decomp2 recfm=n;
   input var1 PIB1.;
   if _n_>8;
run;

data mnist_train; 
   merge train_labels train_images;
run;



proc export data=mnist_train(obs=10)
   outfile="~/aa_hpnenural_nn/test_vb007/autoencoder_mnist/tip/mnist_train_10.csv"
   dbms=csv
   replace;
   putnames=no;
run;



libname test "~/aa_hpnenural_nn/test_vb007/autoencoder_mnist/tip";

data test.mnist_train;
set mnist_train;
run;