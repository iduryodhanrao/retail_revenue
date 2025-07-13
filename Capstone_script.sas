PROC IMPORT OUT=WORK.RETAIL2007
	DATAFILE='/folders/myfolders/SASPractice/EC0744I1.dat'
	DBMS=DLM REPLACE;
	DELIMITER="|";
	GETNAMES=YES;
RUN;
PROC IMPORT OUT=WORK.RETAIL2012
	DATAFILE='/folders/myfolders/SASPractice/EC1244I1.dat'
	DBMS=DLM REPLACE;
	DELIMITER="|";
	GETNAMES=YES;
RUN;
PROC IMPORT OUT=WORK.RETAIL2017
	DATAFILE='/folders/myfolders/SASPractice/EC1744BASIC.dat'
	DBMS=DLM REPLACE;
	DELIMITER="|";
	GETNAMES=YES;
	RUN;

PROC CONTENTS DATA=WORK.RETAIL2007 VARNUM;
RUN;
PROC CONTENTS DATA=WORK.RETAIL2012 VARNUM;
RUN;
PROC CONTENTS DATA=WORK.RETAIL2017 VARNUM;
RUN;

PROC SQL;
CREATE TABLE RETAIL AS 
	SELECT GEOTYPE, ST, GEO_ID, GEOGRAPHY AS GEO_TTL, SECTOR, PUT(NAICS2007,6.) AS NAICS,
	NAICS2007_MEANING AS NAICS_TTL, YEAR, ESTAB, ESTAB_F, RCPTOT, RCPTOT_F, PAYANN,
	PAYANN_F, PAYQTR1, PAYQTR1_F, EMP, EMP_F FROM WORK.RETAIL2007
	
	UNION ALL
	SELECT GEOTYPE, ST, GEO_ID, GEO_TTL, SECTOR, NAICS2012 AS NAICS,
	NAICS2012_TTL AS NAICS_TTL, YEAR, ESTAB, ESTAB_F, RCPTOT, RCPTOT_F, PAYANN,
	PAYANN_F, PAYQTR1, PAYQTR1_F, EMP, EMP_F FROM WORK.RETAIL2012

	UNION ALL
	SELECT GEOTYPE, ST, GEO_ID, GEO_TTL, SECTOR, NAICS2017 AS NAICS,
	NAICS2017_TTL AS NAICS_TTL, YEAR, ESTAB, ESTAB_F, RCPTOT, RCPTOT_F, PAYANN,
	PAYANN_F, PAYQTR1, PAYQTR1_F, EMP, EMP_F FROM WORK.RETAIL2017;
QUIT;

PROC CONTENTS DATA=RETAIL;
RUN;
PROC PRINT DATA=RETAIL(OBS=10);
RUN;

/*CREATE A FORMAT TO GROUP MISSING AND NONMISSING */
PROC FORMAT;
	VALUE $missfmt ' '='Missing' other='Not Missing';
	value $missfmt . = 'Missing' other='Not Missing';
run;

PROC freq data=retail;
FORMAT _CHAR_ $missfmt.;
tables _CHAR_ / missing missprint nocum nopercent;
format _NUMERIC_ missfmt.;
tables _NUMERIC_ / missing missprint nocum nopercent;
run;

PROC SQL;
CREATE TABLE RETAIL AS 
	SELECT GEOTYPE, ST, GEO_ID, GEO_TTL, SECTOR, NAICS, 
	NAICS_TTL, YEAR, ESTAB, RCPTOT, PAYANN, PAYQTR1, EMP
	FROM RETAIL;
QUIT;

PROC SQL;
CREATE TABLE DUP AS
	SELECT * FROM RETAIL 
	GROUP BY GEOTYPE, ST, GEO_ID, GEO_TTL, SECTOR, NAICS, 
	NAICS_TTL, YEAR, ESTAB, RCPTOT, PAYANN, PAYQTR1, EMP having count(*)>1;
quit;

PROC SQL;
CREATE TABLE RETAIL_CTG AS 
	SELECT GEOTYPE, ST, GEO_ID, GEO_TTL, SECTOR, NAICS, NAICS_TTL, 
	SUBSTR(LEFT(NAICS),1,3) AS NAICS_CTG,
	CASE SUBSTR(LEFT(NAICS),1,3)
	WHEN '441' THEN 'Motor vehicles and parts dealers'
	WHEN '442' THEN 'Furniture and home furnishings stores'
	WHEN '443' THEN 'Electronics and appliance stores'
	WHEN '444' THEN 'Building materials and garden equipment and supplies dealers'
	WHEN '445' THEN 'Food and beverage stores'
	WHEN '446' THEN 'Health and personal care stores'
	WHEN '447' THEN 'Gasoline stations'
	WHEN '448' THEN 'Clothing and clothing accessories stores'
	WHEN '451' THEN 'Sporting goods, hobby, musical instrument, and book stores'
	WHEN '452' THEN 'General merchandise stores'
	WHEN '453' THEN 'Miscellaneous store retailers'
	WHEN '454' THEN 'Nonstore retailers'
	ELSE 'Others'
	end as NAICS_CTG_TTL,	
	YEAR, ESTAB, RCPTOT, PAYANN, PAYQTR1, EMP FROM RETAIL 
	WHERE SUBSTR(LEFT(NAICS),1,3)<>'44-';
QUIT;

/*Analyze categorical variables*/
title "Frequencies for Categorical variables";
proc freq data=work.retail_ctg;
	tables GEO_TTL NAICS_CTG GEOTYPE ST SECTOR YEAR / PLOTS=(FREQPLOT);
RUN;

/*Analyze distribution of continous variables*/
proc univariate data=work.retail_ctg noprint;
	histogram ESTAB RCPTOT PAYANN PAYQTR1 EMP;
RUN;

/*Analyze numerical variables*/
title "Descriptive statistics for numerica variables";
proc means data=work.retail_ctg n nmiss min mean median max std;
	var ESTAB RCPTOT PAYANN PAYQTR1 EMP;
RUN;
/*log transform on continous variables*/
data work.transform;
	set work.retail_ctg;
	log_RCPTOT=log(RCPTOT);
	log_ESTAB=LOG(ESTAB);
	log_EMP=LOG(EMP);
RUN;

/*HISTOGRAM PLOT WITH NORMAL CURVE*/
proc sgplot data=work.transform;
	histogram log_RCPTOT / ;
	density log_RCPTOT;
	yaxis grid;
run;
proc sgplot data=work.transform;
	histogram log_ESTAB / ;
	density log_ESTAB;
	yaxis grid;
run;
proc sgplot data=work.transform;
	histogram log_EMP / ;
	density log_EMP;
	yaxis grid;
run;	

/*Bar chart independent vs dependent variable */
proc sgplot data=work.retail_ctg;
	format rcptot comma20.;
	vbar naics_ctg / response=rcptot;
run;

/*Bar chart independent vs dependent variable */
proc sgplot data=work.retail_ctg;
	format rcptot comma20.;
	vbar naics_ctg / response=rcptot;
run;

proc sgplot data=work.retail_ctg;
	format estab comma20.;
	vbar naics_ctg / response=estab;
run;


proc sgplot data=work.retail_ctg;
	format emp comma20.;
	vbar naics_ctg / response=emp;
run;

/*Bar chart independent vs dependent variable group by year */
proc sgplot data=work.retail_ctg;
	format rcptot comma20.;
	vbar naics_ctg / response=rcptot group=year 
	groupdisplay=cluster dataskin=gloss;
run;

proc sgplot data=work.retail_ctg;
	format estab comma20.;
	vbar naics_ctg / response=estab group=year 
	groupdisplay=cluster dataskin=gloss;
run;
proc sgplot data=work.retail_ctg;
	format emp comma20.;
	vbar naics_ctg / response=emp group=year 
	groupdisplay=cluster dataskin=gloss;
run;

proc corr data=work.transform plots=none;
	var year ESTAB EMP;
	WITH RCPTOT;
RUN;

ods noproctitle;
ods graphics / imagemap=on;
/*Anova test */
proc glm data=WORK.TRANSFORM plots(only)=(diagnostics intplot);
	class NAICS_CTG YEAR;
	model log_RCPTOT=NAICS_CTG YEAR / ss1 ss3;
	lsmeans NAICS_CTG YEAR / adjust=tukey pdiff=all 
	alpha=0.05 cl plots=(diffplot);
quit;



