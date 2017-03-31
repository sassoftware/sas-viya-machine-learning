 
cas mysess sessopts=(nworkers=1);

libname mycaslib cas casref=mysess;

%include "SAS2017-0514_benchmark_datasets.sas";


/* Tune a Support Vector Machine model to each benchmark problem */

proc cas noqueue;
    print "---BANANA / TUNE SUPPORT VECTOR MACHINE ---";
    autotune.tuneSvm result=r /
        trainOptions={
            table={name="Banana", vars={{name="X1"},{name="X2"},{name="Y"}}},
			inputs={{name="X1"},{name="X2"}},
            target="Y",
            nominals={"Y"},
            /*output={casOut={name="svm_banana_model", replace=true}},*/
			saveState={name='svm_banana_model', replace=true}
        }
    ;
    print r;
run;
quit;


proc cas noqueue;
    print "---BREAST CANCER / TUNE SUPPORT VECTOR MACHINE ---";
    autotune.tuneSvm result=r /
        trainOptions={
            table={name='BREASTCANCER', vars={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}, {name='X9'},{name="Y"}}},
            inputs={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}, {name='X9'}}, 
            target='Y', 
            nominals={'Y'}, 
            saveState={name='svm_cancer_model', replace=true} 
        }
    ;
    print r;
run;
quit;


proc cas noqueue;
    print "---DIABETES / TUNE SUPPORT VECTOR MACHINE ---";
    autotune.tuneSvm result=r /
        trainOptions={
            table={name='Diabetes', vars={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'},{name="Y"}}}, 
            inputs={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}},
            target='Y', 
            nominals={'Y'}, 
            saveState={name='svm_diabetes_model', replace=true} 
        }
    ;
    print r;
run;
quit;


proc cas noqueue;
    print "---GERMAN / TUNE SUPPORT VECTOR MACHINE ---";
    autotune.tuneSvm result=r /
        trainOptions={
            table={name='German', vars={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}, {name='X9'}, {name='X10'}, 
                                               {name='X11'}, {name='X12'}, {name='X13'}, {name='X14'}, {name='X15'}, {name='X16'}, {name='X17'}, {name='X18'}, {name='X19'}, {name='X20'},{name="Y"}}}, 
            inputs={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}, {name='X9'}, {name='X10'}, 
                                               {name='X11'}, {name='X12'}, {name='X13'}, {name='X14'}, {name='X15'}, {name='X16'}, {name='X17'}, {name='X18'}, {name='X19'}, {name='X20'}},
            target='Y', 
            nominals={'Y'}, 
            saveState={name='svm_german_model', replace=true} 
        }
    ;
    print r;
run;
quit;


proc cas noqueue;
    print "---IMAGE / TUNE SUPPORT VECTOR MACHINE ---";
    autotune.tuneSvm result=r /
        trainOptions={
            table={name='Image', vars={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}, {name='X9'}, {name='X10'}, 
                                              {name='X11'}, {name='X12'}, {name='X13'}, {name='X14'}, {name='X15'}, {name='X16'}, {name='X17'}, {name='X18'},{name="Y"}}}, 
            inputs={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}, {name='X9'}, {name='X10'}, 
                                              {name='X11'}, {name='X12'}, {name='X13'}, {name='X14'}, {name='X15'}, {name='X16'}, {name='X17'}, {name='X18'}},
            target='Y', 
            nominals={'Y'}, 
            saveState={name='svm_image_model', replace=true} 
        }
    ;
    print r;
run;
quit;


proc cas noqueue;
    print "---RINGNORM / TUNE SUPPORT VECTOR MACHINE ---";
    autotune.tuneSvm result=r /
        trainOptions={
            table={name='Ringnorm', vars={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}, {name='X9'}, {name='X10'}, 
                                                 {name='X11'}, {name='X12'}, {name='X13'}, {name='X14'}, {name='X15'}, {name='X16'}, {name='X17'}, {name='X18'}, {name='X19'}, {name='X20'},{name="Y"}}}, 
            inputs={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}, {name='X9'}, {name='X10'}, 
                                                 {name='X11'}, {name='X12'}, {name='X13'}, {name='X14'}, {name='X15'}, {name='X16'}, {name='X17'}, {name='X18'}, {name='X19'}, {name='X20'}},
            target='Y', 
            nominals={'Y'}, 
            saveState={name='svm_ringnorm_model', replace=true} 
        }
    ;
    print r;
run;
quit;


proc cas noqueue;
    print "---SPLICE / TUNE SUPPORT VECTOR MACHINE ---";
    autotune.tuneSvm result=r /
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
            saveState={name='svm_splice_model', replace=true} 
        }
    ;
    print r;
run;
quit;


proc cas noqueue;
    print "---THYROID / TUNE SUPPORT VECTOR MACHINE ---";
    autotune.tuneSvm result=r /
        trainOptions={
            table={name='Thyroid', vars={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'},{name="Y"}}}, 
			inputs={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}},
            target='Y', 
            nominals={'Y'}, 
            saveState={name='svm_thyroid_model', replace=true} 
        }
    ;
    print r;
run;
quit;


proc cas noqueue;
    print "---TWONORM / TUNE SUPPORT VECTOR MACHINE ---";
    autotune.tuneSvm result=r /
        trainOptions={
            table={name='Twonorm', vars={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}, {name='X9'}, {name='X10'}, 
                                                {name='X11'}, {name='X12'}, {name='X13'}, {name='X14'}, {name='X15'}, {name='X16'}, {name='X17'}, {name='X18'}, {name='X19'}, {name='X20'},{name="Y"}}}, 
			inputs={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}, {name='X9'}, {name='X10'}, 
                                                {name='X11'}, {name='X12'}, {name='X13'}, {name='X14'}, {name='X15'}, {name='X16'}, {name='X17'}, {name='X18'}, {name='X19'}, {name='X20'}},
            target='Y', 
            nominals={'Y'}, 
            saveState={name='svm_twonorm_model', replace=true} 
        }
    ;
    print r;
run;
quit;


proc cas noqueue;
    print "---WAVEFORM / TUNE SUPPORT VECTOR MACHINE ---";
    autotune.tuneSvm result=r /
        trainOptions={
            table={name='Waveform', vars={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}, {name='X9'}, {name='X10'}, 
                                                 {name='X11'}, {name='X12'}, {name='X13'}, {name='X14'}, {name='X15'}, {name='X16'}, {name='X17'}, {name='X18'}, {name='X19'}, {name='X20'}, 
                                                 {name='X21'},{name="Y"}}}, 
			inputs={{name='X1'}, {name='X2'}, {name='X3'}, {name='X4'}, {name='X5'}, {name='X6'}, {name='X7'}, {name='X8'}, {name='X9'}, {name='X10'}, 
                                                 {name='X11'}, {name='X12'}, {name='X13'}, {name='X14'}, {name='X15'}, {name='X16'}, {name='X17'}, {name='X18'}, {name='X19'}, {name='X20'}, 
                                                 {name='X21'}},
            target='Y', 
            nominals={'Y'}, 
            saveState={name='svm_waveform_model', replace=true} 
        }
    ;
    print r;
run;
quit;


cas mysess terminate;  
