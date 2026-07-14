********************************************************************************
**# Eurovision Voting & Economic Proximity: Regression Analysis
* Author: Mared Jubb
* Date: June 2026
* Description: Augmented gravity model analysis of Eurovision voting patterns
********************************************************************************

*Clear any existing data
clear all

* Set working directory 
cd "C:\Users\abc\OneDrive\University of Exeter\Personal Project\Python Code"

* Start results log  
capture log close
log using "results/results_log.txt", replace text

// Note: Remove the asterisks to install these packages on the very first run.
// Once installed, leave them commented out to speed up the script.

* ssc install ftools, replace
* ssc install reghdfe, replace
* ssc install estout, replace

********************************************************************************
**## 1. DATA IMPORT
********************************************************************************
import delimited "data\processed\eurovision_panel_1957_2026.csv", varnames(1)

*Verify import
describe
list in 1/5

* Declare panel structure
* numeric_id identifies each directed country pair
* year is the time dimension
xtset numeric_id year

********************************************************************************
**##2. VARIABLE LABELS
********************************************************************************

* Outcome variables
label variable total_points "Total points awarded"
label variable tele_points "Televote points awarded (post-2016)"
label variable jury_points "Jury points awarded (post-2016)"
label variable norm_points "Normalised points (0-1 scale)"

* Identifiers
label variable year "Year"
label variable from_country_id "Voting country (ISO3)"
label variable to_country_id "Recipient country (ISO3)"
label variable pair_id "Country pair identifier"
label variable numeric_id "Numeric pair identifier"
label variable voting_regime "Maximum points available in era"

* Geographic
label variable distw "Population-weighted bilateral distance (km)"
label variable contig "Shared border dummy"

* Linguistic
label variable comlang_off "Shared official language dummy"
label variable comlang_ethno "Shared ethnological language dummy"

* Colonial
label variable colony "Colonial link dummy"
label variable comcol "Common colonizer after 1945 dummy"
label variable col45 "Colonial relationship since 1945 dummy"
label variable curcol "Current colonial relationship dummy"
label variable smctry "Historically same country dummy"

* Geopolitical
label variable former_soviet "Both former Soviet states dummy"
label variable former_yugoslav "Both former Yugoslav states dummy"
label variable scandinavian "Both Scandinavian countries dummy"
label variable balkan "Both Balkan countries dummy"
label variable eu_membership "Both EU members in given year dummy"

* GDP
label variable from_gdp_usd "GDP of voting country (billions USD)"
label variable to_gdp_usd "GDP of recipient country (billions USD)"
label variable from_log_gdp_usd "Log GDP of voting country"
label variable to_log_gdp_usd "Log GDP of recipient country"
label variable from_gdp_pc_usd "GDP per capita of voting country (USD)"
label variable to_gdp_pc_usd "GDP per capita of recipient country (USD)"
label variable from_log_gdp_pc_usd "Log GDP per capita of voting country"
label variable to_log_gdp_pc_usd "Log GDP per capita of recipient country"
label variable gdp_similarity "GDP similarity index (0-1)"

* Migration
label variable migrant_stock "Bilateral migrant stock"
label variable migration_intensity "Migrant stock as share of voting country population"
label variable migration_source "Migration data source (UN_DESA/Eurostat/missing)"
label variable voting_country_population "Voting country total population"

* Trade
label variable trade_bilateral "Total bilateral trade (thousands USD)"
label variable trade_openness "Bilateral trade as share of combined GDP"
label variable log_trade_openness "Log trade openness"
label variable log_trade_bilateral "Log bilateral trade"

********************************************************************************
**##3. SUMMARY STATISTICS
********************************************************************************
* Key outcome variables
estpost summarize total_points tele_points jury_points norm_points
estimates store key_outcomes
esttab key_outcomes using "results/tables/outcome_summary.csv", ///
       cells("count mean sd min max") noobs nonumbers nomtitles plain replace

* Key covariates
estpost summarize distw migrant_stock migration_intensity from_gdp_usd to_gdp_usd /// 
          gdp_similarity trade_openness
estimates store key_covariates
esttab key_covariates using "results/tables/key_covariates.csv", ///
       cells("count mean sd min max") noobs nonumbers nomtitles plain replace
		  
* Dummy variables 
tabulate contig
tabulate comlang_off
tabulate comlang_ethno
tabulate colony
tabulate comcol
tabulate curcol
tabulate col45
tabulate smctry
tabulate former_soviet
tabulate former_yugoslav
tabulate scandinavian
tabulate balkan
tabulate eu_membership


* Check distribution of normalised points 
tabulate norm_points if norm_points == 0
generate zero_vote = (norm_points == 0)
summarize zero_vote

histogram norm_points, frequency ///
    xtitle("Normalised Points (0-1 scale)") ///
    ytitle("Frequency") ///
    title("Distribution of Normalised Points") ///
    bin(20) ///
    ylabel(0(5000)20000, format(%9.0fc))

graph export "results/figures/norm_points_histogram.png", replace width(1200)

* Correlation matrix of continuous variables
estpost correlate norm_points distw migrant_stock migration_intensity ///
        from_log_gdp_usd to_log_gdp_usd gdp_similarity ///
        log_trade_openness, matrix casewise
esttab using "results/tables/correlation_matrix.csv", ///
       unstack not noobs nonumbers nomtitles plain replace

********************************************************************************
**##4. BASELINE REGRESSIONS
********************************************************************************
* Model (1): Baseline Cultural Gravity
reghdfe norm_points distw contig comlang_off colony, ///
        absorb(year from_country_id to_country_id) vce(robust)
estimates store model_1

* Model (2): Economic & Size Controls
reghdfe norm_points distw contig comlang_off colony from_log_gdp_usd ///
        to_log_gdp_usd gdp_similarity log_trade_openness, ///
		absorb(year from_country_id to_country_id) vce(robust)
estimates store model_2

* Model (3): Migration
reghdfe norm_points distw contig comlang_off colony from_log_gdp_usd ///
        to_log_gdp_usd gdp_similarity log_trade_openness migration_intensity, ///
		absorb(year from_country_id to_country_id) vce(robust)
estimates store model_3

* Model (3b): Migration (ethnological language)
reghdfe norm_points distw contig comlang_ethno colony from_log_gdp_usd ///
        to_log_gdp_usd gdp_similarity log_trade_openness migration_intensity, ///
		absorb(year from_country_id to_country_id) vce(robust)
estimates store model_3b

* Model (3c): Migration (colony check)
reghdfe norm_points distw contig comlang_off col45 comcol smctry ///
        from_log_gdp_usd to_log_gdp_usd gdp_similarity log_trade_openness ///
		migration_intensity, absorb(year from_country_id to_country_id) vce(robust)
estimates store model_3c
		
* Model (4): The Full Model 
reghdfe norm_points distw contig comlang_off col45 ///
        from_log_gdp_usd to_log_gdp_usd gdp_similarity log_trade_openness ///
		former_soviet former_yugoslav scandinavian balkan eu_membership ///
		migration_intensity, absorb(year from_country_id to_country_id) vce(robust)
estimates store model_4

* Model (4a): The Full Model (Jury Points)
reghdfe jury_points distw contig comlang_off col45 ///
        from_log_gdp_usd to_log_gdp_usd gdp_similarity log_trade_openness ///
		former_soviet former_yugoslav scandinavian balkan eu_membership ///
		migration_intensity, absorb(year from_country_id to_country_id) vce(robust)
estimates store model_4a
		
* Model (4b): The Full Model (Tele Points)
reghdfe tele_points distw contig comlang_off col45 ///
        from_log_gdp_usd to_log_gdp_usd gdp_similarity log_trade_openness ///
		former_soviet former_yugoslav scandinavian balkan eu_membership ///
		migration_intensity, absorb(year from_country_id to_country_id) vce(robust)
estimates store model_4b

********************************************************************************
**##5. ROBUSTNESS CHECKS
********************************************************************************
* UNDESA vs Eurostat vs Missing Check
reghdfe norm_points distw contig comlang_off col45 ///
        from_log_gdp_usd to_log_gdp_usd gdp_similarity log_trade_openness ///
		former_soviet former_yugoslav scandinavian balkan eu_membership ///
		migration_intensity if migration_source == "UN_DESA", ///
		absorb(year from_country_id to_country_id) vce(robust)
estimates store UNDESA_check

reghdfe norm_points distw contig comlang_off col45 ///
        from_log_gdp_usd to_log_gdp_usd gdp_similarity log_trade_openness ///
		former_soviet former_yugoslav scandinavian balkan eu_membership ///
		migration_intensity if migration_source == "Eurostat", ///
		absorb(year from_country_id to_country_id) vce(robust)
estimates store eurostat_check
		
*Migration Stock Check
reghdfe norm_points distw contig comlang_off col45 ///
        from_log_gdp_usd to_log_gdp_usd gdp_similarity log_trade_openness ///
		former_soviet former_yugoslav scandinavian balkan eu_membership ///
		migrant_stock, absorb(year from_country_id to_country_id) vce(robust)
estimates store migrant_check

* Tobit check
tobit norm_points distw contig comlang_off col45 ///
      from_log_gdp_usd to_log_gdp_usd gdp_similarity log_trade_openness ///
	  former_soviet former_yugoslav scandinavian balkan eu_membership ///
	  migration_intensity, ll(0)
estimates store tobit_check
	  
* Restricted time sample
reghdfe norm_points distw contig comlang_off col45 ///
        from_log_gdp_usd to_log_gdp_usd gdp_similarity log_trade_openness ///
		former_soviet former_yugoslav scandinavian balkan eu_membership ///
		migration_intensity if year >= 2000, ///
		absorb(year from_country_id to_country_id) vce(robust)
estimates store time_check

* Big 5 Removal check
reghdfe norm_points distw contig comlang_off col45 ///
        from_log_gdp_usd to_log_gdp_usd gdp_similarity log_trade_openness ///
                former_soviet former_yugoslav scandinavian balkan eu_membership ///
                migration_intensity ///
                if !inlist(to_country_id, "FRA", "DEU", "ITA", "ESP", "GBR"), ///
                absorb(year from_country_id to_country_id) vce(robust)
estimates store big5_check
	
*Balkan check excluding former_yugoslav
reghdfe norm_points distw contig comlang_off col45 ///
        from_log_gdp_usd to_log_gdp_usd gdp_similarity log_trade_openness ///
                former_soviet scandinavian balkan eu_membership ///
                migration_intensity, ///
                absorb(year from_country_id to_country_id) vce(robust)
estimates store balkan_check

********************************************************************************
**##6. Extract Data
********************************************************************************
esttab model_1 model_2 model_3 model_4 using "results/tables/main_regression.csv", ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_within, labels("Observations" "Within R-Squared")) ///
    mtitles("Model 1" "Model 2" "Model 3" "Model 4") ///
    nogaps replace
	
esttab model_4 model_4a model_4b using "results/tables/vote_regression.csv", ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_within, labels("Observations" "Within R-Squared")) ///
    mtitles("Normalised Points" "Jury Points" "Televote Points") ///
    nogaps replace
	
* Model 4 re-run for fixed effects extraction
reghdfe norm_points distw contig comlang_off col45 ///
        from_log_gdp_usd to_log_gdp_usd gdp_similarity log_trade_openness ///
        former_soviet former_yugoslav scandinavian balkan eu_membership ///
        migration_intensity, absorb(year from_country_id to_country_id) ///
        vce(robust) resid

* Extract fixed effects
predict double xb_total, xbd
predict double xb_covariates, xb
gen double fixed_effects = xb_total - xb_covariates

* Export
keep from_country_id to_country_id year fixed_effects
export delimited using "results/tables/fixed_effects.csv", replace

