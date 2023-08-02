
SELECT *
FROM CovidDeaths
WHERE continent is not NULL
ORDER BY 3,4;

-- Select the data that we going to be using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
WHERE continent is not NULL
ORDER BY 1,2;

-- Looking at Total Cases vs Total Deaths
--Shows the likelihood of dying if you contract Covid in your Country
SELECT date,total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidDeaths
WHERE location like '%Russia%' and continent is not null
ORder by 1,2;

--Looking at Total Cases vs Population
--Shows what percentage of population got Covid
SELECT location,date,total_cases, population, (total_cases/population)*100 as PercentofPopulationInfected
FROM CovidDeaths
ORder by 1,2;

--What country has the highest infection rate compared to population
SELECT location,population,max(total_cases) as HighestInfectionCount, max(total_cases/population)*100 as PercentofPopulationInfected
FROM CovidDeaths
GROUP BY location, population
order by PercentofPopulationInfected desc;

---LET'S break thing down by continent



---Showing the countries with the highest death count per population
SELECT location, max(cast(total_deaths as int)) as TotalDeathCount
FROM CovidDeaths
WHERE continent is not NULL
GROUP BY location
order by TotalDeathCount desc;

--Showing the continents with the Highest death count
SELECT continent, max(cast(total_deaths as int)) as TotalDeathCount
FROM CovidDeaths
WHERE continent is  not NULL
GROUP BY continent
order by TotalDeathCount desc;

-- Global numbers
SELECT date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, (SUM(new_deaths)/SUM(new_cases))*100 as DeathPercentage
FROM CovidDeaths
WHERE continent is not null
--group by date
ORder by 1,2;




--Looking at Total Population vs Vaccinations
--Temp Table
DROP Table if exists PercentPopulationvaccinated
CREATE temp table PercentPopulationvaccinated (
    Continent nvarchar(255), Location nvarchar(255), Date datetime, Population numeric,
    New_vaccinations numeric, RollingPeopleVaccinated numeric);

Insert into PercentPopulationvaccinated
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
       sum(cv.new_vaccinations)
           over (partition by cd.location order by cd.location, cd.date) as RollingPeopleVaccinated
FROM CovidDeaths cd
JOIN CovidVaccinations cv
ON cd.location= cv.location
and cd.date = cv.date
WHERE cd.continent is not null;

SELECT *, (RollingPeopleVaccinated/PercentPopulationvaccinated.Population)*100 as PercentPopulationvaccinated
FROM PercentPopulationvaccinated;

--creating a view to store data for later visualizations
create view PercentPopulationvaccinated as
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
       sum(cv.new_vaccinations)
           over (partition by cd.location order by cd.location, cd.date) as RollingPeopleVaccinated
FROM CovidDeaths cd
JOIN CovidVaccinations cv
ON cd.location= cv.location
and cd.date = cv.date
WHERE cd.continent is not null;

Select *
FROM PercentPopulationvaccinated

