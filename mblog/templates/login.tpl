{% extends "base.tpl" %}

{% block content %}
<h1>Sign In</h1>
<form action="" method="post" name="login">
    {{ form.hidden_tag() }}
    <p>
        <table>
            <tr>
              <td>Login: </td>
              <td>{{ form.login(size=30) }}</td>
            </tr>
            <tr>
              <td>Password: </td>
              <td>{{form.password(size=30)}}</td>
            </tr>
        </table>
        {% for error in form.errors.openid %}
            <span style="color: red;">[{{error}}]</span>
        {% endfor %}<br>
    </p>
    <p>Remember me: {{ form.remember_me }}</p>
    <p>I have no account and want to <a href={{ url_for(".signup") }}> register.</a></p>
    <p><input type="submit" value="Sign In"></p>
</form>
{% endblock %}
