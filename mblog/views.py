from flask import render_template, flash, redirect

from mblog import app
from mblog import db
from mblog.forms import LoginForm
from mblog.forms import SignupForm
from mblog.models import User, Session


@app.route("/")
@app.route("/index")
def index():
    return render_template("index.tpl")


@app.route("/login", methods=["GET", "POST"])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        login = form.login.data
        password = form.password.data
        user = User(db).validate_login(login, password)
        flash(str(user))
        return redirect("/index")

    return render_template("login.tpl", title="Sign In", form=form)


@app.route("/signup", methods=["GET", "POST"])
def signup():
    form = SignupForm()
    if form.validate_on_submit():
        rc = User(db).add_user(
                form.login.data,
                form.password.data,
                form.email.data)
        if rc is False:
            flash("OLOLO")
        return redirect("/index")

    return render_template("signup.tpl", title="Sign Up", form=form)


@app.route("/user/<name>")
def user(name):
    user = {"nickname": name}
    posts = [{
        "author": {"nickname": "MoSt"},
        "body": "Pschooo! Flask is great!"
    }, {
        "author": {"nickname": "Zulu"},
        "body": "PschooPschoooo"}
    ]

    return render_template("index.tpl", title="Home", user=user, posts=posts)
