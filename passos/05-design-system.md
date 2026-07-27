# Passo 5 - Definir o design system

Rode este passo **só se houver interface visual** e o Passo 1b não rodou. Se o
projeto não tiver interface visual, registre isso no FSD e pule. Se o design já
existe e foi registrado, pule.

## Objetivo
Definir a linguagem visual agora que já se sabe o que o sistema faz e como roda.

## Entra
- `docs/PRD.md` e `docs/DECISOES_TECNICAS.md`

## Sai
- `docs/DESIGN.md`

## Perguntas obrigatórias

1. Quem olha essa tela o dia inteiro, e em que condição? (mesa, balcão em pé,
   celular na rua, tela de toque em ambiente público)
2. Existe marca, logotipo ou cor institucional a respeitar?
3. Densidade: muita informação por tela, ou uma coisa por vez?
4. Qual a tela mais usada do sistema? Ela dita o resto.
5. Algum usuário com necessidade específica? (baixa visão, pouca familiaridade
   com computador, uso com luva, ambiente com muita luz)
6. Existe sistema parecido que o usuário já conhece e serve de referência?

## Instrução

Uma pergunta por vez. As decisões do Passo 4 limitam as escolhas - respeite-as
em vez de propor algo que a arquitetura escolhida não sustenta.

Proponha, não imponha: apresente 2 ou 3 direções visuais descritas em palavras
(sóbria e densa · clara e espaçada · alto contraste para ambiente difícil), com
o que cada uma serve melhor. O usuário escolhe.

Depois preencha `templates/DESIGN.md`. Em modo agente, crie ou atualize
`docs/DESIGN.md`. Em modo assistido, apresente o conteúdo para o usuário salvar.

Defina o mínimo, não o máximo:

- Paleta com função declarada: ação principal, perigo, sucesso, aviso, neutro.
- Escala de tipografia com poucos tamanhos, e onde cada um é usado.
- Escala de espaçamento com poucos valores.
- Os componentes que as telas do PRD realmente exigem - não uma biblioteca
  inteira "por precaução".
- Estados obrigatórios de toda tela que carrega dado: vazio, carregando, erro.

Contraste e tamanho de alvo são acessibilidade, não estética. Se a resposta 1
indicar uso em pé, no celular ou em tela de toque, alvo pequeno é defeito.

Componente que ninguém vai usar é peso morto. Corte.

Dúvida de acessibilidade ou fluxo? `skills/design-ui.md` aprofunda.

**Segurança e LGPD valem sempre** - segredo exposto ou dado pessoal em risco?
Avise na hora, mesmo fora do assunto deste passo.

## Portão de saída

- [ ] `docs/DESIGN.md` existe e não tem nenhum campo por preencher
- [ ] Toda cor tem função declarada, não só um código
- [ ] Todo componente listado aparece em alguma tela do PRD
- [ ] Os estados de vazio, carregando e erro estão definidos
- [ ] Os dispositivos-alvo estão nomeados
- [ ] Nada aqui contradiz uma decisão do Passo 4

## Commit

Comandos sugeridos:

```bash
git status
git add docs/DESIGN.md
git diff --staged
git commit -m "docs(prep): define design system"
```

