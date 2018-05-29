/*runs in a Model Studio code node after a supervised learning node*/


%macro selectImpVars( 

        DS=,
	inputs=,
	outDS=

);
					
	/*metadata prep*/
	data target predict;
		set &dm_metadata;

		if strip(ROLE='TARGET') then
			output target;

		if strip(ROLE='PREDICT') then
			output predict;
	run;

        %global targetVar;

	data _null_;
		set target;
		call symput('targetVar',strip(name));
	run;

	/*keep posterior prob var for target event. */
	%put dm_predicted_var %dm_predicted_var;
	%put dm_predicted_vvnvar &dm_predicted_vvnvar; 

	%if &dm_dec_level NE INTERVAL %then
		%do;
			data predict;
				set predict;
				if upcase(name) = "%sysfunc(upcase(&dm_predicted_vvnvar))";
			run;
               %end; 



        %global yHatVar;

	data _null_;
		set predict;
		call symput('yhatVar',strip(name));
	run;

	%put yHatVar &yHatVar.;


        
	   
    %global nKeptInputs;
	%let nKeptInputs = %sysfunc(countw(&inputs.));


	%do i = 1 %to &nKeptInputs.;
		%global keptInput&i.;
		%let keptInput&i. = %scan(&inputs., &i);
	%end; 


%mend selectImpVars;


%macro reduceObs(DS=,
                      obsSP=,
                      outDS=);


	/*CREATE DATASET OF COMPLEMENTARY INPUTS */
	data &outDS.;
		set &DS.(keep= %dm_class_input %dm_interval_input );
		if ranuni(12345) LE &obsSP.;
		_rowNum_ = _N_;
	run;

	
%mend reduceObs;



%macro getComplementaryInputs(

        DS=,
	plotVar=

);



/*CREATE S and C lists*/


data plotVar otherInputs;
	set &DS.;

	if strip(ROLE='INPUT') and strip(name EQ "&plotVar.") then
		output plotVar;
	else if strip(ROLE='INPUT') and strip(name NE "&plotVar.") then
		output otherInputs;
run;

%global plotVarLevel;

data _null_;
	set plotVar; 
	call symput('plotVarLevel',strip(level));
run;


%global nOtherInputVars;

data _null_;
	set otherInputs end = eof;
	if eof then call symput ('nOtherInputVars',strip(_n_)); /*there could be fewer important inputs than the user setting */
run;



%do j = 1 %to &nOtherInputVars.;
	%global otherInputVar&j.;
	%global otherInputVarLevel&j.;
	%put other input var &j: &&otherInputVar&j. &&otherInputVarLevel&j.;
%end; 



data _null_;
	set otherInputs end = eof;
	call symput('otherInputVar'!!strip(_n_),name);
	call symput('otherInputVarLevel'!!strip(_n_),level);

run;



%mend getComplementaryInputs;






%macro getXValues(
               plotVar=,
               DS=,
               OutDS=
		);



	/*for mdSummary */
	data &dm_casiocalib..dummyData;
		set &DS.;
		___xxx___ = 1;
	run;


	/*GET UNIQUE VALUES OF PLOT VAR*/

	proc mdSummary data = &dm_casiocalib..dummyData;
		groupBy &plotVar.;
		var ___xxx___; /*choice of var is arbitrary but cannot be string variable like SPECIES or JOB! */
		output out=&dm_casiocalib..&outDS.;
	run;

	data &outDS.;
		set &dm_casiocalib..&outDS.;
	run;

	proc sort data = &outDS.; /*Do not sort CAS tables! */
		by &plotVar.;
	run;


%mend getXValues; 


%macro replicateObs(plotVar=,xValuesDS=,complementDS=,outReplicatesDS=);

	/*REPLICATE OTHERS DATASET FOR EACH VALUE OF PLOTVAR */

	data &dm_casiocalib..&outReplicatesDS. /* / SESSREF=&_SESSREF_ */;
		set &xValuesDS.(keep=&plotVar.);

		do s=1 to n;
			set &complementDS. (keep=   _rowNum_

				%do j = 1 %to &nOtherInputVars.;
					&&otherInputVar&j.
				%end;
				
		) point=s nobs=n;
		output;
		end;
	run;

%mend replicateObs;



%macro scoreReplicates(replicatesDS=,outScoredReplicatesDS=);


/*SCORE THE REPLICATES */

	data _null;
	     Set &dm_predecessors end=eof;
	     if eof then do;
		  call symput('_predguid', trim(left(guid)));
		  call symput('_prednodeid', trim(left('_'!!nodeid)));
		  call symput('_predcomponent', trim(left(component)));
	     end;
	run;

	%put _predguid = &_predguid;
	%put dm_nodedir = &dm_nodedir;
	%put _predcomponent = &_predcomponent;

	%if "&_predcomponent" = "gradboost" or "&_predcomponent" = "forest" or "&_predcomponent" = "svm" %then %do;
	%dmcas_fetchContent(&_predguid, &dm_nodedir, &_prednodeid, sasast );

	     %let _astoreFile = %nrbquote(&dm_nodedir)&dm_dsep.&_prednodeid..sasast;
	     %put _astoreFile = &_astoreFile;
	     %let rstore= &dm_casiocalib..&_prednodeid._ast;
	     %put rstore = &rstore;

	     %if ^%sysfunc(exist(&rstore)) %then %do;
			proc astore;
			   upload store="&_astoreFile" rstore=&rstore;
			run;
	     %end;
	     %let code_file = &rstore;
	     proc astore;
		     score data=&dm_casiocalib..&ReplicatesDS. 
			     out=&dm_casiocalib..&outScoredReplicatesDS.
			   copyvar=(%dm_interval_input %dm_class_input _rowNum_ )
			   rstore = &code_file;
		  run;   
	%end;
	%else %do;
	     %dmcas_fetchContent(&_predguid, &dm_nodedir, dmcas_scorecode, sas);
	     %let code_file = &dm_nodedir.&dm_dsep.dmcas_scorecode.sas;

		data &dm_casiocalib..&outScoredReplicatesDS.  / SESSREF=&_SESSREF_;
			set &dm_casiocalib..&ReplicatesDS. ;

			%inc "&code_file";
		run;

		%end;


%mend scoreReplicates;



%macro createPlot(plotVar=,DS=,XDS=,replicatesDS=,outPD=);


	/*GENERATE A MEASUREMENT-LEVEL APPROPRIATE PLOT */

	data &dm_lib..&outPD (rename=(_MEAN_ = avgYHat));
		set &dm_casiocalib..&DS;
		label &plotVar. = "&plotVar.";
		label _MEAN_ = "Average Prediction for &targetVar.";
	run;

	proc sort data = &dm_lib..&outPD.;
		by &plotVar.;
	run;

	data partialDependence&i;
		set &dm_lib..&outPD.;
	run;


proc print data =partialDependence&i.; run; 


	%if &plotVarLevel. EQ INTERVAL %then
		%do;
			%dmcas_report(dataset=&outPD., reportType=SeriesPlot, x=&plotVar., y=avgYHat, description=Partial Dependence);
		%end;
	%else
		%do;
			%dmcas_report(dataset=&outPD., reportType=BarChart, category=&plotVar., response=avgYHat, description=Partial Dependence);
		%end;

	
%mend createPlot;




%macro partialDep(
		importantInputs=, /*inputs to display */
		obsSampProp=        /*sampling proportion */
	);
			
			
	/*select most important inputs */		
	%selectImpVars(
	               DS=&dm_data,
		       inputs=&importantInputs,
		       outDS=importantVariables
		       );
		       
		
	/*use sampling or clustering to reduce training set */	
	%reduceObs( 
	                DS=&dm_data,
			obsSP=&obsSampProp,
			outDS=otherVars			
			);


        /*Create PD plot for each important input */
	%do i = 1 %to &nKeptInputs.;
	
	        /*get complementary variables */
		%getComplementaryInputs(
		                DS=&dm_metadata,
		                plotVar=&&keptInput&i.
		                );
		      
		      
		/*get unique values of ith important variable */      
		%getXValues(
		            DS=&dm_data,
		            plotVar=&&keptInput&i.,
		            outDS=uniqueXs
		            );	

		/*replicate reduced set of observations */                   		                  
		%replicateObs(
		              plotVar=&&keptInput&i.,
		              xValuesDS=uniqueXs,
		              complementDS=otherVars,
		              outReplicatesDS=replicates
		              );

                /*score replicates using supervised learning model from predecessor node */
		%scoreReplicates(
		                 replicatesDS=replicates,
		                 outScoredReplicatesDS=scoredReplicates
		                 );


		/*compute average yHat for each value of ith important variable */
		proc MDsummary data = &dm_casiocalib..scoredReplicates ;
			groupBy &&keptInput&i.;
			var &yHatVar;
			output out=&dm_casiocalib..partialDependence;
		run;

                   
		/*create plot */                  
		%createPlot(
		              plotVar=&&keptInput&i.,
		              DS=partialDependence,
		              replicatesDS=scoredReplicates,
		              XDS=uniqueXs,
		              outPD=partialDependence&i.
		              );
		
	%end; 	
		


%endrm:

%mend partialDep;


/*names of inportant inputs are case sensitive 

%partialDep(importantInputs=DEBTINC JOB REASON, obsSampProp=.10);

*/