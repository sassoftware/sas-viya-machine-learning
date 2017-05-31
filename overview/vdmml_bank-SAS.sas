/*****************************************************************************/
/* This demo continues the modelling process that we began within VDMML.     */
/*                                                                           */
/* In the first stage of this process, we performed the following steps:     */
/* - our training data was loaded into memory and made available for         */
/*   each of our applications to access                                      */
/* - this data was partitioned into Training, Validation and Test partitions,*/
/* - the associated partition indicator column was added to the table,       */
/* - transformations were performed on the original columns, and             */
/* - basic, exploratory models were run                                      */
/*                                                                           */
/* This program will extend on the work done in VDMML by....                 */
/*                                                                           */
/*****************************************************************************/
%let caslib=public;
libname mycaslib cas caslib=&caslib;


/****************************************************************************/
/* Setup and initialize for later use in the program                        */
/****************************************************************************/
/* Specify a libref for local data sets */
libname locallib '~/public/SGF2017';

/* Specify a folder path to write the temporary output files */
%let outdir = ~/public/SGF2017;

/* Specify the data set names */
%let indata           = bank_part;
%let localdata        = locallib.bank_part;

%let train_data       = mycaslib.&indata; 
%let prepped_data     = mycaslib.bank_prepped;

/* Specify the data set inputs and target */
%let class_inputs    = cat_input1 cat_input2 demog_ho demog_genf;
%let interval_inputs = IM_demog_age IM_demog_homeval IM_demog_inc demog_pr log_rfm1 rfm2 log_im_rfm3 rfm4-rfm12; 
%let target          = b_tgt;

%if not %sysfunc(exist(&train_data)) %then %do;
  proc casutil;
    load data=&localdata OUTCASLIB="&caslib" casout="&indata" promote;
  run;
%end;


/************************************************************************/
/* Explore the data and plot missing values                             */
/************************************************************************/
proc cardinality data=&train_data. outcard=mycaslib.data_card;
run;

proc print data=mycaslib.data_card(where=(_nmiss_>0));
  title "Data Summary";
run;

data data_missing;
  set mycaslib.data_card (where=(_nmiss_>0 AND (_VARNAME_ ^ in ("cnt_tgt", "int_tgt")) ) keep=_varname_ _nmiss_ _nobs_);
  _percentmiss_ = (_nmiss_/_nobs_)*100;
  label _percentmiss_ = 'Percent Missing';
run;

proc sgplot data=data_missing;
  title "Percentage of Missing Values";
  vbar _varname_ / response=_percentmiss_ datalabel categoryorder=respdesc;
run;
title;


/************************************************************************/
/* Impute missing values in variables with _percentmiss_ > 0            */
/************************************************************************/
proc varimpute data=&train_data.;
  input demog_age demog_homeval demog_inc rfm3  /ctech=mean;
  output out=mycaslib.bank_prepped_temp copyvars=(_ALL_);
  code file="&outdir./impute_score.sas";
run;

/* Cleanup bank_prepped if it already exists */
proc casutil;
   droptable casdata='bank_prepped' incaslib="&caslib" quiet;
run;


/************************************************************************/
/* Apply a log transformation to a couple of the continuous variables   */
/************************************************************************/
data &prepped_data (promote=YES);
  set mycaslib.bank_prepped_temp ;
  
  if (IM_RFM3 > 0) then LOG_IM_RFM3 = LOG(IM_RFM3);
  else LOG_IM_RFM3 = .;
  
  if (RFM1 > 0) then LOG_RFM1 = LOG(RFM1);
  else LOG_RFM1 = .;  
run;


/************************************************************************/
/* DECISION TREE predictive model                                       */
/************************************************************************/
proc treesplit data=&prepped_data.;
  input &interval_inputs. / level=interval;
  input &class_inputs. / level=nominal;
  target &target. / level=nominal;
  partition rolevar=_partind_(train='1' validate='0');
  grow entropy;
  prune c45;
  code file="&outdir./treeselect_score.sas";
run;


/************************************************************************/
/* Score the data using the generated tree model score code             */
/************************************************************************/
data mycaslib._scored_tree;
  set &prepped_data.;
  %include "&outdir./treeselect_score.sas";
run;


/************************************************************************/
/* Autotune ntrees, vars_to_try and inbagfraction in Random Forest      */
/************************************************************************/
proc casutil;
   droptable casdata="forest_model" incaslib="&caslib" quiet;
run;

proc forest data=&prepped_data. intervalbins=20 minleafsize=5 seed=12345 outmodel=mycaslib.forest_model;
  input &interval_inputs. / level = interval;
  input &class_inputs. / level = nominal;
  target &target. / level=nominal;
  grow GAIN;
  partition rolevar=_partind_(train='1' validate='0');  
  autotune maxiter=2 popsize=2 useparameters=custom
           tuneparms=(ntrees(init=50 lb=20 ub=100)
                      vars_to_try(init=5 lb=5 ub=20)
                      inbagfraction(init=0.6 lb=0.2 ub=0.9));
  ods output TunerResults=rf_tuner_results;           
run;


/************************************************************************/
/* Score the data using the generated Forest model                      */
/************************************************************************/
proc forest data=&prepped_data. inmodel=mycaslib.forest_model noprint;
  output out=mycaslib._scored_FOREST copyvars=(b_tgt _partind_ account);
run;

/* Promote the forest_model table */
proc casutil outcaslib="&caslib" incaslib="&caslib";                         
   promote casdata="forest_model";
quit;


/************************************************************************/
/* SUPPORT VECTOR MACHINE predictive model                              */
/************************************************************************/
proc casutil;
   droptable casdata="svm_astore_model" incaslib="&caslib" quiet;
run;

proc svmachine data=&prepped_data. (where=(_partind_=1));
  kernel polynom / deg=2;
  target &target. ;
  input &interval_inputs. / level=interval;
  input &class_inputs. / level=nominal;
  savestate rstore=mycaslib.svm_astore_model;
  ods exclude IterHistory;
run;

/************************************************************************/
/* Score data using ASTORE code generated for the SVM model             */
/************************************************************************/
proc astore;
  score data=&prepped_data. out=mycaslib._scored_SVM 
        rstore=mycaslib.svm_astore_model copyvars=(b_tgt _partind_ account);
run;

/* Promote the svm_astore_model table */
proc casutil outcaslib="&caslib" incaslib="&caslib";                         
   promote casdata="svm_astore_model";
quit;


/************************************************************************/
/* Pull in GBM model created in VA using partitioned data, assess and   */ 
/* compare against new models built on imputed/transformed variables    */
/************************************************************************/
proc casutil;
    load casdata="Gradient_Boosting_VA.sashdat" incaslib="models" casout="va_gbm_astore" 
    outcaslib=&caslib replace;
run;


data mycaslib.bank_part_post;
  set &train_data.;
               
  /*---------------------------------------------------------
     Before you can perform model scoring with PROC ASTORE, 
     you must run the DS1 code that follows to create a 
     temporary table. Your Analytic Store (ASTORE) binary 
     table "Gradient_Boosting_VA" is located in library 
     Models. After running the DS1 code below, use 
     the temporary table as input to PROC ASTORE for model 
     scoring. Please refer to PROC ASTORE documentation for
     additional details.
     -------------------------------------------------------*/
  _va_calculated_54_1=round('b_tgt'n,1.0);
  _va_calculated_54_2=round('demog_genf'n,1.0);
  _va_calculated_54_3=round('demog_ho'n,1.0);
  _va_calculated_54_4=round('_PartInd_'n,1.0);
run;

proc astore;
    score data=mycaslib.bank_part_post out=mycaslib._scored_vagbm
          rstore=mycaslib.va_gbm_astore copyvars=(b_tgt _partind_ account) ;
run;


/************************************************************************/
/* Assess                                                               */
/************************************************************************/
%macro assess_model(prefix=, var_evt=, var_nevt=);
  proc assess data=mycaslib._scored_&prefix.;
    input &var_evt.;
    target &target. / level=nominal event='1';
    fitstat pvar=&var_nevt. / pevent='0';
    by _partind_;
  
    ods output
      fitstat=&prefix._fitstat 
      rocinfo=&prefix._rocinfo 
      liftinfo=&prefix._liftinfo;
run;
%mend assess_model;

ods exclude all;
%assess_model(prefix=TREE, var_evt=p_b_tgt1, var_nevt=p_b_tgt0);
%assess_model(prefix=FOREST, var_evt=p_b_tgt1, var_nevt=p_b_tgt0);
%assess_model(prefix=SVM, var_evt=p_b_tgt1, var_nevt=p_b_tgt0);
%assess_model(prefix=VAGBM, var_evt=P__va_calculated_54_11, var_nevt=P__va_calculated_54_10);
ods exclude none;


/************************************************************************/
/* ROC and Lift Charts using validation data                            */
/************************************************************************/
ods graphics on;

data all_rocinfo;
  set TREE_rocinfo(keep=sensitivity fpr c _partind_ in=t where=(_partind_=0))
      FOREST_rocinfo(keep=sensitivity fpr c _partind_ in=f where=(_partind_=0))
      SVM_rocinfo(keep=sensitivity fpr c _partind_ in=s where=(_partind_=0))
      VAGBM_rocinfo(keep=sensitivity fpr c _partind_ in=v where=(_partind_=0));
      
  length model $ 20;
  select;
    when (s) model='SVM';
    when (f) model='Forest';
    when (t) model='DecisionTree';
    when (v) model='VAGradientBoosting';
  end;
run;

data all_liftinfo;
  set SVM_liftinfo(keep=depth lift cumlift _partind_ in=s where=(_partind_=0))
      FOREST_liftinfo(keep=depth lift cumlift _partind_ in=f where=(_partind_=0))
      TREE_liftinfo(keep=depth lift cumlift _partind_ in=t where=(_partind_=0))
      VAGBM_liftinfo(keep=depth lift cumlift _partind_ in=v where=(_partind_=0));
      
  length model $ 20;
  select;
    when (s) model='SVM';
    when (f) model='Forest';
    when (t) model='DecisionTree';
    when (v) model='VAGradientBoosting';
  end;
run;

data all_fitstatinfo;
  set SVM_fitstat(keep=MCE _partind_ in=s where=(_partind_=0))
      FOREST_fitstat(keep=MCE _partind_ in=f where=(_partind_=0))
      TREE_fitstat(keep=MCE _partind_ in=t where=(_partind_=0))
      VAGBM_fitstat(keep=MCE _partind_ in=v where=(_partind_=0));
      
  length model $ 20;
  select;
    when (s) model='SVM';
    when (f) model='Forest';
    when (t) model='DecisionTree';
    when (v) model='VAGradientBoosting';
  end;
run;

/* Print MCE (Misclassification) */
title "Misclassification (using validation data) ";
proc sql;
  select distinct model, mce from all_fitstatinfo order by mce ;
quit;

/* Draw ROC charts */         
proc sgplot data=all_rocinfo aspect=1;
  title "ROC Curve (using validation data)";
  xaxis values=(0 to 1 by 0.25) grid offsetmin=.05 offsetmax=.05; 
  yaxis values=(0 to 1 by 0.25) grid offsetmin=.05 offsetmax=.05;
  lineparm x=0 y=0 slope=1 / transparency=.7;
  series x=fpr y=sensitivity / group=model;
run;

/* Draw lift charts */         
proc sgplot data=all_liftinfo; 
  title "Lift Chart (using validation data)";
  yaxis label=' ' grid;
  series x=depth y=lift / group=model markers markerattrs=(symbol=circlefilled);
run;

title;
ods graphics off;

