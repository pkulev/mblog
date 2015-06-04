from flask import render_template

from app import app

class Templates:
    index = "index.html"

@app.route("/")
@app.route("/index")
def index():
    return render_template(Templates.index)


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

        
