--select * from CovidVaccinations
---select * from CovidDeaths



--Looking at the Total Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
from covidDeaths dea
join covidvaccinations vac
on dea.location = vac.location
and 
dea.date = vac.date
where dea.continent  is not null
order by 2,3

---looking at total population vs sum of all vaccinations, partition by location

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations )) OVER(PARTITION BY dea.Location) [sum of all vaccinations]
from covidDeaths dea
join covidvaccinations vac
on dea.location = vac.location
and 
dea.date = vac.date
where dea.continent  is not null
order by 2,3

---looking at total population vs sum of all vaccinations, rolling count

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations )) OVER(PARTITION BY dea.Location order by dea.date) [rolling people vaccinated]
from covidDeaths dea
join covidvaccinations vac
on dea.location = vac.location
and 
dea.date = vac.date
where dea.continent  is not null
order by 2,3 


--using CTE (total population vs sum of all vaccinations, rolling count)

WITH POPVSVAC (continent, location, date, population, new_vaccinations, [rolling people vaccinated])
AS
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations )) OVER(PARTITION BY dea.Location order by dea.date) [rolling people vaccinated]
from covidDeaths dea
join covidvaccinations vac
on dea.location = vac.location
and 
dea.date = vac.date
where dea.continent  is not null
)

SELECT *, ([ROLLING PEOPLE VACCINATED]/POPULATION) *100
FROM POPVSVAC

--using TEMP TABLE (total population vs sum of all vaccinations, rolling count)

drop table #PercentPopulationVaccinated

CREATE TABLE #PercentPopulationVaccinated
(
Continent nVarchar(255),
Location nVarchar(255),
Date Datetime,
Population Numeric,
New_vaccinations Numeric,
[rolling people vaccinated] Numeric
)
insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations )) OVER(PARTITION BY dea.Location order by dea.date) [rolling people vaccinated]
from covidDeaths dea
join covidvaccinations vac
on dea.location = vac.location
and 
dea.date = vac.date
where dea.continent  is not null

SELECT *, ([ROLLING PEOPLE VACCINATED]/POPULATION) *100
FROM #PercentPopulationVaccinated


----using ViEWS (total population vs sum of all vaccinations, rolling count)
----creating views to store data for later visualization

CREATE VIEW VwPercentPopulationVaccinated
as

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations )) OVER(PARTITION BY dea.Location order by dea.date) [rolling people vaccinated]
from covidDeaths dea
join covidvaccinations vac
on dea.location = vac.location
and 
dea.date = vac.date
where dea.continent  is not null

select * from VwPercentPopulationVaccinated

