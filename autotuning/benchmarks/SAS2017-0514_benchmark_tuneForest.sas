 
cas mysess sessopts=(nworkers=1);

libname mycaslib cas casref=mysess;

%include "SAS2017-0514_benchmark_datasets.sas";


/* Tune a Forest to each benchmark problem */

proc cas noqueue;
    print "---BANANA / TUNE  FOREST ---";
    autotune.tuneForest result=r /
        trainOptions={
            table={name="Banana", vars={{name="X1"},{name="X2"},{name="Y"}}},
			inputs={{name="X1"},{name="X2"}},
            target="Y",
            nominals={"Y"},
            casout={name="rf_banana_model", replace=true},
            ntree=100, bootstrap=0.6, crit='GAINRATIO', 
            nbins=20, maxlevel=21, maxbranch=2, leafsize=5, 
            missing='USEINSEARCH', minuseinsearch=1, vote='PROB', 
            binorder=true, varimp=true, mergebin=true, encodeName=true, oob=true
        }
    ;
    print r;
run;
quit;


proc cas noqueue;
    print "---BREAST CANCER / TUNE  FOREST ---";
    autotune.tuneForest result=r /
        trainOptions={
            table={name='BREASTCANCER', vars={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}, {name='X9'},{name="Y"}}},
            inputs={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}, {name='X9'}}, 
            target='Y', 
            nominals={'Y'}, 
            casOut={name='rf_cancer_model', replace=true}, 
            ntree=100, bootstrap=0.6, crit='GAINRATIO', 
            nbins=20, maxlevel=21, maxbranch=2, leafsize=5, 
            missing='USEINSEARCH', minuseinsearch=1, vote='PROB', 
            binorder=true, varimp=true, mergebin=true, encodeName=true, oob=true
        }
    ;
    print r;
run;
quit;


proc cas noqueue;
    print "---DIABETES / TUNE  FOREST ---";
    autotune.tuneForest result=r /
        trainOptions={
            table={name='Diabetes', vars={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'},{name="Y"}}}, 
            inputs={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}},
            target='Y', 
            nominals={'Y'}, 
            casOut={name='rf_diabetes_model', replace=true}, 
            ntree=100, bootstrap=0.6, crit='GAINRATIO', 
            nbins=20, maxlevel=21, maxbranch=2, leafsize=5, 
            missing='USEINSEARCH', minuseinsearch=1, vote='PROB', 
            binorder=true, varimp=true, mergebin=true, encodeName=true, oob=true
        }
    ;
    print r;
run;
quit;


proc cas noqueue;
    print "---GERMAN / TUNE  FOREST ---";
    autotune.tuneForest result=r /
        trainOptions={
            table={name='German', vars={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}, {name='X9'}, {name='X10'}, 
                                               {name='X11'}, {name='X12'}, {name='X13'}, {name='X14'}, {name='X15'}, {name='X16'}, {name='X17'}, {name='X18'}, {name='X19'}, {name='X20'},{name="Y"}}}, 
            inputs={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}, {name='X9'}, {name='X10'}, 
                                               {name='X11'}, {name='X12'}, {name='X13'}, {name='X14'}, {name='X15'}, {name='X16'}, {name='X17'}, {name='X18'}, {name='X19'}, {name='X20'}},
            target='Y', 
            nominals={'Y'}, 
            casOut={name='rf_german_model', replace=true}, 
            ntree=100, bootstrap=0.6, crit='GAINRATIO', 
            nbins=20, maxlevel=21, maxbranch=2, leafsize=5, 
            missing='USEINSEARCH', minuseinsearch=1, vote='PROB', 
            binorder=true, varimp=true, mergebin=true, encodeName=true, oob=true
        }
    ;
    print r;
run;
quit;


proc cas noqueue;
    print "---IMAGE / TUNE  FOREST ---";
    autotune.tuneForest result=r /
        trainOptions={
            table={name='Image', vars={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}, {name='X9'}, {name='X10'}, 
                                              {name='X11'}, {name='X12'}, {name='X13'}, {name='X14'}, {name='X15'}, {name='X16'}, {name='X17'}, {name='X18'},{name="Y"}}}, 
            inputs={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}, {name='X9'}, {name='X10'}, 
                                              {name='X11'}, {name='X12'}, {name='X13'}, {name='X14'}, {name='X15'}, {name='X16'}, {name='X17'}, {name='X18'}},
            target='Y', 
            nominals={'Y'}, 
            casOut={name='rf_image_model', replace=true}, 
            ntree=100, bootstrap=0.6, crit='GAINRATIO', 
            nbins=20, maxlevel=21, maxbranch=2, leafsize=5, 
            missing='USEINSEARCH', minuseinsearch=1, vote='PROB', 
            binorder=true, varimp=true, mergebin=true, encodeName=true, oob=true
        }
    ;
    print r;
run;
quit;


proc cas noqueue;
    print "---RINGNORM / TUNE  FOREST ---";
    autotune.tuneForest result=r /
        trainOptions={
            table={name='Ringnorm', vars={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}, {name='X9'}, {name='X10'}, 
                                                 {name='X11'}, {name='X12'}, {name='X13'}, {name='X14'}, {name='X15'}, {name='X16'}, {name='X17'}, {name='X18'}, {name='X19'}, {name='X20'},{name="Y"}}}, 
            inputs={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}, {name='X9'}, {name='X10'}, 
                                                 {name='X11'}, {name='X12'}, {name='X13'}, {name='X14'}, {name='X15'}, {name='X16'}, {name='X17'}, {name='X18'}, {name='X19'}, {name='X20'}},
            target='Y', 
            nominals={'Y'}, 
            casOut={name='rf_ringnorm_model', replace=true}, 
            ntree=100, bootstrap=0.6, crit='GAINRATIO', 
            nbins=20, maxlevel=21, maxbranch=2, leafsize=5, 
            missing='USEINSEARCH', minuseinsearch=1, vote='PROB', 
            binorder=true, varimp=true, mergebin=true, encodeName=true, oob=true
        }
    ;
    print r;
run;
quit;


proc cas noqueue;
    print "---SPLICE / TUNE  FOREST ---";
    autotune.tuneForest result=r /
        trainOptions={
            table={name='Splice', vars={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}, {name='X9'}, {name='X10'}, 
                                               {name='X11'}, {name='X12'}, {name='X13'}, {name='X14'}, {name='X15'}, {name='X16'}, {name='X17'}, {name='X18'}, {name='X19'}, {name='X20'}, 
                                               {name='X21'}, {name='X22'}, {name='X23'}, {name='X24'}, {name='X25'}, {name='X26'}, {name='X27'}, {name='X28'}, {name='X29'}, {name='X30'}, 
                                               {name='X31'}, {name='X32'}, {name='X33'}, {name='X34'}, {name='X35'}, {name='X36'}, {name='X37'}, {name='X38'}, {name='X39'}, {name='X40'}, 
                                               {name='X41'}, {name='X42'}, {name='X43'}, {name='X44'}, {name='X45'}, {name='X46'}, {name='X47'}, {name='X48'}, {name='X49'}, {name='X50'}, 
                                               {name='X51'}, {name='X52'}, {name='X53'}, {name='X54'}, {name='X55'}, {name='X56'}, {name='X57'}, {name='X58'}, {name='X59'}, {name='X60'},{name="Y"}}}, 
            inputs={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}, {name='X9'}, {name='X10'}, 
                                               {name='X11'}, {name='X12'}, {name='X13'}, {name='X14'}, {name='X15'}, {name='X16'}, {name='X17'}, {name='X18'}, {name='X19'}, {name='X20'}, 
                                               {name='X21'}, {name='X22'}, {name='X23'}, {name='X24'}, {name='X25'}, {name='X26'}, {name='X27'}, {name='X28'}, {name='X29'}, {name='X30'}, 
                                               {name='X31'}, {name='X32'}, {name='X33'}, {name='X34'}, {name='X35'}, {name='X36'}, {name='X37'}, {name='X38'}, {name='X39'}, {name='X40'}, 
                                               {name='X41'}, {name='X42'}, {name='X43'}, {name='X44'}, {name='X45'}, {name='X46'}, {name='X47'}, {name='X48'}, {name='X49'}, {name='X50'}, 
                                               {name='X51'}, {name='X52'}, {name='X53'}, {name='X54'}, {name='X55'}, {name='X56'}, {name='X57'}, {name='X58'}, {name='X59'}, {name='X60'}},
            target='Y', 
            nominals={'Y'}, 
            casOut={name='rf_splice_model', replace=true}, 
            ntree=100, bootstrap=0.6, crit='GAINRATIO', 
            nbins=20, maxlevel=21, maxbranch=2, leafsize=5, 
            missing='USEINSEARCH', minuseinsearch=1, vote='PROB', 
            binorder=true, varimp=true, mergebin=true, encodeName=true, oob=true
        }
    ;
    print r;
run;
quit;


proc cas noqueue;
    print "---THYROID / TUNE  FOREST ---";
    autotune.tuneForest result=r /
        trainOptions={
            table={name='Thyroid', vars={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'},{name="Y"}}}, 
			inputs={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}},
            target='Y', 
            nominals={'Y'}, 
            casOut={name='rf_thyroid_model', replace=true}, 
            ntree=100, bootstrap=0.6, crit='GAINRATIO', 
            nbins=20, maxlevel=21, maxbranch=2, leafsize=5, 
            missing='USEINSEARCH', minuseinsearch=1, vote='PROB', 
            binorder=true, varimp=true, mergebin=true, encodeName=true, oob=true
        }
    ;
    print r;
run;
quit;


proc cas noqueue;
    print "---TWONORM / TUNE  FOREST ---";
    autotune.tuneForest result=r /
        trainOptions={
            table={name='Twonorm', vars={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}, {name='X9'}, {name='X10'}, 
                                                {name='X11'}, {name='X12'}, {name='X13'}, {name='X14'}, {name='X15'}, {name='X16'}, {name='X17'}, {name='X18'}, {name='X19'}, {name='X20'},{name="Y"}}}, 
			inputs={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}, {name='X9'}, {name='X10'}, 
                                                {name='X11'}, {name='X12'}, {name='X13'}, {name='X14'}, {name='X15'}, {name='X16'}, {name='X17'}, {name='X18'}, {name='X19'}, {name='X20'}},
            target='Y', 
            nominals={'Y'}, 
            casOut={name='rf_twonorm_model', replace=true}, 
            ntree=100, bootstrap=0.6, crit='GAINRATIO', 
            nbins=20, maxlevel=21, maxbranch=2, leafsize=5, 
            missing='USEINSEARCH', minuseinsearch=1, vote='PROB', 
            binorder=true, varimp=true, mergebin=true, encodeName=true, oob=true
        }
    ;
    print r;
run;
quit;


proc cas noqueue;
    print "---WAVEFORM / TUNE  FOREST ---";
    autotune.tuneForest result=r /
        trainOptions={
            table={name='Waveform', vars={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}, {name='X9'}, {name='X10'}, 
                                                 {name='X11'}, {name='X12'}, {name='X13'}, {name='X14'}, {name='X15'}, {name='X16'}, {name='X17'}, {name='X18'}, {name='X19'}, {name='X20'}, 
                                                 {name='X21'},{name="Y"}}}, 
			inputs={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}, {name='X9'}, {name='X10'}, 
                                                 {name='X11'}, {name='X12'}, {name='X13'}, {name='X14'}, {name='X15'}, {name='X16'}, {name='X17'}, {name='X18'}, {name='X19'}, {name='X20'}, 
                                                 {name='X21'}},
            target='Y', 
            nominals={'Y'}, 
            casOut={name='rf_waveform_model', replace=true}, 
            ntree=100, bootstrap=0.6, crit='GAINRATIO', 
            nbins=20, maxlevel=21, maxbranch=2, leafsize=5, 
            missing='USEINSEARCH', minuseinsearch=1, vote='PROB', 
            binorder=true, varimp=true, mergebin=true, encodeName=true, oob=true
        }
    ;
    print r;
run;
quit;


cas mysess terminate;  

