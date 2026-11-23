import unittest
from flask import Flask
import db
from db_helper import reset_db
from references import add_or_get_author


class TestReferences(unittest.TestCase):
    def setUp(self):
        self.app_context = Flask(__name__).app_context()
        self.app_context.push()
        reset_db()

    def tearDown(self):
        self.app_context.pop()

    def test_add_or_get_author_reuses_existing_author(self):
        first_id = add_or_get_author("Testinimi")
        second_id = add_or_get_author("Testinimi")

        self.assertEqual(first_id, second_id)
        authors = db.query("SELECT name FROM authors")
        self.assertEqual(len(authors), 1)
        self.assertEqual(authors[0]["name"], "Testinimi")

