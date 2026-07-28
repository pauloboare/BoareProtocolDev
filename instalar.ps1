# Instalador do Boare Protocol Dev.
#
# Cria adaptadores locais para ferramentas de desenvolvimento com IA.
# O protocolo continua agnóstico: cada ferramenta recebe o formato que entende.
#
# Exemplos:
#   Auto no projeto:                  .\instalar.ps1 -Projeto -Ferramenta auto
#   Todas no projeto:                 .\instalar.ps1 -Projeto -Ferramenta todas
#   VS Code no projeto:               .\instalar.ps1 -Projeto -Ferramenta vscode
#   Claude Code global:               .\instalar.ps1 -Ferramenta claude
#   Cursor no projeto:                .\instalar.ps1 -Projeto -Ferramenta cursor
#   OpenCode no projeto:              .\instalar.ps1 -Projeto -Ferramenta opencode
#   Kimi no projeto:                  .\instalar.ps1 -Projeto -Ferramenta kimi
#   Antigravity no projeto:           .\instalar.ps1 -Projeto -Ferramenta antigravity
#   Codex no projeto:                 .\instalar.ps1 -Projeto -Ferramenta codex
#
# Referência padrão: v1, canal estável. Use -Referencia main só se quiser a
# versão de desenvolvimento.

param(
    [switch]$Projeto,
    [ValidateSet('auto', 'vscode', 'claude', 'cursor', 'opencode', 'antigravity', 'kimi', 'codex', 'todas', 'assistida')]
    [string]$Ferramenta = 'auto',
    [string]$Referencia = 'v1'
)

$ErrorActionPreference = 'Stop'

$protocolUrl = "https://raw.githubusercontent.com/pauloboare/BoareProtocolDev/$Referencia/CONDUZIR.md"
$protocolCdnUrl = "https://cdn.jsdelivr.net/gh/pauloboare/BoareProtocolDev@$Referencia/CONDUZIR.md"
$protocolGitHubUrl = "https://github.com/pauloboare/BoareProtocolDev/blob/$Referencia/CONDUZIR.md"
$startUrl = "https://raw.githubusercontent.com/pauloboare/BoareProtocolDev/$Referencia/COMECE_AQUI.md"
$startCdnUrl = "https://cdn.jsdelivr.net/gh/pauloboare/BoareProtocolDev@$Referencia/COMECE_AQUI.md"
$startGitHubUrl = "https://github.com/pauloboare/BoareProtocolDev/blob/$Referencia/COMECE_AQUI.md"
$basePrompt = "Leia o primeiro link que conseguir acessar:`n1. $protocolUrl`n2. $protocolCdnUrl`n3. $protocolGitHubUrl"
$startPrompt = "Leia o primeiro link que conseguir acessar:`n1. $startUrl`n2. $startCdnUrl`n3. $startGitHubUrl"

$commands = @(
    @{
        File = 'protocolo.md'
        Description = 'Continua o Boare Protocol Dev pelo estado atual do projeto'
        Prompt = "$basePrompt`nConduza o passo atual pelo estado dos arquivos do projeto."
    },
    @{
        File = 'protocolo-iniciar.md'
        Description = 'Inicia um projeto novo pelo Passo 1 do Boare Protocol Dev'
        Prompt = "Antes de iniciar, confira se existe docs/CONTINUAR.md ou outros artefatos do protocolo em docs/. Se existir, não reinicie: leia docs/CONTINUAR.md ou conduza pelo estado atual com CONDUZIR.md.`n`n$startPrompt`nConduza o Passo 1."
    },
    @{
        File = 'protocolo-continuar.md'
        Description = 'Retoma um projeto que já usa o Boare Protocol Dev'
        Prompt = "Leia docs/CONTINUAR.md e siga a próxima ação recomendada. Compare com os artefatos reais em docs/. Se esse arquivo não existir:`n$basePrompt`nDescubra o passo atual pelo que existe em docs/ e crie docs/CONTINUAR.md antes de avançar."
    },
    @{
        File = 'protocolo-adotar.md'
        Description = 'Adota o Boare Protocol Dev em um sistema existente'
        Prompt = "$basePrompt`nConduza o Passo 2b."
    },
    @{
        File = 'protocolo-status.md'
        Description = 'Diagnostica o estado do Boare Protocol Dev sem alterar arquivos'
        Prompt = "$basePrompt`nDiagnostique o estado atual do protocolo neste projeto. Não edite arquivos, não execute ações destrutivas e não avance passos. Entregue apenas: passo atual provável, evidências encontradas, lacunas, riscos e próximo comando recomendado."
    },
    @{
        File = 'protocolo-retomada.md'
        Description = 'Prepara a retomada do Boare Protocol Dev para a próxima sessão'
        Prompt = "$basePrompt`nAtualize docs/CONTINUAR.md com o estado real deste projeto para outro computador ou agente continuar sem reiniciar. Não avance passos. Registre: último passo concluído, passo atual, última ação feita, próxima ação recomendada, próximo comando recomendado, arquivos que devem ser lidos, perguntas abertas, decisões recentes, riscos ativos e última validação conhecida."
    }
)

function New-ProtocolContinueContent {
    return @(
        '# Continuar o protocolo'
        ''
        $basePrompt
        'Continue pelo estado atual deste projeto.'
        ''
        '## Regra de equipe'
        ''
        '- Este arquivo deve ser versionado no repositório do sistema.'
        '- Antes de trabalhar em outro computador, atualize o repositório local e leia este arquivo.'
        '- Ao encerrar uma sessão ou concluir um passo, rode `/protocolo-retomada` ou atualize este arquivo manualmente.'
        '- Se alguém chamar `/protocolo-iniciar` em um clone que já tem este arquivo, ignore o início e retome daqui.'
        ''
        '## Modo'
        ''
        '<normal / refatoração>'
        ''
        '## Estado atual'
        ''
        '- Último passo concluído: <passo ou "nenhum">'
        '- Passo atual: <passo provável>'
        '- Última ação feita: <ação objetiva>'
        '- Próxima ação recomendada: <ação objetiva>'
        '- Próximo comando recomendado: </protocolo / /protocolo-iniciar / /protocolo-continuar / /protocolo-adotar / /protocolo-status / /protocolo-retomada>'
        ''
        '## Como descobrir o passo atual'
        ''
        '1. Leia os arquivos existentes em `docs/`.'
        '2. Compare com os artefatos esperados pelo protocolo.'
        '3. Busque apenas o arquivo do passo atual.'
        '4. Faça uma pergunta por vez.'
        '5. No fim do passo, confira o portão de saída.'
        '6. Não avance para o próximo passo sem pedido explícito.'
        ''
        '## Artefatos conhecidos'
        ''
        '- `docs/BUGS.md`: <existe / não existe>'
        '- `docs/PRD.md`: <existe / não existe>'
        '- `docs/DECISOES_TECNICAS.md`: <existe / não existe>'
        '- `docs/DESIGN.md`: <existe / não se aplica / não existe>'
        '- `docs/FSD.md`: <existe / não existe>'
        ''
        '## Antes de continuar, leia'
        ''
        '- <arquivo obrigatório para entender o estado atual>'
        ''
        '## Perguntas abertas'
        ''
        '- <pergunta que ainda precisa de resposta>'
        ''
        '## Decisões recentes'
        ''
        '- <decisão tomada, motivo e arquivo onde foi registrada>'
        ''
        '## Riscos ativos'
        ''
        '- <risco, impacto e próxima verificação>'
        ''
        '## Última validação conhecida'
        ''
        '- Comando: <comando executado>'
        '- Resultado: <passou / falhou / não executado>'
        '- Observação: <informação relevante>'
        ''
        '## Observações finais para a próxima sessão'
        ''
        '- <restrição importante>'
        '- <decisão pendente>'
    )
}

function Write-CommandFiles {
    param(
        [string]$Destino,
        [ValidateSet('frontmatter', 'plain')]
        [string]$Formato
    )

    New-Item -ItemType Directory -Force -Path $Destino | Out-Null

    foreach ($command in $commands) {
        $commandPath = Join-Path $Destino $command.File
        if (Test-Path -LiteralPath $commandPath) {
            Write-Warning "Sobrescrevendo comando existente: $commandPath"
        }

        if ($Formato -eq 'frontmatter') {
            $content = @(
                '---'
                "description: $($command.Description)"
                '---'
                ''
                $command.Prompt
            )
        } else {
            $content = @(
                "# $($command.Description)"
                ''
                $command.Prompt
            )
        }

        Set-Content -Path $commandPath -Value $content -Encoding utf8
    }
}

function Write-ProtocolSkill {
    param([string]$Destino)

    New-Item -ItemType Directory -Force -Path $Destino | Out-Null
    $skillPath = Join-Path $Destino 'SKILL.md'
    if (Test-Path -LiteralPath $skillPath) {
        Write-Warning "Sobrescrevendo skill existente: $skillPath"
    }
    $content = @(
        '---'
        'name: protocolo'
        'description: Conduz projetos com o Boare Protocol Dev, mantendo decisões, contexto, testes e retomada no repositório.'
        '---'
        ''
        '# Boare Protocol Dev'
        ''
        'Quando esta skill for usada, siga estas regras:'
        ''
        '- Use o Boare Protocol Dev somente quando o usuário pedir o protocolo, uma etapa do protocolo ou um comando do protocolo.'
        '- Para tarefas comuns sem pedido de protocolo, não aplique este fluxo.'
        '- Leia o primeiro link que conseguir acessar:'
        "  1. $protocolUrl"
        "  2. $protocolCdnUrl"
        "  3. $protocolGitHubUrl"
        '- Se existir `docs/CONTINUAR.md`, leia primeiro e retome por ele.'
        '- Se houver artefatos do protocolo em `docs/`, não reinicie pelo Passo 1.'
        '- Descubra o passo atual pelo que existe em `docs/`.'
        '- Faça uma pergunta por vez.'
        '- Edite arquivos somente dentro do projeto quando a ferramenta permitir.'
        '- Não publique, instale dependências, apague arquivos, use credenciais ou altere histórico sem confirmação explícita.'
        '- No fim, verifique o portão de saída, atualize `docs/CONTINUAR.md` e pare.'
    )
    Set-Content -Path $skillPath -Value $content -Encoding utf8
}

function Add-CodexAgentsGuidance {
    $path = 'AGENTS.md'
    $block = @(
        ''
        '## Boare Protocol Dev'
        ''
        'Use o Boare Protocol Dev somente quando o usuário pedir o protocolo, uma etapa do protocolo ou um comando do protocolo.'
        'Para tarefas comuns sem pedido de protocolo, não aplique este fluxo.'
        "Para conduzir o protocolo neste projeto, leia o primeiro link que conseguir acessar: $protocolUrl, $protocolCdnUrl ou $protocolGitHubUrl. Siga o passo atual pelo estado de docs/."
        'Use docs/CONTINUAR.md como fonte de retomada entre sessões, máquinas e agentes.'
        'Se docs/CONTINUAR.md existir, leia antes de qualquer início.'
    )

    if (Test-Path -LiteralPath $path) {
        $current = Get-Content -LiteralPath $path -Raw
        if ($current -notlike '*Boare Protocol Dev*') {
            Add-Content -LiteralPath $path -Value $block -Encoding utf8
        }
    } else {
        Set-Content -Path $path -Value $block[1..($block.Count - 1)] -Encoding utf8
    }
}

function Add-VSCodeCopilotInstructions {
    if (-not $Projeto) { throw 'VS Code usa instruções por projeto. Rode com -Projeto -Ferramenta vscode.' }

    $path = '.github\copilot-instructions.md'
    New-Item -ItemType Directory -Force -Path '.github' | Out-Null

    $block = @(
        ''
        '## Boare Protocol Dev'
        ''
        'Use o Boare Protocol Dev somente quando o usuário pedir o protocolo, uma etapa do protocolo ou um comando do protocolo.'
        'Para tarefas comuns sem pedido de protocolo, não aplique este fluxo.'
        "Para conduzir o protocolo neste projeto, leia o primeiro link que conseguir acessar: $protocolUrl, $protocolCdnUrl ou $protocolGitHubUrl. Siga o passo atual pelo estado de docs/."
        'Use docs/CONTINUAR.md como fonte de retomada entre sessões, máquinas e agentes.'
        'Se docs/CONTINUAR.md existir, leia antes de qualquer início.'
        'Não avance mais de um passo sem pedido explícito.'
    )

    if (Test-Path -LiteralPath $path) {
        $current = Get-Content -LiteralPath $path -Raw
        if ($current -notlike '*Boare Protocol Dev*') {
            Add-Content -LiteralPath $path -Value $block -Encoding utf8
        }
    } else {
        Set-Content -Path $path -Value $block[1..($block.Count - 1)] -Encoding utf8
    }
}

function Write-AssistedInstall {
    New-Item -ItemType Directory -Force -Path 'docs' | Out-Null
    if (Test-Path -LiteralPath 'docs\INSTALAR_PROTOCOLO.md') {
        Write-Warning 'Sobrescrevendo instrução assistida existente: docs\INSTALAR_PROTOCOLO.md'
    }
    $content = @(
        '# Instalar o Boare Protocol Dev nesta ferramenta'
        ''
        'Esta ferramenta não foi detectada pelo instalador automático ou usa um formato próprio.'
        ''
        'Peça para a IA da ferramenta executar esta tarefa:'
        ''
        '```text'
        "Crie o atalho, skill, regra ou instrução persistente equivalente a /protocolo nesta ferramenta. Esse adaptador deve disponibilizar o Boare Protocol Dev, não obrigar seu uso em toda tarefa. O conteúdo deve dizer: use o Boare Protocol Dev somente quando o usuário pedir o protocolo, uma etapa do protocolo ou um comando do protocolo. Para conduzir, leia o primeiro link que conseguir acessar: $protocolUrl, $protocolCdnUrl ou $protocolGitHubUrl. Se existir docs/CONTINUAR.md, retome por ele e não reinicie pelo Passo 1. Se a ferramenta suportar comandos, crie também protocolo-iniciar, protocolo-continuar, protocolo-adotar, protocolo-status e protocolo-retomada com os prompts do Boare Protocol Dev."
        '```'
        ''
        'Depois, registre em docs/CONTINUAR.md qual caminho foi usado.'
    )
    Set-Content -Path 'docs\INSTALAR_PROTOCOLO.md' -Value $content -Encoding utf8
}

function Install-Claude {
    $destino = if ($Projeto) { '.claude\commands' } else { "$HOME\.claude\commands" }
    Write-CommandFiles -Destino $destino -Formato 'frontmatter'
    return $destino
}

function Install-VSCode {
    Add-VSCodeCopilotInstructions
    return '.github\copilot-instructions.md'
}

function Install-Cursor {
    if (-not $Projeto) { throw 'Cursor usa comandos por projeto. Rode com -Projeto -Ferramenta cursor.' }
    $destino = '.cursor\commands'
    Write-CommandFiles -Destino $destino -Formato 'plain'
    return $destino
}

function Install-OpenCode {
    $destino = if ($Projeto) { '.opencode\commands' } else { "$HOME\.config\opencode\commands" }
    Write-CommandFiles -Destino $destino -Formato 'frontmatter'
    return $destino
}

function Install-Kimi {
    $destino = if ($Projeto) { '.agents\skills\protocolo' } else { "$HOME\.agents\skills\protocolo" }
    Write-ProtocolSkill -Destino $destino
    return $destino
}

function Install-Antigravity {
    $destino = if ($Projeto) { '.agents\plugins\boare-protocol-dev' } else { "$HOME\.gemini\config\plugins\boare-protocol-dev" }
    New-Item -ItemType Directory -Force -Path $destino | Out-Null
    if (Test-Path -LiteralPath (Join-Path $destino 'plugin.json')) {
        Write-Warning "Sobrescrevendo plugin existente: $(Join-Path $destino 'plugin.json')"
    }
    Set-Content -Path (Join-Path $destino 'plugin.json') -Value @(
        '{'
        '  "name": "boare-protocol-dev",'
        '  "version": "1.0.0",'
        '  "description": "Conduz projetos com o Boare Protocol Dev por regras e skills de agente."'
        '}'
    ) -Encoding utf8
    Write-ProtocolSkill -Destino (Join-Path $destino 'skills\protocolo')
    New-Item -ItemType Directory -Force -Path (Join-Path $destino 'rules') | Out-Null
    if (Test-Path -LiteralPath (Join-Path $destino 'rules\protocolo.md')) {
        Write-Warning "Sobrescrevendo regra existente: $(Join-Path $destino 'rules\protocolo.md')"
    }
    Set-Content -Path (Join-Path $destino 'rules\protocolo.md') -Value @(
        '# Boare Protocol Dev'
        ''
        'Use o Boare Protocol Dev somente quando o usuário pedir o protocolo, uma etapa do protocolo ou um comando do protocolo.'
        'Para tarefas comuns sem pedido de protocolo, não aplique este fluxo.'
        "Quando o usuário pedir para usar o protocolo, leia o primeiro link que conseguir acessar: $protocolUrl, $protocolCdnUrl ou $protocolGitHubUrl. Conduza o passo atual."
        'Use docs/CONTINUAR.md para retomada entre sessões, máquinas e agentes. Se ele existir, leia antes de qualquer início e não avance mais de um passo sem pedido explícito.'
    ) -Encoding utf8
    return $destino
}

function Install-Codex {
    if ($Projeto) {
        Add-CodexAgentsGuidance
        $destino = '.codex\skills\protocolo'
    } else {
        $destino = "$HOME\.codex\skills\protocolo"
    }
    Write-ProtocolSkill -Destino $destino
    return $destino
}

function Install-SelectedTool {
    param([string]$Tool)

    switch ($Tool) {
        'vscode' { return Install-VSCode }
        'claude' { return Install-Claude }
        'cursor' { return Install-Cursor }
        'opencode' { return Install-OpenCode }
        'kimi' { return Install-Kimi }
        'antigravity' { return Install-Antigravity }
        'codex' { return Install-Codex }
        'assistida' {
            if (-not $Projeto) { throw 'Instalação assistida precisa de -Projeto para criar docs/INSTALAR_PROTOCOLO.md.' }
            Write-AssistedInstall
            return 'docs\INSTALAR_PROTOCOLO.md'
        }
        default { throw "Ferramenta não suportada: $Tool" }
    }
}

function Resolve-AutoTools {
    $detected = @()

    if ($Projeto) {
        if (Test-Path '.claude') { $detected += 'claude' }
        if ((Test-Path '.vscode') -or (Test-Path '.github\copilot-instructions.md')) { $detected += 'vscode' }
        if (Test-Path '.cursor') { $detected += 'cursor' }
        if (Test-Path '.opencode') { $detected += 'opencode' }
        if (Test-Path '.agents') { $detected += 'antigravity'; $detected += 'kimi' }
        if ((Test-Path '.codex') -or (Test-Path 'AGENTS.md')) { $detected += 'codex' }
    } else {
        if (Get-Command claude -ErrorAction SilentlyContinue) { $detected += 'claude' }
        if (Get-Command opencode -ErrorAction SilentlyContinue) { $detected += 'opencode' }
        if (Get-Command kimi -ErrorAction SilentlyContinue) { $detected += 'kimi' }
        if (Get-Command codex -ErrorAction SilentlyContinue) { $detected += 'codex' }
    }

    $detected = @($detected | Select-Object -Unique)
    if ($detected.Count -eq 0) {
        if ($Projeto) { return @('assistida') }
        return @('claude')
    }
    return $detected
}

if ($Projeto) {
    New-Item -ItemType Directory -Force -Path 'docs' | Out-Null
    $continuarPath = 'docs\CONTINUAR.md'
    if (-not (Test-Path -LiteralPath $continuarPath)) {
        Set-Content -Path $continuarPath -Value (New-ProtocolContinueContent) -Encoding utf8
    }
}

if ($Ferramenta -eq 'todas') {
    if (-not $Projeto) { throw 'Use -Projeto -Ferramenta todas para evitar escrita global excessiva.' }
    $tools = @('vscode', 'claude', 'cursor', 'opencode', 'kimi', 'antigravity', 'codex', 'assistida')
} elseif ($Ferramenta -eq 'auto') {
    $tools = Resolve-AutoTools
} else {
    $tools = @($Ferramenta)
}

$created = @()
foreach ($tool in $tools) {
    $created += "${tool}: $(Install-SelectedTool -Tool $tool)"
}

Write-Output "Adaptadores criados:"
$created | ForEach-Object { Write-Output "- $_" }
Write-Output "Referência usada: $Referencia"
