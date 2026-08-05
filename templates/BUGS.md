# Bugs - <nome do sistema>

Página viva. Nasce no Passo 2 e acompanha o projeto até o fim.
Escreva assim que encontrar.

## Como ler este arquivo

Antes de codificar, leia **Abertos** e **Em investigação**. São as seções que
mudam o que você vai escrever.

**Fechados** é consulta, não leitura: procure pelo sintoma, pelo arquivo ou pelo
identificador do bug. Reler o histórico inteiro a cada sessão não muda nenhuma
decisão e cobra contexto por isso todo dia.

## Abertos

| # | O que acontece | Quando acontece | Gravidade | Onde |
|---|---|---|---|---|
| B01 |  |  | alta / média / baixa |  |

Gravidade **alta**: perde dado, expõe dado, ou impede o uso do sistema.
Alta não espera a próxima funcionalidade - para tudo e corrige.

## Em investigação

| # | O que já se sabe | O que falta descobrir |
|---|---|---|
|  |  |  |

## Fechados

Não apague bug fechado. Bug que volta é bug que ninguém entendeu na primeira vez.

Mantenha aqui os **10 mais recentes**. Passou disso, mova os mais antigos para
`docs/historico/BUGS-FECHADOS.md` - um título e esta mesma tabela, com as mesmas
colunas, na mesma ordem, sem reescrever o texto. Sai de vista, não sai do
repositório: é a mesma exclusão lógica do `PADROES.md`.

| # | O que era | Causa raiz | Corrigido em | Teste que cobre |
|---|---|---|---|---|
|  |  |  | <commit> |  |

## Regras

- Bug entra aqui na hora em que é encontrado, mesmo que o conserto venha logo
  em seguida. Bug não registrado é bug esquecido.
- Uma linha por bug, sem narrativa. O detalhe vive na investigação e no commit;
  esta tabela é lida antes de cada sessão de código.
- Todo bug fechado ganha um teste que o reproduziria. Sem teste, ele volta.
- Ao fechar, leve o conteúdo de "Onde" para dentro de "O que era". Linha
  arquivada só serve se a busca achar: sintoma como o usuário descreveu, mais o
  arquivo ou a área. Histórico que ninguém encontra é lixo com data.
- Bug que expõe dado pessoal é incidente: registre a data, o que ficou exposto
  e por quanto tempo. Isso é exigência legal, não zelo.
- Bug conhecido e não corrigido vira restrição declarada no `FSD.md`.

