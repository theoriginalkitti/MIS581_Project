proc transreg data=WORK.IMPORT ss2 details
              plots=(transformation(dependent) scatter
                    observedbypredicted);
   model BoxCox('Real-World CO2 (g/mi)'n / lambda=-2 -1 -0.5 to 0.5 by 0.05 1 2
                    convenient parameter=2 alpha=0.00001) =
         identity('Model Year'n);
run;