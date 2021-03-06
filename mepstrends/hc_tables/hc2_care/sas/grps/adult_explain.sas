data MEPS; set MEPS;
	adult_explain = ADEXPL42;
	domain = (ADAPPT42 >= 1 & AGELAST >= 18);
run;

&freq_fmt.;

ods output CrossTabs = out;
proc surveyfreq data = MEPS missing; 
	FORMAT adult_explain freq. &fmt.;
	STRATA VARSTR;
	CLUSTER VARPSU;
	WEIGHT SAQWT&yy.F; 
	TABLES domain*&grp.adult_explain / row;
run;

proc print data = out;
	where domain = 1 and adult_explain ne . &where.;
	var adult_explain &gp. WgtFreq Frequency RowPercent RowStdErr;
run;
