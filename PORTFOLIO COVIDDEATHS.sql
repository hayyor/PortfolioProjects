select * from CovidDeaths
order by 3,4



----select the data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population 
from covidDeaths
order by 1,2

--looking at the total cases vs total deaths in each country in percentage %
--shows the chances of dying if contacted covid in each country

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 [Death Percentage %]
from covidDeaths
order by 1,2

--looking at the total cases vs total deaths in a specific country in percentage %
--shows the chances of dying if contacted covid in united states

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 [Death Percentage %]
from covidDeaths
where location like '%states%'
order by 1,2


--looking at the total cases vs population 
--shows what population of percentage got covid

select location, date, population, total_cases, (total_cases/population)*100 [Death per population %]
from covidDeaths
order by 1,2

--looking at the countries with the highest infected rate compared to thier population

select location,  population, MAX(total_cases) HigestInfectionCount, MAX(total_cases/population)*100 percentPopulationInfected
from covidDeaths
group by location, population
order by percentPopulationInfected desc


---SHOWING COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION

select location, MAX(cast(TOTAL_DEATHS as int)) [HIGHEST DEATH COUNT]
from covidDeaths
where continent is not null
group by location
order by [HIGHEST DEATH COUNT] desc

--lets break it down by location with the highest death count per population

select location, MAX(cast(TOTAL_DEATHS as int)) [HIGHEST DEATH COUNT]
from covidDeaths
where continent  is null
group by location
order by [HIGHEST DEATH COUNT] desc

--lets break it down by continent with the highest death count per population

select continent, MAX(cast(TOTAL_DEATHS as int)) [HIGHEST DEATH COUNT]
from covidDeaths
where continent  is not null
group by continent
order by [HIGHEST DEATH COUNT] desc



--global WORLD deaths STATISTICS
select SUM(new_cases) as [total cases], SUM(CAST(new_deaths AS INT)) as [total deaths], SUM(cast(new_deaths as int))/
SUM(NEW_CASES) *100 [DEATH PERCENTAGE]
from covidDeaths
WHERE CONTINENT IS NOT NULL
order by 1,2
