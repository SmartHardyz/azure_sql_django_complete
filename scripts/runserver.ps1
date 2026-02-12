param(
    [string]$PythonExe = "python"
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Resolve-Path (Join-Path $scriptDir "..")

Set-Location $projectRoot

& "$scriptDir\ensure_odbc_driver.ps1"
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

& $PythonExe manage.py runserver
