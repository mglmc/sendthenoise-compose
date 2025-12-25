param (
    [Parameter(Mandatory = $true)]
    [string]$ImageName
)

# Add Docker to PATH if not found
$dockerPath = "C:\Program Files\Docker\Docker\resources\bin"
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    if (Test-Path $dockerPath) {
        $env:PATH = "$dockerPath;$env:PATH"
    } else {
        Write-Error "Docker not found. Please install Docker Desktop."
        exit 1
    }
}

$env:SERVER_IMAGE_NAME = $ImageName

# Run docker compose config and capture output
$configArgs = @("-f", "services/base.yaml", "-f", "services/add-postgres.yaml", "-f", "services/add-server.yaml", "-f", "services/add-nginx.yaml", "-f", "services/add-mathesar.yaml", "config")
$output = docker compose @configArgs 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Error "docker compose config failed: $output"
    exit 1
}

# Always remove the build section (we only use pre-built images)
$cleanedOutput = @()
$skipBuild = $false
$buildIndent = 0

foreach ($line in ($output -split "`n")) {
    if ($line -match "^\s*build:") {
        $skipBuild = $true
        $buildIndent = ($line -replace '^(\s*).*', '$1').Length
        continue
    }
    if ($skipBuild) {
        $currentIndent = ($line -replace '^(\s*).*', '$1').Length
        if ($line.Trim() -ne "" -and $currentIndent -le $buildIndent) {
            $skipBuild = $false
        } else {
            continue
        }
    }
    $cleanedOutput += $line
}

$cleanedOutput -join "`n" | Out-File -FilePath "docker-compose.yaml" -Encoding UTF8

Write-Host "Generated docker-compose.yaml for $ImageName"
