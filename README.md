# Eurovision Voting & Economic Proximity: A Gravity Model Analysis
A two-stage project: a bilateral panel dataset of Eurovision Song Contest voting (1957–2026) combining geographic, 
economic, migration and trade variables, followed by regression analysis testing whether cultural and economic proximity
predicts voting patterns.

## Overview
Eurovision voting has long been suspected of reflecting politics as much as musical merit — whether that's voting blocs 
like Greece and Cyprus notoriously awarding each other maximum points, or backlash: is the UK's history of null points a
matter of public dislike or simply poor entries? This project investigates whether the song contest reflects something 
deeper than who has the best song: the extent to which voting across the contest's history reflects economic and 
cultural proximity between countries. 

Using an augmented gravity model framework — typically applied to trade flows — adapted for cultural exchange, a 
bilateral panel dataset is constructed to test whether factors such as shared languages, diaspora communities, and 
common cultural histories predict bilateral voting patterns. The gravity framework posits that bilateral interaction 
increases with the economic mass of two entities and decreases with the friction between them. Applied here, GDP proxies
for mass: larger economies plausibly support stronger music industries and greater broadcasting capacity. Geographic 
distance and cultural variables capture friction reflecting the barriers to cultural transmission and differing social 
affinities.

The analysis builds on previous literature, notably Ginsburgh & Noury (2008) who find no evidence of vote-trading within
the contest but cannot rule out cultural voting, producing a panel dataset of 38,781 directed voting observations 
(though covariate availability restricts the regression sample to a subset of these years). Stata is then used to 
estimate the regression models, with full results and discussion documented in 
[`results-writeup.md`](./results/results-writeup.md). Finally, these estimates are integrated into an interactive Excel 
dashboard [`03-eurovision-counterfactual-dashboard.xlsx`](./03-eurovision-counterfactual-dashboard.xlsx), creating an accessible tool for testing counterfactual 
scenarios and exploring the isolated impacts of individual covariates.

## Dataset Summary
The core dataset is a directed bilateral panel of Eurovision Song Contest votes spanning 1957–2026, comprising 38,781 
country-pair-year observations merged from two manually compiled datasets and six external sources across geographic, 
economic, migration and trade databases detailed within the data sources section below. These observations span 49
columns which are summarised below:

| Category     | Variables                                                                                                                                                                                    | Count  | Notes                                                                                                                                                                                                                 |
|--------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Identifiers  | <ul><li>Year</li><li>From Country</li><li>To Country</li><li>Country Pair ID</li><li>Numerical ID</li><li>Voting Regime</li></ul>                                                            | 6      | Voting regime captures maximum points available, since the scoring system has changed over the contest's history                                                                                                      |
| Outcome      | <ul><li>Total Points</li><li>Televote Points</li><li>Jury Points</li><li>Normalised Points</li></ul>                                                                                         | 4      | Since 2016 votes have been split between a public televote and jury panel. Normalised points rescales votes to 0–1 to allow comparison across voting regimes                                                          |
| Geographic   | <ul><li>Shared Border Status</li><li>Weighted Bilateral Distance</li></ul>                                                                                                                   | 2      | Weighted bilateral distance is calculated between the biggest cities of each country, weighted by each city's share of national population                                                                            |
| Linguistic   | <ul><li>Shared Official Language Status</li><li>Shared Ethnological Language Status</li></ul>                                                                                                | 2      | Ethnological language defined as spoken by at least 9% of the population in both countries                                                                                                                            |
| Colonial     | <ul><li>Colonial Link</li><li>Common Coloniser after 1945</li><li>Colonial Relationship since 1945</li><li>Current Colonial Relationship</li><li>Historically Same Country</li></ul>         | 5      | Common coloniser after 1945 tends to capture shared imperial legacy (e.g. former British mandate territories) rather than traditional colonialism in the Eurovision sample                                            |
| Geopolitical | <ul><li>Former Soviet (To/From/Shared)</li><li>Former Yugoslav (To/From/Shared)</li><li>Scandinavian (To/From/Shared)</li><li>Balkan (To/From/Shared)</li><li>EU Membership Shared</li></ul> | 13     | Scandinavian bloc: Denmark, Finland, Iceland, Norway, Sweden. Balkan bloc: Albania, Bosnia, Bulgaria, Croatia, Greece, North Macedonia, Montenegro, Romania, Serbia, Slovenia, Turkey. UK coded as leaving EU in 2016 |
| GDP          | <ul><li>GDP (To/From)</li><li>GDP per Capita (To/From)</li><li>Log GDP (To/From)</li><li>Log GDP per Capita (To/From)</li><li>GDP Similarity</li></ul>                                       | 9      |                                                                                                                                                                                                                       |
| Migration    | <ul><li>Migrant Stock</li><li>Migration Intensity</li><li>Voting Country Population</li><li>Migration Dataset Source</li></ul>                                                               | 4      | Voting country population is included as a denominator for migration intensity but may be used independently as a control variable                                                                                    |
| Trade        | <ul><li>Bilateral Trade</li><li>Trade Openness</li><li>Log Trade Openness</li><li>Log Bilateral Trade</li></ul>                                                                              | 4      |                                                                                                                                                                                                                       |
| **Total**    |                                                                                                                                                                                              | **49** |                                                                                                                                                                                                                       |


## Data Sources

| Dataset                                                           | Provider         | Coverage  | Link                                                                                 | Citation                                                                                                                                                   |
|-------------------------------------------------------------------|------------------|-----------|--------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Eurovision Dataset                                                | Janne Spijkervet | 1957–2023 | [DOI](https://doi.org/10.5281/zenodo.4036457)                                        | Spijkervet, J. (2020). *The Eurovision Dataset* (Version 1.0) [Dataset]. Zenodo. https://doi.org/10.5281/zenodo.4036457                                    |
| Modern Eurovision Bilateral Voting Supplement                     | Author           | 2024–2026 | See repository                                                                       | —                                                                                                                                                          |
| GeoDist                                                           | CEPII            | N/A       | [Source](https://www.cepii.fr/CEPII/en/bdd_modele/bdd_modele_item.asp?id=6)          | Mayer, T. & Zignago, S. (2011). Notes on CEPII's distances measures: the GeoDist Database. CEPII Working Paper 2011-25.                                    |
| Geopolitical Dataset                                              | Author           | N/A       | See repository                                                                       | —                                                                                                                                                          |
| NGDPD (GDP)                                                       | IMF              | 1980–2031 | [Source](https://www.imf.org/external/datamapper/NGDPD@WEO/OEMDC/ADVEC/WEOWORLD)     | International Monetary Fund. (2026). *World Economic Outlook*. Washington, DC.                                                                             |
| NGDPDPC (GDP per capita)                                          | IMF              | 1980–2031 | [Source](https://www.imf.org/external/datamapper/NGDPDPC@WEO/OEMDC/ADVEC/WEOWORLD)   | International Monetary Fund. (2026). *World Economic Outlook*. Washington, DC.                                                                             |
| International Migrant Stock 2024                                  | UN DESA          | 1990–2024 | [Source](https://www.un.org/development/desa/pd/content/international-migrant-stock) | United Nations. (2024). *International Migrant Stock 2024: Key facts and figures*. UN DESA/POP/2024/DC/NO. 13.                                             |
| Immigration by age group, sex and country of birth (migr_imm3ctb) | Eurostat         | 2008–2024 | [DOI](https://doi.org/10.2908/MIGR_IMM3CTB)                                          | Eurostat. (2026). *Immigration by age group, sex and country of birth (migr_imm3ctb)* [Dataset]. European Commission. https://doi.org/10.2908/MIGR_IMM3CTB |
| SP.POP.TOTL (Population)                                          | World Bank       | 1960–2024 | [Source](https://data.worldbank.org/indicator/SP.POP.TOTL)                           | World Bank. (2024). *Population, total (SP.POP.TOTL)* [Dataset]. World Bank Open Data.                                                                     |
| BACI (202601 version)                                             | CEPII            | 1995–2024 | [Source](https://www.cepii.fr/CEPII/en/bdd_modele/bdd_modele_item.asp?id=37)         | Gaulier, G. & Zignago, S. (2010). BACI: International Trade Database at the Product-Level. The 1994-2007 Version. CEPII Working Paper N°2010-23.           |

**Note**: Raw data files are not included in this repository due to file size constraints. Source datasets must be
downloaded manually from the links above and placed in the data/raw/ folder before running the pipeline. The processed 
output file is included in data/processed/ alongside the two manually compiled datasets in the data/raw folder.
## Repository Structure
```
eurovision-gravity/
│
├── data/
│   ├── raw/
│   │   ├── eurovision/
│   │   │   └── votes-2024-2026.csv
│   │   └── blocs/
│   │       └── Euro Dummies.xlsx
│   └── processed/
│       └── eurovision_panel_1957_2026.csv
│ 
├── results/
│   ├── figures/
│   │   └── norm_points_histogram.png
│   ├── tables/
│   │   ├── correlation_matrix.csv
│   │   ├── key_covariates.csv
│   │   ├── main_regression.csv
│   │   ├── outcome_summary.csv
│   │   └── vote_regression.csv
│   ├── results_log.txt
│   └── results-writeup.md
│ 
├── 01-eurovision-data-cleaning.ipynb
├── 02-eurovision-analysis.do
├── 03-eurovision-counterfactual-dashboard.xlsm
├── requirements.txt
└── README.md
```
**Note**: Raw data files are not tracked in this repository. See Data Sources above for download links. Files should be 
placed in data/raw/ following the structure below before running the pipeline:
```
eurovision-gravity/
│
├── data/
│   ├── raw/
│   │   ├── eurovision/
│   │   │   ├── votes.csv
│   │   │   └── votes-2024-2026.csv
│   │   ├── geographic/
│   │   │   └── dist_cepii.xls
│   │   ├── gdp/
│   │   │   ├── imf-GDP.xlsx
│   │   │   └── imf-gdp-per-capita.xlsx
│   │   ├── migration/
│   │   │   ├── undesa_pd_2024_ims_stock_by_sex_destination_and_origin.xlsx
│   │   │   ├── estat_migr_imm3ctb.tsv
│   │   │   └── API_SP.POP.TOTL_DS2_en_csv_v2_267553/
│   │   │   │   ├── API_SP.POP.TOTL_DS2_en_csv_v2_267553.csv
│   │   │   │   ├── Metadata_Country_API_SP.POP.TOTL_DS2_en_csv_v2_267553.csv
│   │   │   │   └── Metadata_Indicator_API_SP.POP.TOTL_DS2_en_csv_v2_267553.csv
│   │   ├── trade/
│   │   │   └── BACI_HS92_V202601/
│   │   └── blocs/
│   │       └── Euro Dummies.xlsx
│   └── processed/
│       └── eurovision_panel_1957_2026.csv
│ 
├── results/
│   ├── figures/
│   │   └── norm_points_histogram.png
│   ├── tables/
│   │   ├── correlation_matrix.csv
│   │   ├── key_covariates.csv
│   │   ├── main_regression.csv
│   │   ├── outcome_summary.csv
│   │   └── vote_regression.csv
│   ├── results_log.txt
│   └── results-writeup.md
│
├── 01-eurovision-data-cleaning.ipynb
├── 02-eurovision-analysis.do
├── 03-eurovision-counterfactual-dashboard.xlsm
├── requirements.txt
└── README.md
```
## Dataset Methodology
The project applies an augmented gravity model following Tinbergen (1962) to Eurovision voting data, extended with 
migration stocks, linguistic similarity, colonial ties, and geopolitical bloc membership to capture cultural proximity 
beyond pure geography. Four outcome variables are constructed to capture different dimensions of voting behaviour: 
total points, jury points, televote points, and normalised points. The `voting_regime` column records the maximum 
points available in each era, allowing researchers to filter by scoring system where consistency is required.

The following structural choices were made in constructing the dataset:
- **Normalised points**: Votes received are normalised to a 0–1 scale to account for variation in the maximum points 
available across different voting regimes throughout the contest's history.
- **Brexit date**: The UK's departure from the EU is coded as 2016 — the year the referendum result was announced and 
negotiations began — rather than the legal date of 2020, on the basis that cultural and political perceptions among 
voters would have shifted at that point rather than at formal departure.
- **GDP similarity index**: A GDP similarity index ranging from 0 to 1 is constructed using log GDP, where 1 indicates 
two economies are identical in size and 0 indicates complete dominance by one economy. Log GDP is used to capture 
proportional rather than absolute differences in economic size. This allows researchers to capture whether countries 
of similar economic weight vote differently to asymmetric pairs.
- **Migration mapping**: Within the migration data, country of origin is mapped to the recipient country to test the 
diaspora hypothesis — that migrant communities resident in a voting country systematically favour their home country.
- **Migration intensity**: Migrant stock is normalised as a share of the voting country's population to contextualise 
the scale of diaspora communities relative to country size.
- **Trade openness**: A trade openness measure is constructed as bilateral trade as a share of combined GDP, 
normalising for country size. This captures genuine economic integration rather than scale effects — a large economy 
like Germany trades more in absolute terms with all partners, so raw trade flows alone would be misleading.
- Both log-transformed and level variables of GDP, GDP per capita, bilateral trade and trade openness are constructed, 
allowing the researcher to select the preferred specification in Stata.

## Requirements and Setup
The pipeline requires Python 3.9 or higher. Dependencies are limited to three packages and can be installed via:

```bash
pip install -r requirements.txt
```


The pipeline is implemented as a Jupyter notebook with a master script that runs all stages in sequence, 
producing a single CSV file output to the data/processed folder. To reproduce the dataset, open the master notebook and 
run all cells in order.

### Data sources
Raw data files must be downloaded manually from their respective providers — links and citations are provided in the
Data Sources section above. Files should be placed in the data/raw/ folder following the repository structure above 
before running the pipeline.

If using data files that have been updated after June 2026, minor code adjustments may be required (particularly
with migration data) to ensure the pipeline runs correctly.

### Using the output
The resulting [`CSV`](./data/processed/eurovision_panel_1957_2026.csv) is self-contained and can be used 
independently of the pipeline. This dataset is used to deliver the regression analysis presented in 
[`results-writeup.md`](./results/results-writeup.md), which utilised Stata as the platform to carry out the regressions. 
However, the dataset is equally compatible with Python-based econometric packages such as `statsmodels` for further 
independent analysis. Full variable definitions are documented in codebook.md (in preparation).

## Known Limitations
The effective regression sample is a subset of the full 1957–2026 panel, with coverage determined by the narrowest 
available covariate. Trade data from BACI begins in 1995, making this the binding constraint for fully specified models 
— though researchers using only geographic covariates will retain close to the complete panel. Coverage by variable is 
detailed in the data sources section.

Several countries are partially or fully dropped from the sample due to data availability. Microstates and peripheral 
participants such as Morocco have limited covariate coverage throughout. Countries that no longer exist — Yugoslavia, 
Serbia and Montenegro — have inherently sparse data reflecting their historical participation. Serbia is additionally 
missing weighted distance data due to a gap in GeoDist coverage.

As is structural to the contest, countries do not vote for themselves — the diagonal of the bilateral matrix is absent 
by design rather than data error.

Migration data is spliced across two sources — UN DESA and Eurostat — with source varying by country pair depending on 
availability. This may introduce discontinuities in migration variables across some pairs and should be accounted for 
using the `migration_source` identifier included in the dataset.

The geopolitical dataset — covering variables such as former Soviet and former Yugoslav membership — was independently 
compiled and has not been externally validated. Researchers should exercise judgement when interpreting coefficients on 
these variables.

Limitations specific to the regression analysis itself are discussed separately in 
[`results-writeup.md`](./results/results-writeup.md)

## Results
Regression analysis finds strong evidence that cultural and economic proximity — particularly diaspora communities, 
shared political history, and trade integration — predict Eurovision voting patterns, with these effects concentrated 
almost entirely within the public televote rather than the professional jury. By contrast, the role of economic mass 
(GDP) proves harder to pin down once country-level fixed effects are introduced, a finding with implications for how 
gravity-style models are applied beyond trade.

Full econometric specification, regression results, and discussion are documented in 
[`results-writeup.md`](./results/results-writeup.md). The Stata do-file used to produce these results is available at 
[`02-eurovision-analysis.do`](./02-eurovision-analysis.do).

## Excel Dashboard
An interactive Excel counterfactual dashboard is available at 
[`03-eurovision-counterfactual-dashboard.xlsx`](./03-eurovision-counterfactual-dashboard.xlsx), extending 
the regression analysis into an accessible exploratory tool.

The dashboard applies the Model 4 regression coefficients, documented in 
[`results-writeup.md`](./results/results-writeup.md), to decompose predicted normalised points for any country pair and 
year into five effect categories — geographic, cultural, economic, migration, and bloc — alongside country and year 
fixed effects extracted from the regression. Individual effect categories can be toggled on or off, allowing users to 
construct counterfactual scenarios: for example, simulating voting patterns in a world where diaspora communities play 
no role, or where geopolitical bloc membership is stripped out entirely.

A leaderboard recalculates dynamically for any selected year, comparing model-predicted rankings against actual 
historical results. The gap between predicted and actual — the residual — captures variation not explained by the model,
including unobserved factors such as musical merit.


## Citation & Acknowledgements

### Citation
If using the dataset, pipeline or results please cite as:

> Jubb, M. (2026). Eurovision Voting & Economic Proximity: A Gravity Model Analysis [Dataset, pipeline, results and dashboard]. Available at: https://github.com/maredjubb

### References
Ginsburgh, V. & Noury, A. G. (2008). The Eurovision Song Contest: Is voting political or cultural? *European Journal of Political Economy*, 24(1), 41–52. https://doi.org/10.1016/j.ejpoleco.2007.05.004

Tinbergen, J. (1962). *Shaping the World Economy: Suggestions for an International Economic Policy*. Twentieth Century Fund.


### Acknowledgements
The dataset draws on publicly available data from CEPII (GeoDist and BACI), the IMF World Economic Outlook, 
the World Bank, UN DESA, and Eurostat. Eurovision voting data is sourced from the Eurovision Dataset (Spijkervet, 2020) 
with a modern voting supplement independently compiled by the author. Full citations for all data sources are provided 
in the Data Sources section.