from flask import Flask, render_template, request

app = Flask(__name__)


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/new-reference")
def new_reference():
    return render_template("new_reference.html")


@app.route("/create-reference", methods=["POST"])
def create_reference():
    return request.form
