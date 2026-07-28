#!/bin/sh
# Bootstrap remoto do Boare Protocol Dev.
#
# Baixa o protocolo do GitHub para uma pasta temporária e roda o instalador
# local a partir dali, aplicando os adaptadores no diretório atual (onde este
# script foi chamado), sem exigir clone manual antes.
#
# Uso:
#   curl -fsSL https://raw.githubusercontent.com/pauloboare/BoareProtocolDev/v1/bootstrap.sh | sh -s -- --projeto --ferramenta auto
#
# Aceita as mesmas opções de instalar.sh, incluindo --ref/--referencia para
# baixar outra versão do protocolo (tag ou branch).

set -e

REPO="pauloboare/BoareProtocolDev"
REFERENCIA="v1"

# Descobre --ref/--referencia sem descartar os demais argumentos, que serão
# repassados para o instalar.sh baixado.
ARGS=""
SKIP_NEXT=0
for arg in "$@"; do
    if [ "$SKIP_NEXT" -eq 1 ]; then
        REFERENCIA="$arg"
        SKIP_NEXT=0
        continue
    fi
    case "$arg" in
        --ref|--referencia)
            SKIP_NEXT=1
            ;;
        *)
            ARGS="$ARGS $arg"
            ;;
    esac
done

command -v curl >/dev/null 2>&1 || { echo "curl não encontrado. Instale curl ou baixe o repositório manualmente." >&2; exit 1; }
command -v tar >/dev/null 2>&1 || { echo "tar não encontrado. Instale tar ou baixe o repositório manualmente." >&2; exit 1; }

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

TARBALL="$TMP_DIR/protocolo.tar.gz"
TARBALL_URL="https://github.com/$REPO/archive/$REFERENCIA.tar.gz"

echo "Baixando Boare Protocol Dev ($REFERENCIA)..." >&2
if ! curl -fsSL "$TARBALL_URL" -o "$TARBALL"; then
    echo "Não foi possível baixar '$REFERENCIA' de $REPO. Confira o nome da tag ou branch." >&2
    exit 1
fi

SOURCE_DIR_NAME=$(tar -tzf "$TARBALL" | head -1 | cut -f1 -d/)
tar -xzf "$TARBALL" -C "$TMP_DIR"
SOURCE_DIR="$TMP_DIR/$SOURCE_DIR_NAME"

if [ ! -f "$SOURCE_DIR/instalar.sh" ]; then
    echo "Download concluído, mas instalar.sh não foi encontrado em '$REFERENCIA'." >&2
    exit 1
fi

sh "$SOURCE_DIR/instalar.sh" $ARGS --ref "$REFERENCIA"
