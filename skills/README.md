# Skills: consulta sob demanda

`PADROES.md` define o mínimo que vale sempre. As skills entram quando há uma decisão técnica específica e a IA precisa agir como especialista naquele assunto.

## Como usar

Leia só a skill necessária para o passo atual. A regra é economizar contexto, não carregar manual inteiro.

Toda skill segue a mesma estrutura:

- `Padrão mínimo`: o que não deve ser violado sem registrar risco.
- `Recomendação inicial`: o caminho que costuma funcionar melhor para a primeira versão.
- `Alternativas aceitas`: opções válidas quando o contexto pede outra decisão.
- `Como decidir`: perguntas que separam preferência pessoal de necessidade real.
- `Gates`: critérios objetivos para fechar a decisão ou implementação.

## Índice

| Skill | Quando usar |
|---|---|
| `arquitetura.md` | D2 no Passo 4; corte de módulos; revisão de responsabilidade no Passo 9 |
| `banco-de-dados.md` | D3 no Passo 4; modelagem; migração; consulta lenta; revisão de schema |
| `seguranca.md` | D4 no Passo 4; autenticação; autorização; entrada de usuário; deploy exposto |
| `testes.md` | plano de testes no Passo 6; TDD no Passo 9; bug; refatoração |
| `design-ui.md` | Passo 5 ou 1b; telas do FSD; fluxo confuso; acessibilidade |
| `lgpd.md` | D7 no Passo 4; dado pessoal; consentimento; exportação; retenção |
| `relatorios.md` | relatório, painel, exportação, indicador ou auditoria |
| `codigo-limpo.md` | revisão final do Passo 9; refatoração; função grande; duplicação |
| `contexto-tecnico.md` | escolha de biblioteca, API, framework, versão ou integração externa |
| `depuracao.md` | bug, falha de teste, comportamento intermitente ou terceira tentativa de correção |

## Práticas incorporadas

- Contexto atualizado e sob demanda: antes de escolher biblioteca, API ou padrão dependente de versão, buscar documentação oficial atual ou pedir as tecnologias escolhidas. Não usar memória antiga para APIs modernas.
- Processo disciplinado: para tarefa relevante, primeiro entender, depois decidir, depois implementar, depois validar. Mudança de produção sem gate objetivo não fecha ciclo.
- Segurança no fluxo: tratar vulnerabilidade como item acionável, com impacto, severidade, correção mínima e validação. Scanner ajuda, mas não substitui revisão técnica.
- Agnosticismo: nenhuma skill presume modelo, IDE, framework ou linguagem. Se citar uma ferramenta, deve ser exemplo substituível.
- Exemplos permitidos: uma skill pode citar tecnologia para ilustrar, mas deve marcar como exemplo e explicar o critério de escolha.

## No Passo 9

Para cada item:

1. Identifique a skill dominante.
2. Leia a skill.
3. Aplique o padrão mínimo.
4. Use a recomendação inicial como default.
5. Se o usuário escolher alternativa, avalie pelos critérios da própria skill.
6. Feche apenas quando os gates estiverem atendidos.
