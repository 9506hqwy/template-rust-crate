# Template for Rust Crate

This repository provides a template for Rust crate.

## Prepare

1. Replace value in *Cargo.toml*.
   * `repository`
2. Update other content in *Cargo.toml*.
3. Remove *example* directory.

## Development

### Formatting

Format source code.

```sh
cargo fmt --all
```

### Linting

Lint source code.

```sh
cargo clippy --fix
```

### Testing

Execute test code.

```sh
cargo test
```

### Profiling

#### Frame Graph

Install dependencies tools.

```sh
sudo apt install -y linux-perf
```

Generate frame graph.

```sh
cargo flamegraph -o target/flamegraph.svg --example main
```

#### Memory Profile

Gather data.

```sh
LD_PRELOAD=/usr/local/lib/libbytehound.so <executable>
```

Display data.

```sh
bytehound server memory-profiling_*.dat
```

### Updating

Check newer depenency crate.

```sh
cargo outdated
```

### License Checking

Check dependency licenses.

```sh
cargo tree --target all --format "{p} {l}"
```

Dump dependency licenses.

```sh
mkdir licenses
./tools/cargo-licenses.sh -o licenses --target all
```

## Documentation

Generate API document.

```sh
cargo doc
```

## Building Artifacts

Build binary.

```sh
cargo build
```
