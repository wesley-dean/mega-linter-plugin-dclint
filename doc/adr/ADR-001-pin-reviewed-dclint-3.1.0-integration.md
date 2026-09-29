# ADR-001: Pin the Reviewed DCLint 3.1.0 Integration

Date: 2026-09-29

## Status

Accepted

## Context

This repository exposes Docker Compose Linter (DCLint) through MegaLinter. The
descriptor previously installed the floating npm requirement `dclint`, so a new
upstream release could change plugin behavior without any commit or review in
this repository.

The reviewed upstream release is DCLint 3.1.0. Its tag resolves to commit
`472be0872d03fbcb9d3b53b9c69eba00aeabb9af`.

The existing plugin also used the filename expression
`docker-compose(-.+)?\.ya?ml`. That expression does not match several common
Compose naming forms supported by DCLint itself, including `compose.yml`,
`compose.yaml`, and dotted variants such as `docker-compose.override.yml`.

DCLint 3.1.0 discovers Compose files by the filename convention
`^(docker-)?compose.*\.ya?ml$`. MegaLinter applies a descriptor's
`file_names_regex` against each candidate file's base name using a full regex
match, so the same expression also selects nested paths such as
`compose/docker-compose-service.yml`.

## Decision Drivers

- Plugin behavior should change only through reviewed repository changes.
- The plugin should select the same Docker Compose filename family DCLint
  documents and discovers upstream.
- Nested Compose files should be selected based on their base filename rather
  than excluded because they live in a subdirectory.
- Existing users should retain the `DOCKERFILE_DCLINT` MegaLinter key.
- Integration tests should prove both selection and actual pass/fail behavior.
- Descriptor metadata should identify the actual upstream linter.
- Upstream rule documentation used by this plugin version should be immutable.
- This repository should not claim a fully locked npm dependency graph unless it
  maintains one reproducibly.

## Decision

The descriptor SHALL install `dclint@3.1.0`.

The descriptor SHALL identify
`https://github.com/zavoloklom/docker-compose-linter` as the upstream linter
repository and URL. Rule and inline-disable documentation links SHALL point to
the immutable source commit for DCLint 3.1.0.

The descriptor SHALL use this filename expression:

```text
^(docker-)?compose.*\.ya?ml$
```

This expression intentionally mirrors the upstream DCLint Compose filename
contract. Because MegaLinter applies it to base filenames, files in nested
directories remain eligible. In particular,
`compose/docker-compose-service.yml` SHALL be selected.

MegaLinter `list_of_files` mode SHALL be the only declared supported lint mode.
The descriptor SHALL preserve DCLint's documented `--config`, `--fix`, and
`--no-color` behavior and SHALL count both errors and warnings from DCLint's
stylish summary.

Integration testing SHALL use repository-owned fixtures. A compliant
`docker-compose.yml` SHALL pass. Invalid fixtures named `compose.yml`,
`compose.yaml`, `docker-compose.override.yml`, and
`compose/docker-compose-service.yml` SHALL all be selected and reported by
DCLint, and the combined invocation SHALL fail.

A future DCLint release SHALL be adopted through an explicit plugin change with
review and integration testing.

This decision pins the top-level npm package only. DCLint 3.1.0 declares
compatible version ranges for transitive dependencies, so those dependencies may
resolve to different compatible releases over time. A future decision to lock
the complete npm dependency graph requires a reproducible package-lock or other
explicit dependency-locking mechanism.

## Alternatives Considered

### Continue Installing Unversioned dclint

Rejected because an upstream npm release could alter plugin behavior without a
plugin repository change.

### Retain the Narrow docker-compose Pattern

Rejected because it excludes filename forms DCLint itself supports and excludes
real repository layouts used by plugin consumers.

### Match All YAML Files

Rejected because the plugin is specifically a Docker Compose linter and should
not claim unrelated YAML files.

### Maintain a Hand-Written Transitive Dependency Lock

Rejected because a trustworthy npm dependency closure should be generated and
maintained using npm's native locking mechanisms rather than reconstructed by
hand inside a MegaLinter descriptor.

## Consequences

### Positive

- Common modern and legacy Compose filename forms are selected consistently.
- Nested paths such as `compose/docker-compose-service.yml` work naturally.
- The top-level DCLint version is deterministic and reviewable.
- Upstream metadata and documentation links reflect the implementation actually
  being integrated.
- Tests protect both file selection and lint-result semantics.
- Future DCLint upgrades become explicit maintenance events.

### Negative

- Compatible transitive npm dependencies remain mutable.
- A future DCLint release requires a plugin update rather than automatic
  adoption.
- The upstream filename pattern intentionally matches any suffix after
  `compose`, which is broader than the plugin's previous dash-only pattern.

## Compatibility and Migration

The public MegaLinter key remains `DOCKERFILE_DCLINT`, and the descriptor path
remains `mega-linter-plugin-dclint/dclint.megalinter-descriptor.yml`.

The filename change is additive for ordinary Compose repositories: previously
matched `docker-compose*.yml` files continue to match, while additional
upstream-supported names become eligible.

## Expected Outcome

The plugin provides a stable, explicitly reviewed MegaLinter integration for
DCLint 3.1.0 and selects the Docker Compose filenames DCLint itself recognizes.
