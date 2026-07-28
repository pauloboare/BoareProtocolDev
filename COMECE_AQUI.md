# Comece aqui - Boare Protocol Dev

Este arquivo existe para o primeiro contato com o protocolo.

Se voce e uma IA conduzindo um usuario, use este arquivo quando o pedido for:

```text
Leia o Boare Protocol Dev e conduza o Passo 1.
```

O objetivo e evitar que uma falha ao buscar outro arquivo do GitHub interrompa
o primeiro uso. Para continuar depois do Passo 1, leia `CONDUZIR.md`.

## Antes de iniciar

Confira se o projeto atual ja usa o protocolo antes de conduzir o Passo 1.

Se existir `docs/CONTINUAR.md`, leia esse arquivo e siga a proxima acao
recomendada. Se ele nao existir, mas `docs/` tiver `PRD.md`,
`DECISOES_TECNICAS.md`, `DESIGN.md`, `FSD.md` ou `BUGS.md`, nao reinicie o
protocolo: leia `CONDUZIR.md`, descubra o passo atual pelos artefatos e avise
que o projeto sera retomado.

Use o Passo 1 so quando nao houver estado de protocolo no projeto, ou quando o
usuario pedir explicitamente para comecar outro produto do zero.

## Fontes publicas

Se uma URL falhar, tente a proxima antes de declarar bloqueio:

1. `https://raw.githubusercontent.com/pauloboare/BoareProtocolDev/v1/COMECE_AQUI.md`
2. `https://cdn.jsdelivr.net/gh/pauloboare/BoareProtocolDev@v1/COMECE_AQUI.md`
3. `https://github.com/pauloboare/BoareProtocolDev/blob/v1/COMECE_AQUI.md`

Para os demais arquivos do protocolo, use as mesmas bases:

1. `https://raw.githubusercontent.com/pauloboare/BoareProtocolDev/v1/`
2. `https://cdn.jsdelivr.net/gh/pauloboare/BoareProtocolDev@v1/`
3. `https://github.com/pauloboare/BoareProtocolDev/blob/v1/`

Nao use terminal, shell ou comando de sistema so para baixar arquivos deste
protocolo. Tambem nao tente contornar falha de rede com PowerShell, curl, Python
ou ferramenta equivalente. Se nao conseguir ler pela web nem houver copia local,
peça orientacao ao usuario.

## Como conduzir o Passo 1

Faca uma pergunta por vez. Espere a resposta antes da proxima.

Comece oferecendo a escolha: a pessoa explica a ideia com as proprias palavras,
ou responde as oito perguntas uma a uma.

Se ela explicar primeiro, extraia do texto o que ja responde as oito perguntas,
devolva numerado o que entendeu, e pergunte so o que faltou, uma por vez.
Nao invente resposta que o texto nao deu: lacuna vira pergunta, nao suposicao.

Se ela preferir as perguntas, faca uma por vez. Depois de cada resposta, repita
em uma linha o que entendeu e confirme. Resposta vaga? Peca o caso concreto:
"me da um exemplo real".

Nao proponha solucao tecnica aqui. Nada de banco, framework ou tela. Nao amplie
o escopo. Se surgir ideia nova, anote na pergunta 5 como "fora de escopo por
enquanto" e siga em frente.

## Perguntas obrigatorias

1. Que problema o sistema resolve? Uma frase.
2. Quem usa? Liste os papeis (recepcionista, cliente, administrador...).
3. O que a pessoa consegue fazer no sistema que hoje nao consegue?
4. Qual e a unica funcionalidade que, se faltar, o sistema nao serve para nada?
5. O que explicitamente nao faz parte? No minimo tres itens.
6. Qual e o canal de uso? Exemplos: web, mobile, desktop, linha de comando,
   API, automacao, biblioteca ou integracao.
7. Quantos usuarios ao mesmo tempo? Ordem de grandeza basta: 10, 100, 10 mil.
8. Lida com dado pessoal? Qual exatamente (nome, CPF, e-mail, saude,
   localizacao)?

## Regras de conducao

- Nao avance sem resposta.
- Se a pessoa nao souber, ofereca 2 ou 3 opcoes com o trade-off de cada uma e
  deixe ela escolher.
- A pergunta 4 precisa terminar com uma unica funcionalidade. Se a resposta
  listar tres coisas, insista ate sobrar uma.
- Resposta 6 como "so no computador" ou "so no celular" e ambigua. Pergunte se
  e navegador, app, linha de comando, automacao ou programa instalado.
- A pergunta 5 precisa ter pelo menos tres itens.
- A pergunta 8 precisa nomear os dados. "So nome e e-mail" ja e dado pessoal.
- Segurança e LGPD valem sempre. Se aparecer segredo, dado sensivel ou risco
  claro, avise na hora.

## Saida do Passo 1

No fim, apresente as oito respostas juntas e numeradas, na propria resposta, sem
criar arquivo, e peca confirmacao. A pessoa precisa reconhecer o proprio sistema
ali.

## Portao de saida

- [ ] As oito perguntas tem resposta escrita
- [ ] A resposta 1 cabe em uma frase, sem "e" emendando dois problemas
- [ ] A resposta 4 nomeia uma funcionalidade, nao uma lista
- [ ] A resposta 5 tem no minimo tres itens
- [ ] A resposta 8 nomeia os dados, nao responde apenas "sim"
- [ ] Nenhuma resposta usa palavra vaga: "amigavel", "rapido", "moderno",
  "simples"

Falhou algum item? Volte a pergunta correspondente antes de seguir para o Passo
2.

Pare no fim do Passo 1. So avance quando o usuario mandar.
