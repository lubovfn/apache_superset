# Set execution policy to bypass for this session
Set-ExecutionPolicy Bypass -Scope Process -Force

# Create a directory for Superset if it does not already exist
$supersetDir = "C:\superset"
if (-Not (Test-Path $supersetDir)) {
    New-Item -ItemType Directory -Path $supersetDir
}

# Navigate to the Superset directory
Set-Location -Path $supersetDir

# Create and activate a virtual environment
python -m venv superset-venv
. .\superset-venv\Scripts\Activate.ps1

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
# Upgrade pip and install necessary packages
pip install --upgrade pip setuptools wheel
pip install pillow
pip install apache-superset
pip install psycopg2

# Set environment variables
$env:FLASK_APP = "superset"
$env:SUPERSET_SECRET_KEY = "o6A2S58St/pTds4tidHKTKIh2FQruYdpu3c+n85Obl7R2kVGCLO5wI6E"
#set FLASK_APP=superset
#set SUPERSET_SECRET_KEY = "o6A2S58St/pTds4tidHKTKIh2FQruYdpu3c+n85Obl7R2kVGCLO5wI6E"
# Initialize the database and create an admin user
cd C:\apache_superset\superset-venv\Scripts

cd .\superset-venv\Scripts
superset db upgrade
superset fab create-admin
# superset load_examples
superset init

# Deactivate the virtual environment
deactivate

superset run  --host=0.0.0.0 -p 8884 --with-threads --reload --debugger


#New-NetFirewallRule -Name 'POSTGRESQL-In-TCP' -DisplayName 'PostgreSQL (TCP-In)' -Direction Inbound -Enabled True -Protocol TCP -LocalPort 5432
