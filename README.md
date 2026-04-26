# utilities

Release mirror for Pattern Zones internal utilities.

This repo holds compiled binaries for the following tools (sources in private
sibling repos under `pattern-zones-co/`):

- `forme` 
- `unslop` 
- `hat` 
- `loopctl` 

## Release tag convention

`<tool>-v<version>` (e.g. `forme-v0.2.0`). Each release includes
`linux_amd64`, `linux_arm64`, `darwin_amd64`, `darwin_arm64` tarballs.

## Why this exists

The source repos are private but the compiled binaries are intended to be reproducibly fetchable by
[NixOS](https://github.com/pattern-zones-co/infra) configurations.
