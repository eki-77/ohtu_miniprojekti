from flask import Flask, flash, redirect, render_template, request, abort

from config import SECRET_KEY, TEST_ENV
from datetime import datetime
from db_helper import reset_db
from references import add_reference, get_all_references, get_a_reference, update_a_reference

app = Flask(__name__)
app.secret_key = SECRET_KEY


def input_valid(data, reference_id=None):
    required_fields = ("key", "title", "author", "year")
    if any(not data.get(field, "").strip() for field in required_fields):
        flash("All fields are required.")
        return False

    references = get_all_references()
    for reference in references:
        if reference["id"] != reference_id and reference["citation_key"] == data["key"].strip():
            flash("This key already exists.")
            return False

    year = data["year"].strip()
    if not year.isdecimal() or len(year) > 4:
        flash("Year must be numbers and a maximum of 4 digits.")
        return False
    
    if int(year) > datetime.now().year:
        flash("Year cannot be in the future.")
        return False

    return True


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

    #Jos kaikken teidon lisääminen ei ole pakollista, tämä tulisi editoida:
    if any(not value.strip() for value in data.values()):
        flash("All fields are required.")
        return redirect("/new-reference")

    references = get_all_references()
    for reference in references:
        if reference["citation_key"] == data["key"]:
            flash("This key already exists.")
            return redirect("/new-reference")

    if not data["year"].isdigit() or len(data["year"]) > 4:
        flash("Year must be numbers and a maximum of 4 digits.")
        return redirect("/new-reference")
    if int(data["year"]) > datetime.now().year: 
        flash("Year cannot be in the future.")
        return redirect("/new-reference")

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
