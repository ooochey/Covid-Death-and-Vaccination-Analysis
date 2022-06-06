select location, date, total_cases, new_cases, total_deaths, population
from portfolio.coviddeaths
where continent != ''
# order by 1, 2

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as case_fatality_rate , population
from portfolio.coviddeaths
where location = 'nigeria'
order by 1, 2 asc

# Prevalence of covid in NIgeria

select location, date, population, total_cases, (total_cases/population)*100  as prevalence
from portfolio.coviddeaths
where location = 'nigeria'
order by 2 asc

# Compare highest prevalence of covid per country

select location, population, max(total_cases) as highest_cases_per_country, max((total_cases/population))*100 as prevalence_per_country
from portfolio.coviddeaths
where continent != ''
group by location, population
order by prevalence_per_country desc

# Countries with the Highest Death count per population

select location, max(total_deaths) as total_deaths_Count
from portfolio.coviddeaths
where continent != ''
group by location
order by total_deaths_Count desc

# Continents with the Highest Death count

select location, max(total_deaths) as total_deaths_Count
from portfolio.coviddeaths
where continent = ''
group by location
order by total_deaths_Count desc

# Global Numbers

select date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, (sum(new_deaths)/sum(new_cases))*100 as case_fatality_rate
from portfolio.coviddeaths
where continent != ''
group by date
order by 1


select location, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, (sum(new_deaths)/sum(new_cases))*100 as case_fatality_rate
from portfolio.coviddeaths
where continent != ''
group by location
order by 4 desc


select location, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, population, (sum(new_deaths)/population)*100 as mortality_rate
from portfolio.coviddeaths
where continent != ''
group by location
order by 5 desc

select date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, 7874965730 as world_population, (sum(new_deaths)/7874965730)*100 as mortality_rate_bydate
from portfolio.coviddeaths
where continent != ''
group by date
order by 3 desc

select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, 7874965730 as world_population, (sum(new_deaths)/7874965730)*100 as mortality_rate
from portfolio.coviddeaths
where continent != ''

select location, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, population, (sum(new_deaths)/population)*100 as continent_mortality_rate
from portfolio.coviddeaths
where continent = ''
and location != 'World'
group by location
order by 5 desc

#Vaccination Rate

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as total_new_vac,
((sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date))/dea.population)*100 as vaccination_rate
from portfolio.coviddeaths dea
join portfolio.covidvaccinations vac
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent != ''
order by 2, 3

# Create Views for Visualisation

create view Vaccination_rate as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as total_new_vac,
((sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date))/dea.population)*100 as vaccination_rate
from portfolio.coviddeaths dea
join portfolio.covidvaccinations vac
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent != ''
order by 2, 3

create view global_mortality_rate as 
select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, 7874965730 as world_population, (sum(new_deaths)/7874965730)*100 as mortality_rate
from portfolio.coviddeaths
where continent != ''


create view global_mortality_rate_date as 
select date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, 7874965730 as world_population, (sum(new_deaths)/7874965730)*100 as mortality_rate
from portfolio.coviddeaths
where continent != ''
group by date
order by 1 asc


create view global_mortality_rate_location as 
select location, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, population as population, (sum(new_deaths)/population)*100 as mortality_rate
from portfolio.coviddeaths
where continent != ''
group by location
order by 5 desc


create view global_mortality_rate_location as 
select location, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, population, (sum(new_deaths)/population)*100 as mortality_rate
from portfolio.coviddeaths
where continent = ''
and location != 'World'
group by location
order by 5 desc


create view global_case_fatality_rate as
select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, (sum(new_deaths)/sum(new_cases))*100 as case_fatality_rate
from portfolio.coviddeaths
where continent != ''


create view case_fatality_rate_location as
select location, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, (sum(new_deaths)/sum(new_cases))*100 as case_fatality_rate
from portfolio.coviddeaths
where continent != ''
group by location
order by 4 desc


create view case_fatality_date as
select date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, (sum(new_deaths)/sum(new_cases))*100 as case_fatality_rate
from portfolio.coviddeaths
where continent != ''
group by date
order by 1


create view total_death_continent as 
select location, max(total_deaths) as total_deaths_Count
from portfolio.coviddeaths
where continent = ''
and Location != 'world'
group by location
order by total_deaths_Count desc


create view prevalence_rate_country as 
select location, population, max(total_cases) as highest_cases, round(max((total_cases/population))*100, 2) as prevalence
from portfolio.coviddeaths
where continent != ''
group by location, population
order by prevalence desc

