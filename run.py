#! /usr/bin/env python

from flask.ext.script import Manager

from mblog import app


manager = Manager(app)

def main():
    manager.run()

if __name__ == "__main__":
    main()
