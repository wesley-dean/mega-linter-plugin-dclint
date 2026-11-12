# Architectural Decisions

This document summarizes the repository's Accepted Architecture Decision
Records. The complete ADRs govern when a summary appears to be incomplete
or conflicting; applicable imported coding standards and explicit local
policy also apply.

## ADR-001: Pin the Reviewed DCLint 3.1.0 Integration

The plugin intentionally installs `dclint@3.1.0` and retains the public
`DOCKERFILE_DCLINT` MegaLinter key. It selects upstream-supported Compose
filenames, including nested files, and verifies success and failure through
integration fixtures. Future DCLint upgrades require a separately reviewed
plugin change; the top-level pin does not promise immutable transitive npm
dependencies.

See [ADR-001](adr/ADR-001-pin-reviewed-dclint-3.1.0-integration.md).

## ADR-002: Publish Versioned Descriptor Release Assets

Normal consumers should use reviewed, versioned plugin descriptor release
assets rather than mutable development state. Every release includes the
generated descriptor and its SHA-256 companion, with source provenance and
the pinned DCLint version. Validation exercises the distributed descriptor
before a separately authorized publication job verifies and releases it.

See [ADR-002](adr/ADR-002-publish-versioned-descriptor-release-assets.md).

## ADR-003: Consolidate GitHub Actions Dependabot Version Updates

Routine GitHub Actions version updates remain weekly with a seven-day
cooldown, now with a wildcard group for eligible major, minor, and patch
changes. Security updates remain separate, and any group containing a
major update is excluded from the existing non-major-only auto-merge
condition pending manual review. Existing plugin descriptor and release
governance remains unchanged, and earlier Dependabot PRs require separate
verification before being considered superseded.

See [ADR-003](adr/ADR-003-consolidate-github-actions-dependabot-maintenance.md).
