# Skill: Banco de dados

Quando usar: D3 no Passo 4, modelagem do FSD, migração, revisão de consulta, multi-tenant, relatório pesado ou bug de persistência.

## Contrato da skill

Ao sair desta skill, a IA deve deixar claro:

- quais dados existem;
- quem é dono do dado;
- chaves, índices e restrições;
- estratégia de migração;
- risco de volume, concorrência e privacidade.

## Padrão mínimo

- Toda tabela com dado de negócio tem chave primária estável.
- Toda chave estrangeira usada em filtro ou junção tem índice.
- Regra de unicidade crítica deve ter restrição no banco ou mecanismo equivalente.
- Campo pessoal sensível não deve aparecer em exportação ou log por acidente.
- Migração deve preservar dados existentes.
- Consulta de lista deve ser pensada para volume, não só para base vazia.

## Recomendação inicial

Para a primeira versão, usar schema simples, explícito e auditável:

- prefixo por domínio quando o projeto tiver módulos;
- `created_at` e `updated_at` onde houver entidade de negócio;
- `deleted_at` ou status para exclusão lógica quando houver histórico ou auditoria;
- UUID quando precisar criar registro offline, sincronizar ou expor identificador fora do banco;
- índice composto para filtros reais, como `(unidade_id, data)` em contexto multi-tenant operacional;
- documentação curta da decisão no D3;
- banco principal como fonte da verdade quando há sincronização, importação ou operação offline;
- escopo explícito por cliente, unidade, organização ou dono quando o sistema isola dados por grupo;
- regra de relatório documentada quando o cálculo não pode ser inferido só pelo schema.

## Alternativas aceitas

- Inteiro incremental: aceitável para uso interno sem exposição direta de ID e sem criação offline.
- UUID em tudo: aceitável quando integrações, sincronização, importação ou privacidade compensam o custo.
- Exclusão física: aceitável para dado temporário, cache ou dado sem obrigação de auditoria.
- Banco documental, chave-valor ou outro modelo não relacional: aceitável quando o acesso é por agregado, o schema muda muito ou a escala pede esse modelo. Exige plano claro para consultas e consistência.
- Agregação pré-calculada: aceitável quando relatório cruza histórico grande ou precisa abrir rápido.

## Exemplos, não prescrições

- SQL é exemplo de consulta relacional que precisa de parâmetro, índice e plano de acesso.
- NoSQL é rótulo amplo: pode significar documento, chave-valor, grafo ou coluna larga. Não escolha pelo nome, escolha pelo padrão de acesso.
- UUID é exemplo de identificador opaco útil para sincronização, importação ou exposição externa. Não é obrigatório em toda tabela.

Esses exemplos servem para explicar critério. A decisão real continua sendo D3, com alternativas e custo de troca.

## Como decidir

Pergunte:

1. O dado é transacional, documental, analítico ou temporário?
2. Quem pode ver cada registro?
3. O registro precisa sobreviver a auditoria ou pode ser apagado?
4. Qual consulta será feita todo dia?
5. Qual consulta será feita em relatório pesado?
6. Há risco de duas ações simultâneas violarem a mesma regra?
7. O dado será criado offline ou importado de fonte externa?

## Armadilhas

- Consulta dentro de laço.
- Buscar todas as colunas quando só três são usadas.
- Ordenar por coluna sem índice em tabela grande.
- Filtro por `LIKE '%texto%'` esperando índice comum.
- Coluna booleana indexada sozinha em tabela pequena.
- Constraint ausente para regra que precisa resistir a concorrência.
- Migração que renomeia coluna em um único deploy sem compatibilidade.

## Gates

- D3 registra banco, estratégia de IDs, exclusão e migração.
- Consultas principais têm índice coerente com filtros e ordenação.
- Regras críticas de unicidade ou saldo têm proteção persistente.
- Migração tem plano reversível ou compatível em duas fases quando necessário.
- Dados pessoais têm finalidade, retenção e visibilidade definidas.
