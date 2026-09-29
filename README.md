# mega-linter-plugin-dclint

[![MegaLinter](https://github.com/wesley-dean/mega-linter-plugin-dclint/actions/workflows/megalinter.yml/badge.svg)](https://github.com/wesley-dean/mega-linter-plugin-dclint/actions/workflows/megalinter.yml)
[![Dependabot Updates](https://github.com/wesley-dean/mega-linter-plugin-dclint/actions/workflows/dependabot/dependabot-updates/badge.svg)](https://github.com/wesley-dean/mega-linter-plugin-dclint/actions/workflows/dependabot/dependabot-updates)
[![Scorecard supply-chain security](https://github.com/wesley-dean/mega-linter-plugin-dclint/actions/workflows/scorecard.yml/badge.svg)](https://github.com/wesley-dean/mega-linter-plugin-dclint/actions/workflows/scorecard.yml)

This repository provides a MegaLinter plugin for
[Docker Compose Linter (DCLint)](https://github.com/zavoloklom/docker-compose-linter).

DCLint analyzes, validates, and can fix Docker Compose files. This plugin release
intentionally pins DCLint 3.1.0, the upstream release reviewed and tested for this
integration. A newer upstream release should be adopted through an explicit
plugin change rather than silently through an unversioned npm install.

## Supported Compose Filenames

MegaLinter filters `file_names_regex` against each file's base name. This plugin
uses DCLint's upstream Compose filename convention:

```text
^(docker-)?compose.*\.ya?ml$
```

That includes, among others:

```text
compose.yml
compose.yaml
docker-compose.yml
docker-compose.override.yml
docker-compose-service.yml
compose/docker-compose-service.yml
```

The last example demonstrates that Compose files may live in subdirectories; the
directory path does not prevent MegaLinter from matching the base filename.

## MegaLinter Configuration

Released descriptors are the supported distribution channel for normal
MegaLinter use. For reproducible CI and production workflows, pin the plugin to
a specific release:

```yaml
PLUGINS:
  - "https://github.com/wesley-dean/mega-linter-plugin-dclint/releases/download/v0.1.0/dclint.megalinter-descriptor.yml"
```

When deliberately following the newest released plugin version, use the
latest-release asset:

```yaml
PLUGINS:
  - "https://github.com/wesley-dean/mega-linter-plugin-dclint/releases/latest/download/dclint.megalinter-descriptor.yml"
```

Pinning a release is preferred when build reproducibility matters. The
`releases/latest/download/` form trades that reproducibility for automatic
adoption of newly published plugin releases.

Depending on the rest of the MegaLinter configuration, explicitly enable the
linter when necessary:

```yaml
ENABLE_LINTERS:
  - "DOCKERFILE_DCLINT"
```

The plugin invokes DCLint in MegaLinter's `list_of_files` mode and disables
colored output so the descriptor can reliably count DCLint's error and warning
summary.

## DCLint Configuration

DCLint supports `.dclintrc`, `dclint.config.js`, and other formats discovered
through its upstream configuration loader. When MegaLinter finds the plugin's
configured `.dclintrc`, it passes that path through DCLint's documented
`--config` option.

See the documentation for the reviewed DCLint 3.1.0 source:

- [Rules](https://github.com/zavoloklom/docker-compose-linter/blob/472be0872d03fbcb9d3b53b9c69eba00aeabb9af/docs/rules.md)
- [Configuration comments](https://github.com/zavoloklom/docker-compose-linter/blob/472be0872d03fbcb9d3b53b9c69eba00aeabb9af/docs/configuration-comments.md)
- [CLI reference](https://github.com/zavoloklom/docker-compose-linter/blob/472be0872d03fbcb9d3b53b9c69eba00aeabb9af/docs/cli.md)

## Upstream Version

The descriptor installs:

```text
dclint@3.1.0
```

That pin prevents this plugin from silently changing when a new DCLint package is
published. DCLint 3.1.0 itself declares compatible version ranges for its npm
dependencies, so the transitive dependency closure is not fully immutable.
ADR-001 records that tradeoff explicitly.

## Releases

This repository did not publish plugin releases before this modernization. The
first release produced by the new workflow is `v0.1.0`.

Each plugin release publishes:

```text
dclint.megalinter-descriptor.yml
dclint.megalinter-descriptor.yml.sha256
```

The distributed descriptor records the plugin release version and exact source
commit that produced it, and retains the explicit `dclint@3.1.0` installation
pin.

Release validation exercises the generated descriptor through MegaLinter before
publication. The validated files cross into a separate publication job, where
the exact file set and checksum are verified again before GitHub creates the
release.

The descriptor stored on `main` remains useful for plugin development and
testing, but normal consumers should use a release asset rather than development
state.

## Development

Behavioral tests use deterministic local Docker Compose fixtures. The integration
test proves that a valid `docker-compose.yml` passes and that invalid files
using multiple supported filename forms are all selected, including the nested
`compose/docker-compose-service.yml` case.

Useful targets are:

```bash
make test
make validate
make build
make validate-release
make integration-test
make clean
```

`make test` runs Bats assertions for the descriptor and release build.
`make validate` validates the maintained descriptor against the schema from
MegaLinter 10.1.0. `make integration-test` loads the generated descriptor
through MegaLinter 10.1.0 and exercises the filename-selection and pass/fail
contract.

For a local release-style build:

```bash
make build VERSION=0.1.0 BUILD_REF="$(git rev-parse HEAD)"
```

## Repository Governance

This repository adopts released engineering standards from
[`wesley-dean/coding_standards`](https://github.com/wesley-dean/coding_standards).
The complete pinned snapshot is committed beneath `doc/standards/`, while
`.codingstandardrc` records the adopted release and verified archive digest.

Applicable files beneath `doc/standards/` are project requirements, subject to
accepted repository-specific ADRs and explicit local policy. Imported standards
are managed as a release snapshot and are not edited locally to create project-
specific exceptions.
