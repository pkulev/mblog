import os
import argparse
from setuptools import setup, find_packages

def description():
    with open("README.md") as f:
        return f.read()

def requirements():
    with open("requirements.txt") as f:
        return [s.rstrip("\n") for s in f.readlines() if not s.startswith("#")]

setup(
    name="MicroBlojeeq",
    version="1.0dev",
    description="Flask micro blog.",
    long_description=description(),
    py_modules=["run", "create_db", "migrate_db"],
    packages=find_packages(),
    install_requires=requirements(),
    entry_points="""
        [console_scripts]
        mblog-run=run:main
        mblog-create-db=create_db:main
        mblog-mirgate-db=migrate_db:main
        """
)
