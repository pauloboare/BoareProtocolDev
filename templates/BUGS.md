# Bugs - <nome do sistema>

Página viva. Nasce no Passo 2 e acompanha o projeto até o fim.
Leia antes de codificar. Escreva assim que encontrar.

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

| # | O que era | Causa raiz | Corrigido em | Teste que cobre |
|---|---|---|---|---|
|  |  |  | <commit> |  |

## Regras

- Bug entra aqui na hora em que é encontrado, mesmo que o conserto venha logo
  em seguida. Bug não registrado é bug esquecido.
- Todo bug fechado ganha um teste que o reproduziria. Sem teste, ele volta.
- Bug que expõe dado pessoal é incidente: registre a data, o que ficou exposto
  e por quanto tempo. Isso é exigência legal, não zelo.
- Bug conhecido e não corrigido vira restrição declarada no `FSD.md`.

