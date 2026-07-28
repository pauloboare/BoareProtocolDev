# Passo 2b - Adotar sistema existente

Alternativo ao Passo 2. Rode este quando o sistema **já existe** e a intenção é
refatorá-lo dentro dos princípios do protocolo. Nunca rode os dois.

## Objetivo
Saber o que se herdou, estancar o risco que já está lá, e começar a refatorar
por fatias - sem parar o sistema para documentá-lo inteiro.

## Entra
- O repositório do sistema, como ele está hoje.

## Sai
- `docs/BUGS.md` já preenchido, `docs/CONTINUAR.md`, `.gitignore` revisto,
  e as credenciais expostas em rotação.

## Perguntas obrigatórias

1. O que dói hoje? (o que quebra, o que ninguém mexe com medo, o que é lento)
2. Existe algum teste automatizado hoje? Roda?
3. Que parte **não pode** parar de funcionar em hipótese nenhuma?
4. Alguém além de você mexe neste código?
5. O que já se sabe que está errado e ninguém corrigiu?

## Instrução

### 1. Leitura inicial controlada

Antes de perguntar demais ou editar arquivos, monte um retrato curto do sistema.
Se a ferramenta permitir leitura local, inspecione apenas o necessário:

- README ou documentação de entrada;
- arquivos em `docs/`, se existirem;
- estrutura principal de pastas;
- arquivos de configuração do projeto;
- arquivos-gatilho da ferramenta de IA, se existirem;
- últimos commits relevantes, se o Git estiver disponível;
- lista de testes ou comandos de validação existentes.

Não leia dumps, arquivos de ambiente, credenciais, pastas de dependências,
artefatos gerados ou arquivos grandes sem necessidade. Não execute instalação,
publicação ou comando destrutivo.

Depois da leitura, entregue um resumo com:

- stack aparente, marcada como inferência quando não houver fonte clara;
- áreas do sistema que parecem existir;
- sinais de teste, build, deploy ou ausência deles;
- riscos imediatos;
- primeira fatia candidata para organizar.

Esse resumo não substitui PRD, decisões técnicas nem FSD. Ele serve só para a IA
parar de conduzir no escuro.

### 2. Auditoria de segredo - antes de qualquer mudança

Repositório herdado é o lugar mais provável de haver credencial já commitada, e
`.gitignore` não apaga o passado. Peça ao usuário para rodar a busca por
arquivos de ambiente, chave e dump **no histórico inteiro**, não só nos arquivos
de hoje. Achou? A credencial está comprometida: oriente a **gerar outra**.
Remover do histórico é opcional; rotacionar não é.

Depois disso, revise o `.gitignore` com o bloco de segurança de
`templates/GITIGNORE.md` e confirme que nada sensível ainda aparece rastreado.

### 3. Inventário honesto

Liste os contextos de negócio que existem hoje e, para cada um, se tem teste.
Não reescreva nada agora. O objetivo é saber onde se está.

### 4. `docs/BUGS.md` nasce cheio

Tudo da resposta 5 entra agora, com gravidade. Página viva de sistema herdado
que começa vazia está mentindo.

### 5. Continuidade

Crie `docs/CONTINUAR.md` a partir de `templates/CONTINUAR.md`, **declarando
que o projeto está em modo refatoração** - senão a próxima sessão tenta criar
repositório do zero.

Preencha também:

- último passo concluído;
- passo atual;
- última ação feita;
- próxima ação recomendada;
- próximo comando recomendado;
- arquivos que devem ser lidos antes de continuar;
- perguntas abertas;
- decisões recentes;
- riscos ativos;
- última validação conhecida.

Os arquivos-gatilho da raiz costumam **já existir** num sistema herdado, com
instrução de verdade dentro. Se a ferramenta usada tiver um arquivo-gatilho,
leia antes: se existir, **acrescente** a linha ao fim. Sobrescrever apaga o que
a equipe escreveu.

## Depois deste passo

Não documente o sistema inteiro: isso nunca termina. Trabalhe por fatia,
começando pela resposta 1.

- Passos 3 e 4 descrevem **o que já existe**, e só da fatia em questão: o PRD
  registra a regra que o código já impõe, o D2 registra a arquitetura que ele já
  tem. Divergiu do recomendado? Vira alternativa com motivo, como qualquer outra.
- Passos 5, 6 e 7 valem por fatia, quando a fatia mexe em tela.
- Passo 8 se **verifica**, não se constrói: o caminho até produção já existe.
- Passo 9 roda em **modo refatoração** - leia a seção própria lá.

**Segurança e LGPD valem sempre** - algo em risco? Avise na hora, mesmo fora
do assunto deste passo.

## Portão de saída

- [ ] O histórico foi vasculhado por segredo, não só os arquivos de hoje
- [ ] Toda credencial encontrada está em rotação, ou foi declarada como já rotacionada
- [ ] O `.gitignore` tem o bloco de segurança e nada sensível segue rastreado
- [ ] O resumo inicial registrou fontes, inferências, riscos e primeira fatia candidata
- [ ] `docs/BUGS.md` tem ao menos um item, ou o usuário declarou que não há nenhum
- [ ] `docs/CONTINUAR.md` declara o modo refatoração
- [ ] `docs/CONTINUAR.md` registra próxima ação, perguntas abertas, riscos e última validação conhecida
- [ ] Arquivo-gatilho que já existia foi acrescentado, não sobrescrito
- [ ] A primeira fatia a refatorar está escolhida e escrita

## Commit

Comandos sugeridos:

```bash
git status
git add .gitignore docs/BUGS.md docs/CONTINUAR.md <arquivos-gatilho-alterados>
git diff --staged
git commit -m "chore: adota protocolo no sistema existente"
```
