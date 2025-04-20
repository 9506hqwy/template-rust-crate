# Template for Rust Crate

This repository provides a template for Rust crate.

## TODO

* Collect test coverage on vscode test running.

## Development

### Frame Graph

Install dependencies tools.

```sh
sudo apt install -y linux-perf
```

Generate frame graph.

```sh
cargo flamegraph --example main
```

### Memory Profile

Gather data.

```sh
LD_PRELOAD=/usr/local/lib/libbytehound.so  <executable>
```

Display data.

```sh
bytehound server memory-profiling_*.dat
```

## Testing

Execute test code.

```sh
cargo test
```

## Documentation

Generate API document.

```sh
cargo doc
```

## Building artifacts

Build binary.

```sh
cargo build
```
