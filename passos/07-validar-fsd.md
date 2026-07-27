# Passo 7 - Validar o FSD

## Objetivo
Achar as contradições entre os quatro artefatos antes que virem retrabalho.

## Entra
- `docs/PRD.md`, `docs/DECISOES_TECNICAS.md`, `docs/FSD.md`
- `docs/DESIGN.md`, quando houver interface visual

## Sai
- `docs/FSD.md` aprovado, ou os artefatos de origem corrigidos.

## Perguntas obrigatórias

Nenhuma no começo. Este passo é verificação cruzada, não entrevista.
Pergunte só quando encontrar divergência, para saber qual lado corrigir.

## Instrução

Não releia o FSD procurando erro de escrita. Cruze os documentos, um par por vez,
e mostre o resultado de cada cruzamento antes de passar ao próximo.

Em modo agente, aponte a divergência e aplique a correção no artefato de origem
quando o usuário confirmar a direção. Em modo assistido, aponte a divergência,
proponha a correção e espere o usuário aplicar.

**PRD × FSD**
- Toda `RN` está coberta? Aponte onde cada uma aparece.
- Todo `CA` é verificável por um item do plano de testes? Aponte qual.
- Existe algo no FSD que não vem de nenhuma linha do PRD? Isso é escopo que
  cresceu sem ninguém autorizar. Mostre e pergunte.
- Existe algo no FSD que o PRD colocou explicitamente fora de escopo?

**DECISOES_TECNICAS × FSD**
- O FSD exige algo que a arquitetura escolhida não sustenta?
- O FSD contradiz alguma decisão? Se sim, a decisão muda ou o FSD muda - e mudar
  decisão registrada exige atualizar o motivo e a linha "Revisar se".

**DESIGN × FSD**, quando houver interface visual
- Alguma tela exige componente que o design não tem?
- Algum estado (vazio, carregando, erro) aparece no FSD sem definição visual?

**FSD × FSD**
- A ordem de implementação tem dependência circular?
- Alguma operação depende de dado que nenhuma outra operação cria?

**Segurança e LGPD**
- Todo campo de dado pessoal do PRD aparece protegido no FSD?
- Alguma operação expõe dado pessoal sem verificar permissão?
- Algum identificador sequencial de registro com dado pessoal aparece em
  entrada pública, URL, comando, exportação ou integração?

Achou divergência: **corrija o artefato de origem, não o FSD**. O FSD é
consequência. Consertar só a consequência deixa a contradição viva no documento
que alimenta o próximo passo.

Este é o passo que mais reduz retrabalho e o mais tentador de pular. Não pule.

## Portão de saída

- [ ] Toda `RN` do PRD tem localização apontada no FSD
- [ ] Todo `CA` do PRD tem um teste correspondente apontado
- [ ] Nenhum item do FSD está fora do escopo declarado no PRD
- [ ] Nada no FSD contradiz uma decisão técnica
- [ ] Nada no FSD exige componente ausente do design, quando houver design
- [ ] A ordem de implementação não tem dependência circular
- [ ] Todo dado pessoal aparece protegido, e nenhum vaza em entrada pública
- [ ] Toda divergência achada foi corrigida na origem

## Commit

Comandos sugeridos:

```bash
git status
git add docs/PRD.md docs/DECISOES_TECNICAS.md docs/DESIGN.md docs/FSD.md
git diff --staged
git commit -m "docs(prep): valida FSD e corrige divergências"
```

