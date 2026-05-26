import pandas as pd
import psycopg2
import yaml
from sqlalchemy import create_engine, text  
from urllib.parse import quote_plus

#Postgress connection
with open("config.yml", "r") as file:
    config = yaml.safe_load(file)

pg = config["postgres"]


pg_engine = create_engine(
    f"postgresql+psycopg2://{pg['user']}:{pg['password']}@{pg['host']}:{pg['port']}/{pg['database']}"
)

print("Connected to Postgres")

#Snowflake connection
sf = config["snowflake"]

sf_password = quote_plus(sf["password"])

sf_engine = create_engine(
    f"snowflake://{sf['user']}:{sf_password}"
    f"@{sf['account']}/{sf['database']}/{sf['schema']}"
    f"?warehouse={sf['warehouse']}&role={sf['role']}"
)

print("Connected to Snowflake")

# -------------------------
# AUTO DISCOVER TABLES
# -------------------------
table_query = """
SELECT table_name
FROM information_schema.tables
WHERE table_schema='public'
AND table_type='BASE TABLE'
"""

tables = pd.read_sql(table_query, pg_engine)

table_names = tables["table_name"].tolist()

print(f"Found {len(table_names)} tables")
print(table_names)


for table in table_names:

    print(f"\nLoading table: {table}")

    query = f"SELECT * FROM public.{table}"

    df = pd.read_sql(query, pg_engine)

    print(f"Rows fetched: {len(df)}")

    # Snowflake prefers uppercase columns
    df.columns = [c.upper() for c in df.columns]

    target_table = table.upper()

    # Drop existing table
    with sf_engine.begin() as conn:
        conn.execute(text(f"DROP TABLE IF EXISTS {target_table}"))

    print(f"{target_table} dropped")

    # Recreate table automatically
    df.to_sql(
        name=target_table,
        con=sf_engine,
        if_exists="append",
        index=False,
        chunksize=1000
    )

    print(f"{target_table} loaded successfully")
     
pg_engine.dispose()
sf_engine.dispose()

print("\nMigration completed successfully!")