import os
from migrate.versioning import api

basedir = os.path.abspath(os.path.dirname(__file__))


SQLALCHEMY_DATABASE_URI = "sqlite:///" + os.path.join(basedir, "mblog.db")
SQLALCHEMY_MIGRATE_REPO = os.path.join(basedir, "db_repository")

CSRF_ENABLED = True
SECRET_KEY = 'you-will-never-guess'


def get_version():
    return api.db_version(SQLALCHEMY_DATABASE_URI, SQLALCHEMY_MIGRATE_REPO)
