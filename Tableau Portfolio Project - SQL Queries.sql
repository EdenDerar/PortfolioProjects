/*

Quries fo tablue project

*/

--1.
SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int)) AS total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases) * 100 AS DeathPercentage
FROM [Portofolio Project].dbo.CovidDeaths
--WHERE location like '%States%'
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2


-- 2. 

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From [Portofolio Project].dbo.CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

--3.
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM [Portofolio Project].dbo.CovidDeaths
--Where location like '%states%'
Group by location, population
Order by PercentPopulationInfected DESC

--4.
Select Location, Population, date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Portofolio Project].dbo.CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc







