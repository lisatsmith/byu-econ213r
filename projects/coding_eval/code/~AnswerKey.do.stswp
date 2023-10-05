*****CODING EVALUATION ANSWER KEY*****
*Created by Lisa Turley Smith
*Econ 213R
***************************************

clear all
set more off
ssc install aaplot // install if necessary

program main
  clean_excel
  prepare_data
  analysis
end

program clean_excel
  import excel ../../../shared_data/raw/coding_eval/ACS2018MAcoFamilySize.xlsx, sheet("Data") firstrow clear
  rename (CountyinMassachusetts Totalfamilies Averagefamilysize) (county totalFamilies avgFamilySize)
  save ../temp/familybycounty.dta, replace
  
  import excel ../../../shared_data/raw/coding_eval/MAruca.xlsx, sheet("MAZipcodes") firstrow clear
  assert STATE == "MA"
  drop STATE
  rename (ZIP_CODE RUCA1) (zipcode ruca)
  save ../temp/zip_ruca.dta, replace
end

program prepare_data
  import delimited ../../../shared_data/raw/coding_eval/MAcountiesZIP.csv, clear
  tostring zipcode, replace
  replace zipcode = "0" + zipcode if strlen(zipcode) == 4
  assert strlen(zipcode) == 5
  
  merge 1:1 zipcode using ../temp/zip_ruca.dta
    keep if _merge == 3
    drop _merge
  *NOTE: 23 zipcodes from county-zip crosswalk not in zip-ruca crosswalk
  *      1 zipcode from zip-ruca crosswalk not in county-zip crosswalk
  
  collapse (mean) averageRUCA=ruca (median) medianRUCA=ruca, by(county)
  merge 1:1 county using ../temp/familybycounty.dta, nogen
  *Note: 2 counties do not have ACS family data
  
  save ../output/data/MAcoFamsRUCA.dta, replace
end

program analysis
  sort averageRUCA
  list 
  sort totalFamilies
  list
  sort avgFamilySize
  list
  
  foreach familyvar in totalFamilies avgFamilySize {
    correlate `familyvar' averageRUCA
    regress `familyvar' averageRUCA
    aaplot `familyvar' averageRUCA
      graph export ../output/figures/`familyvar'_avgRUCA.png, replace
  }
end

main

/*QUESTIONS
1. Norfolk, Essex, and Suffolk
2. Middlesex
3. Plymouth
4. Yes, for both. The number of families and average family size both increase the lower the RUCA code.
   In other words, more urban areas have more families and these families tend to be a little (negligibly) larger.
5. This is a very small data set and we are missing two counties. 
   Most of the counties have a very low RUCA code and all counties have roughly the same average family size.
   Very few counties are driving the correlation we see.
*/