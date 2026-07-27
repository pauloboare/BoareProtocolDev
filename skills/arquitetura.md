# Skill: Arquitetura

Quando usar: D2 no Passo 4, adoção de sistema existente, corte de módulo, refatoração relevante ou revisão de responsabilidade no Passo 9.

## Contrato da skill

Ao sair desta skill, a IA deve entregar:

- arquitetura escolhida;
- motivo da escolha;
- alternativas rejeitadas;
- limites entre camadas ou módulos;
- impacto em testes;
- riscos aceitos.

## Padrão mínimo

- Separar decisão de efeito. Função que decide retorna uma decisão. Função que age grava, envia, redireciona ou responde.
- Regra de negócio crítica precisa ser testável sem interface.
- Persistência não deve esconder decisão de negócio.
- Interface não deve conter fluxo de negócio inteiro.
- Restrição que depende de concorrência deve existir no armazenamento ou na infraestrutura equivalente, não só em código.
- Toda decisão arquitetural relevante entra no D2.

## Recomendação inicial

Para uma primeira versão de sistema web administrativo, operacional ou SaaS simples, começar por monólito modular por contexto de negócio. Esse padrão costuma entregar rápido sem misturar regra de negócio, persistência e interface.

Use a arquitetura recomendada como ponto de partida, não como dogma:

```text
src/
  <contexto-de-negocio>/
    entidades/
    regras/
    validadores/
    repositorios/
    servicos/
  compartilhado/
    infraestrutura/
    seguranca/
    suporte/
tests/
  <contexto-de-negocio>/
    regras/
    validadores/
    repositorios/
    servicos/
```

Adapte nomes e pastas à linguagem usada. O desenho importante é a separação de responsabilidade, não o nome exato dos diretórios.

Estrutura sugerida por contexto:

| Responsabilidade | Faz | Não faz |
|---|---|---|
| Entidade | mantém estado válido | consulta banco, renderiza tela |
| Regra | calcula e decide com dados já recebidos | grava, busca, redireciona |
| Validador | explica se entrada é aceitável | aplica efeito colateral |
| Repositório | lê e grava | decide regra de negócio |
| Serviço | orquestra caso de uso | vira depósito de toda lógica |

Fluxo esperado:

```text
Interface ou API -> Serviço
Serviço -> Validador
Serviço -> Regra
Serviço -> Repositório
```

O Serviço coordena. A Regra decide. O Repositório persiste. A Interface apresenta. Regra não chama Repositório. Se uma camada começa a fazer o papel da outra, a arquitetura perdeu valor.

Árvore de testes deve espelhar a árvore de código quando isso ajudar a responder rapidamente: "isso está coberto?".

## Alternativas aceitas

- CRUD simples com camada única: aceitável para cadastro trivial, sem regra relevante, sem concorrência e sem evolução prevista. Registre que a escolha é intencional.
- MVC tradicional: aceitável se controllers ficarem finos e regras saírem para objetos testáveis.
- Clean Architecture completa: aceitável quando o domínio é complexo, há múltiplas interfaces ou troca real de infraestrutura.
- Microserviços: aceitar só com necessidade concreta de escala independente, deploy independente ou isolamento organizacional. Não usar para primeira versão pequena.
- Serverless/event-driven: aceitar quando o problema é naturalmente orientado a eventos, filas, automação ou custo variável. Exige rastreabilidade maior.

## Como decidir

Pergunte:

1. O domínio tem regra ou é quase só cadastro?
2. A mesma regra será usada por tela, API, job ou importação?
3. Existe concorrência real no dado?
4. O time consegue manter mais camadas sem perder velocidade?
5. O sistema precisa trocar banco, fila, UI ou provedor em curto prazo?
6. O custo de teste ficou alto porque a arquitetura mistura responsabilidades?

Se o usuário preferir outra arquitetura, avalie por esses critérios. A skill não deve impor o modelo recomendado quando a alternativa preserva teste, clareza e evolução.

## Sinais de violação

- Regra consultando armazenamento.
- Repositório com `if` de regra de negócio.
- Controller, página ou handler com cálculo central do domínio.
- Serviço chamando muitos serviços irmãos sem dono claro do caso de uso.
- Validação duplicada em tela, API e importação.
- Teste de regra precisando subir banco, sessão, navegador ou rede.

## Gates

- D2 registra padrão escolhido e alternativas.
- Pelo menos uma regra crítica é testável sem infraestrutura.
- Operações concorrentes têm proteção no armazenamento ou mecanismo equivalente.
- O item do Passo 9 aponta onde cada responsabilidade ficou.
- Qualquer desvio da recomendação inicial tem justificativa curta e explícita.
