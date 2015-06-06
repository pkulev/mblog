from flask import render_template, flash, redirect

from mblog import app
from mblog.forms import LoginForm


class Templates:
    index = "index.html"
    login = "login.html"


@app.route("/")
@app.route("/index")
def index():
    return render_template(Templates.index)


@app.route("/login", methods = ["GET", "POST"])
def login():
    form = LoginForm()
    return render_template(Templates.login,
            title="Sign In",
            form=form)


@app.route("/user/<name>")
def user(name):
    user = {"nickname" : name}
    posts = [
        {"author": {"nickname": "MoSt"},
        "body": "Pschooo! Flask is great!"},
        {"author": {"nickname": "Zulu"},
        "body": "PschooPschoooo"}]
    return render_template(Templates.index,
            title="Home",
            user=user,
            posts=posts)
