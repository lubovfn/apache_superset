# Set execution policy to bypass for this session
Set-ExecutionPolicy Bypass -Scope Process -Force

# Create a directory for Airflow if it does not already exist
$airflowDir = "C:\airflow"
if (-Not (Test-Path $airflowDir)) {
    New-Item -ItemType Directory -Path $airflowDir
}

# Navigate to the Airflow directory
Set-Location -Path $airflowDir

# Create and activate a virtual environment
python -m venv airflow-venv
. .\airflow-venv\Scripts\Activate.ps1

# Upgrade pip and install necessary packages
pip install --upgrade pip setuptools wheel

pip install waitress

# Installing Apache Airflow with desired extras, here using PostgreSQL
pip install apache-airflow[postgres]==2.3.0 --constraint https://raw.githubusercontent.com/apache/airflow/constraints-2.3.0/constraints-3.7.txt

# Set environment variables
$env:AIRFLOW_HOME = $airflowDir
$env:AIRFLOW__CORE__SQL_ALCHEMY_CONN = "postgresql+psycopg2://airflow:zj1M0v0Nw2GTFXrjlbvc3qajwZ@localhost/airflow"

# Initialize the database
airflow db init

# Create an admin user (not applicable in Airflow by default, managed through RBAC UI if needed)
# airflow users create --role Admin --username admin --email admin@example.com --firstname Admin --lastname User --password your_password
airflow users  create --role Admin --username admin --email admin --firstname admin --lastname admin --password admin
# Start the webserver and scheduler in separate commands or configure as services
Start-Job -ScriptBlock {
    airflow scheduler
}
Start-Job -ScriptBlock {
    airflow webserver -p 8561
}

# Optionally, deactivate the virtual environment when done setting up
deactivate

# Note: The webserver is run here on port 8080. Adjust the port and host as needed.


#----------------------------------------------------------

nssm install AirflowWebserver
$Binary = (Get-Command Powershell).Source

# The necessary arguments, including the path to our script
$Arguments = '-ExecutionPolicy Bypass -NoProfile -File "C:\airflow\airflow_run.ps1"'

# Creating the service
.\nssm.exe install AirflowWebserver $Binary $Arguments

nssm start AirflowWebserver



# https://xkln.net/blog/running-a-powershell-script-as-a-service/
