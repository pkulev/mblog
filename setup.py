import os
import argparse
from setuptools import setup

def requirements():
    with open("requirements.txt") as f:
        return [s.rstrip("\n") for s in f.readlines() if not s.startswith("#")]

setup(
    name="MicroBlojeeq",
    version="1.0dev",
    py_modules=["run"],
    packages=["app"],
    install_requires=requirements(),
    entry_points="""
        [console_scripts]
        mblog-run=run:main
        """
)
