# Skill: Relatórios e indicadores

Quando usar: FSD com painel, relatório, indicador, exportação, auditoria, gráfico ou consulta analítica.

## Contrato da skill

Ao sair desta skill, a IA deve transformar pergunta de negócio em indicadores, fonte de dados, filtros, permissões, forma de cálculo e validação.

## Padrão mínimo

- Todo indicador responde a uma pergunta.
- Todo número tem fonte e fórmula.
- Relatório individual exige permissão específica.
- Exportação obedece às mesmas regras de autorização da tela.
- Dado agregado deve ser preferido quando for suficiente.
- Cálculo caro precisa de estratégia de performance.

## Recomendação inicial

Separar relatórios por finalidade:

- operacional: o que precisa de ação agora;
- gerencial: tendência e comparação;
- analítico: padrão, sazonalidade, correlação;
- auditoria: quem fez o quê, quando e em qual registro.

Para a primeira versão, priorizar poucos indicadores confiáveis. Melhor um painel simples com fórmula correta do que dez gráficos que não mudam decisão.

Se o relatório expande, agrupa, traduz ou corrige evento histórico, documente a regra. Dado bruto sem contexto pode produzir número errado com aparência de precisão.

## Alternativas aceitas

- Calcular em tempo real: aceitável com baixo volume e índices adequados.
- Pré-calcular resumo: aceitável quando histórico é grande ou abertura precisa ser rápida.
- Exportar CSV simples: aceitável para operação interna, desde que autorização e LGPD estejam resolvidas.
- BI externo: aceitável quando o time já usa ferramenta e há governança de acesso.
- Métrica aproximada: aceitável para tendência, nunca para cobrança, pagamento ou auditoria.

## Como decidir

Pergunte:

1. Que decisão será tomada com este número?
2. A pergunta é operacional, gerencial, analítica ou auditoria?
3. O usuário precisa de dado individual ou agregado basta?
4. Qual filtro é obrigatório?
5. Qual período máximo será consultado?
6. A fórmula depende de regra de negócio histórica?
7. O relatório precisa ser reproduzível no futuro?

## Sinais de problema

- Gráfico bonito sem ação associada.
- Fórmula não documentada.
- Total calculado diferente entre tela e exportação.
- Relatório trazendo dado individual para perfil gerencial sem necessidade.
- Consulta varrendo tabela inteira em horário de uso.
- Indicador sem período, unidade ou escopo.

## Gates

- Cada indicador tem pergunta, fórmula e fonte.
- Permissão de acesso está definida.
- Performance foi pensada para o maior período esperado.
- Exportação foi avaliada por LGPD.
- Regras históricas de cálculo foram registradas.
