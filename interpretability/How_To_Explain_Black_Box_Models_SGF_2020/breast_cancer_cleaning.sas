title "Breast Cancer Data Cleaning";
libname sgf_20 "./dataset_breast_cancer";

/* ========================= Load Data ===================================== */

proc import datafile = "./dataset_breast_cancer/breast-cancer-wisconsin.csv"
            out      = sgf_20.breast_cancer
			dbms     = CSV
			replace;
	guessingrows=10;
run;

/* ========================= Cleaning Data ================================= */

data sgf_20.breast_cancer;
	set sgf_20.breast_cancer(rename=(class = class_old));

	/* Bare Nuclei Imputation */
	if bare_nuclei = . then bare_nuclei = 0;

    /* Reformat Target */
	select (class_old);
		when (2) class="BENIGN";
		when (4) class="MALIGNANT";
	end;

	/* Drop Old Columns */
	drop class_old;

run;

/* ========================= Analyze Data ================================== */

proc contents data=sgf_20.breast_cancer;
run;

proc print data=sgf_20.breast_cancer(obs=20);
run;

proc freq;
	tables _ALL_;
run;

proc corr data=sgf_20.breast_cancer(drop=sample_id) plots(maxpoints=NONE)=matrix(histogram);
run;

title;
