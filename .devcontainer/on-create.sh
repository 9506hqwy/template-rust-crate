#!/bin/bash
set -euo pipefail

# Install dependencies
sudo apt-get update
sudo apt-get install -y \
    build-essential \
    gcc-mingw-w64-x86-64-win32 \
    linux-perf \
    shellcheck \
    zstd

# Configuration PATH
mkdir -p ~/.local/bin
# shellcheck disable=SC2016
echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc

# Common
GITHUB_HEADER_ACCEPT="Accept: application/vnd.github+json"
GITHUB_HEADER_VERSION="X-GitHub-Api-Version: 2022-11-28"

# Install actionlint
ACTIONLIN_URL="https://api.github.com/repos/rhysd/actionlint/releases?per_page=1"
ACTIONLINT_VERSION=$(curl -fsSL -H "${GITHUB_HEADER_ACCEPT}" -H "${GITHUB_HEADER_VERSION}" "${ACTIONLIN_URL}" | jq -r '.[0].tag_name')
curl -fsSL -o - "https://github.com/rhysd/actionlint/releases/download/${ACTIONLINT_VERSION}/actionlint_${ACTIONLINT_VERSION#v}_linux_amd64.tar.gz" | \
    tar -zxf - -O "actionlint" > ~/.local/bin/actionlint
chmod +x ~/.local/bin/actionlint

# Install bat
BAT_URL="https://api.github.com/repos/sharkdp/bat/releases?per_page=1"
BAT_VERSION=$(curl -fsSL -H "${GITHUB_HEADER_ACCEPT}" -H "${GITHUB_HEADER_VERSION}" "${BAT_URL}" | jq -r '.[0].tag_name')
curl -fsSL -o - "https://github.com/sharkdp/bat/releases/download/${BAT_VERSION}/bat-${BAT_VERSION}-x86_64-unknown-linux-gnu.tar.gz" | \
    tar -zxf - -O "bat-${BAT_VERSION}-x86_64-unknown-linux-gnu/bat" > ~/.local/bin/bat
chmod +x ~/.local/bin/bat

# Install delta
DELTA_URL="https://api.github.com/repos/dandavison/delta/releases?per_page=1"
DELTA_VERSION=$(curl -fsSL -H "${GITHUB_HEADER_ACCEPT}" -H "${GITHUB_HEADER_VERSION}" "${DELTA_URL}" | jq -r '.[0].tag_name')
curl -fsSL -o - "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/delta-${DELTA_VERSION}-x86_64-unknown-linux-gnu.tar.gz" | \
    tar -zxf - -O "delta-${DELTA_VERSION}-x86_64-unknown-linux-gnu/delta" > ~/.local/bin/delta
chmod +x ~/.local/bin/delta

# Install edit
#EDIT_URL="https://api.github.com/repos/microsoft/edit/releases?per_page=1"
EDIT_VERSION="v1.2.0"
curl -fsSL -o - "https://github.com/microsoft/edit/releases/download/${EDIT_VERSION}/edit-${EDIT_VERSION#v}-x86_64-linux-gnu.tar.zst" | \
    tar --zstd -xf - -O "edit" > ~/.local/bin/edit
chmod +x ~/.local/bin/edit

# Install lefthook
LEFTHOOK_URL="https://api.github.com/repos/evilmartians/lefthook/releases?per_page=1"
LEFTHOOK_VERSION=$(curl -fsSL -H "${GITHUB_HEADER_ACCEPT}" -H "${GITHUB_HEADER_VERSION}" "${LEFTHOOK_URL}" | jq -r '.[0].tag_name')
curl -fsSL -o - "https://github.com/evilmartians/lefthook/releases/download/${LEFTHOOK_VERSION}/lefthook_${LEFTHOOK_VERSION#v}_Linux_x86_64.gz" | \
    gzip -c -d > ~/.local/bin/lefthook
chmod +x ~/.local/bin/lefthook

# Install yq
YQ_URL="https://api.github.com/repos/mikefarah/yq/releases?per_page=1"
YQ_VERSION=$(curl -fsSL -H "${GITHUB_HEADER_ACCEPT}" -H "${GITHUB_HEADER_VERSION}" "${YQ_URL}" | jq -r '.[0].tag_name')
curl -fsSL -o - "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64.tar.gz" | \
    tar -zxf - -O "./yq_linux_amd64" > ~/.local/bin/yq
chmod +x ~/.local/bin/yq

# Install cargo-expand
cargo install cargo-expand

# Install cargo-outdated
cargo install cargo-outdated

# Install CPU profiler.
cargo install flamegraph

# Install memory profiler.
MEM_PKG=bytehound-x86_64-unknown-linux-gnu.tgz
curl -sSLO --output-dir /tmp "https://github.com/koute/bytehound/releases/download/0.11.0/${MEM_PKG}"
tar -C /tmp -zxf /tmp/"${MEM_PKG}"
sudo mv /tmp/{bytehound,bytehound-gather} /usr/local/bin
sudo mv /tmp/libbytehound.so /usr/local/lib

## Add the Windows target for cross-compilation.
rustup target add x86_64-pc-windows-gnu
