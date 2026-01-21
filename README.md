# UEFA Champions League End-to-End Analytics Project

## Project Overview
This project demonstrates a complete data analytics pipeline using UEFA Champions League data,
from raw datasets to interactive Power BI dashboards.

## Data Pipeline
1. Raw CSV datasets collected from public sources
2. Data cleaning and transformation using Python (cleaning.ipynb)
3. Cleaned datasets exported for database ingestion
4. Dimensional data modeling using SQL (fact and dimension tables)
5. Analytical SQL queries
6. Interactive dashboards built in Power BI

## Data Cleaning
- Performed in Jupyter Notebook (`cleaning.ipynb`)
- Handled missing values, duplicates, and naming inconsistencies
- Standardized columns across datasets

## Data Modeling
- Star / constellation schema
- Fact tables: player goals, player appearances, club performance, coach appearances, season statistics
- Dimension tables: player, club, coach, season

## Analytics & Visualization
- SQL analytics queries for insights
- Power BI dashboards:
  - Executive Overview
  - Club Performance
  - Player Analysis
  - Coach Analysis
  - Season Trends

## Tools & Technologies
- Python (Pandas)
- SQL (MySQL)
- Power BI
- GitHub

## Repository Structure
- `/data/raw` → original datasets
- `/data/cleaned` → cleaned datasets
- `/notebooks` → data cleaning notebook
- `/sql` → data modeling & analytics queries
- `/powerbi` → Power BI report
- `/screenshots` → dashboard images
- `/data_model` → schema diagram

## How to Run
1. Run `cleaning.ipynb` to generate cleaned datasets
2. Load cleaned data into MySQL
3. Execute `Data Modelling.sql` to create tables
4. Use `SQl Analytics.sql` for insights
5. Open `.pbix` file in Power BI Desktop
