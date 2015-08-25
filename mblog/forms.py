from flask.ext.wtf import Form
from wtforms import TextField, BooleanField, PasswordField
from wtforms.validators import Required, Email, EqualTo


class LoginForm(Form):
    openid = TextField("openid", validators=[Required()])
    remember_me = BooleanField("remember_me", default=False)


class SignupForm(Form):
    login = TextField("login", validators=[Required()])
    email = TextField("email", validators=[Email()])
    password = PasswordField("password", validators=[Required(), EqualTo("pass_confirm",
             message="Passwords must match")])
    pass_confirm = PasswordField("pass_confirm")
    im_not_a_robot = BooleanField("not_robot", default=False)
