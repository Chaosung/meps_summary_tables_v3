data MEPS; set MEPS;
  delay_MD  = (MDUNAB42=1|MDDLAY42=1);
  afford_MD = (MDDLRS42=1|MDUNRS42=1);
  insure_MD = (MDDLRS42 in (2,3)|MDUNRS42 in (2,3));
  other_MD  = (MDDLRS42 > 3|MDUNRS42 > 3);
  domain = (ACCELI42 = 1 & delay_MD=1);
run;

proc format;
	value afford 1 = "Couldn't afford";
	value insure 1 = "Insurance related";
	value other 1 = "Other";
run;

proc surveyfreq data = MEPS missing; 
	FORMAT afford_MD afford. insure_MD insure. other_MD other. &fmt.;
	STRATA VARSTR;
	CLUSTER VARPSU;
	WEIGHT PERWT&yy.F; 
	TABLES domain*&grp.(afford_MD insure_MD other_MD) / row;
run;

