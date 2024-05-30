# apache_superset
SUPERSET INSTALL
sudo apt update -y & sudo apt upgrade -y
Install dependencies
sudo apt-get install build-essential libssl-dev libffi-dev python3-dev python3-pip libsasl2-dev libldap2-dev default-libmysqlclient-dev python3.10-venv
Create app directory for superset and dependencies
sudo mkdir /app
sudo chown user /app
cd /app
Create python environment
mkdir superset
cd superset
python3 -m venv superset_env
. superset_env/bin/activate
pip install --upgrade setuptools pip
Install Required dependencies
pip install pillow
pip install apache-superset
Create superset config file and set environment variable
touch superset_config.py
export SUPERSET_CONFIG_PATH=/app/superset/superset_config.py
nano superset_config.py

Edit and paste following code in it
# Superset specific config
ROW_LIMIT = 5000

# Flask App Builder configuration
# Your App secret key will be used for securely signing the session cookie
# and encrypting sensitive information on the database
# Make sure you are changing this key for your deployment with a strong key.
# Alternatively you can set it with `SUPERSET_SECRET_KEY` environment variable.
# You MUST set this for production environments or the server will not refuse
# to start and you will see an error in the logs accordingly.
SECRET_KEY = 'YOUR_OWN_RANDOM_GENERATED_SECRET_KEY'

# The SQLAlchemy connection string to your database backend
# This connection defines the path to the database that stores your
# superset metadata (slices, connections, tables, dashboards, ...).
# Note that the connection information to connect to the datasources
# you want to explore are managed directly in the web UI
# The check_same_thread=false property ensures the sqlite client does not attempt
# to enforce single-threaded access, which may be problematic in some edge cases
SQLALCHEMY_DATABASE_URI = 'sqlite:////app/superset/superset.db?check_same_thread=false'

TALISMAN_ENABLED = False
WTF_CSRF_ENABLED = False

# Set this API key to enable Mapbox visualizations
MAPBOX_API_KEY = ''
AUTH_ROLE_PUBLIC = 'Public'
PUBLIC_ROLE_LIKE = "Guest"  # i created guest role for anonymous view dashboards

FEATURE_FLAGS = {
    "DASHBOARD_RBAC": True,  # it's obligatory
    "ENABLE_TEMPLATE_PROCESSING": True,
    "DASHBOARD_NATIVE_FILTERS": True,
    "DASHBOARD_CROSS_FILTERS": True
}


Please replace YOUR_OWN_RANDOM_GENERATED_SECRET_KEY 
openssl rand -base64 42
export SUPERSET_SSCRET_KEY=dcziytIVoZlky+iWI+bFVB8S1Y6GlIU/pmHW1AOLKRAhQifM12W/5f+W
export FLASK_APP=superset

inititlize database with following commands
# Create an admin user in your metadata database (use `admin` as username to be able to load the examples)
export FLASK_APP=superset

superset db upgrade

superset fab create-admin

# As this is going to be production I have commented load example part but if you need you can run this
# superset load_examples

# Create default roles and permissions
superset init

create create script 
nano run_superset.sh
#!/bin/bash
export SUPERSET_CONFIG_PATH=/app/superset/superset_config.py
 . /app/superset/superset_env/bin/activate
gunicorn \
      -w 10 \
      -k gevent \
      --timeout 120 \
      -b  0.0.0.0:8674 \
      --limit-request-line 0 \
      --limit-request-field_size 0 \
      --statsd-host localhost:8843 \
      "superset.app:create_app()"

we need to grant it run permission
chmod +x run_superset.sh
sh run_superset.sh

create service
sudo nano /etc/systemd/system/superset.service
paste following code in it
[Unit]
Description = Apache Superset Webserver Daemon
After = network.target

[Service]
PIDFile = /app/superset/superset-webserver.PIDFile
Environment=SUPERSET_HOME=/app/superset
Environment=PYTHONPATH=/app/superset
WorkingDirectory = /app/superset
limit-re>
ExecStart = /app/superset/run_superset.sh
ExecStop = /bin/kill -s TERM $MAINPID


[Install]
WantedBy=multi-user.target


enable and start service
systemctl daemon-reload
sudo systemctl enable superset.service
sudo systemctl start superset.service

To install Postgres Drivers copy and execute following code
    sudo apt-get install libpq-dev python-dev
    pip install psycopg2
