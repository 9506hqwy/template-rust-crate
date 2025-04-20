#!/bin/bash
set -euo pipefail

sudo apt-get update
sudo apt install -y linux-perf

cargo install flamegraph
