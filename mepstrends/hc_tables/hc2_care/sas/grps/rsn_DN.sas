data MEPS; set MEPS;
  delay_DN  = (DNUNAB42=1|DNDLAY42=1);
  afford_DN = (DNDLRS42=1|DNUNRS42=1);
  insure_DN = (DNDLRS42 in (2,3)|DNUNRS42 in (2,3));
  other_DN  = (DNDLRS42 > 3|DNUNRS42 > 3);
  domain = (ACCELI42 = 1 & delay_DN=1);
run;

proc format;
	value afford 1 = "Couldn't afford";
	value insure 1 = "Insurance related";
	value other 1 = "Other";
run;

proc surveyfreq data = MEPS missing; 
	FORMAT afford_DN afford. insure_DN insure. other_DN other. &fmt.;
	STRATA VARSTR;
	CLUSTER VARPSU;
	WEIGHT PERWT&yy.F; 
	TABLES domain*&grp.(afford_DN insure_DN other_DN) / row;
run;
