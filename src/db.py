import sqlite3

from flask import g

from config import DATABASE_PATH


def get_connection():
    con = sqlite3.connect(DATABASE_PATH)
    con.execute("PRAGMA foreign_keys = ON")
    con.row_factory = sqlite3.Row
    return con


def execute(sql, params=[]): # pylint: disable=dangerous-default-value
    con = get_connection()
    result = con.execute(sql, params)
    con.commit()
    g.last_insert_id = result.lastrowid
    con.close()


def last_insert_id():
    return g.last_insert_id


def query(sql, params=[]): # pylint: disable=dangerous-default-value
    con = get_connection()
    result = con.execute(sql, params).fetchall()
    con.close()
    return result
