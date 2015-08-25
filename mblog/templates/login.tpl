{% extends "base.tpl" %}

{% block content %}
<h1>Sign In</h1>
<form action="" method="post" name="login">
    {{ form.hidden_tag() }}
    <p>
        Please enter your OpenID:<br>
        {{ form.openid(size=80) }}<br>
        {% for error in form.errors.openid %}
            <span style="color: red;">[{{error}}]</span>
        {% endfor %}<br>
    </p>
    <p>Remember me: {{ form.remember_me }}</p>
    <p>I have no account and want to <a href={{ url_for(".signup") }}> register.</a></p>
    <p><input type="submit" value="Sign In"></p>
</form>
{% endblock %}
