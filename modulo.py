#Importar psycopg2
import psycopg2


try:
    #Realizar la conexión con la base de datos
    connection = psycopg2.connect(
        host='localhost',
        user='postgres',
        password='123456789',
        database='pruebas',
        port=5432
    )

    print("Conexión exitosa")

    #Consultas a realizar, algunas implementadas con limit por la alta cantidad de tuplas, sin embargo, sin el limit funcionarian tambien
    cns_cuerpo_celeste = 'select * from Cuerpo_celeste limit 10'
    cns_tierra = 'select * from Tierra'
    cns_tipo_de_cuerpo = 'select * from Tipo_de_cuerpo limit 10'
    cns_neo = 'select * from NEO limit 10'
    cns_sat_artificial = 'select * from Satelite_artificial limit 10'
    cns_contractor = 'select * from Contractor limit 10'
    cns_c_country = 'select * from Contractor_country limit 10'
    cns_country_operator_owner = 'select * from Country_operator_owner limit 10'
    cns_owner = 'select * from Owner limit 10'
    cns_register = 'select * from Register limit 10'
    #PD: se puede correr sin el limit, sin embargo, ocupa mucho espacio, por motivos de practicidad y para primera entrega usaremos limit 50 para aprobar que funciona

    #Cuerpo_celeste
    A = 'Tabla Cuerpo_celeste: id_cl, semimajorAxis, perihelion, aphelion, eccentricity, inclination, density, gravity, escape, meanRadius, EquaRadius, polarRadius, flattening, dimension, sideralOrbit, discoveryDate, orbitType, orbits, pTransit, transitVisibility, transitDepth, massJ, semimajorAxisAU'
    cursor = connection.cursor()
    cursor.execute(cns_cuerpo_celeste)
    rows = cursor.fetchall()
    print(A)
    for row in rows:
        print(row)
    print("\n")

    print('---------------------------------------------------------------------------------------------------------')
    print("\n")
    #Tierra
    B = 'Tabla Tierra: id_t, semimajorAxis_t, perihelion_t, aphelion_t, eccentricity_t, inclination_t, density_t, gravity_t, escape_t, meanRadius_t, EquaRadius_t, polarRadius_t, flattening_t, dimension_t, sideralOrbit_t, discoveryDate_t, orbitType_t, orbits_t, pTransit_t, transitVisibility_t, transitDepth_t, massJ_t, semimajorAxisAU_t'
    cursor = connection.cursor()
    cursor.execute(cns_tierra)
    rows = cursor.fetchall()
    print(B)
    for row in rows:
        print(row)
    print("\n")

    print('---------------------------------------------------------------------------------------------------------')
    print("\n")
    #Tipo_de_cuerpo
    C = 'Tabla Tipo_de_cuerpo: name, type, id_d'
    cursor = connection.cursor()
    cursor.execute(cns_tipo_de_cuerpo)
    rows = cursor.fetchall()
    print(C)
    for row in rows:
        print(row)
    print("\n")
    
    print('---------------------------------------------------------------------------------------------------------')
    print("\n")
    #NEO
    D = 'Tabla NEO: id_t, neo_id, name, absoluteMagnitude, estimatedDiameterMin, estimatedDiameterMax, relativeVelocity, missDistance, isHazardous'
    cursor = connection.cursor()
    cursor.execute(cns_neo)
    rows = cursor.fetchall()
    print(D)
    for row in rows:
        print(row)
    print("\n")

    print('---------------------------------------------------------------------------------------------------------')
    print("\n")
    #Satelite_artificial
    E = 'Tabla Satelite_artificial: officialName, COSPAR_number, NORAD_number, id_t, detailedPurpose, orbitSat, typeorbitSat, longitudeGEO, perihelionSat, aphelionSat, eccentricitySat, inclinationSat, periodSat, drymass, power, expectedLifetime, launchSite, launchVehicle'
    cursor = connection.cursor()
    cursor.execute(cns_sat_artificial)
    rows = cursor.fetchall()
    print(E)
    for row in rows:
        print(row)
    print("\n")

    print('---------------------------------------------------------------------------------------------------------')
    print("\n")
    #Contractor
    F = 'Tabla Contractor: COSPAR_number, NORAD_number, contractor1, contractor2, contractor3, contractor4, contractor5'
    cursor = connection.cursor()
    cursor.execute(cns_contractor)
    rows = cursor.fetchall()
    print(F)
    for row in rows:
        print(row)
    print("\n")

    print('---------------------------------------------------------------------------------------------------------')
    print("\n")
    #Contractor_country
    G = 'Tabla Contractor_country: COSPAR_number, NORAD_number, country1, country2, country3, country4, country5'
    cursor = connection.cursor()
    cursor.execute(cns_c_country)
    rows = cursor.fetchall()
    print(G)
    for row in rows:
        print(row)
    print("\n")

    print('---------------------------------------------------------------------------------------------------------')
    print("\n")
    #Country_operator_owner
    H = 'Tabla Country_operator_owner: COSPAR_number, NORAD_number, operator1, operator2, operator3, operator4, operator5'
    cursor = connection.cursor()
    cursor.execute(cns_country_operator_owner)
    rows = cursor.fetchall()
    print(H)
    for row in rows:
        print(row)
    print("\n")

    print('---------------------------------------------------------------------------------------------------------')
    print("\n")
    #Owner
    I = 'Tabla Owner: COSPAR_number, NORAD_number, owner1, owner2, owner3, owner4'
    cursor = connection.cursor()
    cursor.execute(cns_owner)
    rows = cursor.fetchall()
    print(I)
    for row in rows:
        print(row)
    print("\n")

    print('---------------------------------------------------------------------------------------------------------')
    print("\n")
    #Register
    J = 'Tabla Register: COSPAR_number, NORAD_number, registerCountry1, registerCountry2, registerCountry3'
    cursor = connection.cursor()
    cursor.execute(cns_register)
    rows = cursor.fetchall()
    print(J)
    for row in rows:
        print(row)
    print("\n")

    print('---------------------------------------------------------------------------------------------------------')
    print("\n")

#Si falla la conexión
except Exception as ex:
    print(ex)
#Finalizar la conexión
finally:
    connection.close()
    print('Conexión finalizada')