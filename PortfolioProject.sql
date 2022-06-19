use PortfolioProject;
select *
FROM coviddeathss
where continent is not null;
-- Select Data that we are going to be using 

SELECT Location, date, total_cases,new_cases,total_deaths, population
FROM PortfolioProject.coviddeathss
order by location, date; 


-- Looking at Total Cases vs Total Deaths 
-- shows likelihood of dying if you contract covid in your country

SELECT Location, date, total_cases,total_deaths, Round((total_deaths/total_cases)*100,2) as DeathPercentage
FROM PortfolioProject.coviddeathss
Where location like'%states%'
order by location, date; 

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

SELECT Location, date, population,total_cases, Round((total_cases/population)*100,2) as Percent_of_population_infected
FROM PortfolioProject.coviddeathss
-- Where location like '%states%'
order by total_cases; 

-- Looking at Countries with Highest Infeciton Rate compared to Population 

SELECT Location, population, MAX(total_cases) as Highest_Infection_Count, MAX(Round((total_cases/population)*100,2)) as Percent_of_population_infected
FROM PortfolioProject.coviddeathss
GROUP BY 
Location, population
-- HAVING Location like '%states%'
order by Percent_of_population_infected desc; 

-- Showing Countries with highest death count per population 

SELECT Location, MAX(cast(Total_deaths as unsigned)) as TotalDeathCount
FROM PortfolioProject.coviddeathss
where continent <> ''
GROUP BY Location
-- HAVING Location like '%states%'
order by TotalDeathCount desc; 

-- Lets break things down by continent

--  Showwing the continents with the highest death count 

SELECT continent, MAX(cast(Total_deaths as unsigned)) as TotalDeathCount
FROM PortfolioProject.coviddeathss
where continent <> ''
GROUP BY continent 
-- HAVING Location like '%states%'
order by TotalDeathCount desc;  
-- Global Numbers

SELECT  SUM(new_cases) as total_cases, SUM(cast(new_deaths as signed)) as total_deaths, SUM(cast(new_deaths as signed)) / SUM(cast(new_cases as signed))*100 as DeathPercentage
FROM PortfolioProject.coviddeathss
-- Where location like'%states%'
where continent <> ''
order by date desc;



-- Looking at Total Populaiton vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,sum(cast(vac.new_vaccinations as signed)) 
over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM 
coviddeathss dea
JOIN 
covidvaccinationss vac on dea.location = vac.location 
and dea.date = vac.date
where dea.continent <> ''
order by 2,3;

-- USE CTE

with PopvsVac (Continent, Location, Date, population ,new_vaccinations, RollingPeopleVaccinated)
as 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,sum(cast(vac.new_vaccinations as signed)) 
over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM 
coviddeathss dea
JOIN 
covidvaccinationss vac on dea.location = vac.location 
and dea.date = vac.date
where dea.continent <> ''
)
 SELECT *, (RollingPeopleVaccinated/population)*100
 FROM 
 PopvsVac;


-- Temp Table 
DROP Table if exists PercentPopulationVaccinated;
CREATE TABLE PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
);

Insert IGNORE INTO PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,sum(cast(vac.new_vaccinations as signed)) 
over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM 
coviddeathss dea
JOIN 
covidvaccinationss vac on dea.location = vac.location 
and dea.date = vac.date
where dea.continent <> '';

 SELECT *, (RollingPeopleVaccinated/population)*100
 FROM 
 PercentPopulationVaccinated;


-- Creating View to store data fro later visualizations

CREATE VIEW  PercentPopulationVaccinatedd as 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,sum(cast(vac.new_vaccinations as signed)) 
over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM 
coviddeathss dea
JOIN 
covidvaccinationss vac on dea.location = vac.location 
and dea.date = vac.date
where dea.continent <> ''; 

SELECT *
FROM PercentPopulationVaccinated;

