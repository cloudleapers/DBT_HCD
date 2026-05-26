import pandas as pd
import psycopg2
from sqlalchemy import create_engine, text



pg_conn = psycopg2.connect(
    host="pg-313c56b-tharnikareddy01-pa06.j.aivencloud.com",
    port=18679,
    database="defaultdb",
    user="avnadmin",
    password="REDACTED"
)

sf_engine = create_engine(
    "snowflake://PTHARNIKA:Tharnika%40010604@BI36122.ap-southeast-1/DBT_HCD/RAW?warehouse=COMPUTE_WH&role=ACCOUNTADMIN"
)


tables = [
    "clinics",
    "patients",
    "doctors",
    "appointments",
    "payments",
    "insurance_plans"
]


for table in tables:

    print(f"\nLoading table: {table}")

    # Read from Postgres
    query = f"SELECT * FROM public.{table}"

    df = pd.read_sql(query, pg_conn)

    print(f"Rows fetched: {len(df)}")

    # Snowflake target table
    target_table = f"RAW_{table.upper()}"

   

    
    df.to_sql(
        name=target_table,
        con=sf_engine,
        if_exists="append",
        index=False,
        method="multi"
    )

    print(f"{target_table} loaded successfully!")

pg_conn.close()

print("\nMigration completed successfully!")