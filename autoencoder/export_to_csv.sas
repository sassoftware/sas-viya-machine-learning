/*export score dataset to csv file*/
proc export data=mycaslib.mnist_train_10_autoencoder_score
    outfile='c:\Python27\mnist_train_10_autoencoder_score.csv'
    dbms=csv
    replace;
    putnames=no;
run;