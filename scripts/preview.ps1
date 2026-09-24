[CmdletBinding()]
param(
    [ValidateRange(1, 65535)]
    [int]$Port = 8000,

    [switch]$NoBrowser
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$tempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
$previewPath = [IO.Path]::GetFullPath(
    (Join-Path $tempRoot 'camachodejay-preview')
)
$expectedParent = $tempRoot.TrimEnd('\')

if (
    -not [string]::Equals(
        [IO.Path]::GetDirectoryName($previewPath),
        $expectedParent,
        [StringComparison]::OrdinalIgnoreCase
    )
) {
    throw "Refusing to use an unexpected preview path: $previewPath"
}

$uvCommand = Get-Command uv -ErrorAction SilentlyContinue
if ($null -ne $uvCommand) {
    $uvExe = $uvCommand.Source
}
else {
    $uvExe = Join-Path $env:USERPROFILE '.local\bin\uv.exe'
    if (-not (Test-Path -LiteralPath $uvExe -PathType Leaf)) {
        throw "uv was not found on PATH or at $uvExe"
    }
}

$serverProcess = $null

function Remove-Preview {
    if (Test-Path -LiteralPath $previewPath) {
        Remove-Item -LiteralPath $previewPath -Recurse -Force
    }
}

Push-Location $repoRoot
try {
    Remove-Preview

    Write-Host 'Building the site...'
    & $uvExe run jupyter-book build . --path-output $previewPath --all
    if ($LASTEXITCODE -ne 0) {
        throw "Jupyter Book failed with exit code $LASTEXITCODE"
    }

    $htmlPath = Join-Path $previewPath '_build\html'
    $indexPath = Join-Path $htmlPath 'index.html'
    if (-not (Test-Path -LiteralPath $indexPath -PathType Leaf)) {
        throw "The build completed without creating $indexPath"
    }

    $pythonExe = Join-Path $repoRoot '.venv\Scripts\python.exe'
    if (-not (Test-Path -LiteralPath $pythonExe -PathType Leaf)) {
        throw "The project Python executable was not found at $pythonExe"
    }

    $url = "http://127.0.0.1:$Port/"
    $serverArguments = @(
        '-m'
        'http.server'
        $Port.ToString()
        '--bind'
        '127.0.0.1'
        '--directory'
        "`"$htmlPath`""
    )

    $serverProcess = Start-Process `
        -FilePath $pythonExe `
        -ArgumentList $serverArguments `
        -WorkingDirectory $repoRoot `
        -WindowStyle Hidden `
        -PassThru

    $serverReady = $false
    for ($attempt = 0; $attempt -lt 50; $attempt++) {
        $serverProcess.Refresh()
        if ($serverProcess.HasExited) {
            throw "The preview server exited with code $($serverProcess.ExitCode)"
        }

        try {
            Invoke-WebRequest `
                -Uri $url `
                -UseBasicParsing `
                -TimeoutSec 1 | Out-Null
            $serverReady = $true
            break
        }
        catch {
            Start-Sleep -Milliseconds 100
        }
    }

    if (-not $serverReady) {
        throw "The preview server did not become ready at $url"
    }

    Write-Host "Preview ready at $url"
    if (-not $NoBrowser) {
        Start-Process -FilePath $url
    }

    Write-Host 'Press Ctrl+C to stop the server and delete the temporary build.'
    Wait-Process -Id $serverProcess.Id
}
finally {
    if ($null -ne $serverProcess) {
        $serverProcess.Refresh()
        if (-not $serverProcess.HasExited) {
            Stop-Process -Id $serverProcess.Id -Force
            Wait-Process -Id $serverProcess.Id -ErrorAction SilentlyContinue
        }
    }

    Remove-Preview
    Pop-Location
    Write-Host "Removed temporary preview: $previewPath"
}
