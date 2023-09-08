proc transreg data=WORK.IMPORT ss2 details
              plots=(transformation(dependent) scatter
                    observedbypredicted);
   model BoxCox('Annual TCO'n / lambda=-2 -1 -0.5 to 0.5 by 0.05 1 2
                    convenient parameter=2 alpha=0.00001) =
         identity('Model Year'n);
run;

data work.transform;
	set WORK.IMPORT;
	'tr1_Annual TCO'n='Annual TCO'n-1;
run;

ods noproctitle;
ods graphics / imagemap=on;

proc glmselect data=work.transform outdesign(addinputvars)=Work.reg_design 
		plots=(criterionpanel);
	model 'tr1_Annual TCO'n='Model Year'n / showpvalues selection=stepwise
    
   (select=sbc);
run;

proc reg data=Work.reg_design alpha=0.05 plots(only)=(diagnostics residuals 
		fitplot observedbypredicted);
	ods select DiagnosticsPanel ResidualPlot FitPlot ObservedByPredicted;
	model 'tr1_Annual TCO'n=&_GLSMOD /;
	run;
quit;

proc delete data=Work.reg_design;
run;
