# Padrões - não-negociáveis

Princípios, não receita de linguagem. Traduza para as tecnologias escolhidas no
Passo 4. O grosso serve ao gerar código; a seção **Commits** vale desde o Passo 2.

## Segredos

- Segredo vive em variável de ambiente. Nunca em código, nunca versionado.
- Arquivo de ambiente fora do versionamento; um exemplo sem valores fica dentro.
- Segredo de publicação mora no cofre de segredos do provedor.

## Dados

- Exclusão é lógica, não física. O registro sai de vista, não do banco.
- Toda operação que altera dado deixa rastro: quem, o quê, quando, de onde.
- Dado pessoal cifrado em repouso; busca por hash, nunca decifrando em laço.
- Identificador exposto ao público não é o sequencial da tabela.

## Acesso

- Toda entrada que altera dado verifica sessão, identidade ou permissão antes de qualquer coisa.
- Permissão é verificada no ambiente que executa a regra. Esconder botão, comando ou opção não é controle de acesso.
- Tentativa de autenticação tem limite por janela de tempo.
- Senha guardada só como hash de senha, nunca cifrada e nunca em texto.

## Entrada e saída

- Toda entrada de usuário vai parametrizada na consulta, nunca concatenada.
- Toda saída é escapada conforme o contexto onde entra.
- Upload: validar o conteúdo real, não a extensão. Renomear ao gravar.
- Lista explícita de campos aceitos. O que não está na lista não entra.

## Testes

- Teste usa armazenamento controlado ou substituto seguro, sem depender do ambiente pessoal do desenvolvedor.
- Testar regra de negócio, validação e caso de erro. Não testar só camada visual ou saída renderizada que não tem decisão.
- Nome de teste descreve o cenário e o resultado esperado.

## Código

- Nome revela intenção. Comentário que explica "o quê" vira nome melhor.
- Função que **decide** devolve a decisão. Função que **age** consome uma
  decisão já tomada. Misturar as duas torna a decisão impossível de testar
  sem executar o efeito.

## Commits

`tipo(escopo): descrição curta no imperativo`

`feat` funcionalidade · `fix` correção · `docs` documentação
`chore` limpeza, refactor · `test` testes · `style` formatação

- Um commit por passo aprovado. Commit pequeno é fácil de reverter.
- `main` só recebe o que foi testado.
- Atalho consciente vira commit explícito, não dívida silenciosa.

