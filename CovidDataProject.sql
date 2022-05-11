Select * 
From PortfolioProject..CovidDeaths
where continent is not Null
order by 3,4



--Select * 
--From PortfolioProject..CovidVaccinations
--order by 3,4


Select location,date,total_cases,new_cases,total_deaths,population
From PortfolioProject..CovidDeaths
order by 1,2


--Shows Total Cases vs Total Deaths

Select location,date,total_cases,total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
From PortfolioProject..CovidDeaths
order by 1,2

--Shows likelihood of dying of Covid in India
Select location,date,total_cases,total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location like '%india%'
order by 1,2

--Shows Total Cases vs Population

Select location, date, population ,total_cases, (total_cases/population) * 100 as CovidPercentage
From PortfolioProject..CovidDeaths
where location like '%india%'
order by 1,2

--Countries with highest infection rate compared to population

Select location,population, MAX(total_cases) as HighestCovidInfection, Max((total_cases/population))* 100 as CovidPercentage
From PortfolioProject..CovidDeaths
--where location like '%india%'
Group by location,population
order by CovidPercentage desc

--Showing the countries with highest death count wrt total population
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not Null
Group by location
order by TotalDeathCount desc

-- Breaking down with continent

--Continents with highest death rate
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not Null
Group by continent
order by TotalDeathCount desc

--Global Numbers

--Percentage of Death by Cases & Deaths on daily basis
Select date,SUM(new_cases) as TotalCasesDaily, Sum(cast(new_deaths as int)) as NewDeathsDaily, Sum(cast(new_deaths as int))/Sum(new_cases) *100 as PercentageOfDeath
From PortfolioProject..CovidDeaths
where continent is not Null
group by date
order by 1,2

--Percentage of World
Select SUM(new_cases) as TotalCasesDaily, Sum(cast(new_deaths as int)) as NewDeathsDaily, Sum(cast(new_deaths as int))/Sum(new_cases) *100 as PercentageOfDeath
From PortfolioProject..CovidDeaths
where continent is not Null
--group by date
order by 1,2


--Covid Vaccination
-- Looking at Total Population vs Vaccinations
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(new_vaccinations as bigint)) OVER 
(Partition by dea.location 
Order by dea.location, dea.date) as TotalPeopleVaccinated
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- Using CTE

With PopvcVac (Continent, location, date, population, new_vaccinations,TotalPeopleVaccinated)
as 
(
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(new_vaccinations as bigint)) OVER 
(Partition by dea.location Order by dea.location, dea.date) as TotalPeopleVaccinated
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (TotalPeopleVaccinated/population) * 100 as PercentageofVaccination
From PopvcVac
order by 1,2

Create View PercentageofVaccination as
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(new_vaccinations as bigint)) OVER 
(Partition by dea.location Order by dea.location, dea.date) as TotalPeopleVaccinated
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentageofVaccination



