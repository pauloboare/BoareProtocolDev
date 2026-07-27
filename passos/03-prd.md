# Passo 3 - Criar o PRD

## Objetivo
Transformar as oito respostas do Passo 1 em requisitos que dá para verificar.

## Entra
- As oito respostas do Passo 1.

## Sai
- `docs/PRD.md`

## Perguntas obrigatórias

Antes de escrever, feche o que ficou aberto no Passo 1:

1. Cada papel de usuário faz o quê, exatamente? Liste as ações de cada um.
2. Que regras o sistema precisa impor sozinho, sem depender de disciplina de
   quem usa? (prazo, limite, exclusividade, ordem obrigatória)
3. O que acontece quando a regra é violada? Bloqueia, avisa, ou registra?
4. Que informação precisa existir antes de o sistema ser útil no primeiro dia?
5. Qual restrição não é negociável? (prazo, orçamento, ambiente obrigatório,
   lei, integração)

## Instrução

Uma pergunta por vez. Depois preencha `templates/PRD.md`. Em modo agente, crie
ou atualize `docs/PRD.md`. Em modo assistido, apresente o conteúdo para o
usuário salvar.

Ao escrever:

- Numere as regras de negócio como `RN01`, `RN02`... Uma regra por número.
- Numere os critérios de aceite como `CA01`, `CA02`... Cada critério descreve um
  comportamento observável: dado um estado, quando acontece algo, então resulta
  algo. Quem lê tem que conseguir dizer se passou ou não.
- Toda regra de negócio precisa de pelo menos um critério de aceite. Regra sem
  critério é intenção, não requisito.
- Palavra subjetiva não entra em critério: "rápido", "amigável", "simples",
  "intuitivo", "moderno". Troque por número ou por comportamento. "Rápido" vira
  "responde em até 2 segundos" - e aí o usuário decide se 2 é o número certo.
- Repita o escopo negativo do Passo 1 no PRD, em seção própria. O que está fora
  precisa estar escrito para continuar fora.
- Não decida tecnologia aqui. O PRD diz o que o sistema faz, não como.

Se aparecer requisito novo durante a conversa, pergunte se entra no escopo ou na
lista do que fica de fora. Não deixe flutuar.

**Segurança e LGPD valem sempre** - segredo exposto ou dado pessoal em risco?
Avise na hora, mesmo fora do assunto deste passo.

## Portão de saída

- [ ] Toda `RN` tem pelo menos um `CA`
- [ ] Nenhum `CA` usa palavra subjetiva
- [ ] Todo papel de usuário tem ao menos uma ação declarada
- [ ] A seção de fora de escopo tem no mínimo três itens
- [ ] A seção de dados pessoais nomeia os dados, ou declara que não há nenhum
- [ ] Nenhuma tecnologia específica é citada

## Commit

Comandos sugeridos:

```bash
git status
git add docs/PRD.md
git diff --staged
git commit -m "docs(prep): adiciona PRD"
```

