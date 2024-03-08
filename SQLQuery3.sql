--SELECT * 
--FROM [Portofolio Project].dbo.CovidDeaths
--WHERE continent is not null
--ORDER BY 3,4

--SELECT * 
--FROM [Portofolio Project].dbo.CovidVaccinations
--ORDER BY 3,4

-- SELECT DATA THAT WE ARE GOING TO BE USING
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [Portofolio Project].dbo.CovidDeaths
WHERE continent is not null
ORDER BY 1,2

--TOTAL CASES VS TOTAL DEATHS
--SHOWS THE LIKELIHOOD OF DYING IN EACH COUNTRY
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM [Portofolio Project].dbo.CovidDeaths
WHERE location like '%States%'
and continent is not null
ORDER BY 1,2


--LOOKING AT THE TOTAL CASES VS POPULATION
--SHOWS PERCENTAGE OF POPULATION THAT GOT COVID
SELECT location, date, population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
FROM [Portofolio Project].dbo.CovidDeaths
WHERE location like '%States%'
and continent is not null
ORDER BY 1,2

--LOOKING AT COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM [Portofolio Project].dbo.CovidDeaths
WHERE continent is not null
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

--SHOWING COUNTRIES WITH  HIGHEST DEATH COUNT PER POPULATION
SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM [Portofolio Project].dbo.CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC

--LETS BREAK THINGS DOWN BY CONTINENTS 
--CONTINENTS WITH  HIGHEST DEATH COUNT PER POPULATION
SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM [Portofolio Project].dbo.CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

--GLOBAL NUMBERS
SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int)) AS total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases) * 100 AS DeathPercentage
FROM [Portofolio Project].dbo.CovidDeaths
--WHERE location like '%States%'
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2

SELECT * 
FROM [Portofolio Project].dbo.CovidVaccinations
ORDER BY 3,4

--LOOKING AT TOTAL POPULATION VS VACCINATION
--SHOWS THE PERCENTAGE OF POPULATION THAT HAVE RECEIVED AT LEAST ONE COVID VACCINE
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM (Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order By dea.Location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM [Portofolio Project].dbo.CovidDeaths dea
JOIN [Portofolio Project].dbo.CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3


--USE CTE, TO PERFORM CALCULATION ON PARTITION BY
WITH PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM (Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order By dea.Location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM [Portofolio Project].dbo.CovidDeaths dea
JOIN [Portofolio Project].dbo.CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)
SELECT * ,(RollingPeopleVaccinated/population)*100
FROM PopvsVac


--TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric,
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM (Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order By dea.Location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM [Portofolio Project].dbo.CovidDeaths dea
JOIN [Portofolio Project].dbo.CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
--WHERE dea.continent is not null
--ORDER BY 2,3
SELECT * ,(RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated


--CREATEING VIEW TO STORE DATA FOR LATER VISUALIZATION

Create View PercentPopulationVaccinateed as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM (Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order By dea.Location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM [Portofolio Project].dbo.CovidDeaths dea
JOIN [Portofolio Project].dbo.CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--ORDER BY 2,3

SELECT * 
FROM PercentPopulationVaccinated

















