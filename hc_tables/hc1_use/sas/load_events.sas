%macro load_events(evnt,file) / minoperator;

	FILENAME &file. "&PUFdir.\&file..ssp";
	proc xcopy in = &file. out = WORK IMPORT;
	run;

	data &evnt;
		SET &syslast; /* Most recent dataset loaded */
		event = "&evnt.";
		year = &year.;

		%if &evnt in (IP OP ER) %then %do;
			SF&yy.X=&evnt.DSF&yy.X+&evnt.FSF&yy.X;
			MR&yy.X=&evnt.DMR&yy.X+&evnt.FMR&yy.X;
			MD&yy.X=&evnt.DMD&yy.X+&evnt.FMD&yy.X;
			PV&yy.X=&evnt.DPV&yy.X+&evnt.FPV&yy.X;
			VA&yy.X=&evnt.DVA&yy.X+&evnt.FVA&yy.X;
			OF&yy.X=&evnt.DOF&yy.X+&evnt.FOF&yy.X;
			SL&yy.X=&evnt.DSL&yy.X+&evnt.FSL&yy.X;
			WC&yy.X=&evnt.DWC&yy.X+&evnt.FWC&yy.X;
			OR&yy.X=&evnt.DOR&yy.X+&evnt.FOR&yy.X;
			OU&yy.X=&evnt.DOU&yy.X+&evnt.FOU&yy.X;
			OT&yy.X=&evnt.DOT&yy.X+&evnt.FOT&yy.X;
			XP&yy.X=&evnt.DXP&yy.X+&evnt.FXP&yy.X;
			
			if year <= 1999 then TR&yy.X=&evnt.DCH&yy.X+&evnt.FCH&yy.X;
			else TR&yy.X=&evnt.DTR&yy.X+&evnt.FTR&yy.X;
		%end;

		%else %do;
			SF&yy.X=&evnt.SF&yy.X;
			MR&yy.X=&evnt.MR&yy.X;
			MD&yy.X=&evnt.MD&yy.X;
			PV&yy.X=&evnt.PV&yy.X;
			VA&yy.X=&evnt.VA&yy.X;			
			OF&yy.X=&evnt.OF&yy.X;
			SL&yy.X=&evnt.SL&yy.X;
			WC&yy.X=&evnt.WC&yy.X;
			OR&yy.X=&evnt.OR&yy.X;
			OU&yy.X=&evnt.OU&yy.X;
			OT&yy.X=&evnt.OT&yy.X;
			XP&yy.X=&evnt.XP&yy.X;

			if year <= 1999 then TR&yy.X=&evnt.CH&yy.X;
			else TR&yy.X=&evnt.TR&yy.X;
		%end;

		PR&yy.X = PV&yy.X+TR&yy.X;
	    OZ&yy.X = OF&yy.X+SL&yy.X+OT&yy.X+OR&yy.X+OU&yy.X+WC&yy.X+VA&yy.X;

		keep DUPERSID event: SEEDOC XP&yy.X SF&yy.X PR&yy.X MR&yy.X MD&yy.X OZ&yy.X;
	run;
%mend;

%load_events(RX,&RX.);
%load_events(DV,&DV.);
%load_events(OM,&OM.);
%load_events(IP,&IP.);
%load_events(ER,&ER.);
%load_events(OP,&OP.);
%load_events(OB,&OB.);
%load_events(HH,&HH.);

/* Define sub-levels for office-based, outpatient, and home health */
data OB; set OB;
	if SEEDOC = 1 then event_v2X = 'OBD';
	else if SEEDOC = 2 then event_v2X = 'OBO';
	else event_v2X = '';
run;

data OP; set OP;
	if SEEDOC = 1 then event_v2X = 'OPY';
	else if SEEDOC = 2 then event_v2X = 'OPZ';
	else event_v2X = '';
run;

/* Merge with FYC file */
data FYCsub; set MEPS;
	keep &subgrps. DUPERSID PERWT&yy.F VARSTR VARPSU;
run;