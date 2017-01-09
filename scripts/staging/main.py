from flask import Flask, request, render_template, redirect, session, url_for, g
import logging
import requests
import simplejson as json
import sys
import subprocess
import time
from urllib.parse import urlparse
import pickle

app = Flask(__name__)
app.config.from_object(__name__)

logging.basicConfig(filename='docker-webhook.log', level=logging.DEBUG)
logging.info('Started')

DEPLOY_STAGING = "scripts/redeploy_staging.sh"
UPDATE_DOC_CONTENT = "scripts/update_doc_folder.sh"

# This is triggered via a webhook on GitHub
@app.route("/docs_content_update", methods=['POST'])
def docs_updated():
    logging.info("repopulating docs content with new content")
    subprocess.Popen(UPDATE_DOC_CONTENT, shell=True).wait()
    subprocess.Popen(DEPLOY_STAGING, shell=True).wait()
    return "OK"

if __name__ == "__main__":
    #subprocess.Popen(UPDATE_DOC_CONTENT, shell=True).wait()
    #subprocess.Popen(DEPLOY_STAGING, shell=True)
    app.run(host='0.0.0.0', port=8081)
