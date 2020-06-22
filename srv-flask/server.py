# /server.py

from functools import wraps
import json
from os import environ as env
from werkzeug.exceptions import HTTPException

from dotenv import load_dotenv, find_dotenv
from flask import Flask
from flask import jsonify, request
from flask import redirect
from flask import render_template
from flask import session
from flask import url_for
from authlib.integrations.flask_client import OAuth
from decouple import config
from six.moves.urllib.parse import urlencode
import logging

app = Flask(__name__)
app.secret_key = config("SECRET_KEY")

### OAUTH
oauth = OAuth(app)

auth0 = oauth.register(
    "auth0",
    client_id=config("CLIENT_ID"),
    client_secret=config("CLIENT_SECRET"),
    api_base_url=config("API_BASE_URL"),
    access_token_url=config("ACCESS_TOKEN_URL"),
    authorize_url=config("AUTHORIZE_URL"),
    client_kwargs={"scope": "openid profile email",},
)

# Here we're using the /callback route.
@app.route("/callback")
def callback_handling():
    # Handles response from token endpoint
    auth0.authorize_access_token()
    resp = auth0.get("userinfo")
    userinfo = resp.json()

    # Store the user information in flask session.
    session["jwt_payload"] = userinfo
    session["profile"] = {
        "user_id": userinfo["sub"],
        "name": userinfo["name"],
        "picture": userinfo["picture"],
    }
    return redirect("/dashboard")


@app.route("/login")
def login():
    return auth0.authorize_redirect(
        redirect_uri=config("REDIRECT_URI"), audience=config("AUDIENCE"),
    )


def requires_auth(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if "profile" not in session:
            # Redirect to Login page here
            return redirect("/")
        return f(*args, **kwargs)

    return decorated


@app.route("/logout")
def logout():
    # Clear session stored data
    session.clear()
    # Redirect user to logout endpoint
    params = {
        "returnTo": url_for("home", _external=True),
        "client_id": config("CLIENT_ID"),
    }
    return redirect(auth0.api_base_url + "/v2/logout?" + urlencode(params))


### Home
@app.route("/")
def home():
    return jsonify("Home")


### Dashboard
@app.route("/dashboard")
@requires_auth
def dashboard():
    profile = {}
    userinfo = session["profile"]
    profile["name"] = userinfo["name"]
    return render_template("dashboard.html", profile=json.dumps(profile ))


### Submit Story
@app.route("/submit-story")
@requires_auth
def submit_story():
    return render_template("submitStory.html")


@app.route("/api/submit-story", methods=["POST"])
@requires_auth
def api_submit_story():
    app.logger.info("Success")
    app.logger.info(request.json)
    app.logger.info(session["profile"])
    return jsonify("success")


if __name__ == "__main__":
    app.run()
