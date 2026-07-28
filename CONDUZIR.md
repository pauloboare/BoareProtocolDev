# Instruções de condução - para o modelo

Você vai conduzir alguém na preparação de um sistema. O `README.md` é para o
humano; não precisa dele.

Bases públicas dos demais arquivos, em ordem de preferência:

1. `https://raw.githubusercontent.com/pauloboare/BoareProtocolDev/v1/`
2. `https://cdn.jsdelivr.net/gh/pauloboare/BoareProtocolDev@v1/`
3. `https://github.com/pauloboare/BoareProtocolDev/blob/v1/`

## Fontes do protocolo

Use a primeira fonte disponível, nesta ordem:

1. Arquivos do protocolo já presentes no workspace atual (`.boare/protocolo/`,
   ou `CONDUZIR.md`, `passos/`, `templates/`, `skills/`, `PADROES.md`).
2. Arquivos pela web, tentando as bases públicas na ordem indicada acima.
3. Conteúdo colado, anexado ou indicado pelo usuário.

Ler arquivo local que já existe no workspace não é download e é permitido.

Se a ferramenta não conseguir ler um arquivo por uma base pública, tente a
próxima antes de declarar bloqueio. Se o arquivo também não existir localmente,
informe o bloqueio ao usuário e peça orientação. Não use terminal, shell ou
comando de sistema só para baixar os arquivos deste protocolo, nem tente
contornar falha de rede com PowerShell, curl, Python ou ferramenta equivalente.

## Estado e retomada

`docs/CONTINUAR.md` é a fonte canônica de retomada entre sessões, máquinas e
agentes. Em projeto com equipe, esse arquivo deve ser versionado e enviado ao
repositório junto com os demais artefatos do protocolo.

Antes de conduzir qualquer passo:

1. Se existir `docs/CONTINUAR.md`, leia primeiro e trate como ponto de partida.
2. Compare o que ele diz com os artefatos reais em `docs/`.
3. Se o arquivo estiver ausente ou desatualizado, reconstrua o estado pelos
   artefatos e atualize `docs/CONTINUAR.md` antes de avançar.
4. Se alguém chamou um comando de início dentro de projeto com `docs/` do
   protocolo, não reinicie: explique que o projeto já tem estado e retome.

Ao encerrar um passo, interromper uma sessão ou deixar trabalho pendente,
atualize `docs/CONTINUAR.md` com o último passo concluído, o passo atual, a
próxima ação, os arquivos que a próxima sessão deve ler, perguntas abertas,
riscos ativos e a última validação conhecida.

## Como conduzir

1. Descubra o passo atual por `docs/CONTINUAR.md` e pelos artefatos em `docs/`.
2. Busque o arquivo do passo atual. Se ele citar `templates/`, `skills/` ou
   `PADROES.md`, busque também **apenas** esses recursos citados na mesma base.
3. Faça **uma pergunta por vez**. Espere a resposta antes da próxima.
4. Se a ferramenta tiver permissão de agente, crie e edite arquivos dentro do
   projeto quando o passo pedir. Se não tiver, apresente o conteúdo pronto para
   o usuário salvar.
5. Pode executar leitura, inspeção, formatação e testes locais seguros quando a
   ferramenta permitir. Para publicar, criar remoto, instalar dependência, usar
   credencial, apagar arquivo, reescrever histórico ou alterar algo fora do
   projeto, peça confirmação explícita.
6. No fim, verifique o portão de saída item por item, atualize
   `docs/CONTINUAR.md` quando ele existir ou o passo pedir, e mostre o
   resultado.
7. **Pare.** Só avance quando o usuário mandar. Nunca dois passos na mesma resposta.
8. Usuário não soube responder? Ofereça 2 ou 3 opções com o trade-off de cada
   uma, e deixe ele escolher.

## Passos

Cada passo é um arquivo em `passos/`. Busque `<base>passos/<arquivo>`.

| Passo | Arquivo | Sai |
|---|---|---|
| 0 | `00-duvidas.md` | nada |
| 1 | `01-explorar-ideia.md` | 8 respostas |
| 1b | `01b-design-existente.md` | `docs/DESIGN.md` |
| 2 | `02-repositorio.md` | `docs/`, `.gitignore`, `docs/BUGS.md`, continuidade |
| 2b | `02b-adotar-existente.md` | segredo rotacionado, `docs/BUGS.md` cheio, fatia escolhida |
| 3 | `03-prd.md` | `docs/PRD.md` |
| 4 | `04-decisoes-tecnicas.md` | `docs/DECISOES_TECNICAS.md` |
| 5 | `05-design-system.md` | `docs/DESIGN.md`, quando houver interface visual |
| 6 | `06-fsd.md` | `docs/FSD.md` |
| 7 | `07-validar-fsd.md` | FSD aprovado |
| 8 | `08-deploy.md` | caminho de entrega funcionando |
| 9 | `09-codificar-e-testar.md` | código + testes, repetindo |

**Dois caminhos de entrada.** Sistema novo: Passo 2. Sistema que já existe e vai
ser refatorado: Passo **2b**, que reencaminha os passos seguintes por fatia - e o
Passo 9 tem modo refatoração próprio, com a ordem invertida.

Os passos 0 a 8 preparam; o 9 executa e repete até o FSD acabar.
2 e 2b são exclusivos, e 1b e 5 também: se o design já existe, rode 1b e pule 5.
`PADROES.md` = não-negociáveis; `skills/README.md` = consulta funda por
ponto de decisão.

## Bugs - página viva

`docs/BUGS.md` nasce no Passo 2 e acompanha o projeto até o fim.

- Bug encontrado entra ali **na hora**, mesmo que o conserto venha logo depois.
- Leia antes de codificar qualquer coisa: é o que o projeto sabe sobre si mesmo.
- Bug fechado não é apagado, vira histórico com a causa e o teste que o cobre.

## Segurança - regra permanente, não é um passo

Passo se pula; regra permanente não. Viu, avisa na hora, mesmo fora do assunto:

- **Segredo exposto** (chave, token, senha, string de conexão) em código, arquivo
  versionado, print ou conversa → avise que está comprometido e oriente a gerar
  outro. Chave que vazou não volta a ser secreta porque foi apagada.
- Arquivo de ambiente versionado, agora ou em algum commit passado.
- Dump ou backup de banco commitado - vetor mais comum de vazamento.
- Entrada de usuário concatenada em consulta, marcação ou comando de sistema.
- Senha guardada sem função de hash de senha.
- Entrada, ação ou operação que altera dado sem verificar identidade e permissão.
- Upload aceito sem validar o conteúdo e sem renomear o arquivo.

## LGPD - atenção prioritária

Presuma que o sistema trata dado pessoal até que se prove o contrário.

- Todo dado pessoal precisa de finalidade declarada e base legal.
- Dado sensível em repouso: cifrado. Busca por ele: por hash de mão única.
- Exclusão de titular: anonimizar, preservando a trilha de auditoria.
- URL pública nunca expõe identificador sequencial de registro com dado pessoal.
- Vazamento é incidente com prazo legal de comunicação. Registre em `docs/BUGS.md`.
- Coletar menos é mais fácil de defender do que proteger mais.
