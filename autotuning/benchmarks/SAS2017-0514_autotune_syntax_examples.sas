 
cas mysess sessopts=(nworkers=1);

/* Note: If your installation does not include the Sampsio library of examples */ 
/* you will need to define it explicitly by running the following command: */
/* libname sampsio '!sasroot/samples/samplesml'; */

libname mycaslib cas casref=mysess;


/* Load data */
data mycaslib.dmagecr;
    set sampsio.dmagecr;
run;


/* Default tuning of gradboost model - autotune statement with no options. 
   The following hyperparameters are tuned:        
   Parameter     Default   Lower Bound  Upper Bound 
   NTREES	     100       20           150         
   VARS_TO_TRY	 # inputs  1            # inputs    
   LEARNINGRATE	 0.1       0.01	        1.0         
   SAMPLINGRATE	 0.5       0.1          1.0         
   LASSO	     0.0       0.0          10.0        
   RIDGE	     0.0       0.0          10.0        */
proc gradboost data=mycaslib.dmagecr outmodel=mycaslib.mymodel;
    target good_bad / level=nominal;
    input checking duration history amount savings employed installp
        marital coapp resident property age other housing existcr job
        depends telephon foreign / level=interval;
    input purpose / level=nominal;
    autotune;
run;


/* Tuning of gradboost model with only 3 iterations of up to 5 evaluations each and */
/* average square error tuning objective. */
proc gradboost data=mycaslib.dmagecr outmodel=mycaslib.mymodel;
    target good_bad / level=nominal;
    input checking duration history amount savings employed installp
        marital coapp resident property age other housing existcr job
        depends telephon foreign / level=interval;
    input purpose / level=nominal;
    autotune popsize=5 maxiter=3 objective=ASE;
run;


/* Tuning of gradboost model with modified range for ntrees and values list */
/* for vars_to_try.  All other hyperparameters are included as listed above. */
proc gradboost data=mycaslib.dmagecr outmodel=mycaslib.mymodel;
    target good_bad / level=nominal;
    input checking duration history amount savings employed installp
        marital coapp resident property age other housing existcr job
        depends telephon foreign / level=interval;
    input purpose / level=nominal;
    autotune popsize=5 maxiter=3 objective=ASE
        tuningparameters=(
            ntrees(lb=10 ub=50 init=10) 
            vars_to_try(values=4 8 12 16 20 init=4)
        );
run;


/* Close session */
cas mysess terminate;
