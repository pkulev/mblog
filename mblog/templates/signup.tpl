{% extends "base.tpl" %}

{% block content %}
<h1>Sign Up</h1>
<form action="" method="post" name="signup">
    {{ form.hidden_tag() }}
    <p>Login: {{ form.login(size=30) }}</p>
    <p>Email: {{ form.email() }}</p>
    <p>Password: {{ form.password() }}</p>
    <p>Confirm password: {{ form.pass_confirm() }}</p>
    <p><input type="submit" value="Sign Up!"</p>
</form>
{% endblock %}
