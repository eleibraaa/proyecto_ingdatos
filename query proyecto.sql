CREATE TABLE Radio_Cuerpo_Celeste (
    id_cl varchar(3),
    radio numeric(20,6),
    primary key (id_cl),
    foreign key (id_cl) references Cuerpo_celeste(id_cl)
);

INSERT INTO Radio_Cuerpo_Celeste (id_cl, radio)
SELECT 
    id_cl,
    POWER((3 * massJ) / (4 * PI() * density), 1.0/3.0) AS radio
FROM 
    Cuerpo_celeste
WHERE 
    density IS NOT NULL AND massJ IS NOT NULL;

select * from Radio_Cuerpo_Celeste;

--

select 
    ROW_NUMBER() OVER (ORDER BY promedio_diametro DESC) as ranking,
    neo_id, 
    promedio_diametro
from (
    select 
        neo_id, 
        ((estimatedDiameterMin + estimatedDiameterMax) / 2) as promedio_diametro
    from 
        NEO
    where 
        ishazardous = 'false'
) as subquery
order by 
    ranking;

select 
    ROW_NUMBER() OVER (ORDER BY promedio_diametro DESC) as ranking,
    neo_id, 
    promedio_diametro
from (
    select 
        neo_id, 
        ((estimatedDiameterMin + estimatedDiameterMax) / 2) as promedio_diametro
    from 
        NEO
    where 
        ishazardous = 'true'
) as subquery
order by 
    ranking;

--Contractor
SELECT 
    c.contractor1 AS Company,
    COUNT(sa.COSPAR_number) AS Satellite_Count
FROM 
    Contractor c
JOIN 
    Satelite_artificial sa ON c.COSPAR_number = sa.COSPAR_number AND c.NORAD_number = sa.NORAD_number
GROUP BY 
    c.contractor1
ORDER BY 
    Satellite_Count Desc;  -- Ordenar de menor a mayor
	
select * from contractor_country;

SELECT 
    country AS Country,
    COUNT(*) AS Satellite_Count
FROM (
    SELECT 
        COSPAR_number, 
        NORAD_number, 
        country1 AS country
    FROM 
        Contractor_country
    UNION ALL
    SELECT 
        COSPAR_number, 
        NORAD_number, 
        country2 AS country
    FROM 
        Contractor_country
    UNION ALL
    SELECT 
        COSPAR_number, 
        NORAD_number, 
        country3 AS country
    FROM 
        Contractor_country
    UNION ALL
    SELECT 
        COSPAR_number, 
        NORAD_number, 
        country4 AS country
    FROM 
        Contractor_country
    UNION ALL
    SELECT 
        COSPAR_number, 
        NORAD_number, 
        country5 AS country
    FROM 
        Contractor_country
) AS countries
JOIN 
    Satelite_artificial sa ON countries.COSPAR_number = sa.COSPAR_number AND countries.NORAD_number = sa.NORAD_number
GROUP BY 
    country
ORDER BY 
    Satellite_Count DESC;

--
select * from cuerpo_celeste;
select * from tipo_de_cuerpo;

with recursive OrbitHierarchy as (
    select 
        cc.id_cl as planet_id, 
        cc.orbits as orbits_id
    from Cuerpo_celeste cc
    where cc.orbits is not null -- Sin orbita

    union all

    -- Recursivo
    select 
        oh.planet_id,          -- Propagar el ID del cuerpo inicial
        cc.orbits as orbits_id -- Buscar la órbita del siguiente nivel
    from OrbitHierarchy oh
    join Cuerpo_celeste cc on oh.orbits_id = cc.id_cl
)
--Final
select 
    tdc_planet.name as "Nombre del Planeta",    -- Nombre del planeta
    oh.planet_id as "ID del Planeta",           -- ID del planeta
    tdc_orbit.name as "Órbita del Cuerpo"       -- Nombre del cuerpo que orbita
from OrbitHierarchy oh

left join Tipo_de_cuerpo tdc_planet on oh.planet_id = tdc_planet.id_d
left join Cuerpo_celeste cc_orbit on oh.orbits_id = cc_orbit.id_cl
left join Tipo_de_cuerpo tdc_orbit on cc_orbit.id_cl = tdc_orbit.id_d;

select 
    cc.orbits, 
    tdc.name as planet_name
from Cuerpo_celeste cc
left join Tipo_de_cuerpo tdc on cc.id_cl = tdc.id_d
left join Cuerpo_celeste cc_orbit on cc.orbits = cc_orbit.id_cl
left join Tipo_de_cuerpo tdc_orbit on cc_orbit.id_cl = tdc_orbit.id_d;

WITH RECURSIVE OrbitHierarchy AS (
            SELECT 
                cc.id_cl AS planet_id, 
                cc.orbits AS orbits_id
            FROM Cuerpo_celeste cc
            WHERE cc.orbits IS NOT NULL

            UNION ALL

            SELECT 
                oh.planet_id,          
                cc.orbits AS orbits_id 
            FROM OrbitHierarchy oh
            JOIN Cuerpo_celeste cc ON oh.orbits_id = cc.id_cl
        )
        SELECT 
            tdc_planet.name AS "Nombre del Planeta", 
            tdc_orbit.name AS "Órbita del Cuerpo"
        FROM OrbitHierarchy oh
        LEFT JOIN Tipo_de_cuerpo tdc_planet ON oh.planet_id = tdc_planet.id_d
        LEFT JOIN Cuerpo_celeste cc_orbit ON oh.orbits_id = cc_orbit.id_cl
        LEFT JOIN Tipo_de_cuerpo tdc_orbit ON cc_orbit.id_cl = tdc_orbit.id_d;