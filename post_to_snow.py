import pandas as pd
import psycopg2
from sqlalchemy import create_engine, text

# =====================================================
# POSTGRES CONNECTION
# =====================================================

pg_conn = psycopg2.connect(
    host="pg-2c458362-saidbtproj45.h.aivencloud.com",
    port="10855",
    database="dbt_project",
    user="avnadmin",
    password="REDACTED"
)

# =====================================================
# SNOWFLAKE CONNECTION
# =====================================================

sf_engine = create_engine(
    "snowflake://saikrishna007:Qwerty123456789@jk54382.ap-southeast-1/dbt_hct/test?warehouse=COMPUTE_WH&role=ACCOUNTADMIN"
)

# =====================================================
# CREATE TEST SCHEMA
# =====================================================

with sf_engine.connect() as conn:

    conn.execute(
        text("""
            CREATE SCHEMA IF NOT EXISTS RAW
        """)
    )

    conn.commit()

# =====================================================
# POSTGRES → SNOWFLAKE DATATYPE MAPPING
# =====================================================

TYPE_MAPPING = {
    "integer": "NUMBER",
    "bigint": "NUMBER",
    "smallint": "NUMBER",
    "serial": "NUMBER",
    "bigserial": "NUMBER",
    "numeric": "NUMBER",
    "decimal": "NUMBER",
    "real": "FLOAT",
    "double precision": "FLOAT",
    "character varying": "VARCHAR",
    "varchar": "VARCHAR",
    "character": "VARCHAR",
    "char": "VARCHAR",
    "text": "VARCHAR",
    "boolean": "BOOLEAN",
    "date": "DATE",
    "timestamp": "TIMESTAMP_NTZ",
    "timestamp without time zone": "TIMESTAMP_NTZ",
    "timestamp with time zone": "TIMESTAMP_TZ"
}

# =====================================================
# GET ALL POSTGRES TABLES
# =====================================================

tables_query = """
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
AND table_type = 'BASE TABLE'
ORDER BY table_name
"""

tables_df = pd.read_sql(tables_query, pg_conn)

# =====================================================
# LOOP THROUGH EACH TABLE
# =====================================================

for table_name in tables_df["table_name"]:

    print(f"\nProcessing Table : {table_name}")

    # =================================================
    # GET COLUMN METADATA
    # =================================================

    columns_query = f"""
    SELECT
        column_name,
        data_type,
        character_maximum_length,
        numeric_precision,
        numeric_scale,
        is_nullable
    FROM information_schema.columns
    WHERE table_schema='public'
    AND table_name='{table_name}'
    ORDER BY ordinal_position
    """

    columns_df = pd.read_sql(columns_query, pg_conn)

    # =================================================
    # BUILD SNOWFLAKE DDL
    # =================================================

    ddl_columns = []

    for _, row in columns_df.iterrows():

        column_name = row["column_name"]
        pg_type = row["data_type"]
        length = row["character_maximum_length"]
        precision = row["numeric_precision"]
        scale = row["numeric_scale"]
        nullable = row["is_nullable"]

        sf_type = TYPE_MAPPING.get(
            pg_type.lower(),
            "VARCHAR"
        )

        # VARCHAR LENGTH
        if sf_type == "VARCHAR" and pd.notna(length):
            sf_type = f"VARCHAR({int(length)})"

        # NUMERIC PRECISION SCALE
        if pg_type.lower() in ["numeric", "decimal"]:

            if pd.notna(precision) and pd.notna(scale):

                sf_type = (
                    f"NUMBER({int(precision)},"
                    f"{int(scale)})"
                )

        column_def = f"{column_name.upper()} {sf_type}"

        if nullable == "NO":
            column_def += " NOT NULL"

        ddl_columns.append(column_def)

    # =================================================
    # CREATE RAW TABLE
    # =================================================

    ddl = f"""
    CREATE OR REPLACE TABLE test.RAW_{table_name.upper()}
    (
        {",".join(ddl_columns)}
    )
    """

    print("Creating Snowflake Table...")

    with sf_engine.connect() as conn:

        conn.execute(text(ddl))
        conn.commit()

    print(
        f"Created : test.RAW_{table_name.upper()}"
    )

    # =================================================
    # READ DATA FROM POSTGRES
    # =================================================

    data_query = f"""
    SELECT *
    FROM public.{table_name}
    """

    df = pd.read_sql(data_query, pg_conn)

    print(
        f"Rows Fetched : {len(df)}"
    )

    # =================================================
    # LOAD DATA TO SNOWFLAKE
    # =================================================

    df.columns = [col.upper() for col in df.columns]

    df.to_sql(
        name=f"RAW_{table_name.upper()}",
        schema="test",
        con=sf_engine,
        if_exists="append",
        index=False,
        method="multi",
        chunksize=10000
    )

    print(
        f"Loaded : test.RAW_{table_name.upper()}"
    )

# =====================================================
# CLOSE CONNECTION
# =====================================================

pg_conn.close()

print("\nMigration Completed Successfully!")