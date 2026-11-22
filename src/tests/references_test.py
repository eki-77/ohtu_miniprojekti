import unittest
from flask import Flask
import db
from references import add_or_get_author
from db_helper import reset_db


def test_function_adds_new_author_but_repetition_does_now():
    app = Flask(__name__)
    with app.app_context():
        reset_db()
        eka_id = add_or_get_author("Testinimi")
        toka_id = add_or_get_author("Testinimi")
        assert eka_id == toka_id
        authors = db.query("SELECT name FROM authors")
        assert len(authors) == 1
        assert authors[0]["name"] == "Testinimi"

