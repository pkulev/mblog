from flask.ext.wtf import Form
from wtforms import TextField, BooleanField
from wtforms.validators import Required


class LoginForm(Form):
    openid = TextField("openid", validators=[Required()])
    remember_me = BooleanField("remember_me", default=False)


class SignupForm(Form):
    login = TextField("login", validators=[Required()])
    email = TextField("email")
    password = TextField("password")
    pass_confirm = TextField("pass_confirm")
    im_not_a_robot = BooleanField("robot")
