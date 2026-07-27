# Passo 8 - Entrega e execução

## Objetivo
Provar que o caminho até o ambiente de uso funciona, enquanto ainda não há nada
a perder.

## Entra
- `docs/DECISOES_TECNICAS.md` - decisão D5, onde o sistema vai rodar.

## Sai
- Caminho de entrega, execução ou publicação testado com o esqueleto vazio.

## Perguntas obrigatórias

1. Como o código chega ao lugar onde será usado? Exemplos: servidor, pacote,
   loja, binário, contêiner, automação local, biblioteca ou integração.
2. Que credencial ou permissão a entrega exige, e onde ela está guardada?
3. Qual ramo, tag, versão ou artefato dispara a entrega?
4. Existe ambiente de teste, homologação ou execução isolada?
5. Se a entrega quebrar no ambiente de uso, como se volta à versão anterior?

## Instrução

Teste o caminho de entrega com um esqueleto vazio **antes** de escrever o
sistema. Descobrir que o caminho até o uso real não funciona depois de semanas
de código é o pior momento possível. Descobrir hoje custa uma tarde.

Em modo agente, você pode criar ou editar arquivos de configuração dentro do
projeto e rodar validações locais. Para publicar, acionar ambiente externo,
usar credencial ou alterar infraestrutura, peça confirmação explícita. Em modo
assistido, mostre a configuração e espere o usuário aplicar.

Sequência:

1. Escrever a automação ou checklist de entrega para o mecanismo da resposta 1.
2. Cadastrar credenciais no cofre de segredos da ferramenta usada, se houver.
3. Rodar uma vez com um artefato de teste reconhecível.
4. Confirmar no destino de uso que o artefato chegou ou executou.
5. Remover o artefato de teste e rodar de novo.

Regras que vêm de falha real:

- **A automação só pode chamar comando que existe no projeto.** Copiar um modelo
  pronto que invoca uma etapa de teste inexistente faz todos os builds falharem,
  do primeiro ao último. Antes de escrever a etapa, confirme que o comando existe.
- Segredo nunca no repositório. Se aparecer um em texto puro na configuração,
  avise que está comprometido e oriente a gerar outro.
- A entrega dispara só a partir do ramo, tag, versão ou artefato da resposta 3.
- Se a resposta 5 não tiver resposta, pare e resolva antes. Entrega sem volta
  atrás é aposta.

Comece pelo caminho mais simples que entrega ou executa. Etapa de teste e
verificação entram depois, quando existir o que testar.

## Portão de saída

- [ ] O caminho de entrega rodou com sucesso pelo menos uma vez
- [ ] O artefato foi confirmado no destino de uso, não só no log
- [ ] Nenhum segredo aparece no repositório ou no histórico
- [ ] Toda etapa da automação chama comando que existe no projeto
- [ ] A entrega dispara só a partir do ramo, tag, versão ou artefato definido
- [ ] O caminho de volta à versão anterior está escrito e foi testado

## Commit

Comandos sugeridos:

```bash
git status
git add <arquivos-da-entrega>
git diff --staged
git commit -m "chore(entrega): configura caminho de entrega"
```

Fechado este passo, a preparação acabou. Siga para o Passo 9, que repete uma
funcionalidade por vez até o FSD acabar.

