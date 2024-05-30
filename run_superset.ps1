Set-ExecutionPolicy Bypass -Scope Process -Force

# Create a directory for Superset if it does not already exist
$supersetDir = "C:\superset"
if (-Not (Test-Path $supersetDir)) {
    New-Item -ItemType Directory -Path $supersetDir
}

# Navigate to the Superset directory
Set-Location -Path $supersetDir

 cd c:\superset
 superset-venv\Scripts\activate
 $env:FLASK_APP = "superset"
 $env:SUPERSET_SECRET_KEY = "YtjFciwkCztKOJjlXi1D4f"
 # superset fab create-admin
 superset init
 superset run  --host=0.0.0.0 -p 8088 --with-threads --reload --debugger
