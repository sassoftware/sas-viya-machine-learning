 
/* NOTE:  data must be downloaded from here: 
   http://mldata.org/repository/tags/data/IDA_Benchmark_Repository/ 
   and set paths appropriately */

/* Create 10 benchmark problem data sets */
data mycaslib.Banana;
   infile 'banana_data.csv' delimiter=',';  /* set path appropriately */
   input 
      Y
      X1
      X2 ;
run;

data mycaslib.BreastCancer;
   infile 'breast_cancer_data.csv' delimiter=',';  /* set path appropriately */
   array X{9};
   input 
      Y $
      X{*} ;
run;

data mycaslib.Diabetes;
   infile 'diabetis_data.csv' delimiter=',';  /* set path appropriately */
   array X{8};
   input 
      Y $
      X{*} ;
run;

data mycaslib.German;
   infile 'german_data.csv' delimiter=',';  /* set path appropriately */
   array X{20};
   input 
      Y $
      X{*} ;
run;

data mycaslib.Image;
   infile 'image_data.csv' delimiter=',';  /* set path appropriately */
   array X{18};
   input 
      Y $
      X{*} ;
run;

data mycaslib.Ringnorm;
   infile 'ringnorm_data.csv' delimiter=',';  /* set path appropriately */
   array X{20};
   input 
      Y $
      X{*} ;
run;

data mycaslib.Splice;
   infile 'splice_data.csv' delimiter=',';  /* set path appropriately */
   array X{60};
   input 
      Y $
      X{*} ;
run;

data mycaslib.Thyroid;
   infile 'thyroid_data.csv' delimiter=',';  /* set path appropriately */
   array X{5};
   input 
      Y $
      X{*} ;
run;

data mycaslib.Twonorm;
   infile 'twonorm_data.csv' delimiter=',';  /* set path appropriately */
   array X{20};
   input 
      Y $ 
      X{*} ;
run;

data mycaslib.Waveform;
   infile 'waveform_data.csv' delimiter=',';  /* set path appropriately */
   array X{21};
   input 
      Y $
      X{*} ;
run;
