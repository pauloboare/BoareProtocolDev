# Skill: Design de interface

Quando usar: Passo 5, Passo 1b, definição de tela no FSD, revisão de fluxo, acessibilidade ou experiência em tablet/celular.

## Contrato da skill

Ao sair desta skill, a IA deve definir o fluxo da tela, estados principais, acessibilidade mínima, hierarquia visual e critérios para validar se o usuário consegue concluir a tarefa.

## Padrão mínimo

- Todo campo tem rótulo.
- Toda ação destrutiva pede confirmação ou oferece desfazer.
- Todo fluxo tem estado de carregando, erro, vazio e sucesso.
- Erro de formulário fica perto do campo afetado.
- Teclado e leitor de tela não podem ficar bloqueados.
- Contraste e tamanho de alvo precisam funcionar no dispositivo real.

## Recomendação inicial

Começar pelo contexto de uso, não pela aparência:

- administrativo intenso: tabela densa, filtros, ordenação, ação em lote, atalhos;
- público ocasional: linguagem simples, poucos campos, progresso claro, ajuda contextual;
- operação em pé ou tablet: botões grandes, fluxo linear, texto maior, baixa dependência de menu;
- dashboard: poucos indicadores acionáveis, cada número com pergunta de negócio associada.

Para a primeira versão, priorizar clareza e erro recuperável antes de refinamento visual.

## Alternativas aceitas

- Interface simples sem design system completo: aceitável em projeto pequeno, se os componentes básicos forem consistentes.
- Design system formal: aceitável quando há muitas telas, múltiplos times ou necessidade de consistência institucional.
- Tabela densa: aceitável para usuário treinado que opera volume.
- Wizard passo a passo: aceitável para usuário ocasional ou tarefa rara com risco alto.
- Mobile first: aceitar quando uso principal for celular, não por moda.

## Como decidir

Pergunte:

1. O usuário faz isso todo dia ou raramente?
2. Ele está sentado, em campo, em balcão ou em tablet?
3. O erro custa pouco, custa retrabalho ou expõe dado?
4. A tela serve para executar ação ou entender indicador?
5. Qual é o próximo passo depois do sucesso?
6. O usuário consegue recuperar uma falha sem suporte técnico?

## Sinais de problema

- Um diálogo abre outro diálogo.
- Sucesso sem dizer o que aconteceu.
- Tela vazia sem orientação.
- Botão principal compete com três ações secundárias.
- Ícone sem texto em ação crítica.
- Filtro aplicado sem mostrar que está filtrado.
- Campo obrigatório descoberto só depois do envio.

## Gates

- FSD lista estados da tela.
- Fluxo principal cabe em uma sequência clara.
- Acessibilidade mínima foi verificada.
- Erros importantes têm mensagem e recuperação.
- A interface escolhida combina com o contexto real de uso.
