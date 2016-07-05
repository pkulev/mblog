import os


basedir = os.path.abspath(os.path.dirname(__file__))


class Config(object):
    MBLOG_LOG = "/var/log/mblog"
    MBLOG_PID = "/var/run/mblog/lock"
    MBLOG_LOCK = MBLOG_PID

    DEBUG = False
    TESTING = False

    MAX_REQUEST_SIZE = 10 * 1024
    """Maximum possible size of incoming request."""

    CSRF_ENABLED = True
    """Cross-reference attack protection."""

    SECRET_KEY = 'you-will-never-guess'
    """CSRF secret key."""


class ProductionConfig(Config):
    pass


class DevelopmentConfig(Config):
    DEBUG = True


class TestingConfig(Config):
    DEBUG = True
    TESTING = True
    MONGODB_URI = "mongodb://localhost"


config = Config()

