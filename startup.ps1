param(
    [string]$DriverName = "ODBC Driver 18 for SQL Server",
    [string]$MsiUrl = "https://go.microsoft.com/fwlink/?linkid=2249005"
)

$ErrorActionPreference = "Stop"

Write-Host "=========================================="
Write-Host "ODBC Driver Setup for Azure App Service"
Write-Host "=========================================="

# Check if ODBC driver is already installed
try {
    $installed = Get-OdbcDriver | Where-Object { $_.Name -eq $DriverName }
    if ($installed) {
        Write-Host "✓ $DriverName is already installed."
        exit 0
    }
} catch {
    Write-Host "⚠ Could not check for existing ODBC driver."
}

# Download and install
Write-Host "Downloading $DriverName..."
$downloadPath = Join-Path $env:TEMP "msodbcsql18.msi"

try {
    Invoke-WebRequest -Uri $MsiUrl -OutFile $downloadPath -UseBasicParsing
    Write-Host "✓ Downloaded successfully."
} catch {
    Write-Host "✗ Download failed: $_"
    exit 1
}

Write-Host "Installing $DriverName..."
$arguments = "/i `"$downloadPath`" /quiet /norestart IACCEPTMSODBCSQLLICENSETERMS=YES"
$process = Start-Process -FilePath "msiexec.exe" -ArgumentList $arguments -Wait -PassThru

if ($process.ExitCode -eq 0) {
    Write-Host "✓ $DriverName installed successfully."
    Remove-Item $downloadPath -Force -ErrorAction SilentlyContinue
    exit 0
} else {
    Write-Host "✗ Installation failed with exit code $($process.ExitCode)."
    exit 1
}
