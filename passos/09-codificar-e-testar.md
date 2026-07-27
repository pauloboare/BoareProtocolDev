# Passo 9 - Codificar e testar

Este passo repete: uma funcionalidade por vez, até o FSD acabar.

## Objetivo
Implementar uma funcionalidade com teste, sem sair do que o FSD especificou.

## Entra
- `docs/FSD.md` validado, `docs/BUGS.md`, `PADROES.md`

## Sai
- Código e testes de **uma** funcionalidade, commitados juntos.
- Quando não houver próximo item no FSD: fechamento do ciclo registrado em
  `docs/CONTINUAR.md`.

## Perguntas obrigatórias

1. Qual item da ordem de implementação do FSD vamos fazer agora?
2. As dependências dele já estão prontas?
3. Existe bug aberto em `docs/BUGS.md` que afeta esta parte?

## Instrução

Antes de escrever qualquer código:

1. Leia `docs/BUGS.md`. É o que o projeto já sabe sobre si mesmo.
2. Releia o item do FSD e os critérios de aceite do PRD que ele cobre.
3. Consulte `PADROES.md` para o que é inegociável, e `skills/README.md` para
   revisão mais funda no que o item envolver.

Ordem de trabalho:

1. **Escreva o teste primeiro**, a partir do plano de testes do FSD. Ele tem que
   falhar porque o comportamento não existe - não por erro de escrita.
2. Escreva o mínimo que faz o teste passar.
3. Cubra os casos de borda do FSD: valor ausente, coleção vazia, limite mínimo e
   máximo, transição proibida, duas ações concorrentes no mesmo registro.
4. Rode os testes locais se a ferramenta permitir. Se não permitir, peça ao
   usuário para rodar e contar o resultado.

Regras:

- Não implemente o que não está no FSD. Apareceu necessidade nova? Pare, avise e
  pergunte se entra no escopo. Escopo cresce em silêncio quando ninguém pergunta.
- Achou bug no caminho? Registre em `docs/BUGS.md` **antes** de continuar, mesmo
  que vá corrigir logo em seguida.
- Corrigiu bug? O teste que o reproduziria entra no mesmo commit. Sem teste, ele
  volta.
- Teste que nunca falhou não prova nada. Se passou de primeira, desconfie: ou o
  comportamento já existia, ou o teste não testa o que você acha que testa.
  **Exceção: modo refatoração, abaixo** - lá o teste passar de primeira é o
  objetivo, não o defeito.
- Atalho consciente vira commit explícito, não dívida silenciosa.
- `.gitignore` impede commitar segredo, não impede o agente de **ler** o
  `.env` enquanto trabalha. Se a ferramenta que codifica com você tiver
  controle de acesso a arquivo, restrinja ao projeto e mascare segredos.

## Modo refatoração - código que já existe

Veio do Passo 2b. A ordem inverte, porque aqui o comportamento já está de pé e
o risco não é errar o novo: é mudar o antigo sem perceber.

1. **Fixe o comportamento atual num teste que passa de primeira.** Ele não prova
   que o código está certo - prova que você sabe o que ele faz hoje. É a rede
   antes de mexer. Se não passar de primeira, você entendeu errado: descubra o
   que ele realmente faz antes de tocar em qualquer linha.
2. Está errado e a rede o fixou? Registre em `docs/BUGS.md`. Corrigir vem
   depois de refatorar, em commit próprio - as duas coisas juntas escondem
   qual delas quebrou.
3. **Refatore sem mudar comportamento.** A rede tem que seguir verde o tempo
   todo. Ficou vermelha, você mudou o que não queria.
4. Só então acrescente o teste de negação que faltava, e o comportamento novo
   pela ordem normal deste passo.

Separe em commits diferentes: fixar a rede, refatorar, corrigir. Um commit que
faz os três não dá para reverter em parte.

**Segurança e LGPD valem sempre** - algo em risco além do que já foi checado?
Avise na hora.

## Portão de saída

- [ ] Todo critério de aceite do item tem teste correspondente
- [ ] Os testes passam, e o usuário confirmou o resultado
- [ ] Os casos de borda do FSD estão cobertos
- [ ] Nada foi implementado fora do FSD
- [ ] Bug encontrado no caminho está registrado em `docs/BUGS.md`
- [ ] Nenhum segredo entrou no código
- [ ] Em modo refatoração: a rede ficou verde antes de mexer e seguiu verde depois
- [ ] Os não-negociáveis do `PADROES.md` estão respeitados

## Commit

Comandos sugeridos:

```bash
git status
git add <arquivos-da-funcionalidade> <arquivos-de-teste> docs/BUGS.md
git diff --staged
git commit -m "feat(<escopo>): <o que passou a funcionar>"
```

## Fechamento

Depois do commit, confira a ordem de implementação do FSD.

Se ainda houver item pendente, volte ao começo deste passo para o próximo item.

Se não houver item pendente:

1. Rode a suíte de testes final, se a ferramenta permitir.
2. Atualize `docs/CONTINUAR.md` registrando que o FSD foi concluído.
3. Liste o que foi entregue, o que ficou fora de escopo e os riscos ainda
   conhecidos.
4. Pare e entregue um resumo final ao usuário.
