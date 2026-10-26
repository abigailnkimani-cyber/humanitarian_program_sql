     -- creating a database
     CREATE DATABASE humanitarian_program;
     
       -- creating tables  
     CREATE TABLE village_locations (
    village_id       INTEGER PRIMARY KEY,
    village          VARCHAR(30) UNIQUE,
    latitude         VARCHAR(30),
    longitude        VARCHAR(30),
    total_population INTEGER
    );
     
     CREATE TABLE beneficiary_partner_data (
    partner_id       INTEGER PRIMARY KEY,
    partner          VARCHAR(30),
    village          VARCHAR(30),
    beneficiaries    INTEGER,
    beneficiary_type VARCHAR(30),
    FOREIGN KEY (village) REFERENCES village_locations (village)
);

	CREATE TABLE jurisdiction_hierarchy (
    id        INTEGER PRIMARY KEY,
    name      VARCHAR(50),
    type      VARCHAR(20),
    parent_id INTEGER,
    FOREIGN KEY (parent_id) REFERENCES jurisdiction_hierarchy (id)
);

-- input the sample data into the tables
INSERT INTO village_locations
(village_id, village, latitude, longitude, total_population)
VALUES
(1, 'Dharkenley', '2.0469', '45.3182', 5000),
(2, 'Bulo-Kahin', '2.0560', '45.3250', 4200),
(3, 'Hilo Kelyo', '2.0650', '45.3300', 3800),
(4, 'Xubow', '2.1000', '45.3500', 6000),
(5, 'Xiintooy', '2.1100', '45.3600', 4500),
(6, 'Dhagax Jebis', '2.1200', '45.3700', 5200),
(7, 'Filtare', '2.1300', '45.3800', 3900),
(8, 'Howl-Wadaag', '2.1400', '45.3900', 4700),
(9, 'Balcad', '2.1500', '45.4000', 5500),
(10, 'Mareeray', '2.1600', '45.4100', 4300),
(11, 'Kulmis', '2.1700', '45.4200', 6058),
(12, 'Sabuun', '2.1800', '45.4300', 5100),
(13, 'Bayaxaw', '2.1900', '45.4400', 3600),
(14, 'Bayaxawo', '2.2000', '45.4500', 4000);

INSERT INTO beneficiary_partner_data
(partner_id, partner, village, beneficiaries, beneficiary_type)
VALUES
(1, 'World Vision', 'Dharkenley', 1200, 'Individuals'),
(2, 'World Vision', 'Bulo-Kahin', 350, 'Households'),
(3, 'CARE', 'Dharkenley', 800, 'Individuals'),
(4, 'CARE', 'Hilo Kelyo', 250, 'Households'),
(5, 'IRC', 'Xubow', 1500, 'Individuals'),
(6, 'IRC', 'Xiintooy', 300, 'Households'),
(7, 'World Vision', 'Dhagax Jebis', 900, 'Individuals'),
(8, 'CARE', 'Filtare', 450, 'Households'),
(9, 'IRC', 'Howl-Wadaag', 1100, 'Individuals'),
(10, 'World Vision', 'Balcad', 700, 'Households'),
(11, 'CARE', 'Mareeray', 600, 'Individuals'),
(12, 'IRC', 'Kulmis', 400, 'Households'),
(13, 'World Vision', 'Sabuun', 1000, 'Individuals'),
(14, 'CARE', 'Bayaxaw', 500, 'Households'),
(15, 'IRC', 'Bayaxawo', 1300, 'Individuals'),
(16, 'World Vision', 'Dharkenley', 700, 'Households'),
(17, 'CARE', 'Bulo-Kahin', 550, 'Individuals'),
(18, 'IRC', 'Hilo Kelyo', 900, 'Individuals');


INSERT INTO jurisdiction_hierarchy
(id, name, type, parent_id)
VALUES
(1, 'Middle Shabelle', 'Region', NULL),
(2, 'Hiraan', 'Region', NULL),

(3, 'Balcad', 'District', 1),
(4, 'Jowhar', 'District', 1),
(5, 'Beledweyn', 'District', 2),

(6, 'Dharkenley', 'Village', 3),
(7, 'Bulo-Kahin', 'Village', 3),
(8, 'Hilo Kelyo', 'Village', 3),

(9, 'Xubow', 'Village', 4),
(10, 'Xiintooy', 'Village', 4),
(11, 'Dhagax Jebis', 'Village', 4),
(12, 'Filtare', 'Village', 4),
(13, 'Howl-Wadaag', 'Village', 4),
(14, 'Balcad', 'Village', 4),
(15, 'Mareeray', 'Village', 4),
(16, 'Kulmis', 'Village', 4),
(17, 'Sabuun', 'Village', 4),
(18, 'Bayaxaw', 'Village', 4),
(19, 'Bayaxawo', 'Village', 4);

-- displaying records from all tables

select * from beneficiary_partner_data;
select * from village_locations;
select * from jurisdiction_hierarchy;

--- display village,partner and beneficiaries

select partner, village, beneficiaries
from beneficiary_partner_data;

-- villages with a population greater than 4,500
select village,total_population
from village_locations vl 
where total_population > 4500
order by total_population desc;

--records where the beneficiary type is Households
select *
from beneficiary_partner_data
where beneficiary_type = 'Households';

-- converting Beneficiary Counts
select
    partner_id,
    partner,
    village,
    beneficiaries,
    beneficiary_type,
    case
        when beneficiary_type = 'Individuals' then beneficiaries
        when beneficiary_type = 'Households'  then beneficiaries * 6
   end as individual_beneficiaries
from beneficiary_partner_data;

 individual beneficiaries
select
    partner,
    sum(
        case
           when beneficiary_type = 'Households' then beneficiaries * 6
            else beneficiaries
        end
    ) as total_individual_beneficiaries
from beneficiary_partner_data
group by partner
order by total_individual_beneficiaries desc;

--for each partner, total number of villages served
select
    partner,
   count(distinct village) as distinct_villages_served
from beneficiary_partner_data
group by partner
order by distinct_villages_served desc;

-- for each partner average individual beneficiaries per record
select
	partner,
	round(AVG(case
           when beneficiary_type = 'Households' then beneficiaries * 6
            else beneficiaries
         end
         ), 2) as avg_individual_beneficiaries
from beneficiary_partner_data	
group by partner
order by avg_individual_beneficiaries desc;

--Join beneficiary_partner_data with village_locations.
select
    b.partner,
    b.village,
   case
       when b.beneficiary_type = 'Households' then b.beneficiaries * 6
        else b.beneficiaries
    end as individual_beneficiaries,
    v.total_population as village_population,
    round(
        (case
            when b.beneficiary_type = 'Households' then b.beneficiaries * 6
            else b.beneficiaries
         end) * 100.0 / v.total_population, 2
    ) as coverage_pct
from beneficiary_partner_data as b
join village_locations as v
    on b.village = v.village
order by coverage_pct desc;

-- add District Information
select
    b.partner,
    b.village,
    d.name as district,
    case
       when b.beneficiary_type = 'Households' then b.beneficiaries * 6
        else b.beneficiaries
   end as individual_beneficiaries
from beneficiary_partner_data as b
join jurisdiction_hierarchy as v
    on  b.village = v.name
    and v.type    = 'Village'
join jurisdiction_hierarchy as d
    on  v.parent_id = d.id
    and d.type      = 'District'
order by d.name, b.village, b.partner;


-- villages served by more than one partner
select village,
count(distinct partner) as distinct_partners
from beneficiary_partner_data
group by village
having count(distinct partner) > 1
order by distinct_partners desc, village;

--create summary tables
--partner summary
create table Partner_summary as
select
    partner as Partner,
    
    sum(case
            when beneficiary_type = 'Households' then beneficiaries * 6
           else beneficiaries
        end) as Total_beneficiaries,
        
    count(distinct village) as Villages_served,
    
   round(avg(case
           when beneficiary_type = 'Households' then beneficiaries * 6
            else beneficiaries
        end), 2) as Average_beneficiaries
        
from beneficiary_partner_data
group by partner;
order by Total_beneficiaries desc;

-district summary
create table District_summary as
select
    d.name as district,
    sum(case
            when b.beneficiary_type = 'Households' then b.beneficiaries * 6
            else b.beneficiaries
        end) as total_individual_beneficiaries,
    count(distinct  b.village) as villages_served
from beneficiary_partner_data as b
join jurisdiction_hierarchy as v
   on b.village = v.name
    and v.type    = 'Village'
join jurisdiction_hierarchy as d
    on  v.parent_id = d.id
    and d.type      = 'District'
group by d.name
order by total_individual_beneficiaries desc;    
        

