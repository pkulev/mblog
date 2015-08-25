{% extends "base.tpl" %}

{% block content %}
<h1>Sign Up</h1>

<form action="" method="post" name="signup">
    {{ form.hidden_tag() }}

    <p>Login: {{ form.login(size=30) }}</p>
    {% for error in form.errors.login %}
        <span style="color: red;">[{{error}}]</span>
    {% endfor %}

    <p>Email: {{ form.email() }}</p>
    {% for error in form.errors.login %}
        <span style="color: red;">[{{error}}]</span>
    {% endfor %}

    <p>Password: {{ form.password() }}</p>
    {% for error in form.errors.password %}
        <span style="color: red;">[{{error}}]</span>
    {% endfor %}

    <p>Confirm password: {{ form.pass_confirm() }}</p>
    {% for error in form.errors.pass_confirm %}
        <span style="color: red;">[{{error}}]</span>
    {% endfor %}
    <p>I'm not a robot: {{ form.im_not_a_robot() }}</p>
    <p><input type="submit" value="Sign Up!"</p>
</form>
{% endblock %}
