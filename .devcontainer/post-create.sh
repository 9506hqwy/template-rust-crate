#!/bin/bash
set -euo pipefail

sudo apt-get update
sudo apt install -y linux-perf

# Install CPU profiler.
cargo install flamegraph

# Install memory profiler.
MEM_PKG=bytehound-x86_64-unknown-linux-gnu.tgz
curl -sSLO --output-dir /tmp "https://github.com/koute/bytehound/releases/download/0.11.0/${MEM_PKG}"
tar -C /tmp -zxf /tmp/"${MEM_PKG}"
sudo mv /tmp/{bytehound,bytehound-gather} /usr/local/bin
sudo mv /tmp/libbytehound.so /usr/local/lib
