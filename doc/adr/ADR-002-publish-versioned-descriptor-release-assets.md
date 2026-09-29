# ADR-002: Publish Versioned DCLint Descriptor Release Assets

Date: 2026-09-29

## Status

Accepted

## Context

This repository has no existing Git tags or GitHub Releases. Normal consumers
have therefore depended on the mutable plugin descriptor on `main`.

A MegaLinter plugin descriptor is executable configuration because it defines
installation commands and runtime behavior. Normal consumers benefit from a
reviewed, versioned distribution boundary.

## Decision Drivers

- Consumers should be able to pin an immutable plugin descriptor version.
- Consumers who deliberately follow releases should have a stable latest-release
  URL distinct from `main`.
- The exact distributed descriptor bytes should be validated before publication.
- Publication authority should be isolated from jobs that execute repository
  source and plugin tests.
- The first release should establish a conventional `vX.Y.Z` lineage without
  pretending historical versions existed.

## Decision

Every GitHub release SHALL include:

```text
dclint.megalinter-descriptor.yml
dclint.megalinter-descriptor.yml.sha256
```

The release build SHALL generate the distributed descriptor from the maintained
descriptor, record the `v`-prefixed release version and exact 40-character
source commit SHA in YAML comments, and generate the accompanying SHA-256
checksum.

The generated descriptor SHALL retain the `dclint@3.1.0` installation pin
established by ADR-001 until a later reviewed change updates that integration
boundary.

Release validation SHALL test the generated descriptor itself, including schema
validation, checksum verification, a passing Compose fixture, and the filename
selection/failure fixtures through MegaLinter.

Only after validation succeeds SHALL a separate publication job receive the
release files. That job SHALL re-verify the exact file set and checksum before
creating the GitHub release.

Because the repository has no existing release lineage, the release workflow
SHALL use `v0.1.0` as its initial version. Subsequent releases SHALL preserve
the `vX.Y.Z` convention and follow the repository's Conventional Commit release
governance.

Documentation SHALL recommend a version-pinned release asset for reproducible CI:

```text
https://github.com/wesley-dean/mega-linter-plugin-dclint/releases/download/vX.Y.Z/dclint.megalinter-descriptor.yml
```

Documentation MAY also offer the following URL when a consumer intentionally
wants the newest published plugin release:

```text
https://github.com/wesley-dean/mega-linter-plugin-dclint/releases/latest/download/dclint.megalinter-descriptor.yml
```

MegaLinter validates the configured plugin string before downloading it. Both
documented HTTPS forms satisfy the required `/mega-linter-plugin-` substring
because the repository name is `mega-linter-plugin-dclint`.

Local integration testing SHALL stage a byte-identical copy of the generated
descriptor beneath a temporary `mega-linter-plugin-` directory because the
natural `file://dist/...` path does not satisfy MegaLinter's local-plugin path
check. That staging path is a test accommodation and does not change the public
release artifact filename.

## Alternatives Considered

### Continue Recommending main

Rejected because branch content is mutable and does not represent an explicit
release decision.

### Start at v1.0.0

Rejected because this is the first formal distribution mechanism for an existing
pre-release plugin, not a declaration that the integration has reached a new
major stability contract.

### Publish Releases Without Descriptor Assets

Rejected because a GitHub Release would remain disconnected from the
configuration MegaLinter actually consumes.

### Build and Publish in One Privileged Job

Rejected because validation does not require release-publishing authority.
Separating those capabilities narrows the publication trust boundary.

## Consequences

### Positive

- Consumers can pin plugin descriptor versions.
- The latest-release URL follows releases rather than development state.
- Published descriptor bytes are tested before publication.
- Release assets include an integrity checksum and source provenance comments.
- The repository gains a clear release lineage beginning at `v0.1.0`.

### Negative

- Release automation becomes more involved.
- A checksum distributed beside an asset detects byte changes but is not an
  independent authentication mechanism.

## Compatibility and Migration

Existing raw-`main` consumers continue to work, but documentation now recommends
release assets.

The feature-bearing PR that introduces this decision is expected to produce the
first release, `v0.1.0`, after merge.

## Expected Outcome

Consumers can choose explicitly between a version-pinned DCLint plugin and
automatic adoption of newly published plugin releases without following
development state.
