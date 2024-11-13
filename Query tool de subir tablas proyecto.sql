--ATENCIÓN, puede necesitar cambiar las "," de los archivos csv por "." para que pueda correr las tablas y copy, puede que si o no.
--TABLAS del proyecto ingenieria de datos
create table Cuerpo_celeste(
	id_cl varchar(3),
	semimajorAxis numeric(20,6),
	perihelion numeric(16,6),
	aphelion numeric(16,6),
	eccentricity numeric(16,6),
	inclination numeric(16,6),
	density numeric(16,6),
	gravity numeric(16,6),
	escape numeric(16,6),
	meanRadius numeric(16,6),
	equaRadius numeric(16,6),
	polarRadius numeric(16,6),
	flattening numeric(16,6),
	dimension varchar(18),
	sideralOrbit numeric(16,6),
	discoveryDate date,
	orbitType varchar(12),
	orbits varchar(20),
	pTransit numeric(20,6),
	transitVisibility numeric(20,6),
	transitDepth numeric(20,6),
	massJ numeric(20,6),
	semimajorAxisAU numeric(20,6),
	primary key (id_cl)
);
--drop table Cuerpo_celeste;
select * from Cuerpo_celeste;

COPY
		Cuerpo_celeste(id_cl, semimajorAxis, perihelion, aphelion, eccentricity, inclination, density,
		gravity, escape, meanRadius, equaRadius, polarRadius, flattening, dimension, sideralOrbit,
		discoveryDate, orbitType, orbits, pTransit, transitVisibility, transitDepth,
		massJ, semimajorAxisAU) FROM 'C:\Users\Public\TABLA CUERPO CELESTE.csv' DELIMITER ';' CSV HEADER;

create table Tierra(
	id_t varchar(3),
	semimajorAxis_t numeric(20,6),
	perihelion_t numeric(16,6),
	aphelion_t numeric(16,6),
	eccentricity_t numeric(16,6),
	inclination_t numeric(16,6),
	density_t numeric(16,6),
	gravity_t numeric(16,6),
	escape_t numeric(16,6),
	meanRadius_t numeric(16,6),
	equaRadius_t numeric(16,6),
	polarRadius_t numeric(16,6),
	flattening_t numeric(16,6),
	dimension_t varchar(18),
	sideralOrbit_t numeric(16,6),
	discoveryDate_t date,
	orbitType_t varchar(12),
	orbits_t varchar(20),
	pTransit_t numeric(20,6),
	transitVisibility_t numeric(20,6),
	transitDepth_t numeric(20,6),
	massJ_t numeric(20,6),
	semimajorAxisAU_t numeric(20,6),
	primary key (id_t),
	foreign key (id_t) references Cuerpo_celeste
);
--drop table Tierra;
select * from Tierra;

COPY
		Tierra(id_t, semimajorAxis_t, perihelion_t, aphelion_t, eccentricity_t, inclination_t, density_t,
		gravity_t, escape_t, meanRadius_t, equaRadius_t, polarRadius_t, flattening_t, dimension_t, sideralOrbit_t,
		discoveryDate_t, orbitType_t, orbits_t, pTransit_t, transitVisibility_t, transitDepth_t,
		massJ_t, semimajorAxisAU_t) FROM 'C:\Users\Public\TABLA TIERRA.csv' DELIMITER ';' CSV HEADER;

create table Tipo_de_cuerpo(
	name varchar(20),
	type varchar(13),
	id_d varchar(3),
	primary key(name, id_d),
	foreign key (id_d) references Cuerpo_celeste
);
--drop table Tipo_de_cuerpo
select * from Tipo_de_cuerpo;

COPY
		Tipo_de_cuerpo(name, type, id_d) FROM 'C:\Users\Public\TABLA TIPO DE CUERPO.csv' DELIMITER ';' CSV HEADER;

create table NEO(
	id_t varchar(3),
	neo_id varchar(8),
	name varchar(40),
	absoluteMagnitude numeric(6,4),
	estimatedDiameterMin numeric(12,6),
	estimatedDiameterMax numeric(12,6),
	relativeVelocity numeric(12,6),
	missDistance numeric(14,6),
	isHazardous boolean,
	foreign key (id_t) references Tierra
);
--drop table NEO
select * from NEO;

COPY
		NEO(id_t, neo_id, name, absoluteMagnitude, estimatedDiameterMin, estimatedDiameterMax,
			relativeVelocity, missDistance, isHazardous) FROM 'C:\Users\Public\TABLA NEO.csv' DELIMITER ';' CSV HEADER;

create table Satelite_artificial(
	officialName varchar(55),
	COSPAR_number varchar(12),
	NORAD_number varchar(5),
	id_t varchar(3),
	detailedPurpose varchar(55),
	orbitSat varchar(12),
	typeOrbitSat varchar(35),
	longitudeGEO numeric(10,4),
	perihelionSat numeric(10,4),
	aphelionSat numeric(10,4),
	eccentricitySat numeric(10,4),
	inclinationSat numeric(10,4),
	periodSat numeric(10,4),
	drymass numeric(10,4),
	power numeric(10,4),
	expectedLifetime numeric(6,2),
	launchSite varchar(55),
	launchVehicle varchar(30),
	primary key(COSPAR_number, NORAD_number),
	foreign key (id_t) references Tierra
);
--drop table Satelite_artificial
select * from Satelite_artificial;

COPY
		Satelite_artificial(officialName, COSPAR_number, NORAD_number, id_t, detailedPurpose, orbitSat,
		typeOrbitSat, longitudeGEO, perihelionSat, aphelionSat, eccentricitySat, inclinationSat, periodSat,
		drymass, power, expectedLifetime, launchSite, launchVehicle) FROM 'C:\Users\Public\satellites.csv' DELIMITER ';' CSV HEADER;

create table Contractor(
	COSPAR_number varchar(12),
	NORAD_number varchar(5),
	contractor1 varchar(125),
	contractor2 varchar(90),
	contractor3 varchar(65),
	contractor4 varchar(65),
	contractor5 varchar(65),
	primary key(COSPAR_number, NORAD_number),
	foreign key (COSPAR_number, NORAD_number) references Satelite_artificial
);
--drop table Contractor
select * from Contractor;

COPY
		Contractor(COSPAR_number, NORAD_number, contractor1, contractor2, contractor3,
			contractor4, contractor5) FROM 'C:\Users\Public\TABLA Contractor.csv' DELIMITER ';' CSV HEADER;

create table Contractor_country(
	COSPAR_number varchar(12),
	NORAD_number varchar(5),
	country1 varchar(20),
	country2 varchar(20),
	country3 varchar(20),
	country4 varchar(20),
	country5 varchar(20),
	primary key(COSPAR_number, NORAD_number),
	foreign key (COSPAR_number, NORAD_number) references Satelite_artificial
);
--drop table Contractor_country
select * from Contractor_country;

COPY
		Contractor_country(COSPAR_number, NORAD_number, country1, country2, country3,
			country4, country5) FROM 'C:\Users\Public\Country of contractor.csv' DELIMITER ';' CSV HEADER;

create table Country_operator_owner(
	COSPAR_number varchar(12),
	NORAD_number varchar(5),
	operator1 varchar(20),
	operator2 varchar(20),
	operator3 varchar(20),
	operator4 varchar(20),
	operator5 varchar(20),
	primary key(COSPAR_number, NORAD_number),
	foreign key (COSPAR_number, NORAD_number) references Satelite_artificial
);
--drop table Country_operator_owner
select * from Country_operator_owner;

COPY
		Country_operator_owner(COSPAR_number, NORAD_number, operator1, operator2, operator3,
			operator4, operator5) FROM 'C:\Users\Public\Country of contractor.csv' DELIMITER ';' CSV HEADER;

create table Owner(
	COSPAR_number varchar(12),
	NORAD_number varchar(5),
	owner1 varchar(150),
	owner2 varchar(120),
	owner3 varchar(120),
	owner4 varchar(120),
	primary key(COSPAR_number, NORAD_number),
	foreign key (COSPAR_number, NORAD_number) references Satelite_artificial
);
--drop table Owner
select * from Owner;

COPY
		owner(COSPAR_number, NORAD_number, owner1, owner2, owner3, owner4) FROM 'C:\Users\Public\Owner.csv' DELIMITER ';' CSV HEADER;

create table Register(
	COSPAR_number varchar(12),
	NORAD_number varchar(5),
	registerCountry1 varchar(120),
	registerCountry2 varchar(120),
	registerCountry3 varchar(90),
	primary key(COSPAR_number, NORAD_number),
	foreign key (COSPAR_number, NORAD_number) references Satelite_artificial
);
--drop table Register
select * from Register;

COPY
		Register(COSPAR_number, NORAD_number, registerCountry1, registerCountry2, registerCountry3) FROM 'C:\Users\Public\Register.csv' DELIMITER ';' CSV HEADER;
