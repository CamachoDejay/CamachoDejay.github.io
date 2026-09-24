[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = [IO.Path]::GetFullPath((Split-Path -Parent $PSScriptRoot))
$buildPath = [IO.Path]::GetFullPath((Join-Path $repoRoot '_build'))
$expectedParent = $repoRoot.TrimEnd('\')

if (
    -not [string]::Equals(
        [IO.Path]::GetDirectoryName($buildPath),
        $expectedParent,
        [StringComparison]::OrdinalIgnoreCase
    )
) {
    throw "Refusing to use an unexpected build path: $buildPath"
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

$originalLocation = Get-Location
$previousPythonUtf8 = [Environment]::GetEnvironmentVariable(
    'PYTHONUTF8',
    'Process'
)
$previousPythonIoEncoding = [Environment]::GetEnvironmentVariable(
    'PYTHONIOENCODING',
    'Process'
)
$previousNodeenvPermission = [Environment]::GetEnvironmentVariable(
    'JB_ALLOW_NODEENV',
    'Process'
)

function Remove-Build {
    if (Test-Path -LiteralPath $buildPath) {
        Remove-Item -LiteralPath $buildPath -Recurse -Force
    }
}

try {
    [Environment]::SetEnvironmentVariable('PYTHONUTF8', '1', 'Process')
    [Environment]::SetEnvironmentVariable(
        'PYTHONIOENCODING',
        'utf-8',
        'Process'
    )
    [Environment]::SetEnvironmentVariable('JB_ALLOW_NODEENV', '1', 'Process')

    Set-Location $repoRoot
    Write-Host 'Synchronizing the locked environment...'
    & $uvExe sync --locked
    if ($LASTEXITCODE -ne 0) {
        throw "uv sync failed with exit code $LASTEXITCODE"
    }

    Remove-Build
    Write-Host 'Running a clean, strict Jupyter Book 2 build...'
    & $uvExe run --locked jupyter book build --html --strict
    if ($LASTEXITCODE -ne 0) {
        throw "Jupyter Book failed with exit code $LASTEXITCODE"
    }

    $indexPath = Join-Path $buildPath 'html\index.html'
    if (-not (Test-Path -LiteralPath $indexPath -PathType Leaf)) {
        throw "The build completed without creating $indexPath"
    }

    Write-Host 'Validation passed: the strict build completed successfully.'
}
finally {
    Set-Location $originalLocation
    Remove-Build

    [Environment]::SetEnvironmentVariable(
        'PYTHONUTF8',
        $previousPythonUtf8,
        'Process'
    )
    [Environment]::SetEnvironmentVariable(
        'PYTHONIOENCODING',
        $previousPythonIoEncoding,
        'Process'
    )
    [Environment]::SetEnvironmentVariable(
        'JB_ALLOW_NODEENV',
        $previousNodeenvPermission,
        'Process'
    )

    Write-Host "Removed generated build output: $buildPath"
}
