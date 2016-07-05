#! /usr/bin/env python

from flask_script import Manager

from mblog import app


manager = Manager(app)


def main():
    """Entry point."""

    manager.run()

if __name__ == "__main__":
    main()
