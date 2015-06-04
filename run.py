#! /usr/bin/env python

from flask.ext.script import Manager

from app import app


manager = Manager(app)

def main():
    manager.run()

if __name__ == "__main__":
    main()
