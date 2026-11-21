from flask import Flask, render_template, request

from config import SECRET_KEY, TEST_ENV
from db_helper import reset_db
from references import add_reference, get_all_references

app = Flask(__name__)
app.secret_key = SECRET_KEY

@app.route("/")
def index():
    references = get_all_references()
    return render_template(
        "index.html", 
        references=references,
        count=len(references))


@app.route("/new-reference")
def new_reference():
    return render_template("new_reference.html")


@app.route("/create-reference", methods=["POST"])
def create_reference():
    data = request.form
    add_reference(
        data["key"],
        "book",
        data["title"],
        data["year"],
        data["author"],
        data["publisher"],
    )
    # if successful:
    flash("Reference added successfully.")
    return redirect("/")


if TEST_ENV:

    @app.route("/reset-db")
    def reset_database():
        reset_db()
        return "Database reset"
