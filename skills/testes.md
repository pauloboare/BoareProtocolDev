# Skill: Testes

Quando usar: plano de testes no Passo 6, item do Passo 9, bug, refatoração, segurança, regra de negócio ou preparação da primeira versão.

## Contrato da skill

Ao sair desta skill, a IA deve dizer o que será provado, em qual camada, com qual teste, e qual falha esperada existiria antes da correção.

## Padrão mínimo

- Código relevante precisa de teste proporcional ao risco.
- Correção de bug precisa de teste que falha antes.
- Regra de negócio crítica precisa de teste positivo e negativo.
- Autorização precisa de teste negativo.
- Refatoração precisa preservar testes antes e depois.
- Teste deve falhar por um motivo compreensível.

## Recomendação inicial

Usar ciclo curto inspirado em TDD quando houver comportamento novo ou bug:

1. Vermelho: escrever ou identificar teste que falha pelo motivo certo.
2. Verde: fazer o mínimo para passar.
3. Refatorar: limpar sem mudar comportamento.
4. Verificar: rodar teste relevante e, se possível, validação geral.

Escolher a camada mais barata que prova o comportamento:

| Responsabilidade | Tipo preferido | Infraestrutura |
|---|---|---|
| Regra e Validador | unidade | nenhuma |
| Entidade | unidade | nenhuma |
| Repositório | integração | banco controlado ou em memória |
| Serviço | integração leve | dependências substituídas |
| Tela/API | funcional | só fluxo crítico |

## Alternativas aceitas

- Teste manual documentado: aceitável na primeira versão quando automação é cara demais, mas deve virar pendência clara.
- Snapshot: aceitável para saída estrutural estável, não para esconder lógica.
- Teste end-to-end: aceitar para caminho crítico, não para cobrir toda regra.
- Teste de integração em vez de unidade: aceitável quando a regra depende de contrato real com banco, fila ou API.
- Sem teste novo: aceitável apenas para mudança de texto, documentação, estilo sem comportamento ou código já coberto.

## Como decidir

Pergunte:

1. Que comportamento quebraria se essa mudança fosse removida?
2. Qual é a forma mais barata de provar isso?
3. Existe caminho negado que precisa ser protegido?
4. O teste falharia antes da implementação?
5. A falha apontaria o defeito ou só diria que "algo quebrou"?
6. O custo do teste indica problema de arquitetura?

## Casos que não podem faltar

- Valor zero.
- Valor falso.
- Campo ausente.
- Campo vazio.
- Valor fora do limite.
- Usuário sem permissão.
- Registro de outra unidade ou dono.
- Concorrência quando há saldo, unicidade ou intervalo.
- Dependência indisponível quando o fluxo precisa se recuperar.

## Prática recomendada

Separar teste puro de regra, teste de guarda de autorização e teste de integração com banco controlado. Para fluxos sensíveis, simular tempo ou sessão por dependência controlada, não por espera real.

## Gates

- Plano do Passo 6 lista testes por risco.
- Item do Passo 9 informa teste executado.
- Bug fechado tem teste de regressão.
- Implementação nova tem pelo menos um teste que prova o comportamento principal, salvo exceção registrada.
- Falha de teste é específica o bastante para orientar correção.
