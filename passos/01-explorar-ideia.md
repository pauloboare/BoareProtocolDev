# Passo 1 - Explorar a ideia

## Objetivo
Transformar uma ideia crua em oito respostas que cabem em uma página.

## Entra
- A ideia, do jeito que estiver na sua cabeça.

## Sai
- Oito respostas escritas. Sem arquivo: o repositório ainda não existe (Passo 2).
- Guarde as respostas. Elas são a entrada do PRD (Passo 3).

## Perguntas obrigatórias

1. Que problema o sistema resolve? Uma frase.
2. Quem usa? Liste os papéis (recepcionista, cliente, administrador...).
3. O que a pessoa consegue fazer no sistema que hoje não consegue?
4. Qual é a única funcionalidade que, se faltar, o sistema não serve para nada?
5. O que explicitamente **não** faz parte? No mínimo três itens.
6. Qual é o canal de uso? Exemplos: web, mobile, desktop, linha de comando,
   API, automação, biblioteca ou integração.
7. Quantos usuários ao mesmo tempo? Ordem de grandeza basta: 10, 100, 10 mil.
8. Lida com dado pessoal? Qual exatamente (nome, CPF, e-mail, saúde, localização)?

Não avance sem resposta. Se a pessoa não souber, ofereça 2 ou 3 opções com o
trade-off de cada uma e deixe ela escolher. Não escolha por ela.

## Instrução

Comece oferecendo a escolha: a pessoa explica a ideia com as próprias palavras,
ou responde às oito perguntas uma a uma.

**Explicou primeiro?** Extraia do texto o que já responde às oito perguntas,
devolva numerado o que entendeu, e pergunte só o que faltou - uma por vez.
Não invente resposta que o texto não deu: lacuna vira pergunta, não suposição.

**Preferiu as perguntas?** Faça uma por vez. Espere a resposta antes da próxima.

Nos dois caminhos: depois de cada resposta, repita em uma linha o que entendeu
e confirme. Resposta vaga? Peça o caso concreto: "me dá um exemplo real".

Ao conduzir:

- Não proponha solução técnica aqui. Nada de banco, framework ou tela.
- Não amplie o escopo. Se surgir ideia nova, anote na pergunta 5 como
  "fora de escopo por enquanto" e siga em frente.
- A pergunta 4 é a mais importante. Se a resposta listar três coisas, insista
  até sobrar uma. Todo sistema tem um centro - ache o centro. Resposta óbvia
  demais (repete o nome do sistema, tipo "cadastrar a doação" num sistema de
  doações)? Peça: "imagine sem essa parte - o que ainda funciona?" Sobrou
  quase tudo, ainda não achou o centro.
- Resposta 6 do tipo "só no computador" ou "só no celular" é ambígua: pode ser
  navegador, app, linha de comando, automação ou programa instalado. Pergunte
  direto antes de registrar.
- A pergunta 5 é a mais difícil e a que mais economiza trabalho depois.
  Escopo negativo com menos de três itens significa que ninguém pensou
  no assunto ainda.
- A pergunta 8 decide quanto de segurança e conformidade o projeto carrega.
  "Só o nome e o e-mail" já é dado pessoal.

No fim, apresente as oito respostas juntas e numeradas - na própria resposta,
sem criar arquivo - para a pessoa confirmar. Ela tem que reconhecer o próprio
sistema ali.

**Segurança e LGPD valem sempre** - algo em risco? Avise na hora, mesmo fora
do assunto deste passo.

## Portão de saída

- [ ] As oito perguntas têm resposta escrita
- [ ] A resposta 1 cabe em uma frase, sem "e" emendando dois problemas
- [ ] A resposta 4 nomeia **uma** funcionalidade, não uma lista
- [ ] A resposta 5 tem no mínimo três itens
- [ ] A resposta 8 nomeia os dados, não responde apenas "sim"
- [ ] Nenhuma resposta usa palavra vaga: "amigável", "rápido", "moderno", "simples"

Falhou algum item? Volte à pergunta correspondente antes de seguir para o Passo 2.

## Commit

Nenhum. O repositório nasce no Passo 2 - leve as oito respostas com você.

