import imp

from migrate.versioning import api

from mblog import db
from config import SQLALCHEMY_DATABASE_URI as db_uri
from config import SQLALCHEMY_MIGRATE_REPO as migrate_repo


def main():
    current_version = api.db_version(db_uri, migrate_repo)
    next_version = current_version + 1

    migration = migrate_repo + "/versions/{0:03d}_migration.py".format(next_version)

    tmp_module = imp.new_module("old_model")
    old_model = api.create_model(db_uri, migrate_repo)
    exec(old_model, tmp_module.__dict__)

    script = api.make_update_script_for_model(
            db_uri,
            migrate_repo,
            tmp_module.meta,
            db.metadata)

    with open(migration, "wt") as f:
        f.write(script)

    api.upgrade(db_uri, migrate_repo)

    print("New migration saved as {0}".format(migration))
    print("Current database version: {0}".format(str(current_version)))


if __name__ == "__main__":
    main()
