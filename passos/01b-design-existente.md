# Passo 1b - Registrar design existente

Rode este passo **só se o design já existe**. Se não existe, pule: ele é definido
no Passo 5, depois do PRD e das decisões técnicas.

## Objetivo
Registrar o design que já existe, para que vire insumo das decisões técnicas.

## Entra
- Referência visual: print, link, marcação e estilo, template comprado, manual de
  marca, ou um sistema existente que serve de espelho.

## Sai
- `docs/DESIGN.md`

## Perguntas obrigatórias

1. Qual é a origem da referência? (template comprado, manual de marca, sistema
   existente, print de concorrente)
2. Ela pode ser usada? Licença, direito de uso, marca de terceiro.
3. Quais cores, e o que cada uma significa? (ação principal, perigo, sucesso)
4. Qual tipografia, e quais tamanhos aparecem de fato?
5. Quais componentes já existem prontos? (botão, campo, tabela, modal, alerta)
6. Onde vai ser usado: desktop, celular, tablet, tela de toque?
7. Existem estados de vazio, de carregando e de erro definidos?

## Instrução

Uma pergunta por vez. Não invente valor que não está na referência - se a cor
exata não aparece, pergunte; não chute um código parecido.

Preencha o template `templates/DESIGN.md` com o que foi respondido. Em modo
agente, crie ou atualize `docs/DESIGN.md`. Em modo assistido, apresente o
conteúdo pronto para o usuário salvar.

Lacuna encontrada não é problema, é achado. Estado de erro que ninguém desenhou,
componente que falta: registre como lacuna, com nome. Lacuna escrita é lacuna que
o FSD vai cobrar no Passo 6.

Contraste é acessibilidade, não gosto. Se a referência usa texto claro sobre
fundo claro, ou alvo de toque pequeno demais para dedo, aponte.

Se a resposta 2 indicar que a licença é incerta, diga isso com todas as letras.
Descobrir depois do lançamento custa mais do que trocar agora.

**Segurança e LGPD valem sempre** - segredo exposto ou dado pessoal em risco?
Avise na hora, mesmo fora do assunto deste passo.

## Portão de saída

- [ ] `docs/DESIGN.md` existe e não tem nenhum campo por preencher
- [ ] Toda cor tem nome e função declarada, não só um código
- [ ] A origem da referência está registrada, com a situação da licença
- [ ] Os dispositivos-alvo estão nomeados
- [ ] As lacunas estão listadas como lacunas, não omitidas

## Commit

Mostre ao usuário para ele rodar:

`git add docs/DESIGN.md && git commit -m "docs(prep): registra design existente"`

Se o repositório ainda não existe, faça o Passo 2 antes e commite depois.

