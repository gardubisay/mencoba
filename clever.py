import os  # Don't forget to import the os module
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello, Clever Cloud!'

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))
