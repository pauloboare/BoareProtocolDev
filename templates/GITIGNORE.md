# .gitignore - base segura

Para o usuário salvar como `.gitignore` na raiz, **antes do primeiro commit**.
Aqui os nomes são concretos de propósito: neutro não protegeria nada.

## Bloco de segurança - vale para qualquer projeto

```gitignore
# Segredos e credenciais
.env
.env.*
!.env.example
*.pem
*.key
*.p12
*.pfx
id_rsa*
credentials*
secrets*

# Dumps e backups de banco
*.sql
*.dump
*.bak
*.sqlite
*.sqlite3
*.db

# Logs - costumam guardar dado pessoal e token
*.log
logs/

# Arquivo enviado por usuário
uploads/
storage/
```

O bloco de dumps é o que mais importa. Alguém exporta uma tabela para investigar
um problema e comita o arquivo sem pensar, com os dados pessoais dentro. É o
vazamento mais comum e o mais fácil de evitar.

## Bloco de higiene

```gitignore
.DS_Store
Thumbs.db
.idea/
.vscode/
*.swp
dist/
build/
tmp/
cache/
```

## Bloco por tecnologia escolhida

Conforme as decisões do Passo 4: pasta de dependências instaladas por
gerenciador, arquivos compilados e cache do executor de testes da linguagem ou
ferramenta escolhida.

## Conferência

Depois de salvar, peça ao usuário para rodar `git status` e confirmar que nada
sensível aparece. Se um segredo já foi commitado antes, o `.gitignore` não
resolve - só rotacionar a credencial resolve.

