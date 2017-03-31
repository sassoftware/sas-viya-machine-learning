 
/* Create a session using workers.
   Each model trained in parallel during tuning will use this number of workers. */
cas mysess sessopts=(nworkers=4);

libname mycaslib cas casref=mysess;


/* Import the MNIST digits data - train and test */
filename traincsv url 'https://pjreddie.com/media/files/mnist_train.csv';
proc import 
  datafile=traincsv
  out=train
  dbms=csv
  replace;
  getnames=no;
run;

filename validcsv url 'https://pjreddie.com/media/files/mnist_test.csv';
proc import 
  datafile=validcsv
  out=valid
  dbms=csv
  replace;
  getnames=no;
run;


/* Merge the train and validation tables, with validvar for train/validate rolevar. */
/* Rename target column and pixel input columns. */
data mycaslib.digits;
   set train(in=_a) valid(in=_b);
   rename VAR1=label
          VAR2-VAR785=pixel1-pixel784;
   if _a then validvar=0;
   else validvar = 1;
run; 


/* create list of non-empty pixel columns for model inputs */
proc cardinality data=mycaslib.digits outcard=mycaslib.digitscard;
run;

proc sql;
   select _varname_ into :inputnames separated by ' '
   from mycaslib.digitscard
   where _mean_ > 0
   and _varname_ contains "pixel"
   ;
quit;


/* View full list of inputs */
%put inputs=&inputnames;


/* tune gradboost model to digits data */
/* NOTE:  Each train can take 20 minutes, give or take; the tuning */
/*        options are set very low here - 3 iterations of 3 evaluations each, */
/*        with a limit of 1 hour of tuning time.  The full tuning options */
/*        from SGF2017-0514 are given below. */
proc gradboost data=mycaslib.digits;
   partition rolevar=validvar(train='0' valid='1');
   input &inputnames; 
   target label / level=nom;
   autotune popsize=3 maxiter=3 maxevals=10 nparallel=3 maxtime=3600
            tuneparms=(ntrees(UB=200));
run;

/* NOTE: this is the paper version of autotune settions, which runs for just over */
/*       1 day when 32 models are evaluated in parallel using 4 workers each (128 total workers). */
/*       Replace above autotune statement as desired.  */
/*   autotune popsize=129 maxiter=20 maxevals=2560 nparallel=32 maxtime=172800*/
/*            tuneparms=(ntrees(UB=200));*/ 

/* Terminate session */
cas mysess terminate;

