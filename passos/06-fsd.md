# Passo 6 - Criar o FSD

## Objetivo
Escrever a especificação que dá para executar sem precisar perguntar mais nada.

## Entra
- `docs/PRD.md`, `docs/DECISOES_TECNICAS.md`
- `docs/DESIGN.md`, quando houver interface visual

## Sai
- `docs/FSD.md`

## Perguntas obrigatórias

O FSD sai dos três artefatos, não de perguntas novas. Só pergunte o que eles
deixaram em aberto:

1. Alguma regra do PRD ficou sem definição de comportamento em caso de erro?
2. Existe integração com sistema de terceiro? Quem responde quando ela cai?
3. Que dado precisa existir antes do primeiro uso real?
4. Alguma parte precisa ficar pronta antes das outras por motivo de negócio?

## Instrução

Preencha `templates/FSD.md`. Em modo agente, crie ou atualize `docs/FSD.md`.
Em modo assistido, apresente o conteúdo para o usuário salvar. Não escreva o
código da funcionalidade neste passo.

Ao fechar o passo, atualize `docs/CONTINUAR.md` com o Passo 6 concluído, o
Passo 7 como próximo passo recomendado e a primeira leitura obrigatória da
próxima sessão.

O FSD tem seis partes:

1. **Inventário** - cada arquivo a criar ou alterar, com a responsabilidade dele
   em uma linha e a camada a que pertence (ver D2). Se não cabe em uma linha,
   o arquivo faz coisa demais.
2. **Estrutura de dados** - entidades, campos, tipos, relações e restrições.
   Marque quais campos são dado pessoal e como ficam protegidos.
3. **Contratos** - para cada operação: o que entra, o que sai, o que pode dar
   errado e o que o sistema responde em cada erro.
4. **Interface e estados**, quando houver - cada tela, comando, endpoint ou
   interação com seus estados, incluindo vazio, carregando/processando e erro.
   Estado de erro sem resposta definida é estado não especificado.
5. **Plano de testes** - o que testar, com os casos de borda nomeados: valor
   ausente, coleção vazia, limite mínimo e máximo, transição proibida, duas
   ações concorrentes no mesmo registro, acesso pelo papel errado.
6. **Ordem de implementação** - o que vem antes do quê, e por quê.

Rastreabilidade é o que faz este passo valer: toda `RN` do PRD tem que aparecer
em pelo menos um item do FSD, e dá para apontar onde. Se uma regra não achou
lugar, ou o FSD está incompleto ou a regra não era necessária - pergunte.

Não invente requisito. Se algo parecer necessário mas não estiver no PRD, avise
e pergunte se entra. Escopo cresce em silêncio quando ninguém pergunta.

Consulte `PADROES.md` ao definir estrutura de dados e contratos. Tela de
relatório, dado pessoal ou plano de testes? `skills/README.md` aponta a
skill certa.

**Segurança e LGPD valem sempre** - segredo exposto ou dado pessoal em risco?
Avise na hora, mesmo fora do assunto deste passo.

## Portão de saída

- [ ] Cada arquivo do inventário tem responsabilidade em uma linha
- [ ] Toda `RN` do PRD aparece em pelo menos um item do FSD
- [ ] Todo campo de dado pessoal está marcado, com a proteção declarada
- [ ] Toda operação declara os erros possíveis e a resposta de cada um
- [ ] Toda tela que carrega dado tem estados de vazio, carregando e erro
- [ ] O plano de testes nomeia casos de borda, não só o caminho feliz
- [ ] Toda operação que lê ou altera recurso tem teste de acesso negado pelo
      papel errado
- [ ] A ordem de implementação não tem dependência circular
- [ ] `docs/CONTINUAR.md` aponta o Passo 7 como próxima ação

## Commit

Comandos sugeridos:

```bash
git status
git add docs/FSD.md docs/CONTINUAR.md
git diff --staged
git commit -m "docs(prep): adiciona FSD"
```
