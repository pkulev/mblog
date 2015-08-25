import random
import string
import hashlib
import pymongo


class User(object):
    """User data access object."""

    def __init__(self, db):
        self.db = db
        self.users = self.db.users
        self.SECRET = "verysecret"

    def make_salt(self):
        """Make a little salt."""
        salt = ""
        for i in range(5):
            salt += random.choice(string.ascii_letters)
        return salt

    def hash_password(self, password, salt=None):
        """Return hashed password: (HASH(password + salt), salt)."""
        if salt is None:
            salt = self.make_salt()
        return hashlib.sha256("".join([password, salt]).encode("utf-8")).hexdigest() + "," + salt

    def validate_login(self, username, password):
        """
        Validate user login.

        Return: user record or None."""

        user = None
        try:
            user = self.users.find_one({"_id": username})
        except Exception as e:
            print("Unable to query database for user.")

        if user:
            salt = user["password"].split(",")[1]
            if user["password"] == self.hash_password(password, salt):
                return user
        return None

    def add_user(self, username, password, email):
        """Create a new user in the users collection."""
        password_hash = self.hash_password(password)

        user = {"_id": username, "password": password_hash}
        if email:
            user["email"] = email

        try:
            self.users.insert(user)
        except pymongo.errors.OperationFailure as e:
            print("Mongo error: " + str(e))
            return False
        except pymongo.errors.DuplicateKeyError as e:
            print("Username already taken." + str(e))
            return False

        return True


class Session(object):
    """Session data access object."""

    def __init__(self, db):
        self.db = db
        self.sessions = self.db.sessions

    def start_session(self, username):
        """
        Start new session id.

        Add adding new document to the session collection.
        Return sessionID or None."""
        session_id = self.get_random_str(32)
        session = {"_id": session_id, "username": username}

        try:
            self.sessions.insert_one(session)
        except Exception as e:
            print(str(e))
            return None

        return str(session["_id"])

    def end_session(self, session_id):
        if session_id:
            self.sessions.delete_one({"_id": session_id})

    def get_session(self, session_id):
        """Return session."""
        if session_id:
            session = self.sessions.find_one({"_id": session_id})
            return session
        return None

    def get_username(self, session_id):
        """Return username of the current session."""
        session = self.get_session(session_id)
        if session:
            return session["username"]
        return None

    def get_random_str(self, amount):
        random_string = ""
        for i in range(amount):
            random_string += random.choice(string.ascii_letters)
        return random_string
