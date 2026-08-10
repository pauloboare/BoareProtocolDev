param()

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$releaseVersion = '1.2.1'
$protocolRef = 'v1'
$expectedRawUrl = "https://raw.githubusercontent.com/pauloboare/BoareProtocolDev/$protocolRef/CONDUZIR.md"
$expectedStartRawUrl = "https://raw.githubusercontent.com/pauloboare/BoareProtocolDev/$protocolRef/COMECE_AQUI.md"
$expectedCdnBaseUrl = "https://cdn.jsdelivr.net/gh/pauloboare/BoareProtocolDev@$protocolRef/"
$expectedBootstrapShRawUrl = "https://raw.githubusercontent.com/pauloboare/BoareProtocolDev/$protocolRef/bootstrap.sh"
$expectedBootstrapPsRawUrl = "https://raw.githubusercontent.com/pauloboare/BoareProtocolDev/$protocolRef/bootstrap.ps1"
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

$commandFiles = @(
    'protocolo.md',
    'protocolo-iniciar.md',
    'protocolo-continuar.md',
    'protocolo-adotar.md',
    'protocolo-status.md',
    'protocolo-retomada.md',
    'protocolo-atualizar.md'
)

$continuarRequiredLines = @(
    '## Limite deste arquivo',
    '- Antes de continuar, leia: 3 arquivos',
    '- Perguntas abertas: 5',
    '- Decisões recentes: 5',
    '- Riscos ativos: 5',
    '- Observações finais para a próxima sessão: 5',
    'docs/DECISOES_TECNICAS.md',
    '.boare/protocolo/protocolo.json'
)

function Get-MarkdownSectionTitles {
    param([string]$Path)
    return @(
        Get-Content -LiteralPath $Path -Encoding utf8 |
            Where-Object { $_ -match '^##\s' } |
            ForEach-Object { $_.Trim() }
    )
}

function Assert-ContinuarContract {
    param(
        [string]$Path,
        [string]$Origem
    )

    $text = Get-Content -LiteralPath $Path -Raw -Encoding utf8
    foreach ($line in $continuarRequiredLines) {
        if (-not $text.Contains($line)) {
            throw "CONTINUAR.md gerado por ${Origem} não tem a regra de contexto esperada: $line"
        }
    }

    $templateTitles = Get-MarkdownSectionTitles (Resolve-RepoPath 'templates\CONTINUAR.md')
    $generatedTitles = Get-MarkdownSectionTitles $Path
    if (($templateTitles -join ' | ') -ne ($generatedTitles -join ' | ')) {
        throw @"
Seções de docs/CONTINUAR.md geradas por ${Origem} divergem de templates/CONTINUAR.md.
Template: $($templateTitles -join ' | ')
Gerado:   $($generatedTitles -join ' | ')
"@
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

function Assert-SmokeTextContains {
    param(
        [string]$Root,
        [string]$RelativePath,
        [string]$Expected
    )
    $path = Join-Path $Root $RelativePath
    Assert-SmokeFile $Root $RelativePath
    $text = Get-Content -LiteralPath $path -Raw -Encoding utf8
    if (-not $text.Contains($Expected)) {
        throw "Smoke test falhou. Texto esperado não encontrado em ${RelativePath}: $Expected"
    }
}

function Assert-SameFileText {
    param(
        [string]$LeftPath,
        [string]$RightPath,
        [string]$Contexto
    )
    $left = (Get-Content -LiteralPath $LeftPath -Raw -Encoding utf8) -replace "`r`n", "`n"
    $right = (Get-Content -LiteralPath $RightPath -Raw -Encoding utf8) -replace "`r`n", "`n"
    if ($left.TrimEnd("`n") -ne $right.TrimEnd("`n")) {
        throw "instalar.ps1 e instalar.sh geram conteúdo diferente para ${Contexto}. As duas cópias precisam andar juntas."
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
        Assert-ContinuarContract (Join-Path $autoEmpty 'docs\CONTINUAR.md') 'instalar.ps1'
        Assert-SmokeFile $autoEmpty 'docs\INSTALAR_PROTOCOLO.md'
        Assert-SmokeFile $autoEmpty '.boare\protocolo\CONDUZIR.md'
        Assert-SmokeFile $autoEmpty '.boare\protocolo\protocolo.json'
        Assert-SmokeFile $autoEmpty '.boare\protocolo\passos\01-explorar-ideia.md'
    } finally {
        Remove-SmokeTestDir $autoEmpty
    }

    $autoCodex = New-SmokeTestDir
    try {
        Set-Content -Path (Join-Path $autoCodex 'AGENTS.md') -Value '# Projeto' -Encoding utf8
        Push-Location $autoCodex
        try { & $installer -Projeto -Ferramenta auto | Out-Null } finally { Pop-Location }
        Assert-SmokeFile $autoCodex '.codex\skills\protocolo\SKILL.md'
        Assert-SmokeFile $autoCodex '.boare\protocolo\CONDUZIR.md'
        Assert-SmokeFile $autoCodex '.boare\protocolo\protocolo.json'
    } finally {
        Remove-SmokeTestDir $autoCodex
    }

    $autoVSCode = New-SmokeTestDir
    try {
        New-Item -ItemType Directory -Path (Join-Path $autoVSCode '.vscode') | Out-Null
        Push-Location $autoVSCode
        try { & $installer -Projeto -Ferramenta auto | Out-Null } finally { Pop-Location }
        Assert-SmokeFile $autoVSCode '.github\copilot-instructions.md'
        Assert-SmokeFile $autoVSCode '.boare\protocolo\CONDUZIR.md'
        Assert-SmokeFile $autoVSCode '.boare\protocolo\protocolo.json'
    } finally {
        Remove-SmokeTestDir $autoVSCode
    }

    $allTools = New-SmokeTestDir
    try {
        Push-Location $allTools
        try { & $installer -Projeto -Ferramenta todas | Out-Null } finally { Pop-Location }
        Assert-SmokeFile $allTools '.github\copilot-instructions.md'
        Assert-SmokeFile $allTools '.claude\commands\protocolo.md'
        Assert-SmokeTextContains $allTools '.claude\commands\protocolo-retomada.md' 'docs/historico/BUGS-FECHADOS.md'
        Assert-SmokeTextContains $allTools '.cursor\commands\protocolo-retomada.md' 'docs/historico/BUGS-FECHADOS.md'
        Assert-SmokeTextContains $allTools '.claude\commands\protocolo-atualizar.md' 'protocolo.json'
        Assert-SmokeTextContains $allTools '.cursor\commands\protocolo-atualizar.md' 'protocolo.json'
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
        Assert-SmokeFile $allTools '.boare\protocolo\CONDUZIR.md'
        Assert-SmokeFile $allTools '.boare\protocolo\protocolo.json'
        Assert-SmokeFile $allTools '.boare\protocolo\templates\CONTINUAR.md'
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
            Assert-SmokeFile $autoAgents '.boare/protocolo/CONDUZIR.md'
            Assert-SmokeFile $autoAgents '.boare/protocolo/protocolo.json'
        } finally {
            Remove-SmokeTestDir $autoAgents
        }

        $autoVSCode = New-SmokeTestDir
        try {
            New-Item -ItemType Directory -Path (Join-Path $autoVSCode '.vscode') | Out-Null
            Push-Location $autoVSCode
            try { & $shPath -c $shellInstallerRunner 'boare-smoke' $installer '--projeto' '--ferramenta' 'auto' | Out-Null } finally { Pop-Location }
            Assert-SmokeFile $autoVSCode '.github/copilot-instructions.md'
            Assert-SmokeFile $autoVSCode '.boare/protocolo/CONDUZIR.md'
            Assert-SmokeFile $autoVSCode '.boare/protocolo/protocolo.json'
        } finally {
            Remove-SmokeTestDir $autoVSCode
        }

        $parityShell = New-SmokeTestDir
        $parityPwsh = New-SmokeTestDir
        try {
            Push-Location $parityShell
            try {
                & $shPath -c $shellInstallerRunner 'boare-smoke' $installer '--projeto' '--ferramenta' 'claude' | Out-Null
                & $shPath -c $shellInstallerRunner 'boare-smoke' $installer '--projeto' '--ferramenta' 'cursor' | Out-Null
            } finally { Pop-Location }
            Push-Location $parityPwsh
            try {
                & (Resolve-RepoPath 'instalar.ps1') -Projeto -Ferramenta claude | Out-Null
                & (Resolve-RepoPath 'instalar.ps1') -Projeto -Ferramenta cursor | Out-Null
            } finally { Pop-Location }

            $parityFiles = @('docs/CONTINUAR.md') + @(
                $commandFiles | ForEach-Object { ".claude/commands/$_" }
            ) + @(
                $commandFiles | ForEach-Object { ".cursor/commands/$_" }
            )
            foreach ($parityFile in $parityFiles) {
                Assert-SameFileText `
                    (Join-Path $parityShell $parityFile) `
                    (Join-Path $parityPwsh $parityFile) `
                    $parityFile
            }
        } finally {
            Remove-SmokeTestDir $parityShell
            Remove-SmokeTestDir $parityPwsh
        }

        $allTools = New-SmokeTestDir
        try {
            Push-Location $allTools
            try { & $shPath -c $shellInstallerRunner 'boare-smoke' $installer '--projeto' '--ferramenta' 'todas' | Out-Null } finally { Pop-Location }
            Assert-SmokeFile $allTools '.github/copilot-instructions.md'
            Assert-SmokeFile $allTools '.claude/commands/protocolo.md'
            Assert-SmokeTextContains $allTools '.claude/commands/protocolo-retomada.md' 'docs/historico/BUGS-FECHADOS.md'
            Assert-SmokeTextContains $allTools '.cursor/commands/protocolo-retomada.md' 'docs/historico/BUGS-FECHADOS.md'
            Assert-SmokeTextContains $allTools '.claude/commands/protocolo-atualizar.md' 'protocolo.json'
            Assert-SmokeTextContains $allTools '.cursor/commands/protocolo-atualizar.md' 'protocolo.json'
            Assert-SmokeFile $allTools '.cursor/commands/protocolo.md'
            Assert-SmokeFile $allTools '.opencode/commands/protocolo.md'
            Assert-SmokeFile $allTools '.agents/skills/protocolo/SKILL.md'
            Assert-SmokeFile $allTools '.agents/plugins/boare-protocol-dev/plugin.json'
            Assert-SmokeFile $allTools '.agents/plugins/boare-protocol-dev/rules/protocolo.md'
            Assert-SmokeFile $allTools '.agents/plugins/boare-protocol-dev/skills/protocolo/SKILL.md'
            Assert-SmokeFile $allTools '.codex/skills/protocolo/SKILL.md'
            Assert-SmokeFile $allTools 'docs/INSTALAR_PROTOCOLO.md'
            Assert-SmokeFile $allTools 'docs/CONTINUAR.md'
            Assert-ContinuarContract (Join-Path $allTools 'docs/CONTINUAR.md') 'instalar.sh'
            Assert-SmokeFile $allTools 'AGENTS.md'
            Assert-SmokeFile $allTools '.boare/protocolo/CONDUZIR.md'
            Assert-SmokeFile $allTools '.boare/protocolo/protocolo.json'
            Assert-SmokeFile $allTools '.boare/protocolo/templates/CONTINUAR.md'
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
    'plugins\protocolo\commands\protocolo-atualizar.md',
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
Assert-TextContains 'README.md' 'agentes de desenvolvimento'
Assert-TextContains 'README.md' 'Exemplos técnicos são permitidos'
Assert-TextContains 'README.md' '## Instalação rápida'
Assert-TextContains 'README.md' '## Uso diário'
Assert-TextContains 'README.md' '## Teste sem instalar'
Assert-TextContains 'README.md' 'Para abrir o terminal no lugar certo'
Assert-TextContains 'README.md' '.boare/protocolo/'
Assert-TextContains 'README.md' '## Versionamento'
Assert-TextContains 'README.md' '.boare/protocolo/protocolo.json'
Assert-TextContains 'README.md' '--status'
Assert-TextContains 'README.md' '-Status'
Assert-TextContains 'README.md' 'Para atualizar por terminal, rode novamente a instalação'
Assert-TextContains 'README.md' 'Use o mecanismo nativo da ferramenta para ler URL'
Assert-TextContains 'README.md' 'COMECE_AQUI.md'
Assert-TextContains 'README.md' '## Comandos'
Assert-TextContains 'README.md' '## Segurança'
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
Assert-TextContains 'README.md' 'Testar entrega'
Assert-TextDoesNotContain 'README.md' '# Protocolo Boare'
Assert-TextDoesNotContain 'README.md' 'peça que eu cole o conteúdo do arquivo'
Assert-TextDoesNotContain 'README.md' 'Comece em 30 segundos'
Assert-TextDoesNotContain 'README.md' 'Testar caminho de deploy'
Assert-TextDoesNotContain 'README.md' 'A URL aponta para `main` de propósito'
Assert-TextDoesNotContain 'README.md' 'No GitHub, o botão de copiar aparece'
Assert-TextDoesNotContain 'README.md' '## Quick Start sem instalar'
Assert-TextDoesNotContain 'README.md' '### Codex sem espera'
Assert-TextDoesNotContain 'README.md' 'Perguntas obrigatórias:'

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
Assert-TextContains 'plugins\protocolo\commands\protocolo-iniciar.md' 'não reinicie'
Assert-TextContains 'plugins\protocolo\commands\protocolo-continuar.md' 'crie docs/CONTINUAR.md antes de avançar'
Assert-TextContains 'COMECE_AQUI.md' $expectedStartRawUrl
Assert-TextContains 'COMECE_AQUI.md' 'Passo 1'
Assert-TextContains 'COMECE_AQUI.md' '## Antes de iniciar'
Assert-TextContains 'COMECE_AQUI.md' 'Se existir `docs/CONTINUAR.md`'
Assert-TextContains 'COMECE_AQUI.md' 'nao tente contornar falha de rede'
Assert-TextContains 'COMECE_AQUI.md' 'Que problema o sistema resolve?'
Assert-TextContains 'COMECE_AQUI.md' 'Pare no fim do Passo 1'

Assert-TextContains 'CONDUZIR.md' "https://raw.githubusercontent.com/pauloboare/BoareProtocolDev/$protocolRef/"
Assert-TextContains 'CONDUZIR.md' $expectedCdnBaseUrl
Assert-TextContains 'CONDUZIR.md' '## Estado e retomada'
Assert-TextContains 'CONDUZIR.md' '.boare/protocolo/'
Assert-TextContains 'CONDUZIR.md' 'Atualização de protocolo é ação'
Assert-TextContains 'CONDUZIR.md' 'Arquivos do protocolo já presentes no workspace atual'
Assert-TextContains 'CONDUZIR.md' 'nem tente'
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
Assert-TextContains 'templates\CONTINUAR.md' '.boare/protocolo/CONDUZIR.md'
Assert-TextContains 'templates\CONTINUAR.md' '.boare/protocolo/protocolo.json'
Assert-TextContains 'templates\CONTINUAR.md' '## Regra de equipe'
Assert-TextContains 'templates\CONTINUAR.md' '## Estado atual'
Assert-TextContains 'templates\CONTINUAR.md' '## Perguntas abertas'
Assert-TextContains 'templates\CONTINUAR.md' '## Riscos ativos'
Assert-TextContains 'templates\CONTINUAR.md' '## Última validação conhecida'
Assert-TextContains 'templates\CONTINUAR.md' '/protocolo-retomada'
Assert-TextContains 'templates\CONTINUAR.md' '## Limite deste arquivo'
Assert-TextContains 'templates\BUGS.md' '## Como ler este arquivo'
Assert-TextContains 'templates\BUGS.md' 'os **10 mais recentes**'
Assert-TextContains 'templates\BUGS.md' 'docs/historico/BUGS-FECHADOS.md'
Assert-TextDoesNotContain 'templates\BUGS.md' 'Leia antes de codificar. Escreva assim que encontrar.'
Assert-TextContains 'CONDUZIR.md' 'docs/historico/BUGS-FECHADOS.md'
Assert-TextContains 'CONDUZIR.md' 'é consulta por busca, não leitura'
Assert-TextContains 'CONDUZIR.md' 'Arquivo que nasceu antes desta regra'
Assert-TextContains 'CONDUZIR.md' 'Pedida a atualização'
Assert-TextContains 'CONDUZIR.md' '/protocolo-atualizar'
Assert-TextContains 'CONDUZIR.md' 'peça confirmação'
Assert-TextDoesNotContain 'CONDUZIR.md' 'Leia antes de codificar qualquer coisa'
Assert-TextContains 'passos\09-codificar-e-testar.md' 'Abertos** e **Em investigação**'
Assert-TextContains 'passos\09-codificar-e-testar.md' 'docs/historico/BUGS-FECHADOS.md'
Assert-TextContains 'passos\09-codificar-e-testar.md' 'estão dentro do teto'
Assert-TextDoesNotContain 'passos\09-codificar-e-testar.md' 'mantenha bugs, riscos e perguntas abertas visíveis'
Assert-TextContains 'passos\02-repositorio.md' 'teto de bugs'
Assert-TextContains 'passos\02b-adotar-existente.md' 'uma linha por área'
Assert-TextContains 'plugins\protocolo\commands\protocolo-retomada.md' 'docs/historico/BUGS-FECHADOS.md'
Assert-TextContains 'instalar.ps1' 'docs/historico/BUGS-FECHADOS.md'
Assert-TextContains 'instalar.ps1' '## Limite deste arquivo'
Assert-TextContains 'instalar.sh' 'docs/historico/BUGS-FECHADOS.md'
Assert-TextContains 'instalar.sh' '## Limite deste arquivo'

$updateCommandFile = 'plugins\protocolo\commands\protocolo-atualizar.md'
Assert-TextContains $updateCommandFile $expectedBootstrapShRawUrl
Assert-TextContains $updateCommandFile $expectedBootstrapPsRawUrl
Assert-TextContains $updateCommandFile 'protocolo.json'
Assert-TextContains $updateCommandFile 'peça confirmação explícita'
Assert-TextContains $updateCommandFile '--ferramenta auto'
Assert-TextContains $updateCommandFile 'Não avance passo do protocolo'
Assert-TextContains 'instalar.ps1' 'protocolo-atualizar.md'
Assert-TextContains 'instalar.ps1' 'bootstrap.sh'
Assert-TextContains 'instalar.ps1' 'bootstrap.ps1'
Assert-TextContains 'instalar.sh' 'protocolo-atualizar.md'
Assert-TextContains 'instalar.sh' 'BOOTSTRAP_SH_URL'
Assert-TextContains 'instalar.sh' 'BOOTSTRAP_PS_URL'
Assert-TextContains 'README.md' '/protocolo-atualizar'
Assert-TextContains 'instalar.ps1' 'protocolo-iniciar.md'
Assert-TextContains 'instalar.ps1' 'protocolo-continuar.md'
Assert-TextContains 'instalar.ps1' 'protocolo-adotar.md'
Assert-TextContains 'instalar.ps1' 'protocolo-status.md'
Assert-TextContains 'instalar.ps1' 'protocolo-retomada.md'
Assert-TextContains 'instalar.ps1' 'docs\CONTINUAR.md'
Assert-TextContains 'instalar.ps1' '.boare/protocolo/CONDUZIR.md'
Assert-TextContains 'instalar.ps1' 'update_policy'
Assert-TextContains 'instalar.ps1' '[switch]$Status'
Assert-TextContains 'instalar.ps1' 'Próximo passo na sua IDE ou agente'
Assert-TextContains 'instalar.ps1' 'Se existir docs/CONTINUAR.md'
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
Assert-TextContains 'instalar.sh' '.boare/protocolo/CONDUZIR.md'
Assert-TextContains 'instalar.sh' 'update_policy'
Assert-TextContains 'instalar.sh' '--status'
Assert-TextContains 'instalar.sh' 'Próximo passo na sua IDE ou agente'
Assert-TextContains 'instalar.sh' 'Se existir docs/CONTINUAR.md'
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
Assert-TextContains 'bootstrap.ps1' '[switch]$Status'
Assert-TextContains 'bootstrap.ps1' "instalarArgs['Status']"
Assert-TextContains 'scripts\validar.ps1' 'Smoke test do instalar.sh não pode ser pulado em CI'
Assert-TextContains 'passos\01-explorar-ideia.md' 'Qual é o canal de uso?'
Assert-TextContains 'passos\08-deploy.md' 'ambiente de uso'
Assert-TextContains 'passos\08-deploy.md' 'docs/CONTINUAR.md` aponta o Passo 9'
Assert-TextDoesNotContain 'passos\01-explorar-ideia.md' 'Web, mobile, ou os dois?'
Assert-TextDoesNotContain 'passos\08-deploy.md' 'Como o código chega hoje ao servidor?'
Assert-TextDoesNotContain 'passos\09-codificar-e-testar.md' 'git add . &&'
Assert-TextContains 'passos\09-codificar-e-testar.md' '## Fechamento'
Assert-TextContains 'passos\09-codificar-e-testar.md' 'FSD foi concluído'
Assert-TextContains 'passos\09-codificar-e-testar.md' 'docs/CONTINUAR.md` registra o próximo item do FSD'
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
