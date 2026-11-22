from datetime import datetime
from flask import Flask, flash, redirect, render_template, request

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

    #Jos kaikken teidon lisääminen ei ole pakollista, tämä tulisi editoida:
    if any(not value.strip() for value in data.values()):
        flash("All fields are required.")
        return redirect("/new-reference")

    references = get_all_references()
    for reference in references:
        if reference["citation_key"] == data["key"]:
            flash("This key already exists.")
            return redirect("/new-reference")
    if len(data["title"]) > 200:
        flash("Title can't be more than 200 marks")
        return redirect("/new-reference")

    if len(data["publisher"]) > 100:
        flash("Publisher can't be more than 100 marks")
        return redirect("/new-reference")

    if int(data["year"]) < 0:
        flash("Year cannot be negative.")
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
