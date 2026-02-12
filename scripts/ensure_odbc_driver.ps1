param(
    [string]$DriverName = "ODBC Driver 18 for SQL Server",
    [string]$MsiUrl = "https://go.microsoft.com/fwlink/?linkid=2249005",
    [switch]$Force
)

$ErrorActionPreference = "Stop"

function Test-IsAdmin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if (-not (Get-Command Get-OdbcDriver -ErrorAction SilentlyContinue)) {
    Write-Error "Get-OdbcDriver is not available. Install the Windows ODBC feature or use a newer PowerShell version."
    exit 1
}

$installed = Get-OdbcDriver | Where-Object { $_.Name -eq $DriverName }
if ($installed -and -not $Force) {
    Write-Host "$DriverName already installed."
    exit 0
}

if (-not (Test-IsAdmin)) {
    Write-Warning "Administrator privileges are required to install the ODBC driver."
}

$downloadPath = Join-Path $env:TEMP "msodbcsql18.msi"
Write-Host "Downloading $DriverName..."
Invoke-WebRequest -Uri $MsiUrl -OutFile $downloadPath -UseBasicParsing

Write-Host "Installing $DriverName..."
$arguments = "/i `"$downloadPath`" /quiet /norestart IACCEPTMSODBCSQLLICENSETERMS=YES"
$process = Start-Process -FilePath "msiexec.exe" -ArgumentList $arguments -Wait -PassThru
if ($process.ExitCode -ne 0) {
    Write-Error "msiexec failed with exit code $($process.ExitCode)."
    exit $process.ExitCode
}

Write-Host "$DriverName installed."
Remove-Item $downloadPath -Force -ErrorAction SilentlyContinue
