# Bootstrap remoto do Boare Protocol Dev.
#
# Baixa o protocolo do GitHub para uma pasta temporária e roda o instalador
# local a partir dali, aplicando os adaptadores no diretório atual (onde este
# script foi chamado), sem exigir clone manual antes.
#
# Uso:
#   $b = Join-Path $env:TEMP "boare-bootstrap.ps1"
#   Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/pauloboare/BoareProtocolDev/v1/bootstrap.ps1" -OutFile $b
#   & $b -Projeto -Ferramenta auto
#
# Aceita os mesmos parâmetros de instalar.ps1, incluindo -Referencia para
# baixar outra versão do protocolo (tag ou branch).

param(
    [switch]$Projeto,
    [switch]$Status,
    [ValidateSet('auto', 'vscode', 'claude', 'cursor', 'opencode', 'antigravity', 'kimi', 'codex', 'todas', 'assistida')]
    [string]$Ferramenta = 'auto',
    [string]$Referencia = 'v1'
)

$ErrorActionPreference = 'Stop'

$repo = 'pauloboare/BoareProtocolDev'
$tarballUrl = "https://github.com/$repo/archive/$Referencia.zip"

$tmpDir = Join-Path ([System.IO.Path]::GetTempPath()) ("boare-" + [System.Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $tmpDir | Out-Null

try {
    $zipPath = Join-Path $tmpDir 'protocolo.zip'
    Write-Host "Baixando Boare Protocol Dev ($Referencia)..."

    try {
        Invoke-WebRequest -UseBasicParsing -Uri $tarballUrl -OutFile $zipPath
    }
    catch {
        Write-Error "Não foi possível baixar '$Referencia' de $repo. Confira o nome da tag ou branch."
        exit 1
    }

    Expand-Archive -LiteralPath $zipPath -DestinationPath $tmpDir -Force

    $sourceDir = Get-ChildItem -Path $tmpDir -Directory |
        Where-Object { Test-Path (Join-Path $_.FullName 'instalar.ps1') } |
        Select-Object -First 1

    if (-not $sourceDir) {
        Write-Error "Download concluído, mas instalar.ps1 não foi encontrado em '$Referencia'."
        exit 1
    }

    $instalarArgs = @{
        Ferramenta  = $Ferramenta
        Referencia  = $Referencia
    }
    if ($Projeto) { $instalarArgs['Projeto'] = $true }
    if ($Status) { $instalarArgs['Status'] = $true }

    & (Join-Path $sourceDir.FullName 'instalar.ps1') @instalarArgs
}
finally {
    Remove-Item -Recurse -Force $tmpDir -ErrorAction SilentlyContinue
}
