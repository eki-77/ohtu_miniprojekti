from os import getenv

TEST_ENV = getenv("TEST_ENV") == "true"
DATABASE_PATH = getenv("DATABASE_PATH", "database.db")
SECRET_KEY = getenv("SECRET_KEY", "test")
