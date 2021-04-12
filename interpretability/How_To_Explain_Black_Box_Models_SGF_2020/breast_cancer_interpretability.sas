title "Breast Cancer Modelling";
libname sgf_20 "./dataset_breast_cancer";

/* ========================= Connect To CAS ================================ */

cas mycas; 
libname mycas cas;

/* ========================= Partition/Upload Data ========================= */

data mycas.breast_cancer_train mycas.breast_cancer_test;
	set sgf_20.breast_cancer;

	/* Random Partitioning */
	call streaminit(1234);
	rand = rand("Uniform");

	if rand <= 0.7 then output mycas.breast_cancer_train;
	               else output mycas.breast_cancer_test;

	drop rand;
run;

/* ========================= Train Models ================================== */

/* CASL Array Syntax */
%let inputs = {"clump_thickness", "cell_size_uniformity", "cell_shape_uniformity",
               "marginal_adhesion", "single_cell_size", "bare_nuclei",
               "bland_chromatin", "normal_nucleoli", "mitoses"};

/* Train Random Forest */
proc cas;

	inputs = &inputs;

	/* Basic Random Forest Call */
	decisionTree.forestTrain   result    = forest_res
                             / table     = "BREAST_CANCER_TRAIN"
							   target    = "class"
                               inputs    = inputs
							   oob       = True
							   nTree     = 500
							   maxLevel  = 12
							   seed      = 1234
							   varImp    = True
							   casOut    = {name    = "FOREST_MODEL_TABLE",
                                            replace = True}
                               savestate = {name    = "FOREST_MODEL",
											replace = True};
	run;

	decisionTree.forestScore   result     = forest_res
	                         / table      = "BREAST_CANCER_TRAIN"
							   model      = {name = "FOREST_MODEL_TABLE"}
							   casOut     = {name    = "BREAST_CANCER_TRAIN_FORSCORE",
                                             replace = True}
							   encodeName = True
							   copyVars   = inputs || "class" || "sample_id";
	run;

	decisionTree.forestScore   result     = forest_res
	                         / table      = "BREAST_CANCER_TEST"
							   model      = {name = "FOREST_MODEL_TABLE"}
							   casOut     = {name    = "BREAST_CANCER_TEST_FORSCORE",
                                             replace = True}
							   encodeName = True
							   copyVars   = inputs || "class" || "sample_id";
	run;

quit;

/* Train Logistic Regression */
proc cas;

	/* Dropping Less Important Inputs */
	inputs = &inputs;
	new_inputs = {};

	do val over inputs;
		if val != "mitoses" &
           val != "normal_nucleoli" &
           val != "single_cell_size" then new_inputs = new_inputs || val;
	end;

	inputs = new_inputs;

	/* Basic Logistic Call */
	regression.logistic   result    = log_res
						/ table     = "BREAST_CANCER_TRAIN"
						  model     = {depVar  = {{name    = "class",
                                                   options = {event = "MALIGN"}}},
								       effects = inputs}
						  selection = {method = "backward"}
						  store     = {name    = "LOGISTIC_MODEL",
								       replace = True};
	run;

	regression.logisticScore   result   = log_res
	                         / table    = "BREAST_CANCER_TRAIN"
						       restore  = "LOGISTIC_MODEL"
							   casOut   = {name    = "BREAST_CANCER_TRAIN_LOGSCORE",
                                           replace = True}
							   copyVars = "ALL";
	run;

	regression.logisticScore   result   = log_res
	                         / table    = "BREAST_CANCER_TEST"
						       restore  = "LOGISTIC_MODEL"
							   casOut   = {name    = "BREAST_CANCER_TEST_LOGSCORE",
                                           replace = True}
							   copyVars = "ALL";
	run;

quit;

/* Train Assessment to Select Cutoffs */
proc assess data=mycas.BREAST_CANCER_TRAIN_FORSCORE;
	target class / level = nominal event="MALIGN";
	input P_classMALIGN;
run; /* 0.4 Cutoff */

proc assess data=mycas.BREAST_CANCER_TRAIN_LOGSCORE;
	target class / level = nominal event="MALIGN";
	input _PRED_;
run; /* 0.19 Cutoff */

/* Assess Accuracy on Test */
proc assess data=mycas.BREAST_CANCER_TEST_FORSCORE;
	target class / level = nominal event="MALIGN";
	input P_classMALIGN;
run; /* 0.029126 Misclass */

proc assess data=mycas.BREAST_CANCER_TEST_LOGSCORE;
	target class / level = nominal event="MALIGN";
	input _PRED_;
run; /* 0.043689 Misclass */

/* ========================= Interpretability Macros ======================= */

/* Partial Dependence/ ICE Macro */
%macro pd_ice(var_name,plot_type,ice=False,model=,pred_target=,append_table=,reset=0);

	proc cas;

		/* Inputs and Nominals macro -> CASL Var */
		inputs = &inputs;

		/* Action Call */
		explainModel.partialDependence   result           = pd_res
									   / table            = "BREAST_CANCER_TRAIN"
									     inputs           = inputs
										 modelTable       = "&model"
										 modelTableType   = "ASTORE"
										 predictedTarget  = "&pred_target"
										 analysisVariable = {name  = "&var_name",
															 nBins = 50}
										 iceTable         = {casout   = {name    = "ICE_TABLE",
										 					             replace = True},
															 copyVars = "ALL"}
										 seed             = 1234
		;
		run;

		/* Save PD Results */
		saveresult pd_res["PartialDependence"] dataset = PD_RES;
		run;

	quit;

	/* Setup Up Desired SGPLOT Call */
	%if &ice=False %then %do;
		%let plot_data=PD_RES;
		%if &plot_type=line %then %let plot_statement=series x = &var_name y = MeanPrediction;
		                    %else %let plot_statement=vbarparm category = &var_name response = MeanPrediction;
	%end; %else %do;
		%let plot_data=mycas.ICE_TABLE;
		%if &plot_type=line %then %let plot_statement=series x = &var_name y = &pred_target / group = sample_id lineattrs=(pattern=solid colors=black);
		/* Boxplot? */      %else %let plot_statement=series x = &var_name y = &pred_target / group = sample_id lineattrs=(pattern=solid colors=black);
	%end;

	/* SGPLOT Call */
	proc sgplot data = &plot_data;
		&plot_statement;
	run;

	/* Append Data */
	%if %length(&append_table) > 0 %then %do;
		data new_table;
			length Variable $30;
			set PD_RES;
			x = &var_name;
			drop &var_name;
			Variable = "&var_name";
		run;

		%if &reset = 0 %then %do;
			data &append_table;
				set &append_table
					new_table;
			run;
		%end; %else %do;
			data &append_table;
				set new_table;
			run;
		%end;
	%end;

%mend;

%pd_ice( cell_size_uniformity,line,model=FOREST_MODEL,pred_target=P_classMALIGN,append_table=forest_pds,reset=1);

/* PD Plots - Forest */
%pd_ice(      clump_thickness,line,model=FOREST_MODEL,pred_target=P_classMALIGN,append_table=forest_pds,reset=1);
%pd_ice( cell_size_uniformity,line,model=FOREST_MODEL,pred_target=P_classMALIGN,append_table=forest_pds);
%pd_ice(cell_shape_uniformity,line,model=FOREST_MODEL,pred_target=P_classMALIGN,append_table=forest_pds);
%pd_ice(    marginal_adhesion,line,model=FOREST_MODEL,pred_target=P_classMALIGN,append_table=forest_pds);
%pd_ice(     single_cell_size,line,model=FOREST_MODEL,pred_target=P_classMALIGN,append_table=forest_pds);
%pd_ice(          bare_nuclei,line,model=FOREST_MODEL,pred_target=P_classMALIGN,append_table=forest_pds);
%pd_ice(      bland_chromatin,line,model=FOREST_MODEL,pred_target=P_classMALIGN,append_table=forest_pds);
%pd_ice(      normal_nucleoli,line,model=FOREST_MODEL,pred_target=P_classMALIGN,append_table=forest_pds);
%pd_ice(              mitoses,line,model=FOREST_MODEL,pred_target=P_classMALIGN,append_table=forest_pds);
proc print data=forest_pds; run;

proc sgplot data = forest_pds(where=(x>=1));
	series x = x y = MeanPrediction / group = Variable;
run;

/* PD Plots - Logistic */
%pd_ice(      clump_thickness,line,model=LOGISTIC_MODEL,pred_target=P_classMALIGN,append_table=logistic_pds,reset=1);
%pd_ice( cell_size_uniformity,line,model=LOGISTIC_MODEL,pred_target=P_classMALIGN,append_table=logistic_pds);
/* %pd_ice(cell_shape_uniformity,line,model=LOGISTIC_MODEL,pred_target=P_classMALIGN,append_table=logistic_pds); */
/* %pd_ice(    marginal_adhesion,line,model=LOGISTIC_MODEL,pred_target=P_classMALIGN,append_table=logistic_pds); */
/* %pd_ice(     single_cell_size,line,model=LOGISTIC_MODEL,pred_target=P_classMALIGN,append_table=logistic_pds); */
%pd_ice(          bare_nuclei,line,model=LOGISTIC_MODEL,pred_target=P_classMALIGN,append_table=logistic_pds);
/* %pd_ice(      bland_chromatin,line,model=LOGISTIC_MODEL,pred_target=P_classMALIGN,append_table=logistic_pds); */
/* %pd_ice(      normal_nucleoli,line,model=LOGISTIC_MODEL,pred_target=P_classMALIGN,append_table=logistic_pds); */
/* %pd_ice(              mitoses,line,model=LOGISTIC_MODEL,pred_target=P_classMALIGN,append_table=logistic_pds); */
proc print data=forest_pds; run;

proc sgplot data = logistic_pds(where=(x>=1));
	series x = x y = MeanPrediction / group = Variable;
run;

/* ========================= Look for Interesting Observations ============= */

/* Process Data - Accuracy */
data breast_cancer_train_forscore;
	set mycas.breast_cancer_train_forscore;
	if class = "MALIGN" then class_error = 1 - P_classMALIGN;
	                    else class_error = P_classMALIGN;
run;

/* Best Accuracy */
proc sort data=breast_cancer_train_forscore;
	by class_error;
run;

title "Highest Accuracy by Class";
data breast_cancer_high_benign; set breast_cancer_train_forscore(obs=1); where class = "BENIGN"; run;
proc print data=breast_cancer_high_benign; run;
data breast_cancer_high_malign; set breast_cancer_train_forscore(obs=1); where class = "MALIGN"; run;
proc print data=breast_cancer_high_malign; run;

/* Worst Accuracy */
proc sort data=breast_cancer_train_forscore;
	by descending class_error;
run;

title "Lowest Accuracy by Class";
data breast_cancer_low_benign; set breast_cancer_train_forscore(obs=1); where class = "BENIGN"; run;
proc print data=breast_cancer_low_benign; run;
data breast_cancer_low_malign; set breast_cancer_train_forscore(obs=1); where class = "MALIGN"; run;
proc print data=breast_cancer_low_malign; run;

title;

/* ========================= LIME Plots ==================================== */

%macro forest_lime(observation, num_vars=5);

	proc cas;

		/* Inputs and Nominals macro -> CASL Var */
		inputs = &inputs;

		/* Action Call */
		explainModel.linearExplainer     result           = lex_res
									   / table            = "BREAST_CANCER_TRAIN"
									   	 query            = {name  = "BREAST_CANCER_TRAIN",
															 where = "sample_id = &observation;"}
									     inputs           = inputs
										 modelTable       = "FOREST_MODEL"
										 modelTableType   = "ASTORE"
										 predictedTarget  = "P_classMALIGN"
										 preset           = "LIME"
										 explainer        = {standardizeEstimates = "INTERVALS",
														     maxEffects           = &num_vars+1}
										 seed             = 1234
		;
		run;

		/* Save PD Results */
		saveresult lex_res["ParameterEstimates"] dataset = LEX_RES;
		run;

	quit;

	/* Sort by Magnitude of Effect */
	data LEX_RES;
		set LEX_RES;
		abs_est = abs(Estimate);
	run;

	proc sort data = LEX_RES;
		by descending abs_est;
	run;

	/* Plot Coefficients */
	proc sgplot data = LEX_RES;
		where Estimate ne 0 &
		      Variable ne "Intercept";
		hbarparm category = variable response = Estimate;
	run;

%mend;

/* LIME Plots for Interesting Observations */
title "High Accuracy, BENIGN";
%forest_lime(1015425);

title "High Accuracy, MALIGN ";
%forest_lime(1017122);

title "Low Accuracy, BENIGN";
%forest_lime(1213375);

title "Low Accuracy, MALIGN";
%forest_lime(1226012);

title;

/* ========================= SHAPLEY Values Plots ========================== */

%macro forest_shap(observation, num_vars=5);

	proc cas;

		/* Inputs and Nominals macro -> CASL Var */
		inputs = &inputs;

		/* Action Call */
		explainModel.shapleyExplainer    result           = shx_res
									   / table            = "BREAST_CANCER_TRAIN"
									   	 query            = {name  = "BREAST_CANCER_TRAIN",
															 where = "sample_id = &observation;"}
									     inputs           = inputs
										 modelTable       = "FOREST_MODEL"
										 modelTableType   = "ASTORE"
										 predictedTarget  = "P_classMALIGN"
		;
		run;

		/* Save PD Results */
		saveresult shx_res["ShapleyValues"] dataset = SHX_RES;
		run;

	quit;

	/* Sort by Magnitude of Effect */
	data SHX_RES;
		set SHX_RES;
		abs_shap = abs(ShapleyValue);
		where Variable ne "Intercept";
	run;

	proc sort data = SHX_RES;
		by descending abs_shap;
	run;

	data SHX_RES;
		set SHX_RES;
		if _N_ <= &num_vars;
	run;

	/* Plot Shapley Values */
	proc sgplot data = SHX_RES;
		hbarparm category = Variable response = ShapleyValue;
	run;

%mend;

/* Shapley Values Plots for Interesting Observations */
title "High Accuracy, BENIGN";
%forest_shap(1015425);

title "High Accuracy, MALIGN ";
%forest_shap(1017122);

title "Low Accuracy, BENIGN";
%forest_shap(1213375);

title "Low Accuracy, MALIGN";
%forest_shap(1226012);

title;


/* High Accuracy Example */
title "Malignant Sample, Correct Prediction";
proc print data=breast_cancer_high_malign; run;

title "LIME, Malignant Sample, Correct Prediction";
%forest_lime(1017122);

title "Shapley Values, Malignant Sample, Correct Prediction";
%forest_shap(1017122);

/* Low Accuracy Example */
title "Malignant Sample, Incorrect Prediction";
proc print data=breast_cancer_low_malign; run;

title "LIME, Malignant Sample, Incorrect Prediction";
%forest_lime(1226012);

title "Shapley Values, Malignant Sample, Incorrect Prediction";
%forest_shap(1226012);

title;
