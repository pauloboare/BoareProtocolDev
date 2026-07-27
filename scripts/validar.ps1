param()

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$releaseVersion = '1.0.0'
$protocolRef = 'v1'
$expectedRawUrl = "https://raw.githubusercontent.com/pauloboare/BoareProtocolDev/$protocolRef/CONDUZIR.md"
$expectedStartRawUrl = "https://raw.githubusercontent.com/pauloboare/BoareProtocolDev/$protocolRef/COMECE_AQUI.md"
$expectedCdnBaseUrl = "https://cdn.jsdelivr.net/gh/pauloboare/BoareProtocolDev@$protocolRef/"
$forbiddenEmDash = [string][char]0x2014

function Resolve-RepoPath {
    param([string]$RelativePath)
    return Join-Path $repoRoot $RelativePath
}

function Assert-File {
    param([string]$RelativePath)
    $path = Resolve-RepoPath $RelativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "Arquivo obrigatório ausente: $RelativePath"
    }
}

function Assert-Dir {
    param([string]$RelativePath)
    $path = Resolve-RepoPath $RelativePath
    if (-not (Test-Path -LiteralPath $path -PathType Container)) {
        throw "Diretório obrigatório ausente: $RelativePath"
    }
}

function Read-RepoText {
    param([string]$RelativePath)
    return Get-Content -LiteralPath (Resolve-RepoPath $RelativePath) -Raw
}

function Assert-TextContains {
    param(
        [string]$RelativePath,
        [string]$Expected
    )
    $text = Read-RepoText $RelativePath
    if (-not $text.Contains($Expected)) {
        throw "Texto esperado não encontrado em ${RelativePath}: $Expected"
    }
}

function Assert-TextDoesNotContain {
    param(
        [string]$RelativePath,
        [string]$Forbidden
    )
    $text = Read-RepoText $RelativePath
    if ($text.Contains($Forbidden)) {
        throw "Texto proibido encontrado em ${RelativePath}: $Forbidden"
    }
}

function New-SmokeTestDir {
    $path = Join-Path $repoRoot ('.tmp-validar-' + [guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $path | Out-Null
    return $path
}

function Assert-SmokeFile {
    param(
        [string]$Root,
        [string]$RelativePath
    )
    $path = Join-Path $Root $RelativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "Smoke test falhou. Arquivo esperado não foi criado: $RelativePath"
    }
}

function Remove-SmokeTestDir {
    param([string]$Path)
    if (-not $Path) { return }
    if (-not (Test-Path -LiteralPath $Path)) { return }

    $resolvedRoot = (Resolve-Path -LiteralPath $repoRoot).Path
    $resolvedPath = (Resolve-Path -LiteralPath $Path).Path
    if (-not $resolvedPath.StartsWith($resolvedRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Recusando remover diretório fora do repositório: $resolvedPath"
    }

    Remove-Item -LiteralPath $resolvedPath -Recurse -Force
}

function Invoke-PowerShellInstallerSmokeTests {
    $installer = Resolve-RepoPath 'instalar.ps1'

    $autoEmpty = New-SmokeTestDir
    try {
        Push-Location $autoEmpty
        try { & $installer -Projeto -Ferramenta auto | Out-Null } finally { Pop-Location }
        Assert-SmokeFile $autoEmpty 'docs\CONTINUAR.md'
        Assert-SmokeFile $autoEmpty 'docs\INSTALAR_PROTOCOLO.md'
    } finally {
        Remove-SmokeTestDir $autoEmpty
    }

    $autoCodex = New-SmokeTestDir
    try {
        Set-Content -Path (Join-Path $autoCodex 'AGENTS.md') -Value '# Projeto' -Encoding utf8
        Push-Location $autoCodex
        try { & $installer -Projeto -Ferramenta auto | Out-Null } finally { Pop-Location }
        Assert-SmokeFile $autoCodex '.codex\skills\protocolo\SKILL.md'
    } finally {
        Remove-SmokeTestDir $autoCodex
    }

    $autoVSCode = New-SmokeTestDir
    try {
        New-Item -ItemType Directory -Path (Join-Path $autoVSCode '.vscode') | Out-Null
        Push-Location $autoVSCode
        try { & $installer -Projeto -Ferramenta auto | Out-Null } finally { Pop-Location }
        Assert-SmokeFile $autoVSCode '.github\copilot-instructions.md'
    } finally {
        Remove-SmokeTestDir $autoVSCode
    }

    $allTools = New-SmokeTestDir
    try {
        Push-Location $allTools
        try { & $installer -Projeto -Ferramenta todas | Out-Null } finally { Pop-Location }
        Assert-SmokeFile $allTools '.github\copilot-instructions.md'
        Assert-SmokeFile $allTools '.claude\commands\protocolo.md'
        Assert-SmokeFile $allTools '.cursor\commands\protocolo.md'
        Assert-SmokeFile $allTools '.opencode\commands\protocolo.md'
        Assert-SmokeFile $allTools '.agents\skills\protocolo\SKILL.md'
        Assert-SmokeFile $allTools '.agents\plugins\boare-protocol-dev\plugin.json'
        Assert-SmokeFile $allTools '.agents\plugins\boare-protocol-dev\rules\protocolo.md'
        Assert-SmokeFile $allTools '.agents\plugins\boare-protocol-dev\skills\protocolo\SKILL.md'
        Assert-SmokeFile $allTools '.codex\skills\protocolo\SKILL.md'
        Assert-SmokeFile $allTools 'docs\INSTALAR_PROTOCOLO.md'
        Assert-SmokeFile $allTools 'docs\CONTINUAR.md'
        Assert-SmokeFile $allTools 'AGENTS.md'
    } finally {
        Remove-SmokeTestDir $allTools
    }
}

function Invoke-ShellInstallerSmokeTests {
    $sh = Get-Command sh -ErrorAction SilentlyContinue | Select-Object -First 1
    $shPath = if ($sh) { $sh.Source } else { $null }

    if (-not $shPath) {
        $candidatePaths = @(
            'C:\Program Files\Git\bin\sh.exe',
            'C:\Program Files (x86)\Git\bin\sh.exe',
            'C:\Program Files\Git\usr\bin\sh.exe',
            'C:\Program Files (x86)\Git\usr\bin\sh.exe'
        )
        foreach ($candidatePath in $candidatePaths) {
            if (Test-Path -LiteralPath $candidatePath -PathType Leaf) {
                $shPath = $candidatePath
                break
            }
        }
    }

    if (-not $shPath) {
        if ($env:CI) {
            throw 'Smoke test do instalar.sh não pode ser pulado em CI: sh não encontrado'
        }
        Write-Host 'Smoke test do instalar.sh pulado fora do CI: sh não encontrado neste ambiente'
        return
    }

    $originalPath = $env:PATH
    $shDir = Split-Path -Parent $shPath
    $pathAdditions = @($shDir)

    if ($shPath -like '*\Git\bin\sh.exe') {
        $gitRoot = Split-Path -Parent (Split-Path -Parent $shPath)
        $pathAdditions += (Join-Path $gitRoot 'usr\bin')
    } elseif ($shPath -like '*\Git\usr\bin\sh.exe') {
        $gitRoot = Split-Path -Parent (Split-Path -Parent $shPath)
        $pathAdditions += (Join-Path $gitRoot 'bin')
    }

    $existingPath = @($env:PATH -split ';' | Where-Object { $_ })
    $missingPathAdditions = @(
        foreach ($pathAddition in $pathAdditions) {
            if ((Test-Path -LiteralPath $pathAddition -PathType Container) -and
                -not ($existingPath -contains $pathAddition)) {
                $pathAddition
            }
        }
    )

    try {
        if ($missingPathAdditions.Count -gt 0) {
            $env:PATH = (($missingPathAdditions + @($env:PATH)) -join ';')
        }

        $shellPathPrefix = 'PATH="/usr/bin:/bin:$PATH";'
        & $shPath -c "$shellPathPrefix command -v mkdir >/dev/null 2>&1"
        if ($LASTEXITCODE -ne 0) {
            if ($env:CI) {
                throw 'Smoke test do instalar.sh não pode ser pulado em CI: sh encontrado, mas sem utilitários POSIX no PATH'
            }
            Write-Host 'Smoke test do instalar.sh pulado fora do CI: sh encontrado, mas sem utilitários POSIX no PATH'
            return
        }

        $installer = Resolve-RepoPath 'instalar.sh'
        $shellInstallerRunner = 'PATH="/usr/bin:/bin:$PATH"; installer="$1"; shift; sh "$installer" "$@"'

        $autoAgents = New-SmokeTestDir
        try {
            New-Item -ItemType Directory -Path (Join-Path $autoAgents '.agents') | Out-Null
            Push-Location $autoAgents
            try { & $shPath -c $shellInstallerRunner 'boare-smoke' $installer '--projeto' '--ferramenta' 'auto' | Out-Null } finally { Pop-Location }
            Assert-SmokeFile $autoAgents '.agents/skills/protocolo/SKILL.md'
            Assert-SmokeFile $autoAgents '.agents/plugins/boare-protocol-dev/rules/protocolo.md'
            Assert-SmokeFile $autoAgents '.agents/plugins/boare-protocol-dev/skills/protocolo/SKILL.md'
        } finally {
            Remove-SmokeTestDir $autoAgents
        }

        $autoVSCode = New-SmokeTestDir
        try {
            New-Item -ItemType Directory -Path (Join-Path $autoVSCode '.vscode') | Out-Null
            Push-Location $autoVSCode
            try { & $shPath -c $shellInstallerRunner 'boare-smoke' $installer '--projeto' '--ferramenta' 'auto' | Out-Null } finally { Pop-Location }
            Assert-SmokeFile $autoVSCode '.github/copilot-instructions.md'
        } finally {
            Remove-SmokeTestDir $autoVSCode
        }

        $allTools = New-SmokeTestDir
        try {
            Push-Location $allTools
            try { & $shPath -c $shellInstallerRunner 'boare-smoke' $installer '--projeto' '--ferramenta' 'todas' | Out-Null } finally { Pop-Location }
            Assert-SmokeFile $allTools '.github/copilot-instructions.md'
            Assert-SmokeFile $allTools '.claude/commands/protocolo.md'
            Assert-SmokeFile $allTools '.cursor/commands/protocolo.md'
            Assert-SmokeFile $allTools '.opencode/commands/protocolo.md'
            Assert-SmokeFile $allTools '.agents/skills/protocolo/SKILL.md'
            Assert-SmokeFile $allTools '.agents/plugins/boare-protocol-dev/plugin.json'
            Assert-SmokeFile $allTools '.agents/plugins/boare-protocol-dev/rules/protocolo.md'
            Assert-SmokeFile $allTools '.agents/plugins/boare-protocol-dev/skills/protocolo/SKILL.md'
            Assert-SmokeFile $allTools '.codex/skills/protocolo/SKILL.md'
            Assert-SmokeFile $allTools 'docs/INSTALAR_PROTOCOLO.md'
            Assert-SmokeFile $allTools 'docs/CONTINUAR.md'
            Assert-SmokeFile $allTools 'AGENTS.md'
        } finally {
            Remove-SmokeTestDir $allTools
        }
    } finally {
        $env:PATH = $originalPath
    }
}

$requiredDirs = @(
    'passos',
    'skills',
    'templates',
    'plugins\protocolo\commands',
    'plugins\protocolo\.claude-plugin'
)

$requiredFiles = @(
    'README.md',
    'COMECE_AQUI.md',
    'CONDUZIR.md',
    'PADROES.md',
    'LICENSE',
    '.github\workflows\validar.yml',
    '.gitignore',
    '.claude-plugin\marketplace.json',
    'plugins\protocolo\.claude-plugin\plugin.json',
    'plugins\protocolo\commands\protocolo.md',
    'plugins\protocolo\commands\protocolo-iniciar.md',
    'plugins\protocolo\commands\protocolo-continuar.md',
    'plugins\protocolo\commands\protocolo-adotar.md',
    'plugins\protocolo\commands\protocolo-status.md',
    'plugins\protocolo\commands\protocolo-retomada.md',
    'instalar.ps1',
    'instalar.sh',
    'templates\BUGS.md',
    'templates\CONTINUAR.md',
    'templates\DECISOES_TECNICAS.md',
    'templates\DESIGN.md',
    'templates\FSD.md',
    'templates\GITIGNORE.md',
    'templates\PRD.md'
)

$stepFiles = @(
    'passos\00-duvidas.md',
    'passos\01-explorar-ideia.md',
    'passos\01b-design-existente.md',
    'passos\02-repositorio.md',
    'passos\02b-adotar-existente.md',
    'passos\03-prd.md',
    'passos\04-decisoes-tecnicas.md',
    'passos\05-design-system.md',
    'passos\06-fsd.md',
    'passos\07-validar-fsd.md',
    'passos\08-deploy.md',
    'passos\09-codificar-e-testar.md'
)

$skillFiles = @(
    'skills\arquitetura.md',
    'skills\banco-de-dados.md',
    'skills\codigo-limpo.md',
    'skills\contexto-tecnico.md',
    'skills\depuracao.md',
    'skills\design-ui.md',
    'skills\lgpd.md',
    'skills\relatorios.md',
    'skills\seguranca.md',
    'skills\testes.md'
)

$publicTextFiles = $requiredFiles + $stepFiles + $skillFiles + @(
    'CONDUZIR.md',
    'PADROES.md'
)

$forbiddenPublicTerms = @(
    ('SIGA' + 'DEM'),
    ('SIGA' + 'DEP'),
    ('Context' + '7'),
    ('Super' + 'powers'),
    ('Sn' + 'yk'),
    ('nossa ' + 'conversa'),
    ('que ' + 'usei'),
    'handoff',
    'Handoff'
)

foreach ($dir in $requiredDirs) { Assert-Dir $dir }
foreach ($file in ($requiredFiles + $stepFiles + $skillFiles)) { Assert-File $file }

$marketplace = Read-RepoText '.claude-plugin\marketplace.json' | ConvertFrom-Json
if ($marketplace.name -ne 'boare') { throw 'marketplace.name deve ser boare' }
if ($marketplace.version -ne $releaseVersion) { throw "marketplace.version deve ser $releaseVersion" }
if (-not $marketplace.plugins -or $marketplace.plugins.Count -ne 1) { throw 'marketplace deve declarar exatamente um plugin' }

$marketplacePlugin = $marketplace.plugins[0]
if ($marketplacePlugin.name -ne 'protocolo') { throw 'plugin do marketplace deve se chamar protocolo' }
if ($marketplacePlugin.version -ne $releaseVersion) { throw "plugins[0].version deve ser $releaseVersion" }
if ($marketplacePlugin.source -ne './plugins/protocolo') { throw 'plugins[0].source deve apontar para ./plugins/protocolo' }
if ($marketplacePlugin.license -ne 'MIT') { throw 'plugins[0].license deve ser MIT' }

$pluginManifest = Read-RepoText 'plugins\protocolo\.claude-plugin\plugin.json' | ConvertFrom-Json
if ($pluginManifest.name -ne 'protocolo') { throw 'plugin.json name deve ser protocolo' }
if ($pluginManifest.version -ne $releaseVersion) { throw "plugin.json version deve ser $releaseVersion" }
if ($pluginManifest.license -ne 'MIT') { throw 'plugin.json license deve ser MIT' }

Assert-TextContains 'LICENSE' 'MIT License'
Assert-TextContains '.gitignore' '.tmp-validar-*/'
Assert-TextContains '.github\workflows\validar.yml' 'ubuntu-latest'
Assert-TextContains '.github\workflows\validar.yml' 'windows-latest'
Assert-TextContains 'README.md' '# Boare Protocol Dev'
Assert-TextContains 'README.md' 'agnóstico a modelo de IA, IDE e linguagem'
Assert-TextContains 'README.md' 'Foi pensado para agentes'
Assert-TextContains 'README.md' 'Exemplos técnicos são permitidos'
Assert-TextContains 'README.md' '## Quick Start'
Assert-TextContains 'README.md' 'COMECE_AQUI.md'
Assert-TextContains 'README.md' '## Instalação'
Assert-TextContains 'README.md' '## Comandos instalados'
Assert-TextContains 'README.md' '## Upgrade'
Assert-TextContains 'README.md' '## Segurança e privacidade'
Assert-TextContains 'README.md' 'VS Code'
Assert-TextContains 'README.md' '.github/copilot-instructions.md'
Assert-TextContains 'README.md' 'A IA só deve conduzi-lo quando você pedir'
Assert-TextContains 'README.md' '.claude/commands'
Assert-TextContains 'README.md' '.cursor/commands'
Assert-TextContains 'README.md' '.opencode/commands'
Assert-TextContains 'README.md' '.agents/skills/protocolo'
Assert-TextContains 'README.md' '.agents/plugins/boare-protocol-dev'
Assert-TextContains 'README.md' '.codex/skills/protocolo'
Assert-TextContains 'README.md' 'docs/INSTALAR_PROTOCOLO.md'
Assert-TextContains 'README.md' '/protocolo-iniciar'
Assert-TextContains 'README.md' '/protocolo-continuar'
Assert-TextContains 'README.md' '/protocolo-adotar'
Assert-TextContains 'README.md' '/protocolo-status'
Assert-TextContains 'README.md' '/protocolo-retomada'
Assert-TextContains 'README.md' 'Testar caminho de entrega'
Assert-TextDoesNotContain 'README.md' '# Protocolo Boare'
Assert-TextDoesNotContain 'README.md' 'peça que eu cole o conteúdo do arquivo'
Assert-TextDoesNotContain 'README.md' 'Comece em 30 segundos'
Assert-TextDoesNotContain 'README.md' 'Testar caminho de deploy'
Assert-TextDoesNotContain 'README.md' 'A URL aponta para `main` de propósito'
Assert-TextDoesNotContain 'README.md' 'No GitHub, o botão de copiar aparece'

$filesThatMustPointToRelease = @(
    'plugins\protocolo\commands\protocolo.md',
    'plugins\protocolo\commands\protocolo-continuar.md',
    'plugins\protocolo\commands\protocolo-adotar.md',
    'plugins\protocolo\commands\protocolo-status.md',
    'plugins\protocolo\commands\protocolo-retomada.md'
)

foreach ($file in $filesThatMustPointToRelease) {
    Assert-TextContains $file $expectedRawUrl
    Assert-TextDoesNotContain $file 'cole o conteúdo do arquivo'
}

Assert-TextContains 'README.md' $expectedStartRawUrl
Assert-TextContains 'README.md' 'cdn.jsdelivr.net'
Assert-TextContains 'plugins\protocolo\commands\protocolo-iniciar.md' $expectedStartRawUrl
Assert-TextContains 'plugins\protocolo\commands\protocolo-iniciar.md' 'cdn.jsdelivr.net'
Assert-TextContains 'COMECE_AQUI.md' $expectedStartRawUrl
Assert-TextContains 'COMECE_AQUI.md' 'Passo 1'
Assert-TextContains 'COMECE_AQUI.md' 'Que problema o sistema resolve?'
Assert-TextContains 'COMECE_AQUI.md' 'Pare no fim do Passo 1'

Assert-TextContains 'CONDUZIR.md' "https://raw.githubusercontent.com/pauloboare/BoareProtocolDev/$protocolRef/"
Assert-TextContains 'CONDUZIR.md' $expectedCdnBaseUrl
Assert-TextContains 'CONDUZIR.md' 'Arquivos do protocolo já presentes no workspace atual'
Assert-TextContains 'CONDUZIR.md' 'Se a ferramenta tiver permissão de agente'
Assert-TextContains 'CONDUZIR.md' 'Para publicar, criar remoto, instalar dependência'
Assert-TextContains 'CONDUZIR.md' 'Se ele citar `templates/`, `skills/` ou'
Assert-TextDoesNotContain 'CONDUZIR.md' 'https://raw.githubusercontent.com/pauloboare/BoareProtocolDev/main/'
Assert-TextDoesNotContain 'CONDUZIR.md' 'colar o conteúdo do arquivo'
Assert-TextDoesNotContain 'CONDUZIR.md' 'Você não executa nada'

Assert-TextDoesNotContain 'passos\02-repositorio.md' '`CLAUDE.md` e `AGENTS.md` na raiz apontam'
Assert-TextContains 'passos\02-repositorio.md' 'arquivo-gatilho'
Assert-TextContains 'passos\02-repositorio.md' 'Quer criar remoto agora'
Assert-TextContains 'passos\02-repositorio.md' 'manter só local'
Assert-TextContains 'passos\02b-adotar-existente.md' 'Se a ferramenta usada tiver um arquivo-gatilho'
Assert-TextContains 'passos\02b-adotar-existente.md' 'Leitura inicial controlada'
Assert-TextContains 'passos\02b-adotar-existente.md' 'stack aparente, marcada como inferência'
Assert-TextContains 'passos\02b-adotar-existente.md' 'próxima ação, perguntas abertas, riscos e última validação conhecida'
Assert-TextContains 'templates\CONTINUAR.md' '## Como descobrir o passo atual'
Assert-TextContains 'templates\CONTINUAR.md' '## Estado atual'
Assert-TextContains 'templates\CONTINUAR.md' '## Perguntas abertas'
Assert-TextContains 'templates\CONTINUAR.md' '## Riscos ativos'
Assert-TextContains 'templates\CONTINUAR.md' '## Última validação conhecida'
Assert-TextContains 'templates\CONTINUAR.md' '/protocolo-retomada'
Assert-TextContains 'instalar.ps1' 'protocolo-iniciar.md'
Assert-TextContains 'instalar.ps1' 'protocolo-continuar.md'
Assert-TextContains 'instalar.ps1' 'protocolo-adotar.md'
Assert-TextContains 'instalar.ps1' 'protocolo-status.md'
Assert-TextContains 'instalar.ps1' 'protocolo-retomada.md'
Assert-TextContains 'instalar.ps1' 'docs\CONTINUAR.md'
Assert-TextContains 'instalar.ps1' '.claude\commands'
Assert-TextContains 'instalar.ps1' '.cursor\commands'
Assert-TextContains 'instalar.ps1' '.opencode\commands'
Assert-TextContains 'instalar.ps1' '.agents\skills\protocolo'
Assert-TextContains 'instalar.ps1' '.agents\plugins\boare-protocol-dev'
Assert-TextContains 'instalar.ps1' '.codex\skills\protocolo'
Assert-TextContains 'instalar.ps1' 'docs\INSTALAR_PROTOCOLO.md'
Assert-TextContains 'instalar.ps1' '.github\copilot-instructions.md'
Assert-TextContains 'instalar.ps1' 'Para tarefas comuns sem pedido de protocolo, não aplique este fluxo'
Assert-TextContains 'instalar.ps1' 'Sobrescrevendo comando existente'
Assert-TextContains 'instalar.ps1' "[string]`$Referencia = 'v1'"
Assert-TextContains 'instalar.ps1' "ValidateSet('auto', 'vscode', 'claude', 'cursor', 'opencode', 'antigravity', 'kimi', 'codex', 'todas', 'assistida')"
Assert-TextContains 'instalar.sh' 'protocolo-iniciar.md'
Assert-TextContains 'instalar.sh' 'protocolo-continuar.md'
Assert-TextContains 'instalar.sh' 'protocolo-adotar.md'
Assert-TextContains 'instalar.sh' 'protocolo-status.md'
Assert-TextContains 'instalar.sh' 'protocolo-retomada.md'
Assert-TextContains 'instalar.sh' 'docs/CONTINUAR.md'
Assert-TextContains 'instalar.sh' '.claude/commands'
Assert-TextContains 'instalar.sh' '.cursor/commands'
Assert-TextContains 'instalar.sh' '.opencode/commands'
Assert-TextContains 'instalar.sh' '.agents/skills/protocolo'
Assert-TextContains 'instalar.sh' '.agents/plugins/boare-protocol-dev'
Assert-TextContains 'instalar.sh' '.codex/skills/protocolo'
Assert-TextContains 'instalar.sh' 'docs/INSTALAR_PROTOCOLO.md'
Assert-TextContains 'instalar.sh' '.github/copilot-instructions.md'
Assert-TextContains 'instalar.sh' 'Para tarefas comuns sem pedido de protocolo, não aplique este fluxo'
Assert-TextContains 'instalar.sh' 'Aviso: sobrescrevendo comando existente'
Assert-TextContains 'instalar.sh' 'REFERENCIA="v1"'
Assert-TextContains 'instalar.sh' '--ferramenta'
Assert-TextContains 'instalar.sh' 'COMMANDS_DESTINO'
Assert-TextContains 'instalar.sh' 'SKILL_DESTINO'
Assert-TextContains 'scripts\validar.ps1' 'Smoke test do instalar.sh não pode ser pulado em CI'
Assert-TextContains 'passos\01-explorar-ideia.md' 'Qual é o canal de uso?'
Assert-TextContains 'passos\08-deploy.md' 'ambiente de uso'
Assert-TextDoesNotContain 'passos\01-explorar-ideia.md' 'Web, mobile, ou os dois?'
Assert-TextDoesNotContain 'passos\08-deploy.md' 'Como o código chega hoje ao servidor?'
Assert-TextDoesNotContain 'passos\09-codificar-e-testar.md' 'git add . &&'
Assert-TextContains 'passos\09-codificar-e-testar.md' '## Fechamento'
Assert-TextContains 'passos\09-codificar-e-testar.md' 'FSD foi concluído'
Assert-TextDoesNotContain 'passos\07-validar-fsd.md' 'git commit -am'

Assert-TextContains 'skills\README.md' 'Padrão mínimo'
Assert-TextContains 'skills\README.md' 'Recomendação inicial'
Assert-TextContains 'skills\README.md' 'Alternativas aceitas'
Assert-TextContains 'skills\README.md' 'Agnosticismo'

foreach ($skillFile in $skillFiles) {
    Assert-TextContains $skillFile '## Padrão mínimo'
    Assert-TextContains $skillFile '## Recomendação inicial'
    Assert-TextContains $skillFile '## Alternativas aceitas'
    Assert-TextContains $skillFile '## Como decidir'
    Assert-TextContains $skillFile '## Gates'
}

Invoke-PowerShellInstallerSmokeTests
Invoke-ShellInstallerSmokeTests

foreach ($textFile in $publicTextFiles) {
    Assert-TextDoesNotContain $textFile $forbiddenEmDash
    foreach ($term in $forbiddenPublicTerms) {
        Assert-TextDoesNotContain $textFile $term
    }
}

Write-Host "Validação OK: Boare Protocol Dev $releaseVersion ($protocolRef)"
