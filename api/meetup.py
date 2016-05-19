"""Meetup API."""

from flask import Flask, render_template, request, send_from_directory
import json
import os

app = Flask(__name__, static_folder='img')


@app.route('/img/<path:path>')
def send_img(path):
    """Send image from dir."""
    app.logger.debug(path)
    return send_from_directory('', path)


@app.route('/')
def secret():
    """Secret."""
    return render_template('secret.html')


@app.route('/check', methods=['POST', 'GET'])
def chec():
    """Check secret data is correct."""
    if request.method == 'POST':
        result = request.form

    vault_data = '/credentials/app.json'
    data = {'msg': 'Vault token is not valid'}

    if os.path.isfile(vault_data):
        with open(vault_data) as data_file:
            response = json.load(data_file)
            app.logger.debug(response)

        if 'data' in response:
            data = response['data']
            if 'password' in data:
                if data['password'] == result['secret']:
                    return render_template('bond.html', data=data)

    return render_template('notbond.html', data=data)


if __name__ == '__main__':
    app.run(
        host='0.0.0.0',
        port=5000,
        debug=True,
        threaded=True)
