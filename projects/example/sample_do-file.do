version 18 //specify which version of stata you used
clear all //always start with a clean slate
set more off // tells Stata not to pause or display the more message
set seed 021096 // always good to include, but especially include if there is any kind of randomization
cd "[file location here]" // only if for external use
adopath + ../[ado path]/ado // if necessary


program main
	global analysis_years 2001 2002 2003 2004 2005 // if you don't have too many globals, define them here, otherwise keep them in another program
  global treatment_grp "" "A" "B" "AB" "C"
  global tables Table1_SumStats Table2_Results // define outputs in globals for clarity
  
  foreach year in $analysis_years {
    foreach group in $treatment_grp {
      prepare_sample, yr(`year') treat_grp(`group')
    }
  }
  
	sumstats
  analysis
  prepare_output
  
	foreach tab in $tables {
		fill_tables, mat(`tab') save_txt(../output/tables/) ///
	}
end

program prepare_sample
  syntax, yr(int) [treat_grp(str)] //define what you'll be reading in. Then call these as local variables.
  
  if `treat_grp' != "" {
    use ../data/mydata_`yr'.dta if treatment_status == `treat_grp'
  }
  else {
    use ../data/mydata_`yr'.dta
  }
  
  [code here]
end

program sumstats
  [code here]

end

program analysis
  [code here]

end

program prepare_output
  [code here]

end

*EXECUTE
main

