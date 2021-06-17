/* the Titanic data set is available at 
https://raw.githubusercontent.com/amueller/scipy-2017-sklearn/091d371/notebooks/datasets/titanic3.csv
*/
proc casutil;
        load file="titanic3.csv" casout="titanic3" ;	*load the data;
run;

%let in_numeric_features = %str('age' 'fare');
%let in_categorical_features = %str('embarked' 'sex' 'pclass');
%let target = 'survived';
%let in_all_features = %str(&in_numeric_features  &in_categorical_features &target);


/*partition the data to train and test with a partition indicator*/
proc partition data=mycas.titanic3 partind samppct=20 seed=17;
               output out=mycas.titanic copyvars=(age fare embarked sex pclass survived);
run;

proc cas;
  loadactionset "dataPreprocess"; run;

  /*call the transform action for the preprocessing on the train data*/
  action dataPreprocess.transform /
    table={name='titanic', where='_PartInd_=0'},
    pipelines = {
                  {inputs = {&in_numeric_features},
                   impute={method='median'},		/*impute the numeric features by median*/
                   function={method='standardize', args={location='mean', scale='std'}} 	/*standardize*/
                  },
                  {inputs = {&in_categorical_features},
                   impute={method='mode'},		/*impute the categorical features by mode*/
                   cattrans={method='onehot'}		/*encode with the onehot method*/
                  }
                },
    outVarsNameGlobalPrefix = 't',		/*common prefix for the transformed variables*/
    saveState = {name='transstore', replace=True};	/*save the state to an analytic store*/
run;

/*call scoring to get the transformed train data*/
/*since proc astore does not support a where clause, we need to physically save a copy of the train data*/
data mycas.titanic_train;
    set mycas.titanic(where=(_PartInd_=0));
run;

proc astore;
    score rstore=mycas.transstore data=mycas.titanic_train copyvars=(survived) out=mycas.trans_out;
run;

/*call proc logselect to build a logistic model and save to an analytic store*/
proc logselect data=mycas.trans_out;
  class t_embarked t_sex t_pclass;
  model survived = t_embarked t_sex t_pclass t_age t_fare;
  store out=mycas.logstore;
run;

*score the test data with multiple analytic stores;
/*since proc astore does not support a where clause, we need to physically save a copy of the test data*/
data mycas.titanic_test;
    set mycas.titanic(where=(_PartInd_=1));
run;

proc astore;
    score rstore=mycas.logstore rstore=mycas.transstore data=mycas.titanic_test out=mycas.test_out;
run;

