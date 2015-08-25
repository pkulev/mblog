from flask import Flask
from pymongo import MongoClient


app = Flask(__name__)
app.config.from_object("common.config.TestingConfig")
conn = MongoClient(app.config.get("MONGODB_URI"))
db = conn.mblog


from mblog import views, models
