# Skill: Contexto técnico

Quando usar: escolha ou uso de linguagem, biblioteca, API, framework, banco, hospedagem, versão, integração externa, recurso recente ou erro que pode depender de documentação atual.

## Contrato da skill

Ao sair desta skill, a IA deve separar o que sabe do projeto, o que vem de documentação atual e o que ainda é inferência. Código baseado em API moderna não deve depender só de memória do modelo.

## Padrão mínimo

- Não inventar API, método, flag ou configuração.
- Identificar linguagem, framework, biblioteca e versão quando isso afetar a resposta.
- Preferir documentação oficial, código existente, lockfile ou tipos instalados.
- Se a documentação não estiver acessível, pedir fonte ao usuário ou marcar a suposição.
- Não despejar documentação inteira no contexto. Buscar só o trecho necessário.
- Quando citar uma tecnologia só para explicar, marcar como exemplo e oferecer o critério de decisão.
- Exemplo técnico não é recomendação automática. Se o usuário já escolheu outro
  conjunto de tecnologias, traduza o conceito.

## Recomendação inicial

Usar contexto sob demanda:

1. Resolver exatamente qual biblioteca ou produto está em uso.
2. Confirmar versão por arquivo do projeto, lockfile, manifesto ou documentação informada.
3. Buscar documentação oficial ou fonte local equivalente.
4. Extrair só exemplos e regras ligados à tarefa.
5. Citar a fonte usada na decisão técnica quando for relevante.

Esse padrão mantém o protocolo agnóstico: pode ser feito por web, ferramenta integrada, documentação local, código fonte instalado ou informação fornecida pelo usuário.

## Alternativas aceitas

- Usar só o código existente: aceitável quando o projeto já tem padrão claro e a tarefa é repetir esse padrão.
- Usar documentação local vendorizada: aceitável quando o projeto trava versões ou trabalha offline.
- Usar tipos e autocompletar da dependência instalada: aceitável para API bem tipada.
- Usar memória do modelo: aceitável para conceito estável, nunca para detalhe de versão, sintaxe nova ou configuração sensível.
- Pedir a versão, o link oficial ou a fonte usada pelo projeto: aceitável quando rede ou ferramenta está bloqueada.

## Como decidir

Pergunte:

1. A resposta depende de versão?
2. A biblioteca mudou nos últimos anos?
3. O projeto já usa esse padrão em outro arquivo?
4. O erro indica API inexistente, assinatura errada ou configuração obsoleta?
5. Há risco de segurança, deploy ou perda de dados se a API estiver errada?
6. A documentação oficial é acessível no ambiente atual?

## Sinais de problema

- Código usa método que não aparece em nenhum arquivo do projeto nem documentação consultada.
- Resposta mistura versões diferentes do mesmo framework.
- Agente troca arquitetura porque viu exemplo genérico de internet.
- Instala biblioteca nova sem verificar se as tecnologias escolhidas já resolvem.
- Copia tutorial inteiro sem adaptar ao projeto.

## Gates

- Versão ou fonte consultada está clara quando a decisão depende disso.
- O trecho usado é suficiente e específico.
- A solução segue o padrão existente do projeto ou justifica o desvio.
- Qualquer suposição não verificada está marcada.
- Nenhuma dependência nova é proposta sem motivo e impacto.
