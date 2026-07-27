# Passo 4 - Decisões técnicas e arquitetura

## Objetivo
Fechar as decisões caras de mudar depois, com o motivo registrado.

## Entra
- `docs/PRD.md` (e `docs/DESIGN.md`, se o Passo 1b rodou)

## Sai
- `docs/DECISOES_TECNICAS.md`

## Decisões obrigatórias

| # | Decisão | Precisa de opções? |
|---|---------|--------------------|
| D1 | Tipo de aplicação | sim |
| D2 | **Arquitetura da aplicação** | sim - 2 a 3 opções |
| D3 | Persistência dos dados | sim |
| D4 | Autenticação e autorização | sim |
| D5 | Onde vai rodar | sim |
| D6 | Um cliente só, ou vários isolados no mesmo sistema? | não |
| D7 | Trata dado pessoal? Qual, com que finalidade e base legal? | não |

## Instrução

Uma decisão por vez, na ordem. Não apresente D3 antes de D2 estar fechada.
Para cada decisão que precisa de opções:

1. Derive as opções **do caso concreto** - usuários, regras, restrições e dado
   pessoal do PRD. Não recite o catálogo do mercado: ofereça 2 ou 3 caminhos
   que servem a este sistema. Em D2, parta da decomposição recomendada em
   `skills/arquitetura.md`; afastar-se dela é opção legítima, mas entra como
   alternativa com motivo, não por omissão.
2. Se uma decisão envolver tecnologias, trate linguagem, framework, banco,
   hospedagem e ferramenta como escolhas abertas. Você pode recomendar uma
   combinação, mas precisa justificar pelo PRD, pelo time, pelo ambiente
   existente, pelo deploy, pelos testes e pelo custo de manutenção.
3. Pode usar exemplo técnico para explicar a diferença entre opções, desde que
   fique explícito que é exemplo. Exemplo não vira recomendação automática.
4. Para cada uma, diga o que facilita, o que dificulta, e **quanto custa trocar
   depois**. A última é a que mais importa.
5. Recomende uma, com o motivo em uma frase.
6. Deixe o usuário escolher. Ele pode preferir a que você não recomendou -
   registre assim mesmo, com o motivo dele.

Preencha `templates/DECISOES_TECNICAS.md`. Em modo agente, crie ou atualize
`docs/DECISOES_TECNICAS.md`. Em modo assistido, apresente o conteúdo para o
usuário salvar. Formato de cada decisão:

```markdown
## D2 - Arquitetura da aplicação

| Opção | Facilita | Dificulta | Custo de trocar depois |
|---|---|---|---|
| A |  |  |  |
| B |  |  |  |

**Escolhida:** B
**Motivo:** uma frase
**Rejeitadas:** A porque ...
**Revisar se:** condição concreta que invalidaria esta escolha
```

A linha **Revisar se** impede a decisão de ser rediscutida do zero na próxima
sessão. Escreva condição verificável: "se passar de 500 usuários ao mesmo tempo",
não "se crescer muito".

- Contradisse restrição do PRD? Ou a decisão muda, ou o PRD muda - e mudar o PRD
  é decisão do usuário, não sua.
- D7 condiciona D3 e D4: declare finalidade e base legal de cada dado pessoal
  antes de decidir persistência e acesso.
- D4 diz **onde** sessão endurecida e cabeçalhos de resposta são aplicados **uma
  vez só**, para todo ponto de entrada. Repetido tela a tela, alguma esquece.
- Fechadas as decisões que definem linguagem, framework, banco ou ferramenta,
  **volte ao `.gitignore`** e acrescente o bloco correspondente. Ele nasceu no
  Passo 2, quando isso ainda não existia: sem essa revisão, dependência
  instalada e arquivo compilado entram no primeiro commit de código.
- Não recomende pelo que é popular. Recomende pelo que cabe no PRD.
- Usuário sem opinião? A opção mais simples que atende o PRD de hoje, com
  "Revisar se" bem escrita. `skills/README.md` aponta a skill de cada decisão.

**Segurança e LGPD valem sempre** - algo em risco? Avise na hora, mesmo fora
do assunto deste passo.

## Portão de saída

- [ ] D1 a D7 respondidas
- [ ] D2 tem no mínimo 2 opções, com a rejeitada justificada
- [ ] Toda decisão com opções tem o custo de trocar depois preenchido
- [ ] Toda decisão tem a linha "Revisar se", com condição verificável
- [ ] Nenhuma decisão contradiz restrição do PRD
- [ ] D4 nomeia o ponto único onde sessão e cabeçalhos são aplicados
- [ ] O `.gitignore` ganhou o bloco das tecnologias escolhidas
- [ ] Havendo dado pessoal no PRD, D7 declara finalidade e base legal de cada um

## Commit

Comandos sugeridos:

```bash
git status
git add docs/DECISOES_TECNICAS.md .gitignore
git diff --staged
git commit -m "docs(prep): registra decisões técnicas"
```

