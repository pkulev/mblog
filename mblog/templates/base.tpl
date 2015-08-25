<html>
    <head>
        {% if title %}
        <title>{{ title }} - MicroBlogeeq</title>
        {% else %}
        <title>MicroBlojeeq</title>
        {% endif %}
    </head>
    <body>
        <div>MicroBlogeeq: <a href="/index">Home</a></div>
        <hr>
        {% with messages = get_flashed_messages() %}
            {% if messages %}
            <ul>
                {% for message in messages %}
                    <li>{{ message }}</li>
                {% endfor %}
            </ul>
            {% endif %}
        {% endwith %}

        {% block content %}
        {% endblock %}
    </body>
</html>

