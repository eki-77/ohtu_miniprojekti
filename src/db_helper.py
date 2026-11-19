"""Creating and resetting the database. Run with: uv run python src/db_helper.py"""

import os

import db


def _connect():
    """Connection with foreign key checks off, so tables can be cleared
    or dropped in any order."""
    con = db.get_connection()
    con.execute("PRAGMA foreign_keys = OFF")
    return con


def tables():
    """Returns all table names from the database"""
    sql = (
        "SELECT name FROM sqlite_master "
        "WHERE type = 'table' AND name NOT LIKE 'sqlite_%'"
    )
    return [row["name"] for row in db.query(sql)]


def reset_db():
    """Deletes all rows from every table, keeping the tables"""
    tables_in_db = tables()
    print(f"Clearing contents from tables: {', '.join(tables_in_db)}")
    con = _connect()
    for table in tables_in_db:
        con.execute(f'DELETE FROM "{table}"')
    con.commit()
    con.close()


def setup_db():
    """
    Creating the database
    If database tables already exist, those are dropped before the creation
    """
    tables_in_db = tables()
    con = _connect()
    if len(tables_in_db) > 0:
        print(f"Tables exist, dropping: {', '.join(tables_in_db)}")
        for table in tables_in_db:
            con.execute(f'DROP TABLE "{table}"')
        con.commit()

    print("Creating database")

    # Read schema from schema.sql file
    schema_path = os.path.join(os.path.dirname(__file__), "schema.sql")
    with open(schema_path, "r", encoding="utf-8") as f:
        schema_sql = f.read()

    con.executescript(schema_sql)
    con.commit()
    con.close()


if __name__ == "__main__":
    setup_db()
