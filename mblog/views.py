from flask import render_template, flash, redirect

from mblog import app
from mblog.forms import LoginForm
from mblog.forms import SignupForm


@app.route("/")
@app.route("/index")
def index():
    return render_template("index.tpl")


@app.route("/login", methods=["GET", "POST"])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        flash("Login requested: {0}, remember: {1}.".format(
            form.openid.data,
            form.remember_me.data))
        return redirect("/index")

    return render_template("login.tpl",
            title="Sign In", form=form)


@app.route("/signup", methods=["GET", "POST"])
def signup():
    form = SignupForm()
    if form.validate_on_submit():
        return redirect("/index")

    return render_template("signup.tpl",
            title="Sign Up", form=form)


@app.route("/user/<name>")
def user(name):
    user = {"nickname" : name}
    posts = [
        {"author": {"nickname": "MoSt"},
        "body": "Pschooo! Flask is great!"},
        {"author": {"nickname": "Zulu"},
        "body": "PschooPschoooo"}]
    return render_template("index.tpl",
            title="Home",
            user=user,
            posts=posts)
