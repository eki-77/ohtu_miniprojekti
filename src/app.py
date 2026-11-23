from datetime import datetime

from flask import Flask, abort, flash, redirect, render_template, request

from config import SECRET_KEY, TEST_ENV
from db_helper import reset_db
from references import (
    add_reference,
    delete_reference,
    get_a_reference,
    get_all_references,
    update_a_reference,
)

app = Flask(__name__)
app.secret_key = SECRET_KEY


def input_valid(data, reference_id=None):
    required_fields = ("key", "title", "author", "year")
    if any(not data.get(field, "").strip() for field in required_fields):
        flash("All fields are required.")
        return False

    if len(data["title"].strip()) > 200:
        flash("Title can't be more than 200 marks")
        return False

    if len(data.get("publisher", "").strip()) > 100:
        flash("Publisher can't be more than 100 marks")
        return False

    references = get_all_references()
    for reference in references:
        if (
            reference["id"] != reference_id
            and reference["citation_key"] == data["key"].strip()
        ):
            flash("This key already exists.")
            return False

    year = data["year"].strip()
    if year.startswith("-") and year[1:].isdecimal():
        flash("Year cannot be negative.")
        return False

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
    return render_template("index.html", references=references, count=len(references))


@app.route("/new-reference")
def new_reference():
    return render_template("new_reference.html")


@app.route("/create-reference", methods=["POST"])
def create_reference():
    data = request.form

    if not input_valid(data):
        return redirect("/new-reference")

    add_reference(
        data["key"].strip(),
        "book",
        data["title"].strip(),
        data["year"].strip(),
        data["author"].strip(),
        data.get("publisher", "").strip() or None,
    )

    flash("Reference added successfully.")
    return redirect("/")


@app.route("/edit/<int:reference_id>", methods=["GET", "POST"])
def edit_reference(reference_id):
    reference = get_a_reference(reference_id)

    if not reference:
        abort(404)

    if request.method == "GET":
        return render_template("edit.html", reference=reference)

    data = request.form
    if not input_valid(data, reference_id):
        return redirect(f"/edit/{reference_id}")

    citation_key = data["key"].strip()
    title = data["title"].strip()
    author = data["author"].strip()
    publisher = data.get("publisher", "").strip() or None
    year = data["year"].strip()

    update_a_reference(reference_id, citation_key, title, year, author, publisher)
    flash("Reference updated successfully.")
    return redirect("/")


@app.route("/delete-reference/<int:reference_id>", methods=["POST"])
def delete_reference_route(reference_id):
    delete_reference(reference_id)
    return redirect("/")


if TEST_ENV:

    @app.route("/reset-db")
    def reset_database():
        reset_db()
        return "Database reset"
