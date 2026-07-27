# Skill: Código limpo

Quando usar: antes de aprovar item do Passo 9, em refatoração, revisão de legibilidade ou quando a alteração ficou maior do que o necessário.

## Contrato da skill

Ao sair desta skill, a IA deve apontar poucas melhorias de alto impacto, não uma lista estética. Cada recomendação precisa dizer onde está o problema, qual risco cria e qual corte resolve.

## Padrão mínimo

- Código precisa revelar intenção pelo nome e pelo corte das funções.
- Regra de negócio não deve ficar escondida em detalhe de framework.
- Erro precisa ser tratável e compreensível.
- Remover duplicação real, mas não criar abstração prematura.
- Não alterar comportamento durante refatoração sem teste cobrindo antes e depois.

## Recomendação inicial

Usar funções pequenas com guard clauses e nomes que descrevem domínio. Preferir objeto ou estrutura de parâmetros quando a função passa de três ou quatro argumentos relacionados.

Ordem de limpeza:

1. Separar regra de efeito.
2. Cortar função longa em passos nomeados.
3. Remover duplicação de regra.
4. Simplificar condição difícil de ler.
5. Apagar código morto com segurança.

## Alternativas aceitas

- Função maior: aceitável quando o fluxo é linear, coeso e mais claro junto do que quebrado artificialmente.
- Duplicação temporária: aceitável quando dois casos ainda parecem parecidos, mas devem evoluir de forma diferente.
- Comentário explicativo: aceitável para regra de negócio, decisão externa ou workaround documentado. Não usar para explicar código confuso que pode ser renomeado.
- Abstração genérica: aceitável só quando há três usos reais ou uma variação prevista e documentada.

## Como decidir

Pergunte:

1. Quem ler o arquivo entende o fluxo em menos de alguns minutos?
2. O nome da função diz o que ela entrega, não como faz?
3. O teste quebra se a regra principal for removida?
4. A abstração reduz mudança futura ou só economiza linhas agora?
5. Um bug nessa função seria fácil de localizar?

## Sinais de problema

- `if` dentro de `if` dentro de laço.
- Função que valida, salva, envia email e renderiza resposta.
- Parâmetro booleano que muda completamente o comportamento.
- Código defensivo sem teste para o caso defendido.
- Comentário compensando nome ruim.
- Módulo "utils" crescendo com regra de negócio sem dono.

## Gates

- O item fecha com testes passando.
- Refatoração não muda comportamento sem teste novo.
- Nenhuma função nova mistura decisão crítica com efeito colateral desnecessário.
- Os 2 ou 3 problemas de maior impacto foram priorizados.
