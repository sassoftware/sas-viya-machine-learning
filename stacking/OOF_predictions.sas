/* Start a CAS session named mySession */
cas mySession; 

/* Define a CAS engine libref for CAS in-memory data tables */
libname cas sasioca; 

/* Create a SAS libref for the directory that has the data */
libname data "/folders/myfolders/"; 

/* Load OOF predictions into CAS using a DATA step */
data cas.train_oofs;
	set data.train_oofs;
	_fold_=int(ranuni(1)*5)+1;
run;

proc cas;
	/* Create an input variable list for modeling*/
	input_vars={{name='mean_gbt'},{name='mean_frst'},{name='mean_logit'},
                {name='mean_factmac'}}; 
	nFold=5;	
	
	do i=1 to nFold;
		/* Generate no_fold_i and fold_i variables */
		no_fold_i = "_fold_ ne " || (String)i;
		fold_i    = "_fold_ eq " || (String)i;
		
		/* Generate a model name to store the ith trained model */
		mymodel = "gbt_" || (String)i;
	
		/* Generate a cas table name to store the scored data */ 
		scored_data = "gbtscore_" || (String)i;

		/* Train a gradient boosting model without fold i */
		decisiontree.gbtreetrain result=r1 / 
			table={name='train_mean_oofs',  where=no_fold_i}           
			inputs=input_vars  
			target="target"
			maxbranch=2
			maxlevel=5
			leafsize=60
			ntree=56
			m=3
			binorder=1
			nbins=100
			seed=1234
			subsamplerate=0.75938
			learningRate=0.10990
			lasso=3.25403
			ridge=3.64367
			casout={name=mymodel, replace=1};
			print r1;
		
		/* Score for the left out fold i */					
		decisionTree.gbtreescore result = r2/ 
			table={name='train_mean_oofs', where=fold_i} 
			model={name=mymodel} 
			casout={name=scored_data, replace=TRUE }
			copyVars={"id", "target"}
			encodeName=true;
	end;
quit;

/* Put together OOF predictions */
data cas.gbt_stack_oofs (keep= id target p_target se);
	set cas.gbtscore_1-cas.gbtscore_5;
	se=(p_target-target)*(p_target-target);
	run;
run;

/* The mean value for variable se is the 5-fold cross validation error */
proc cas;
	summary / table={name='gbt_stack_oofs', vars={'se'}}; 
run;
/* Quit PROC CAS */
quit;
