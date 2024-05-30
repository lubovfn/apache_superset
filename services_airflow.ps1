services_airflow.ps1
Set-ExecutionPolicy Bypass -Scope Process -Force

# Create a directory for airflow if it does not already exist
$airflowDir = "C:\airflow"
if (-Not (Test-Path $airflowDir)) {
    New-Item -ItemType Directory -Path $airflowDir
}

# Navigate to the airflow directory
Set-Location -Path $airflowDir

 cd c:\airflow
 airflow_venv\Scripts\activate
 $airflowDir = "C:\airflow"
 $env:AIRFLOW_HOME = $airflowDir
 $env:AIRFLOW__CORE__SQL_ALCHEMY_CONN = "postgresql+psycopg2://airflow:zj1M0v0Nw2GTFXrjlbvc3qajwZ@localhost/airflow"
 # superset fab create-admin
 airflow db init
 # airflow scheduler
 python C:\airflow\start_airflow.py

 airflow scheduler
