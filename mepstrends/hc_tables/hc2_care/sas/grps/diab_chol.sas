data MEPS; set MEPS;
	if year > 2007 then do;
		past_year = (DSCH&yy.53=1 or DSCH&ya.53=1);
		more_year = (DSCH&yb.53=1 or DSCB&yb.53=1);
		never_chk = (DSCHNV53 = 1);
		dontknow  = (DSCH&yy.53 = -8);
		non_resp  = (DSCH&yy.53 in (-7,-9));
	end;	

	else do;
		past_year = (CHOLCK53 = 1);
		more_year = (1 < CHOLCK53 and CHOLCK53 < 6);
		never_chk = (CHOLCK53 = 6);
		dontknow  = (CHOLCK53 = -8);
		non_resp  = (CHOLCK53 in (-7,-9));
	end;

	if past_year = 1 then diab_chol = 1;
	else if more_year = 1 then diab_chol = 2;
	else if never_chk = 1 then diab_chol = 3;
	else if dontknow = 1  then diab_chol = -8;
	else if non_resp = 1  then diab_chol = -7;
	else diab_chol = -9;
run;

proc format;
	value diab_chol
		1 = "In the past year"
		2 = "More than 1 year ago"
		3 = "Never had cholesterol checked"
		4 = "No exam in past year"
		-1 = "Inapplicable"
		-7 = "Non-response"
		-8 = "Don't know"
	    -9 = "Missing";
run;

proc surveyfreq data = MEPS missing; 
	FORMAT diab_chol diab_chol. &fmt.;
	STRATA VARSTR;
	CLUSTER VARPSU;
	WEIGHT DIABW&yy.F; 
	TABLES &grp.diab_chol / row;
run;
