#!/bin/bash
set -euo pipefail

# Install dependencies
sudo apt-get update
sudo apt-get install -y linux-perf shellcheck zstd

# Configuration PATH
mkdir -p ~/.local/bin
echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc

# Install actionlint
ACTIONLINT_VERSION=1.7.7
curl -fsSL -o - "https://github.com/rhysd/actionlint/releases/download/v${ACTIONLINT_VERSION}/actionlint_${ACTIONLINT_VERSION}_linux_amd64.tar.gz" | \
    tar -zxf - -O "actionlint" > ~/.local/bin/actionlint
chmod +x ~/.local/bin/actionlint

# Install bat
BAT_VERSION=0.25.0
curl -fsSL -o - "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-v${BAT_VERSION}-i686-unknown-linux-gnu.tar.gz" | \
    tar -zxf - -O "bat-v${BAT_VERSION}-i686-unknown-linux-gnu/bat" > ~/.local/bin/bat
chmod +x ~/.local/bin/bat

# Install delta
DELTA_VERSION=0.18.2
curl -fsSL -o - "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/delta-${DELTA_VERSION}-x86_64-unknown-linux-gnu.tar.gz" | \
    tar -zxf - -O "delta-${DELTA_VERSION}-x86_64-unknown-linux-gnu/delta" > ~/.local/bin/delta
chmod +x ~/.local/bin/delta

# Install edit
EDIT_VERSION=1.2.0
curl -fsSL -o - "https://github.com/microsoft/edit/releases/download/v${EDIT_VERSION}/edit-${EDIT_VERSION}-x86_64-linux-gnu.tar.zst" | \
    tar --zstd -xf - -O "edit" > ~/.local/bin/edit
chmod +x ~/.local/bin/edit

# Install lefthook
LEFTHOOK_VERSION=1.11.13
curl -fsSL -o - "https://github.com/evilmartians/lefthook/releases/download/v${LEFTHOOK_VERSION}/lefthook_${LEFTHOOK_VERSION}_Linux_x86_64.gz" | \
    gzip -c -d > ~/.local/bin/lefthook
chmod +x ~/.local/bin/lefthook

# Install yq
YQ_VERSION=4.45.4
curl -fsSL -o - "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64.tar.gz" | \
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
