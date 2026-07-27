# Passo 2 - Criar o repositório

## Objetivo
Colocar o projeto sob versionamento antes de produzir qualquer artefato.

**É o repositório do sistema que você constrói - não o deste protocolo.** O
protocolo você só leu, como instrução; ele não tem relação com o `.git` daqui.

## Entra
- Nome do projeto e uma frase descrevendo o que ele faz.

## Sai
- Repositório com `docs/`, `.gitignore` seguro, `docs/BUGS.md` e
  `docs/CONTINUAR.md` como fonte canônica de retomada.

## Perguntas obrigatórias

1. Nome do repositório? (minúsculas, sem espaço, sem acento)
2. Descrição em uma linha.
3. Público ou privado? Se o sistema trata dado pessoal, privado.
4. Já existe código escrito, ou o repositório nasce vazio?
5. Quer criar remoto agora, ou manter só local por enquanto?

## Instrução

Em modo agente, você pode criar arquivos locais do protocolo dentro do projeto.
Para inicializar Git, criar remoto, commitar ou publicar, confirme o alvo e use
o mecanismo de aprovação da ferramenta quando existir. Em modo assistido, mostre
os comandos, explique o que cada um faz e espere o usuário rodar.

**Antes de tudo, confirme o estado real** - não presuma pelo que foi dito:

- A pasta atual já tem `.git`? Confira, não pergunte só de boca - se já tiver,
  pule a inicialização e siga para o que faltar da sequência.
- O controle de versão está instalado?
- Tem nome e e-mail configurados? Sem isso o primeiro commit falha.
- Consegue autenticar na plataforma de repositórios remotos? Se nunca fez, ela
  oferece dois caminhos: chave criptográfica ou token de acesso. Oriente pelo
  utilitário oficial de linha de comando da plataforma, que guarda a credencial
  no lugar certo. **Token colado em arquivo de configuração é segredo exposto** -
  não oriente por esse caminho.

Faltando algum item, resolva antes de seguir.

Sequência:

1. Inicializar o repositório local e nomear o ramo principal `main`.
2. Criar a pasta `docs/` - onde todo artefato deste protocolo vai morar.
3. Criar o `.gitignore` **antes do primeiro commit**, a partir de
   `templates/GITIGNORE.md`. O bloco de segurança vale desde já; o bloco das
   tecnologias escolhidas depende do Passo 4, então volte aqui para completar.
4. Criar o exemplo do arquivo de ambiente, **sem valores reais**. Ele documenta
   quais variáveis existem.
5. Criar `docs/BUGS.md` a partir de `templates/BUGS.md`. Nasce vazio e acompanha
   o projeto até o fim da vida dele.
6. Criar `docs/CONTINUAR.md` a partir de `templates/CONTINUAR.md`. Se a
   ferramenta usada tiver um arquivo-gatilho próprio na raiz do projeto,
   acrescente nele uma linha curta: "Leia `docs/CONTINUAR.md` e siga."
   Isso é adaptação de IDE/agente, não regra do protocolo.
7. Primeiro commit. Depois, se a resposta 5 pediu remoto, criar o repositório
   remoto e enviar. Se não pediu, registrar que o projeto está só local por
   enquanto em `docs/CONTINUAR.md`.

Antes do primeiro commit, peça ao usuário para listar o que será versionado e
confira item por item - inclusive se a resposta 4 disse que já existe código.
Segredo commitado uma vez fica no histórico para sempre: apagar o arquivo
depois não resolve, só rotacionar a credencial resolve.

Convenção de mensagem de commit: seção "Commits" do `PADROES.md`.

## Portão de saída

- [ ] Ambiente de versionamento configurado e autenticado
- [ ] Repositório local existe, com ramo principal `main`
- [ ] Repositório remoto existe e recebeu o primeiro push, ou a decisão de manter só local está registrada em `docs/CONTINUAR.md`
- [ ] `docs/`, `docs/BUGS.md` e `docs/CONTINUAR.md` existem
- [ ] Se houver arquivo-gatilho da ferramenta usada, ele aponta para `docs/CONTINUAR.md`
- [ ] `.gitignore` cobre segredos, dumps de banco, logs e arquivos enviados
- [ ] O exemplo do arquivo de ambiente está versionado, sem valor real
- [ ] Nenhum segredo aparece no histórico
- [ ] A visibilidade corresponde à resposta 3

## Commit

Comandos sugeridos:

```bash
git status
git add .gitignore docs/BUGS.md docs/CONTINUAR.md <arquivo-env-exemplo>
git diff --staged
git commit -m "chore: estrutura inicial"
```
