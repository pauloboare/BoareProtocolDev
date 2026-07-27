# Skill: Depuração

Quando usar: bug, teste falhando, erro intermitente, comportamento diferente entre ambientes, regressão ou terceira tentativa de correção sem sucesso.

## Contrato da skill

Ao sair desta skill, a IA deve entregar causa provável, evidência, correção mínima e teste de regressão ou verificação equivalente.

## Padrão mínimo

- Não corrigir antes de reproduzir ou entender a falha.
- Não aplicar patch aleatório em sequência.
- Não esconder erro removendo validação, log ou teste.
- Bug fechado precisa de causa e prova de que não volta.
- Após três tentativas falhas, parar e revisar arquitetura, premissas e dados de entrada.

## Recomendação inicial

Usar fluxo disciplinado:

1. Reproduzir: identificar comando, tela, entrada, usuário, ambiente ou teste que mostra a falha.
2. Observar: ler erro, log, diff recente e caminho executado.
3. Isolar: reduzir para menor caso que ainda falha.
4. Formular hipótese: explicar por que falha antes de editar.
5. Testar hipótese: mudar só o necessário ou criar teste que confirma.
6. Corrigir: aplicar menor alteração coerente.
7. Proteger: adicionar teste de regressão ou checklist verificável.

## Alternativas aceitas

- Correção direta sem teste novo: aceitável para typo, texto, documentação ou configuração claramente isolada.
- Inspeção estática sem reproduzir: aceitável quando ambiente externo não existe, mas a evidência precisa ser forte.
- Rollback temporário: aceitável quando o ambiente de uso está em risco, com bug registrado para correção real.
- Log adicional primeiro: aceitável quando bug é intermitente e não há evidência suficiente.
- Revisão arquitetural antes da correção: necessária quando a falha mostra acoplamento, concorrência ou regra sem dono.

## Como decidir

Pergunte:

1. A falha é determinística ou intermitente?
2. Começou após qual mudança?
3. O erro está no dado, na regra, na integração, na sessão ou na infraestrutura?
4. Existe teste que deveria ter pego isso?
5. A correção mínima resolve a causa ou só o sintoma?
6. Já houve duas ou mais tentativas parecidas?

## Sinais de problema

- Patch adiciona condição especial sem explicar a causa.
- Teste é alterado para aceitar comportamento errado.
- Erro some localmente, mas sem comando ou evidência.
- Bug de autorização corrigido só na interface, não no ponto que executa a regra.
- Falha concorrente tratada só com `if` em código.
- Terceira tentativa muda outra parte sem revisar premissa.

## Gates

- Causa provável registrada.
- Evidência da falha antes da correção.
- Correção mínima aplicada.
- Teste de regressão ou verificação manual documentada.
- Se houve três tentativas falhas, revisão de arquitetura registrada antes de novo patch.
