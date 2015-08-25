{% extends "base.tpl" %}

{% block content %}
{% if user %}
<h1>Hello, {{ user.nickname }}!</h1>
{% else %}
<h1>Hello, Stranger!</h1>
<h3>Please, <a href={{ url_for(".login") }}>login</a> to get access to blog.</h3>
{% endif %}

{% for post in posts %}
<div><p>{{ post.author.nickname }} says: <b>{{ post.body }}</b></p></div>
{% endfor %}
{% endblock %}
