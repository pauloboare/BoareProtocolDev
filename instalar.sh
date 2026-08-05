#!/bin/sh
# Instalador do Boare Protocol Dev.
#
# Cria adaptadores locais para ferramentas de desenvolvimento com IA.
# Referência padrão: v1, canal estável. Use --ref main só se quiser a versão de
# desenvolvimento.
#
# Exemplos:
#   Auto no projeto:                  sh instalar.sh --projeto --ferramenta auto
#   Todas no projeto:                 sh instalar.sh --projeto --ferramenta todas
#   VS Code no projeto:               sh instalar.sh --projeto --ferramenta vscode
#   Claude Code global:               sh instalar.sh --ferramenta claude
#   Cursor no projeto:                sh instalar.sh --projeto --ferramenta cursor
#   OpenCode no projeto:              sh instalar.sh --projeto --ferramenta opencode
#   Kimi no projeto:                  sh instalar.sh --projeto --ferramenta kimi
#   Antigravity no projeto:           sh instalar.sh --projeto --ferramenta antigravity
#   Codex no projeto:                 sh instalar.sh --projeto --ferramenta codex

set -e

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

PROJETO=0
FERRAMENTA="auto"
REFERENCIA="v1"
PROTOCOL_VERSION="1.2.0"
STATUS=0

while [ "$#" -gt 0 ]; do
    case "$1" in
        --projeto)
            PROJETO=1
            ;;
        --status)
            STATUS=1
            ;;
        --ferramenta)
            shift
            FERRAMENTA="$1"
            ;;
        --ref|--referencia)
            shift
            REFERENCIA="$1"
            ;;
        --vscode|--claude|--cursor|--opencode|--antigravity|--kimi|--codex|--todas|--assistida|--auto)
            FERRAMENTA="${1#--}"
            ;;
        *)
            echo "Opção desconhecida: $1" >&2
            exit 1
            ;;
    esac
    shift
done

PROTOCOL_URL="https://raw.githubusercontent.com/pauloboare/BoareProtocolDev/$REFERENCIA/CONDUZIR.md"
PROTOCOL_CDN_URL="https://cdn.jsdelivr.net/gh/pauloboare/BoareProtocolDev@$REFERENCIA/CONDUZIR.md"
PROTOCOL_GITHUB_URL="https://github.com/pauloboare/BoareProtocolDev/blob/$REFERENCIA/CONDUZIR.md"
START_URL="https://raw.githubusercontent.com/pauloboare/BoareProtocolDev/$REFERENCIA/COMECE_AQUI.md"
START_CDN_URL="https://cdn.jsdelivr.net/gh/pauloboare/BoareProtocolDev@$REFERENCIA/COMECE_AQUI.md"
START_GITHUB_URL="https://github.com/pauloboare/BoareProtocolDev/blob/$REFERENCIA/COMECE_AQUI.md"
LOCAL_PROTOCOL_PATH=".boare/protocolo/CONDUZIR.md"
LOCAL_START_PATH=".boare/protocolo/COMECE_AQUI.md"
BOOTSTRAP_SH_URL="https://raw.githubusercontent.com/pauloboare/BoareProtocolDev/$REFERENCIA/bootstrap.sh"
BOOTSTRAP_SH_CDN_URL="https://cdn.jsdelivr.net/gh/pauloboare/BoareProtocolDev@$REFERENCIA/bootstrap.sh"
BOOTSTRAP_PS_URL="https://raw.githubusercontent.com/pauloboare/BoareProtocolDev/$REFERENCIA/bootstrap.ps1"
BOOTSTRAP_PS_CDN_URL="https://cdn.jsdelivr.net/gh/pauloboare/BoareProtocolDev@$REFERENCIA/bootstrap.ps1"

write_commands_frontmatter() {
    COMMANDS_DESTINO="$1"
    mkdir -p "$COMMANDS_DESTINO"

    [ -f "$COMMANDS_DESTINO/protocolo.md" ] && echo "Aviso: sobrescrevendo comando existente: $COMMANDS_DESTINO/protocolo.md" >&2
    cat > "$COMMANDS_DESTINO/protocolo.md" <<FIM
---
description: Continua o Boare Protocol Dev pelo estado atual do projeto
---

Leia $LOCAL_PROTOCOL_PATH se existir. Se não existir, leia o primeiro link que conseguir acessar:
1. $PROTOCOL_URL
2. $PROTOCOL_CDN_URL
3. $PROTOCOL_GITHUB_URL

Conduza o passo atual pelo estado dos arquivos do projeto.
FIM

    [ -f "$COMMANDS_DESTINO/protocolo-iniciar.md" ] && echo "Aviso: sobrescrevendo comando existente: $COMMANDS_DESTINO/protocolo-iniciar.md" >&2
cat > "$COMMANDS_DESTINO/protocolo-iniciar.md" <<FIM
---
description: Inicia um projeto novo pelo Passo 1 do Boare Protocol Dev
---

Antes de iniciar, confira se existe docs/CONTINUAR.md ou outros artefatos do protocolo em docs/. Se existir, não reinicie: leia docs/CONTINUAR.md ou conduza pelo estado atual com CONDUZIR.md.

Leia $LOCAL_START_PATH se existir. Se não existir, leia o primeiro link que conseguir acessar:
1. $START_URL
2. $START_CDN_URL
3. $START_GITHUB_URL

Conduza o Passo 1.
FIM

    [ -f "$COMMANDS_DESTINO/protocolo-continuar.md" ] && echo "Aviso: sobrescrevendo comando existente: $COMMANDS_DESTINO/protocolo-continuar.md" >&2
    cat > "$COMMANDS_DESTINO/protocolo-continuar.md" <<FIM
---
description: Retoma um projeto que já usa o Boare Protocol Dev
---

Leia docs/CONTINUAR.md e siga a próxima ação recomendada. Compare com os artefatos reais em docs/. Se esse arquivo não existir, leia $LOCAL_PROTOCOL_PATH se existir. Se não existir, leia o primeiro link que conseguir acessar:
1. $PROTOCOL_URL
2. $PROTOCOL_CDN_URL
3. $PROTOCOL_GITHUB_URL

Descubra o passo atual pelo que existe em docs/ e crie docs/CONTINUAR.md antes de avançar.
FIM

    [ -f "$COMMANDS_DESTINO/protocolo-adotar.md" ] && echo "Aviso: sobrescrevendo comando existente: $COMMANDS_DESTINO/protocolo-adotar.md" >&2
    cat > "$COMMANDS_DESTINO/protocolo-adotar.md" <<FIM
---
description: Adota o Boare Protocol Dev em um sistema existente
---

Leia $LOCAL_PROTOCOL_PATH se existir. Se não existir, leia o primeiro link que conseguir acessar:
1. $PROTOCOL_URL
2. $PROTOCOL_CDN_URL
3. $PROTOCOL_GITHUB_URL

Conduza o Passo 2b.
FIM

    [ -f "$COMMANDS_DESTINO/protocolo-status.md" ] && echo "Aviso: sobrescrevendo comando existente: $COMMANDS_DESTINO/protocolo-status.md" >&2
    cat > "$COMMANDS_DESTINO/protocolo-status.md" <<FIM
---
description: Diagnostica o estado do Boare Protocol Dev sem alterar arquivos
---

Leia $LOCAL_PROTOCOL_PATH se existir. Se não existir, leia o primeiro link que conseguir acessar:
1. $PROTOCOL_URL
2. $PROTOCOL_CDN_URL
3. $PROTOCOL_GITHUB_URL

Diagnostique o estado atual do protocolo neste projeto. Não edite arquivos, não execute ações destrutivas e não avance passos. Entregue apenas: passo atual provável, evidências encontradas, lacunas, riscos e próximo comando recomendado.
FIM

    [ -f "$COMMANDS_DESTINO/protocolo-retomada.md" ] && echo "Aviso: sobrescrevendo comando existente: $COMMANDS_DESTINO/protocolo-retomada.md" >&2
    cat > "$COMMANDS_DESTINO/protocolo-retomada.md" <<FIM
---
description: Prepara a retomada do Boare Protocol Dev para a próxima sessão
---

Leia $LOCAL_PROTOCOL_PATH se existir. Se não existir, leia o primeiro link que conseguir acessar:
1. $PROTOCOL_URL
2. $PROTOCOL_CDN_URL
3. $PROTOCOL_GITHUB_URL

Atualize docs/CONTINUAR.md com o estado real deste projeto para outro computador ou agente continuar sem reiniciar. Não avance passos. Registre: último passo concluído, passo atual, última ação feita, próxima ação recomendada, próximo comando recomendado, arquivos que devem ser lidos, perguntas abertas, decisões recentes, riscos ativos e última validação conhecida.

Antes de gravar, aplique os limites do próprio arquivo: no máximo 3 arquivos na lista de leitura obrigatória e 5 itens em perguntas abertas, decisões recentes, riscos ativos e observações finais. O excedente não é apagado, é promovido: decisão vai para docs/DECISOES_TECNICAS.md, risco aceito vira restrição em docs/FSD.md, pergunta respondida vira decisão. Bug não é copiado para o CONTINUAR.md; docs/BUGS.md é a fonte. Se docs/BUGS.md tiver mais de 10 bugs fechados, mova os mais antigos para docs/historico/BUGS-FECHADOS.md, no mesmo formato. Se esses arquivos forem anteriores a esta regra e não tiverem as seções Limite deste arquivo e Como ler este arquivo, acrescente-as a partir dos templates antes de gravar.
FIM

    [ -f "$COMMANDS_DESTINO/protocolo-atualizar.md" ] && echo "Aviso: sobrescrevendo comando existente: $COMMANDS_DESTINO/protocolo-atualizar.md" >&2
    cat > "$COMMANDS_DESTINO/protocolo-atualizar.md" <<FIM
---
description: Atualiza a cópia local do Boare Protocol Dev neste projeto
---

Verifique .boare/protocolo/protocolo.json. Se não existir, informe que o protocolo não está instalado neste projeto e pare.

Para conferir a versão disponível sem instalar nada, baixe e execute o bootstrap com a flag de status. Use o primeiro que conseguir acessar, conforme o sistema operacional:

macOS/Linux (bootstrap.sh), com --projeto --status:
1. $BOOTSTRAP_SH_URL
2. $BOOTSTRAP_SH_CDN_URL

Windows (bootstrap.ps1), com -Projeto -Status:
1. $BOOTSTRAP_PS_URL
2. $BOOTSTRAP_PS_CDN_URL

Se a versão instalada já for igual à disponível, informe isso ao usuário e pare sem alterar nada.

Havendo diferença, mostre as duas versões e peça confirmação explícita antes de baixar e executar o instalador de verdade - isso baixa e executa código do GitHub. Confirmado, rode o mesmo bootstrap trocando --status por --ferramenta auto (ou -Status por -Ferramenta auto). Isso atualiza só os adaptadores já detectados neste projeto; não instala ferramenta nova.

Depois de atualizar:
1. Mostre o diff de .boare/protocolo/ e dos adaptadores alterados.
2. docs/CONTINUAR.md ou docs/BUGS.md anteriores às seções novas do protocolo? Acrescente-as a partir de .boare/protocolo/templates/ antes de seguir.
3. Rode a validação do projeto, se existir.
4. Commit próprio, separado de qualquer mudança do sistema: chore(protocolo): atualiza para <versão> (<referência>).

Não avance passo do protocolo nesta operação. Atualização de protocolo não é um passo do fluxo.
FIM
}

write_commands_plain() {
    COMMANDS_DESTINO="$1"
    mkdir -p "$COMMANDS_DESTINO"

    [ -f "$COMMANDS_DESTINO/protocolo.md" ] && echo "Aviso: sobrescrevendo comando existente: $COMMANDS_DESTINO/protocolo.md" >&2
    cat > "$COMMANDS_DESTINO/protocolo.md" <<FIM
# Continua o Boare Protocol Dev pelo estado atual do projeto

Leia $LOCAL_PROTOCOL_PATH se existir. Se não existir, leia o primeiro link que conseguir acessar:
1. $PROTOCOL_URL
2. $PROTOCOL_CDN_URL
3. $PROTOCOL_GITHUB_URL

Conduza o passo atual pelo estado dos arquivos do projeto.
FIM

    [ -f "$COMMANDS_DESTINO/protocolo-iniciar.md" ] && echo "Aviso: sobrescrevendo comando existente: $COMMANDS_DESTINO/protocolo-iniciar.md" >&2
cat > "$COMMANDS_DESTINO/protocolo-iniciar.md" <<FIM
# Inicia um projeto novo pelo Passo 1 do Boare Protocol Dev

Antes de iniciar, confira se existe docs/CONTINUAR.md ou outros artefatos do protocolo em docs/. Se existir, não reinicie: leia docs/CONTINUAR.md ou conduza pelo estado atual com CONDUZIR.md.

Leia $LOCAL_START_PATH se existir. Se não existir, leia o primeiro link que conseguir acessar:
1. $START_URL
2. $START_CDN_URL
3. $START_GITHUB_URL

Conduza o Passo 1.
FIM

    [ -f "$COMMANDS_DESTINO/protocolo-continuar.md" ] && echo "Aviso: sobrescrevendo comando existente: $COMMANDS_DESTINO/protocolo-continuar.md" >&2
    cat > "$COMMANDS_DESTINO/protocolo-continuar.md" <<FIM
# Retoma um projeto que já usa o Boare Protocol Dev

Leia docs/CONTINUAR.md e siga a próxima ação recomendada. Compare com os artefatos reais em docs/. Se esse arquivo não existir, leia $LOCAL_PROTOCOL_PATH se existir. Se não existir, leia o primeiro link que conseguir acessar:
1. $PROTOCOL_URL
2. $PROTOCOL_CDN_URL
3. $PROTOCOL_GITHUB_URL

Descubra o passo atual pelo que existe em docs/ e crie docs/CONTINUAR.md antes de avançar.
FIM

    [ -f "$COMMANDS_DESTINO/protocolo-adotar.md" ] && echo "Aviso: sobrescrevendo comando existente: $COMMANDS_DESTINO/protocolo-adotar.md" >&2
    cat > "$COMMANDS_DESTINO/protocolo-adotar.md" <<FIM
# Adota o Boare Protocol Dev em um sistema existente

Leia $LOCAL_PROTOCOL_PATH se existir. Se não existir, leia o primeiro link que conseguir acessar:
1. $PROTOCOL_URL
2. $PROTOCOL_CDN_URL
3. $PROTOCOL_GITHUB_URL

Conduza o Passo 2b.
FIM

    [ -f "$COMMANDS_DESTINO/protocolo-status.md" ] && echo "Aviso: sobrescrevendo comando existente: $COMMANDS_DESTINO/protocolo-status.md" >&2
    cat > "$COMMANDS_DESTINO/protocolo-status.md" <<FIM
# Diagnostica o estado do Boare Protocol Dev sem alterar arquivos

Leia $LOCAL_PROTOCOL_PATH se existir. Se não existir, leia o primeiro link que conseguir acessar:
1. $PROTOCOL_URL
2. $PROTOCOL_CDN_URL
3. $PROTOCOL_GITHUB_URL

Diagnostique o estado atual do protocolo neste projeto. Não edite arquivos, não execute ações destrutivas e não avance passos. Entregue apenas: passo atual provável, evidências encontradas, lacunas, riscos e próximo comando recomendado.
FIM

    [ -f "$COMMANDS_DESTINO/protocolo-retomada.md" ] && echo "Aviso: sobrescrevendo comando existente: $COMMANDS_DESTINO/protocolo-retomada.md" >&2
    cat > "$COMMANDS_DESTINO/protocolo-retomada.md" <<FIM
# Prepara a retomada do Boare Protocol Dev para a próxima sessão

Leia $LOCAL_PROTOCOL_PATH se existir. Se não existir, leia o primeiro link que conseguir acessar:
1. $PROTOCOL_URL
2. $PROTOCOL_CDN_URL
3. $PROTOCOL_GITHUB_URL

Atualize docs/CONTINUAR.md com o estado real deste projeto para outro computador ou agente continuar sem reiniciar. Não avance passos. Registre: último passo concluído, passo atual, última ação feita, próxima ação recomendada, próximo comando recomendado, arquivos que devem ser lidos, perguntas abertas, decisões recentes, riscos ativos e última validação conhecida.

Antes de gravar, aplique os limites do próprio arquivo: no máximo 3 arquivos na lista de leitura obrigatória e 5 itens em perguntas abertas, decisões recentes, riscos ativos e observações finais. O excedente não é apagado, é promovido: decisão vai para docs/DECISOES_TECNICAS.md, risco aceito vira restrição em docs/FSD.md, pergunta respondida vira decisão. Bug não é copiado para o CONTINUAR.md; docs/BUGS.md é a fonte. Se docs/BUGS.md tiver mais de 10 bugs fechados, mova os mais antigos para docs/historico/BUGS-FECHADOS.md, no mesmo formato. Se esses arquivos forem anteriores a esta regra e não tiverem as seções Limite deste arquivo e Como ler este arquivo, acrescente-as a partir dos templates antes de gravar.
FIM

    [ -f "$COMMANDS_DESTINO/protocolo-atualizar.md" ] && echo "Aviso: sobrescrevendo comando existente: $COMMANDS_DESTINO/protocolo-atualizar.md" >&2
    cat > "$COMMANDS_DESTINO/protocolo-atualizar.md" <<FIM
# Atualiza a cópia local do Boare Protocol Dev neste projeto

Verifique .boare/protocolo/protocolo.json. Se não existir, informe que o protocolo não está instalado neste projeto e pare.

Para conferir a versão disponível sem instalar nada, baixe e execute o bootstrap com a flag de status. Use o primeiro que conseguir acessar, conforme o sistema operacional:

macOS/Linux (bootstrap.sh), com --projeto --status:
1. $BOOTSTRAP_SH_URL
2. $BOOTSTRAP_SH_CDN_URL

Windows (bootstrap.ps1), com -Projeto -Status:
1. $BOOTSTRAP_PS_URL
2. $BOOTSTRAP_PS_CDN_URL

Se a versão instalada já for igual à disponível, informe isso ao usuário e pare sem alterar nada.

Havendo diferença, mostre as duas versões e peça confirmação explícita antes de baixar e executar o instalador de verdade - isso baixa e executa código do GitHub. Confirmado, rode o mesmo bootstrap trocando --status por --ferramenta auto (ou -Status por -Ferramenta auto). Isso atualiza só os adaptadores já detectados neste projeto; não instala ferramenta nova.

Depois de atualizar:
1. Mostre o diff de .boare/protocolo/ e dos adaptadores alterados.
2. docs/CONTINUAR.md ou docs/BUGS.md anteriores às seções novas do protocolo? Acrescente-as a partir de .boare/protocolo/templates/ antes de seguir.
3. Rode a validação do projeto, se existir.
4. Commit próprio, separado de qualquer mudança do sistema: chore(protocolo): atualiza para <versão> (<referência>).

Não avance passo do protocolo nesta operação. Atualização de protocolo não é um passo do fluxo.
FIM
}

write_skill() {
    SKILL_DESTINO="$1"
    mkdir -p "$SKILL_DESTINO"
    [ -f "$SKILL_DESTINO/SKILL.md" ] && echo "Aviso: sobrescrevendo skill existente: $SKILL_DESTINO/SKILL.md" >&2
    cat > "$SKILL_DESTINO/SKILL.md" <<FIM
---
name: protocolo
description: Conduz projetos com o Boare Protocol Dev, mantendo decisões, contexto, testes e retomada no repositório.
---

# Boare Protocol Dev

Quando esta skill for usada, siga estas regras:

- Use o Boare Protocol Dev somente quando o usuário pedir o protocolo, uma etapa do protocolo ou um comando do protocolo.
- Para tarefas comuns sem pedido de protocolo, não aplique este fluxo.
- Leia o primeiro link que conseguir acessar:
  1. $PROTOCOL_URL
  2. $PROTOCOL_CDN_URL
  3. $PROTOCOL_GITHUB_URL
- Em instalação por projeto, leia primeiro \`$LOCAL_PROTOCOL_PATH\`.
- Se existir \`docs/CONTINUAR.md\`, leia primeiro e retome por ele.
- Se houver artefatos do protocolo em \`docs/\`, não reinicie pelo Passo 1.
- Descubra o passo atual pelo que existe em \`docs/\`.
- Faça uma pergunta por vez.
- Edite arquivos somente dentro do projeto quando a ferramenta permitir.
- Não publique, instale dependências, apague arquivos, use credenciais ou altere histórico sem confirmação explícita.
- No fim, verifique o portão de saída, atualize \`docs/CONTINUAR.md\` e pare.
FIM
}

write_continuar() {
    if [ "$PROJETO" -ne 1 ]; then
        return
    fi
    mkdir -p docs
    if [ -f docs/CONTINUAR.md ]; then
        return
    fi
    cat > docs/CONTINUAR.md <<FIM
# Continuar o protocolo

Leia $LOCAL_PROTOCOL_PATH se existir. Se não existir, leia o primeiro link que conseguir acessar:
1. $PROTOCOL_URL
2. $PROTOCOL_CDN_URL
3. $PROTOCOL_GITHUB_URL

Continue pelo estado atual deste projeto.

## Regra de equipe

- Este arquivo deve ser versionado no repositório do sistema.
- Antes de trabalhar em outro computador, atualize o repositório local e leia este arquivo.
- A versão local do protocolo fica em \`.boare/protocolo/protocolo.json\`.
- Não cheque atualização do protocolo a cada sessão; atualize só por pedido explícito.
- Ao encerrar uma sessão ou concluir um passo, rode \`/protocolo-retomada\` ou atualize este arquivo manualmente.
- Se alguém chamar \`/protocolo-iniciar\` em um clone que já tem este arquivo, ignore o início e retome daqui.

## Limite deste arquivo

Bilhete de retomada, não diário. Ele é lido inteiro no começo de toda sessão e reescrito no fim de cada passo: o que cresce aqui é cobrado em contexto todo dia.

Tetos, conferidos sempre que este arquivo for atualizado:

- Antes de continuar, leia: 3 arquivos
- Perguntas abertas: 5
- Decisões recentes: 5
- Riscos ativos: 5
- Observações finais para a próxima sessão: 5

O excedente não é apagado, é promovido: decisão vai para \`docs/DECISOES_TECNICAS.md\`, risco aceito vira restrição no \`docs/FSD.md\`, pergunta respondida vira decisão. Item sem lugar definitivo fica aqui.

Bug não é copiado para cá. \`docs/BUGS.md\` é a fonte; cite o identificador (\`B07\`) só quando ele bloquear a próxima ação.

## Modo

<normal / refatoração>

## Estado atual

- Último passo concluído: <passo ou "nenhum">
- Passo atual: <passo provável>
- Última ação feita: <ação objetiva>
- Próxima ação recomendada: <ação objetiva>
- Próximo comando recomendado: </protocolo / /protocolo-iniciar / /protocolo-continuar / /protocolo-adotar / /protocolo-status / /protocolo-retomada>

## Como descobrir o passo atual

1. Leia os arquivos existentes em \`docs/\`.
2. Compare com os artefatos esperados pelo protocolo.
3. Busque apenas o arquivo do passo atual.
4. Faça uma pergunta por vez.
5. No fim do passo, confira o portão de saída.
6. Não avance para o próximo passo sem pedido explícito.

## Artefatos conhecidos

- \`docs/BUGS.md\`: <existe / não existe>
- \`docs/PRD.md\`: <existe / não existe>
- \`docs/DECISOES_TECNICAS.md\`: <existe / não existe>
- \`docs/DESIGN.md\`: <existe / não se aplica / não existe>
- \`docs/FSD.md\`: <existe / não existe>

## Antes de continuar, leia

- <arquivo obrigatório para entender o estado atual>

## Perguntas abertas

- <pergunta que ainda precisa de resposta>

## Decisões recentes

- <decisão tomada, motivo e arquivo onde foi registrada>

## Riscos ativos

- <risco, impacto e próxima verificação>

## Última validação conhecida

- Comando: <comando executado>
- Resultado: <passou / falhou / não executado>
- Observação: <informação relevante>

## Observações finais para a próxima sessão

- <restrição importante>
- <decisão pendente>
FIM
}

copy_protocol_bundle() {
    if [ "$PROJETO" -ne 1 ]; then
        return
    fi
    BUNDLE_DESTINO=".boare/protocolo"
    mkdir -p "$BUNDLE_DESTINO/passos" "$BUNDLE_DESTINO/templates" "$BUNDLE_DESTINO/skills"
    cp -f "$SCRIPT_DIR/COMECE_AQUI.md" "$SCRIPT_DIR/CONDUZIR.md" "$SCRIPT_DIR/PADROES.md" "$BUNDLE_DESTINO/"
    cp -f "$SCRIPT_DIR"/passos/*.md "$BUNDLE_DESTINO/passos/"
    cp -f "$SCRIPT_DIR"/templates/*.md "$BUNDLE_DESTINO/templates/"
    cp -f "$SCRIPT_DIR"/skills/*.md "$BUNDLE_DESTINO/skills/"
    cat > "$BUNDLE_DESTINO/protocolo.json" <<FIM
{
  "name": "boare-protocol-dev",
  "version": "$PROTOCOL_VERSION",
  "reference": "$REFERENCIA",
  "update_policy": "manual",
  "entrypoint": "CONDUZIR.md"
}
FIM
}

show_protocol_status() {
    MANIFEST=".boare/protocolo/protocolo.json"
    echo "Boare Protocol Dev"
    echo "Versão disponível neste instalador: $PROTOCOL_VERSION ($REFERENCIA)"

    if [ ! -f "$MANIFEST" ]; then
        echo "Versão instalada neste projeto: nenhuma"
        echo "Para instalar, rode o comando de instalação com --projeto."
        return
    fi

    INSTALLED_VERSION=$(sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$MANIFEST" | head -1)
    INSTALLED_REF=$(sed -n 's/.*"reference"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$MANIFEST" | head -1)
    echo "Versão instalada neste projeto: $INSTALLED_VERSION ($INSTALLED_REF)"

    if [ "$INSTALLED_VERSION" = "$PROTOCOL_VERSION" ] && [ "$INSTALLED_REF" = "$REFERENCIA" ]; then
        echo "Status: atualizado para a referência informada."
    else
        echo "Status: há diferença entre a versão instalada e a versão disponível neste instalador."
        echo "Para atualizar, rode novamente a instalação com --projeto."
    fi
}

if [ "$STATUS" -eq 1 ]; then
    show_protocol_status
    exit 0
fi

add_codex_agents_guidance() {
    if [ "$PROJETO" -ne 1 ]; then
        return
    fi
    if [ -f AGENTS.md ] && grep -q "Boare Protocol Dev" AGENTS.md; then
        return
    fi
    {
        echo ""
        echo "## Boare Protocol Dev"
        echo ""
        echo "Use o Boare Protocol Dev somente quando o usuário pedir o protocolo, uma etapa do protocolo ou um comando do protocolo."
        echo "Para tarefas comuns sem pedido de protocolo, não aplique este fluxo."
        echo "Para conduzir o protocolo neste projeto, leia primeiro $LOCAL_PROTOCOL_PATH. Se não existir, use $PROTOCOL_URL, $PROTOCOL_CDN_URL ou $PROTOCOL_GITHUB_URL. Siga o passo atual pelo estado de docs/."
        echo "Use docs/CONTINUAR.md como fonte de retomada entre sessões, máquinas e agentes."
        echo "Se docs/CONTINUAR.md existir, leia antes de qualquer início."
    } >> AGENTS.md
}

add_vscode_copilot_instructions() {
    if [ "$PROJETO" -ne 1 ]; then
        echo "VS Code usa instruções por projeto. Rode com --projeto --ferramenta vscode." >&2
        exit 1
    fi
    mkdir -p .github
    if [ -f .github/copilot-instructions.md ] && grep -q "Boare Protocol Dev" .github/copilot-instructions.md; then
        return
    fi
    {
        echo ""
        echo "## Boare Protocol Dev"
        echo ""
        echo "Use o Boare Protocol Dev somente quando o usuário pedir o protocolo, uma etapa do protocolo ou um comando do protocolo."
        echo "Para tarefas comuns sem pedido de protocolo, não aplique este fluxo."
        echo "Para conduzir o protocolo neste projeto, leia primeiro $LOCAL_PROTOCOL_PATH. Se não existir, use $PROTOCOL_URL, $PROTOCOL_CDN_URL ou $PROTOCOL_GITHUB_URL. Siga o passo atual pelo estado de docs/."
        echo "Use docs/CONTINUAR.md como fonte de retomada entre sessões, máquinas e agentes."
        echo "Se docs/CONTINUAR.md existir, leia antes de qualquer início."
        echo "Não avance mais de um passo sem pedido explícito."
    } >> .github/copilot-instructions.md
}


write_assisted_install() {
    if [ "$PROJETO" -ne 1 ]; then
        echo "Instalação assistida precisa de --projeto para criar docs/INSTALAR_PROTOCOLO.md." >&2
        exit 1
    fi
    mkdir -p docs
    [ -f docs/INSTALAR_PROTOCOLO.md ] && echo "Aviso: sobrescrevendo instrução assistida existente: docs/INSTALAR_PROTOCOLO.md" >&2
    cat > docs/INSTALAR_PROTOCOLO.md <<FIM
# Instalar o Boare Protocol Dev nesta ferramenta

Esta ferramenta não foi detectada pelo instalador automático ou usa um formato próprio.

Peça para a IA da ferramenta executar esta tarefa:

\`\`\`text
Crie o atalho, skill, regra ou instrução persistente equivalente a /protocolo nesta ferramenta. Esse adaptador deve disponibilizar o Boare Protocol Dev, não obrigar seu uso em toda tarefa. O conteúdo deve dizer: use o Boare Protocol Dev somente quando o usuário pedir o protocolo, uma etapa do protocolo ou um comando do protocolo. Para conduzir, leia primeiro $LOCAL_PROTOCOL_PATH. Se não existir, use $PROTOCOL_URL, $PROTOCOL_CDN_URL ou $PROTOCOL_GITHUB_URL. Se existir docs/CONTINUAR.md, retome por ele e não reinicie pelo Passo 1. Se a ferramenta suportar comandos, crie também protocolo-iniciar, protocolo-continuar, protocolo-adotar, protocolo-status e protocolo-retomada com os prompts do Boare Protocol Dev.
\`\`\`

Depois, registre em docs/CONTINUAR.md qual caminho foi usado.
FIM
}

install_tool() {
    TOOL="$1"
    case "$TOOL" in
        vscode)
            add_vscode_copilot_instructions
            DESTINO=".github/copilot-instructions.md"
            ;;
        claude)
            if [ "$PROJETO" -eq 1 ]; then DESTINO=".claude/commands"; else DESTINO="$HOME/.claude/commands"; fi
            write_commands_frontmatter "$DESTINO"
            ;;
        cursor)
            if [ "$PROJETO" -ne 1 ]; then echo "Cursor usa comandos por projeto. Rode com --projeto --ferramenta cursor." >&2; exit 1; fi
            DESTINO=".cursor/commands"
            write_commands_plain "$DESTINO"
            ;;
        opencode)
            if [ "$PROJETO" -eq 1 ]; then DESTINO=".opencode/commands"; else DESTINO="$HOME/.config/opencode/commands"; fi
            write_commands_frontmatter "$DESTINO"
            ;;
        kimi)
            if [ "$PROJETO" -eq 1 ]; then DESTINO=".agents/skills/protocolo"; else DESTINO="$HOME/.agents/skills/protocolo"; fi
            write_skill "$DESTINO"
            ;;
        antigravity)
            if [ "$PROJETO" -eq 1 ]; then DESTINO=".agents/plugins/boare-protocol-dev"; else DESTINO="$HOME/.gemini/config/plugins/boare-protocol-dev"; fi
            mkdir -p "$DESTINO/rules"
            [ -f "$DESTINO/plugin.json" ] && echo "Aviso: sobrescrevendo plugin existente: $DESTINO/plugin.json" >&2
            cat > "$DESTINO/plugin.json" <<FIM
{
  "name": "boare-protocol-dev",
  "version": "1.0.0",
  "description": "Conduz projetos com o Boare Protocol Dev por regras e skills de agente."
}
FIM
            write_skill "$DESTINO/skills/protocolo"
            [ -f "$DESTINO/rules/protocolo.md" ] && echo "Aviso: sobrescrevendo regra existente: $DESTINO/rules/protocolo.md" >&2
            cat > "$DESTINO/rules/protocolo.md" <<FIM
# Boare Protocol Dev

Use o Boare Protocol Dev somente quando o usuário pedir o protocolo, uma etapa do protocolo ou um comando do protocolo.
Para tarefas comuns sem pedido de protocolo, não aplique este fluxo.
Quando o usuário pedir para usar o protocolo, leia primeiro $LOCAL_PROTOCOL_PATH. Se não existir, use $PROTOCOL_URL, $PROTOCOL_CDN_URL ou $PROTOCOL_GITHUB_URL. Conduza o passo atual.
Use docs/CONTINUAR.md para retomada entre sessões, máquinas e agentes. Se ele existir, leia antes de qualquer início e não avance mais de um passo sem pedido explícito.
FIM
            ;;
        codex)
            add_codex_agents_guidance
            if [ "$PROJETO" -eq 1 ]; then DESTINO=".codex/skills/protocolo"; else DESTINO="$HOME/.codex/skills/protocolo"; fi
            write_skill "$DESTINO"
            ;;
        assistida)
            write_assisted_install
            DESTINO="docs/INSTALAR_PROTOCOLO.md"
            ;;
        *)
            echo "Ferramenta não suportada: $TOOL" >&2
            exit 1
            ;;
    esac
    echo "- $TOOL: $DESTINO"
}

resolve_auto_tools() {
    if [ "$PROJETO" -eq 1 ]; then
        FOUND=""
        [ -d .claude ] && FOUND="$FOUND claude"
        [ -d .vscode ] || [ -f .github/copilot-instructions.md ] && FOUND="$FOUND vscode"
        [ -d .cursor ] && FOUND="$FOUND cursor"
        [ -d .opencode ] && FOUND="$FOUND opencode"
        [ -d .agents ] && FOUND="$FOUND antigravity kimi"
        [ -d .codex ] || [ -f AGENTS.md ] && FOUND="$FOUND codex"
        if [ -z "$FOUND" ]; then echo "assistida"; else echo "$FOUND"; fi
    else
        FOUND=""
        command -v claude >/dev/null 2>&1 && FOUND="$FOUND claude"
        command -v opencode >/dev/null 2>&1 && FOUND="$FOUND opencode"
        command -v kimi >/dev/null 2>&1 && FOUND="$FOUND kimi"
        command -v codex >/dev/null 2>&1 && FOUND="$FOUND codex"
        if [ -z "$FOUND" ]; then echo "claude"; else echo "$FOUND"; fi
    fi
}

write_continuar
copy_protocol_bundle

case "$FERRAMENTA" in
    auto)
        TOOLS="$(resolve_auto_tools)"
        ;;
    todas)
        if [ "$PROJETO" -ne 1 ]; then echo "Use --projeto --ferramenta todas para evitar escrita global excessiva." >&2; exit 1; fi
        TOOLS="vscode claude cursor opencode kimi antigravity codex assistida"
        ;;
    vscode|claude|cursor|opencode|antigravity|kimi|codex|assistida)
        TOOLS="$FERRAMENTA"
        ;;
    *)
        echo "Ferramenta inválida: $FERRAMENTA" >&2
        exit 1
        ;;
esac

echo "Adaptadores criados:"
for TOOL in $TOOLS; do
    install_tool "$TOOL"
done
echo "Referência usada: $REFERENCIA"
if [ "$PROJETO" -eq 1 ]; then
    echo ""
    echo "Boare Protocol Dev instalado neste projeto."
    echo "Próximo passo na sua IDE ou agente:"
    echo "Use o Boare Protocol Dev deste projeto e conduza o passo atual."
    case " $TOOLS " in
        *" assistida "*)
            echo ""
            echo "A ferramenta não foi detectada automaticamente. Se necessário, abra docs/INSTALAR_PROTOCOLO.md na sua IDE para concluir o adaptador."
            ;;
    esac
fi
