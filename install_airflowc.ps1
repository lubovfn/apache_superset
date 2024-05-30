cd C:\airflow
python -m venv airflow_venv
.\airflow_venv\Scripts\activate
$env:SLUGIFY_USES_TEXT_UNIDECODE="yes"
[System.Environment]::SetEnvironmentVariable('SLUGIFY_USES_TEXT_UNIDECODE', 'yes', [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable('SLUGIFY_USES_TEXT_UNIDECODE', 'yes', [System.EnvironmentVariableTarget]::Machine)

pip install apache-airflow['postgresql']

pip install psycopg2

airflow initdb

airflow webserver -p 8377

# create folder DAG in C: drive (C:\DAG)

# Add new DAG 

run airflow initdb











pip install apache-airflow[postgres]==2.3.0 --constraint https://raw.githubusercontent.com/apache/airflow/constraints-2.3.0/constraints-3.7.txt
set AIRFLOW_HOME=C:\path\to\airflow
airflow db init

# Edit the configuration file (airflow.cfg) to set the correct executor and point to the PostgreSQL database:
executor = LocalExecutor
sql_alchemy_conn = postgresql+psycopg2://airflow:your_password@localhost/airflow

nssm install airflow_scheduler "C:\path\to\airflow_venv\Scripts\airflow.exe"
nssm set airflow_scheduler AppDirectory "C:\path\to\airflow"
nssm set airflow_scheduler AppParameters scheduler
nssm start airflow_scheduler

nssm install airflow_webserver "C:\path\to\airflow_venv\Scripts\airflow.exe"
nssm set airflow_webserver AppDirectory "C:\path\to\airflow"
nssm set airflow_webserver AppParameters webserver
nssm start airflow_webserver


# Start the scheduler and webserver
airflow scheduler
airflow webserver -p 8374
