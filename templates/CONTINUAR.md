# Continuar o protocolo

Leia `.boare/protocolo/CONDUZIR.md` se existir. Se não existir, leia o primeiro
link que conseguir acessar:

1. https://raw.githubusercontent.com/pauloboare/BoareProtocolDev/v1/CONDUZIR.md
2. https://cdn.jsdelivr.net/gh/pauloboare/BoareProtocolDev@v1/CONDUZIR.md
3. https://github.com/pauloboare/BoareProtocolDev/blob/v1/CONDUZIR.md

Continue pelo estado atual deste projeto.

## Regra de equipe

- Este arquivo deve ser versionado no repositório do sistema.
- Antes de trabalhar em outro computador, atualize o repositório local e leia
  este arquivo.
- A versão local do protocolo fica em `.boare/protocolo/protocolo.json`.
- Não cheque atualização do protocolo a cada sessão; atualize só por pedido
  explícito.
- Ao encerrar uma sessão ou concluir um passo, rode `/protocolo-retomada` ou
  atualize este arquivo manualmente.
- Se alguém chamar `/protocolo-iniciar` em um clone que já tem este arquivo,
  ignore o início e retome daqui.

## Limite deste arquivo

Bilhete de retomada, não diário. Ele é lido inteiro no começo de toda sessão e
reescrito no fim de cada passo: o que cresce aqui é cobrado em contexto todo dia.

Tetos, conferidos sempre que este arquivo for atualizado:

- Antes de continuar, leia: 3 arquivos
- Perguntas abertas: 5
- Decisões recentes: 5
- Riscos ativos: 5
- Observações finais para a próxima sessão: 5

O excedente não é apagado, é promovido: decisão vai para
`docs/DECISOES_TECNICAS.md`, risco aceito vira restrição no `docs/FSD.md`,
pergunta respondida vira decisão. Item sem lugar definitivo fica aqui.

Bug não é copiado para cá. `docs/BUGS.md` é a fonte; cite o identificador
(`B07`) só quando ele bloquear a próxima ação.

## Modo

<normal / refatoração>

## Estado atual

- Último passo concluído: <passo ou "nenhum">
- Passo atual: <passo provável>
- Última ação feita: <ação objetiva>
- Próxima ação recomendada: <ação objetiva>
- Próximo comando recomendado: </protocolo / /protocolo-iniciar / /protocolo-continuar / /protocolo-adotar / /protocolo-status / /protocolo-retomada>

## Como descobrir o passo atual

1. Leia os arquivos existentes em `docs/`.
2. Compare com os artefatos esperados pelo protocolo.
3. Busque apenas o arquivo do passo atual.
4. Faça uma pergunta por vez.
5. No fim do passo, confira o portão de saída.
6. Não avance para o próximo passo sem pedido explícito.

## Artefatos conhecidos

- `docs/BUGS.md`: <existe / não existe>
- `docs/PRD.md`: <existe / não existe>
- `docs/DECISOES_TECNICAS.md`: <existe / não existe>
- `docs/DESIGN.md`: <existe / não se aplica / não existe>
- `docs/FSD.md`: <existe / não existe>

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
