# Skill: Segurança

Quando usar: D4 no Passo 4, autenticação, autorização, entrada de usuário, upload, sessão, API, deploy, dependência vulnerável ou revisão antes de publicar.

## Contrato da skill

Ao sair desta skill, a IA deve classificar riscos por explorabilidade, impacto, correção mínima e validação. Segurança não fecha com "parece ok".

## Padrão mínimo

- Entrada de usuário nunca entra crua em consulta, comando, marcação, script, template ou caminho de arquivo.
- Autorização verifica o recurso específico, não só login ou perfil.
- Sessão ou token expira, é renovado com segurança e não fica acessível onde não precisa.
- Ação que altera dado tem proteção contra requisição forjada quando aplicável.
- Upload valida conteúdo real, tamanho, extensão permitida e destino.
- Produção não expõe debug, `.env`, backup, dump, diretório interno ou rastreamento de erro.
- Dependência vulnerável deve ter decisão registrada: corrigir, mitigar ou aceitar risco.

## Recomendação inicial

Aplicar segurança cedo no fluxo: encontrar o risco no ponto onde ele nasce, explicar impacto e corrigir perto da origem.

Ordem de revisão:

1. Entrada e saída.
2. Autenticação e sessão.
3. Autorização por recurso.
4. Configuração do ambiente de uso.
5. Upload e arquivos.
6. Dependências e licenças.
7. Logs e dados pessoais.

Para cada achado, escrever: local, ataque possível, severidade, correção mínima, teste ou verificação.

## Exemplos, não prescrições

Use exemplos técnicos quando ajudarem a reconhecer a classe do risco:

- Consulta parametrizada: em SQL, preparar parâmetros em vez de concatenar texto.
- Saída escapada: em HTML, escapar conforme texto, atributo, URL ou script.
- Requisição forjada: em aplicação com cookie automático, CSRF é um exemplo comum.
- Token assinado: JWT é um exemplo, não a única opção.

Esses exemplos não definem stack. Se o projeto usa outra tecnologia, traduza o risco para o mecanismo equivalente.

## Alternativas aceitas

- Autenticação simples por sessão: aceitável quando o sistema controla o cliente e a expiração está correta.
- Token assinado: aceitável para cliente desacoplado, mas exige expiração, rotação e armazenamento seguro.
- Perfis simples: aceitável com poucos papéis bem definidos.
- Permissão por política ou atributo: necessária quando o acesso depende de unidade, dono, status ou contexto.
- Scanner externo: recomendado quando disponível, mas não substitui revisão manual das regras de negócio.

## Como decidir

Pergunte:

1. O atacante precisa estar logado?
2. Ele precisa ter perfil alto ou basta usuário comum?
3. O ataque lê dado, altera dado, derruba serviço ou escala permissão?
4. A falha depende de configuração do ambiente de uso?
5. Existe teste automatizado que impede regressão?
6. Dependência vulnerável está no caminho executado ou só no desenvolvimento?

## Checklist técnico

- Consultas e comandos parametrizados.
- Saída escapada conforme o contexto onde será renderizada.
- Proteção contra requisição forjada quando a credencial é enviada automaticamente pelo cliente.
- Rate limit em login e endpoints sensíveis.
- Mensagem de erro genérica para usuário, log detalhado interno.
- Headers de segurança conforme a tecnologia e o ambiente de execução.
- Lista permitida para redirecionamento.
- Lista permitida para campos de formulário.
- Secrets fora do repositório.
- Backup e dump fora da pasta pública.

## Gates

- D4 registra autenticação, autorização e sessão.
- Item com entrada de usuário tem validação e escape.
- Item que lê ou altera recurso tem teste negativo de autorização.
- Produção tem checklist mínimo de exposição.
- Vulnerabilidade conhecida tem decisão e validação.
