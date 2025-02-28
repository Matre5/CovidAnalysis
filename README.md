# COVID-19 Data Analysis Using SQL

## Overview
This project contains SQL queries used to analyze the impact of COVID-19 across different countries and continents. 

The analysis covers various aspects, such as infection rates, death rates, vaccination progress, and continent-wide trends. 

The dataset is open sourced.

## Key Analyses
### 1. General Exploration
- Extracts all records from the `CovidDeaths_New` table while excluding null continents.
- Orders results by date and location.

### 2. Total Cases vs. Total Deaths
- Summarizes total COVID-19 cases and total deaths for each location.
- Helps determine the severity of the virus per country.

### 3. Infection and Death Percentages
- Calculates the percentage of the population infected.
- Determines the likelihood of dying after contracting the virus.
- Focuses on specific countries like Nigeria and the United States.

### 4. Highest Recorded Cases and Deaths
- Identifies the country with the highest number of cases.
- Determines the country with the highest infection percentage.
- Highlights the location with the most COVID-19 deaths.

### 5. Deaths Per Continent
- Displays the total death count per continent.
- Identifies the continent with the highest death toll.

### 6. Global COVID-19 Trends
- Shows daily new cases and deaths worldwide.
- Calculates the global daily death percentage.
- Aggregates total cases, deaths, and mortality rates worldwide.

### 7. Vaccination Analysis
- Joins `CovidDeaths_New` and `CovidVac` to analyze vaccination trends.
- Displays the number of vaccinations per country and per day.
- Calculates the percentage of vaccinated people in each location.

### 8. Advanced SQL Techniques
- **Common Table Expressions (CTE):** Tracks cumulative vaccinations per country.
- **Temporary Tables:** Stores vaccination data to facilitate further calculations.
- **Views:** Creates reusable queries for visualization in BI tools.

## SQL Queries Used
- `SELECT`, `JOIN`, `GROUP BY`, `ORDER BY`, `SUM()`, `MAX()`, `AVG()`
- `WITH` (for CTEs), `CREATE VIEW` (for reusable queries)
- `DROP TABLE`, `CREATE TABLE`, `INSERT INTO` (for temporary tables)

## How to Use
1. Ensure you have a SQL database containing the `CovidDeaths_New` and `CovidVac` tables.
2. Run the queries sequentially in a SQL environment like MySQL, PostgreSQL, or SQL Server.
3. Modify the queries to filter by specific countries or regions as needed.

## License
This project is open-source and licensed under the **MIT License**.
