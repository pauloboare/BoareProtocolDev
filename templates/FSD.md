# FSD - <nome do sistema>

Base: `docs/PRD.md`, `docs/DECISOES_TECNICAS.md` e, quando houver interface
visual, `docs/DESIGN.md`.

## 1. Inventário

| Arquivo | Novo ou alterado | Responsabilidade (uma linha) |
|---|---|---|
|  |  |  |

Não coube em uma linha? O arquivo faz coisa demais. Divida.

## 2. Estrutura de dados

| Entidade | Campo | Tipo | Obrigatório | Dado pessoal | Proteção |
|---|---|---|---|---|---|
|  |  |  |  | sim / não |  |

Relações e restrições: <A pertence a B; combinação X+Y é única>

## 3. Contratos

Uma seção por operação, neste formato:

### <nome da operação>

- **Entra:** <campos, tipos, obrigatoriedade>
- **Sai:** <estrutura de retorno>
- **Permissão exigida:** <papel>
- **Erros:** <situação → resposta ao usuário, um por linha>

## 4. Interface e estados

| Interface | Vazio | Carregando/processando | Erro | Ações disponíveis |
|---|---|---|---|---|
|  |  |  |  |  |

## 5. Plano de testes

| # | Cenário | Regra coberta | Resultado esperado |
|---|---|---|---|
| T01 |  | RN01 / CA01 |  |

Casos de borda obrigatórios: valor ausente · coleção vazia · limite mínimo e
máximo · transição proibida · duas ações concorrentes no mesmo registro · acesso
pelo papel errado.

Autorização é caso de borda, não caminho feliz: testar só quem pode não prova
nada sobre quem não pode.

## 6. Ordem de implementação

| Ordem | O quê | Depende de |
|---|---|---|
| 1 |  | - |

Sem dependência circular.

## Rastreabilidade

| RN do PRD | Onde aparece neste FSD |
|---|---|
| RN01 |  |

Toda regra do PRD tem que ter uma linha aqui.

