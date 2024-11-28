from dash import Dash, html, dcc
import dash_table
import psycopg2
import plotly.express as px
import pandas as pd
import dash_bootstrap_components as dbc

try:
    #CONEC
    connection = psycopg2.connect(
        host='localhost',
        user='postgres',
        password='123456789',
        database='pruebas',
        port=5432
    )

    print("Conexión exitosa")

    cursor = connection.cursor()

    #FALSE
    cursor.execute("""
        SELECT 
            ROW_NUMBER() OVER (ORDER BY promedio_diametro DESC) as ranking,
            neo_id, 
            promedio_diametro
        FROM (
            SELECT 
                neo_id, 
                ((estimatedDiameterMin + estimatedDiameterMax) / 2) as promedio_diametro
            FROM 
                NEO
            WHERE 
                ishazardous = 'false'
        ) as subquery
        ORDER BY ranking;
    """)
    rows_false = cursor.fetchall()
    df_false = pd.DataFrame(rows_false, columns=[desc[0] for desc in cursor.description])

    #TRUE
    cursor.execute("""
        SELECT 
            ROW_NUMBER() OVER (ORDER BY promedio_diametro DESC) as ranking,
            neo_id, 
            promedio_diametro
        FROM (
            SELECT 
                neo_id, 
                ((estimatedDiameterMin + estimatedDiameterMax) / 2) as promedio_diametro
            FROM 
                NEO
            WHERE 
                ishazardous = 'true'
        ) as subquery
        ORDER BY ranking;
    """)
    rows_true = cursor.fetchall()
    df_true = pd.DataFrame(rows_true, columns=[desc[0] for desc in cursor.description])

    #RADIOS
    cursor.execute("SELECT * FROM Radio_Cuerpo_Celeste;")
    rows_radio = cursor.fetchall()
    df_radio = pd.DataFrame(rows_radio, columns=[desc[0] for desc in cursor.description])

    #CON
    cursor.execute("""
        SELECT 
            c.contractor1 AS Company,
            COUNT(sa.COSPAR_number) AS Satellite_Count
        FROM 
            Contractor c
        JOIN 
            Satelite_artificial sa ON c.COSPAR_number = sa.COSPAR_number AND c.NORAD_number = sa.NORAD_number
        GROUP BY 
            c.contractor1
        ORDER BY Satellite_Count DESC;
    """)
    rows_contractors = cursor.fetchall()
    df_contractors = pd.DataFrame(rows_contractors, columns=[desc[0] for desc in cursor.description])

    #SAT/CON
    cursor.execute("""
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
        GROUP BY country
        ORDER BY Satellite_Count DESC;
    """)
    rows_countries = cursor.fetchall()
    df_countries = pd.DataFrame(rows_countries, columns=[desc[0] for desc in cursor.description])

    #RECURSION
    cursor.execute("""
        SELECT 
            cc.orbits, 
            tdc.name AS planet_name
        FROM 
            Cuerpo_celeste cc
        LEFT JOIN 
            Tipo_de_cuerpo tdc ON cc.id_cl = tdc.id_d
        LEFT JOIN 
            Cuerpo_celeste cc_orbit ON cc.orbits = cc_orbit.id_cl
        LEFT JOIN 
            Tipo_de_cuerpo tdc_orbit ON cc_orbit.id_cl = tdc_orbit.id_d;
    """)
    rows_orbit = cursor.fetchall()
    df_orbit = pd.DataFrame(rows_orbit, columns=[desc[0] for desc in cursor.description])

    #FONDO
    app = Dash(__name__, external_stylesheets=[dbc.themes.DARKLY])

    #VISUALIZACIÓN
    fig_false = px.bar(df_false, x='neo_id', y='promedio_diametro', title='Diámetro Promedio - NEO No Peligrosos')
    fig_true = px.bar(df_true, x='neo_id', y='promedio_diametro', title='Diámetro Promedio - NEO Peligrosos')
    fig_scatter = px.scatter(df_radio, x='id_cl', y='radio', title='Radio de Cuerpo Celeste')
    fig_contractors = px.bar(df_contractors, x='company', y='satellite_count', title='Satélites por Contratista')
    fig_countries = px.bar(df_countries, x='country', y='satellite_count', title='Satélites por País')

    #DECORACION
    app.layout = html.Div(style={
        'backgroundImage': 'url("https://www.nasa.gov/wp-content/themes/nasa/assets/images/nasa-logo.png")',
        'backgroundSize': 'cover',
        'backgroundPosition': 'center center',
        'height': '100vh',
        'color': 'white',
        'fontFamily': 'Arial, sans-serif'
    }, children=[
        dbc.Row(
            dbc.Col(html.H1('Gráficos y Datos Astronómicos', style={'textAlign': 'center', 'fontSize': '3em', 'padding': '20px'})),
        ),
        
        dbc.Row([
            dbc.Col(dcc.Graph(id='graph-false', figure=fig_false), width=6),
            dbc.Col(dcc.Graph(id='graph-true', figure=fig_true), width=6),
        ], justify='center'),
        
        dbc.Row([
            dbc.Col(dcc.Graph(id='graph-scatter', figure=fig_scatter), width=6),
            dbc.Col(dcc.Graph(id='graph-contractors', figure=fig_contractors), width=6),
        ], justify='center'),
        
        dbc.Row(
            dbc.Col(dcc.Graph(id='graph-countries', figure=fig_countries), width=12),
            justify='center'
        ),
        
        dbc.Row(
            dbc.Col(dash_table.DataTable(
                id='orbit-table',
                columns=[
                    {'name': 'Órbita del Cuerpo', 'id': 'orbits'},
                    {'name': 'Nombre del Planeta', 'id': 'planet_name'}
                ],
                data=df_orbit.to_dict('records'),
                page_size=10,
                style_table={'overflowX': 'auto'},
                style_cell={'textAlign': 'center', 'padding': '10px', 'fontSize': '16px'},
                style_header={'backgroundColor': 'rgba(0, 0, 0, 0.5)', 'fontWeight': 'bold', 'color': 'white'},
                style_data={'backgroundColor': 'rgba(0, 0, 0, 0.2)', 'color': 'white'}
            ), width=12)
        ),
    ])

    if __name__ == '__main__':
        app.run_server(debug=True)

except Exception as ex:
    print("Error:", ex)

finally:
    if connection:
        connection.close()
        print("Conexión cerrada")
