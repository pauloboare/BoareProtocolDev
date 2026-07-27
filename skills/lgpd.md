# Skill: LGPD e privacidade

Quando usar: D7 no Passo 4, dado pessoal no FSD, consentimento, exportação, relatório individual, logs, retenção ou direito do titular.

## Contrato da skill

Ao sair desta skill, a IA deve identificar dado pessoal, finalidade, base legal, retenção, visibilidade, direitos do titular e riscos de exposição.

## Padrão mínimo

- Não coletar dado pessoal sem finalidade explícita.
- Não exibir dado pessoal para perfil que não precisa dele.
- Não registrar dado sensível em log, erro, analytics ou URL.
- Consentimento precisa ser demonstrável e revogável quando for a base legal.
- Exportação precisa respeitar a mesma autorização da tela.
- Exclusão, anonimização ou retenção devem ser decididas antes da implementação.

## Recomendação inicial

Para a primeira versão, usar minimização:

- coletar só o necessário para a funcionalidade;
- preferir identificador interno opaco fora do banco;
- agregar relatórios sempre que a pergunta permitir;
- registrar acesso a dado individual sensível;
- documentar no D7 uma tabela simples: dado, finalidade, base legal, retenção, quem vê.

## Alternativas aceitas

- Manter dado identificável por obrigação legal: aceitável quando houver prazo e finalidade definidos.
- Anonimizar em vez de apagar: aceitável quando histórico estatístico ou auditoria precisa permanecer.
- Pseudonimizar: aceitável quando operação precisa relacionar registros sem expor identidade diretamente.
- Consentimento granular: necessário quando finalidades independentes usam o mesmo titular.
- Controle manual inicial: aceitável na primeira versão se houver processo claro, registro e responsável.

## Como decidir

Pergunte:

1. Este dado identifica alguém diretamente ou combinado com outro dado?
2. Qual funcionalidade quebra se o dado não for coletado?
3. Quem precisa ver o dado bruto?
4. Por quanto tempo ele precisa existir?
5. O titular consegue acessar, corrigir, portar, revogar ou pedir exclusão?
6. Relatório agregado resolve sem expor registro individual?

## Direitos que viram funcionalidade

- Confirmação e acesso.
- Correção.
- Portabilidade.
- Revogação de consentimento.
- Exclusão ou anonimização quando aplicável.
- Informação sobre compartilhamento.

## Sinais de problema

- ID sequencial exposto em URL, comando, exportação, integração ou entrada pública.
- CSV com dados pessoais sem controle de acesso.
- Log contendo CPF, telefone, email, token ou payload completo.
- Campo "observação" livre aceitando dado sensível sem orientação.
- Relatório individual disponível para perfil amplo.

## Gates

- D7 preenchido para cada dado pessoal relevante.
- FSD descreve como direitos do titular serão tratados.
- Logs e exportações foram revisados.
- Acesso a dado individual tem regra de autorização.
- Retenção ou anonimização está definida.
