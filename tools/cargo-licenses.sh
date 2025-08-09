#!/bin/bash
# Copy license files for dependency libraries.
#
# Usage:
#   ./cargo-licenses.sh [-o <output-directory>] ...[cargo tree option]
#
# References:
# - https://users.rust-lang.org/t/missing-good-tools-for-bundling-third-party-licenses/93172
set -euo pipefail

if ! command -v jq > /dev/null; then
    echo >&2 "Not found 'jq' command."
    exit 1
fi

if [[ ! -f Cargo.toml ]]; then
    echo >&2 "Not found 'Cargo.toml'."
    exit 1
fi

OUTPUT_DIR="."

TREE_ARGS=()
while [[ $# -gt 0 ]]
do
    case "$1" in
        -o)
            shift
            OUTPUT_DIR="$1"
            ;;
        *)
            TREE_ARGS+=("$1")
            ;;
    esac

    shift
done

if [[ ! -d "${OUTPUT_DIR}" ]]; then
    echo >&2 "Not found '${OUTPUT_DIR}'."
    exit 1
fi

function copy-files() {
    PKG_DIR="$1"
    DEST_DIR="$2"

    # LICENSE
    find "${PKG_DIR}" -maxdepth 1 -type f -iname 'LICENSE*' -exec cp {} "${DEST_DIR}/" \;

    # COPYING
    find "${PKG_DIR}" -maxdepth 1 -type f -iname 'COPYING*' -exec cp {} "${DEST_DIR}/" \;

    # NOTICE
    find "${PKG_DIR}" -maxdepth 1 -type f -iname 'NOTICE*' -exec cp {} "${DEST_DIR}/" \;
}

function copy-license-files() {
    PAKCAGE="$1"

    NAME=$(jq -r '.name' <<< "${PAKCAGE}")
    REPOSITORY=$(jq -r '.repository' <<< "${PAKCAGE}")

    VERSION=$(jq -r '.version' <<< "${PAKCAGE}")
    if [[ -z "${VERSION}" ]]; then
        echo >&2 "Not found version for '${NAME}' package."
        exit 1
    fi

    MANIFEST_PATH=$(jq -r '.manifest_path' <<< "${PAKCAGE}")
    if [[ ! -f "${MANIFEST_PATH}" ]]; then
        echo >&2 "Not found manifest for '${NAME}-${VERSION}' package."
        exit 1
    fi

    PKG_DIR=$(dirname "${MANIFEST_PATH}")

    if [[ "${REPOSITORY}" =~ ^https:// ]]; then
        DEST_DIR="${REPOSITORY#https:\/\/}/${NAME}"
    else
        DEST_DIR="${NAME}"
    fi

    DEST_VER_DIR="${OUTPUT_DIR}/${DEST_DIR}@${VERSION}"
    mkdir -p "${DEST_VER_DIR}"

    copy-files "${PKG_DIR}" "${DEST_VER_DIR}"

    # Check emptry directory.
    if find "${DEST_VER_DIR}" -empty -type d | grep -q .; then
        if [[ ! "${PKG_DIR}" =~ index.crates.io ]]; then
            # For current workspace crate.
            PKG_DIR=$(dirname "${PKG_DIR}")
            copy-files "${PKG_DIR}" "${DEST_VER_DIR}"
        fi

        if find "${DEST_VER_DIR}" -empty -type d | grep -q .; then
            echo >&2 "Found empty '${DEST_VER_DIR}' directory."
            #exit 1
        fi
    fi
}

export CARGO_TERM_COLOR=never

METADATA_ALL=$(cargo metadata --format-version 1)

# shellcheck disable=SC2207
DEPS=($(cargo tree --prefix none --no-dedupe "${TREE_ARGS[@]}" | cut -d ' ' -f 1 | sort | uniq))
for DEP in "${DEPS[@]}"
do
    METADATA_DEP=$(jq -c ".packages | map(select(.name==\"${DEP}\")) | first" <<< "${METADATA_ALL}")
    if [[ "${METADATA_DEP}" == "null" ]]; then
        echo >&2 "Not found '${DEP}' metadata."
        exit 1
    fi

    copy-license-files "${METADATA_DEP}"
done
