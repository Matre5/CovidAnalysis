SELECT *
FROM Portfolio_Data..CovidDeaths_New
WHERE continent is not null
ORDER BY 3,4

--SELECT *
--FROM Portfolio_Data..CovidVac
--ORDER BY 3,4

SELECT location, date, population, total_cases, new_cases, total_deaths
FROM Portfolio_Data..CovidDeaths_New
WHERE continent is not null

--Total cases vs Total Deaths per location
SELECT location, SUM(total_cases) AS Total_Cases, SUM(total_deaths) AS Total_Deaths
FROM Portfolio_Data..CovidDeaths_New
WHERE continent is not null
GROUP BY location
ORDER BY 1

--percentage of infected population in respect to the whole population in africa
--Shows the likelihood of dying at that time from coronavirus
SELECT location, date,population,total_cases,total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage, (total_cases/population)*100 AS InfectedPercentage
FROM Portfolio_Data..CovidDeaths_New
WHERE location LIKE '%Nigeria%'

SELECT location, date,population,total_cases, (total_cases/population)*100 AS InfectedPercentage
FROM Portfolio_Data..CovidDeaths_New
WHERE location LIKE '%state%'

--showing the country with the highest Case recorded from the dataset 
SELECT location,population ,MAX(total_cases) AS HighestCaseRecorded, MAX((total_cases/population))*100 AS InfectedPercentage
FROM Portfolio_Data..CovidDeaths_New
WHERE continent is not null
GROUP BY location, population
ORDER BY HighestCaseRecorded DESC

-- showing the country with the highest percent of the polpulation infected
SELECT location,population, MAX((total_cases/population))*100 AS InfectedPercentage
FROM Portfolio_Data..CovidDeaths_New
WHERE continent is not null
GROUP BY location, population
ORDER BY InfectedPercentage DESC

--showing the country with the highest percent of deaths
SELECT location,population,MAX(total_deaths) AS DeathCasesRecorded,MAX((total_deaths/population))*100 AS DeathPercentage
FROM Portfolio_Data..CovidDeaths_New
WHERE continent is not null
GROUP BY location, population
ORDER BY DeathCasesRecorded DESC

--showing the deaths per continent
SELECT location,MAX(total_deaths) AS DeathCasesRecorded,MAX((total_deaths/population))*100 AS DeathPercentage
FROM Portfolio_Data..CovidDeaths_New
WHERE continent is null
GROUP BY location
ORDER BY DeathCasesRecorded DESC

--Displaying the continent with the highest death count


--GLOBAL NUMBERS
--Death case daily , infection cases daily and death percentage daily
SELECT date, SUM(new_cases) AS CasesPerDay_Globally, SUM(new_deaths) AS DeathsPerDay_Globally, (SUM(new_deaths)/SUM(new_cases))*100 AS DeathPercentageDaily_Globally
FROM Portfolio_Data..CovidDeaths_New
WHERE continent is not null
GROUP BY date
ORDER BY 1

--Total numbers
SELECT SUM(new_cases) AS TotalCases_Globally, SUM(new_deaths) AS Totaldeaths_Globally, (SUM(new_deaths)/SUM(new_cases))*100 AS DeathPercentage_Globally
FROM Portfolio_Data..CovidDeaths_New
WHERE continent is not null
ORDER BY 1

--Total numbers
SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM Portfolio_Data..CovidDeaths_New
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

--JOINING OUR TWO TABLES TOGETHER
SELECT *
FROM Portfolio_Data ..CovidDeaths_New dea
JOIN Portfolio_Data ..CovidVac vac
	ON dea.location = vac.location
	and dea.date = vac.date

--number of population vaccinated per location and date
SELECT dea.continent, dea.location,dea.population, dea.date, vac.new_vaccinations --MAX(population) AS Population, MAX(people_vaccinated) AS No_of_people_vaccinated, (MAX(population)/MAX(people_vaccinated))*100 AS PercenatgeVaccinated
FROM Portfolio_Data ..CovidDeaths_New dea
JOIN Portfolio_Data ..CovidVac vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--GROUP BY dea.location
ORDER BY 2


--Percentage of vaccination per population in each location
SELECT dea.location,MAX(population) AS Population, MAX(people_vaccinated) AS No_of_people_vaccinated, (MAX(people_vaccinated)/MAX(population))*100 AS PercenatgeVaccinated
FROM Portfolio_Data ..CovidDeaths_New dea
JOIN Portfolio_Data ..CovidVac vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
GROUP BY dea.location
ORDER BY PercenatgeVaccinated DESC



--Using a CTE
WITH Population_Vac (continent, location, popluation, date, new_vaccinations, VaccinationSum)
as
(
SELECT dea.continent, dea.location,dea.population, dea.date, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS VaccinationSum
--, VaccinationSum
FROM Portfolio_Data ..CovidDeaths_New dea
JOIN Portfolio_Data ..CovidVac vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--GROUP BY dea.location
--ORDER BY 2,3
)

SELECT *, ((VaccinationSum/popluation) *100) AS Percentage_Vaccinated_In_population
FROM Population_Vac

--Using a Temp table
DROP TABLE IF EXISTS #PercentPopVaccinated
CREATE TABLE #PercentPopVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Population numeric,
Date datetime,
New_Vaccination numeric,
VaccinationSum numeric
)

INSERT INTO #PercentPopVaccinated
SELECT dea.continent, dea.location,dea.population, dea.date, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS VaccinationSum
--, VaccinationSum
FROM Portfolio_Data ..CovidDeaths_New dea
JOIN Portfolio_Data ..CovidVac vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--GROUP BY dea.location
--ORDER BY 2,3
SELECT *, ((VaccinationSum/Population) *100) AS Percentage_Vaccinated_In_population
FROM #PercentPopVaccinated


--CREATING OUR VIEWS TO BE VISUALIZED LATER
CREATE VIEW PercentPopVaccinated AS
SELECT dea.continent, dea.location,dea.population, dea.date, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS VaccinationSum
--, VaccinationSum
FROM Portfolio_Data ..CovidDeaths_New dea
JOIN Portfolio_Data ..CovidVac vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3


CREATE VIEW WorldDeathCount AS
SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM Portfolio_Data..CovidDeaths_New
WHERE continent is not null
GROUP BY continent


CREATE VIEW DailyRecords AS
SELECT date, SUM(new_cases) AS CasesPerDay_Globally, SUM(new_deaths) AS DeathsPerDay_Globally, (SUM(new_deaths)/SUM(new_cases))*100 AS DeathPercentageDaily_Globally
FROM Portfolio_Data..CovidDeaths_New
WHERE continent is not null
GROUP BY date

CREATE VIEW NigeriaDailyRecordsAndPercentages AS
SELECT location, date,population,total_cases,total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage, (total_cases/population)*100 AS InfectedPercentage
FROM Portfolio_Data..CovidDeaths_New
WHERE location LIKE '%Nigeria%' 