import os.path

from migrate.versioning import api
from config import SQLALCHEMY_DATABASE_URI
from config import SQLALCHEMY_MIGRATE_REPO

from mblog import db


def main():
    db.create_all()

    try:
        api.version_control(SQLALCHEMY_DATABASE_URI,
                SQLALCHEMY_MIGRATE_REPO,
                api.version(SQLALCHEMY_MIGRATE_REPO))

    except Exception as e:
        api.create(SQLALCHEMY_MIGRATE_REPO, "database repository")
        api.version_control(SQLALCHEMY_DATABASE_URI, SQLALCHEMY_MIGRATE_REPO)


if __name__ == "__main__":
    main()
