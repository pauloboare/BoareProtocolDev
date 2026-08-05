---
description: Atualiza a cópia local do Boare Protocol Dev neste projeto
---

Verifique .boare/protocolo/protocolo.json. Se não existir, informe que o protocolo não está instalado neste projeto e pare.

Para conferir a versão disponível sem instalar nada, baixe e execute o bootstrap com a flag de status. Use o primeiro que conseguir acessar, conforme o sistema operacional:

macOS/Linux (bootstrap.sh), com --projeto --status:
1. https://raw.githubusercontent.com/pauloboare/BoareProtocolDev/v1/bootstrap.sh
2. https://cdn.jsdelivr.net/gh/pauloboare/BoareProtocolDev@v1/bootstrap.sh

Windows (bootstrap.ps1), com -Projeto -Status:
1. https://raw.githubusercontent.com/pauloboare/BoareProtocolDev/v1/bootstrap.ps1
2. https://cdn.jsdelivr.net/gh/pauloboare/BoareProtocolDev@v1/bootstrap.ps1

Se a versão instalada já for igual à disponível, informe isso ao usuário e pare sem alterar nada.

Havendo diferença, mostre as duas versões e peça confirmação explícita antes de baixar e executar o instalador de verdade - isso baixa e executa código do GitHub. Confirmado, rode o mesmo bootstrap trocando --status por --ferramenta auto (ou -Status por -Ferramenta auto). Isso atualiza só os adaptadores já detectados neste projeto; não instala ferramenta nova.

Depois de atualizar:
1. Mostre o diff de .boare/protocolo/ e dos adaptadores alterados.
2. docs/CONTINUAR.md ou docs/BUGS.md anteriores às seções novas do protocolo? Acrescente-as a partir de .boare/protocolo/templates/ antes de seguir.
3. Rode a validação do projeto, se existir.
4. Commit próprio, separado de qualquer mudança do sistema: chore(protocolo): atualiza para <versão> (<referência>).

Não avance passo do protocolo nesta operação. Atualização de protocolo não é um passo do fluxo.
