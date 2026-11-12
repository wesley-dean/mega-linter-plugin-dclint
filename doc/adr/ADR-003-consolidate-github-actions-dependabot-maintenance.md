# ADR-003: Consolidate GitHub Actions Dependabot Version Updates

Date: 2026-11-12

## Status

Accepted

## Decision

Continue the weekly GitHub Actions Dependabot version-update schedule and
seven-day cooldown, but replace the `minor-and-patch` group with one
broadly matching `actions-version-updates` group. The group SHALL
explicitly use `applies-to: version-updates` and `patterns: ["*"]`
without an `update-types` restriction, allowing eligible major,
minor, and patch routine version updates to arrive in one group.

Security updates SHALL remain separate from routine version updates and
SHALL NOT wait for the weekly schedule or cooldown. The existing
`dependabot/fetch-metadata` non-major-only auto-merge condition SHALL
remain unchanged. A group with any major version change must receive
manual review appropriate to its highest-risk dependency.

## Context

The repository currently configures weekly GitHub Actions version updates
with a seven-day cooldown and a group restricted to minor/patch releases.
Major versions are therefore proposed separately, contributing to routine
review overhead. The verified `coding_standards@v3.2.0` release establishes
a balanced per-ecosystem group for all eligible routine SemVer categories.

This plugin distributes an executable MegaLinter descriptor that installs
the deliberately pinned `dclint@3.1.0` package, selects Docker Compose
filenames, and produces validated, versioned release assets. GitHub Actions
dependencies may affect descriptor testing, checksums, release publication,
and the separation of unprivileged validation from publication authority.
Consolidating dependency-version proposals must not relax any of those
boundaries.

## Decision Drivers and Constraints

- Reduce recurring dependency-update PR fragmentation without hiding
  dependency risks or changing the established weekly visibility.
- Preserve the seven-day version-update cooldown.
- Preserve separate, timely Dependabot security-update processing.
- Preserve the current auto-merge condition that excludes any group whose
  highest reported change is `version-update:semver-major`.
- Preserve accepted ADR-001's reviewed DCLint version and filename matching.
- Preserve ADR-002's immutable release assets, checksum verification,
  descriptor source provenance, and separate publishing authority.
- Do not change GitHub Actions check identities, permissions, effective
  review requirements, or release tokens as part of this adoption.
- No settings claims are inferred from YAML alone; actual branch protections,
  CODEOWNERS enforcement, dependency alerts, and security-update enablement
  require separate verification.

## Considered Alternatives

1. **Retain minor/patch-only grouping.** Rejected because it perpetuates
   separate major-version proposals without changing the needed review.
2. **Group eligible major, minor, and patch routine updates.** Selected to
   reduce fragmentation with mandatory heightened review for major groups.
3. **Switch to monthly scheduling or a longer cooldown.** Rejected without
   evidence that this actively maintained plugin benefits from slower
   dependency visibility.
4. **Auto-merge grouped major updates.** Rejected because workflow security,
   CI compatibility, and artifact publication may change materially.
5. **Immediately close current Dependabot PRs.** Rejected because changing
   grouping does not establish that their changes were replaced or tested.

## Tradeoffs and Consequences

Some routine GitHub Actions updates may be consolidated, reducing PR review
volume. Resolution constraints, incompatible upgrades, or update failures may
still produce multiple PRs. A grouped failure can obscure its cause; a narrow
repository-governed exclusion may be appropriate when justified by evidence.

Every dependency in a grouped PR remains subject to release-note review,
migration impact assessment, token/permission inspection, and meaningful
testing. A green MegaLinter check does not prove the generated descriptor
still installs and runs the pinned DCLint tool or that the release-publication
path is safe. No new claims of ecosystem-wide or exact weekly PR counts are
made.

Leave existing Dependabot PR #81 open until subsequent grouped updates
demonstrably supersede its dependency set and sufficient test evidence
exists. This decision does not modify the actual plugin descriptor,
`dclint@3.1.0` integration, filename matching, build commands, or release
publication permissions.

## Expected Outcomes and Verification

Observe future Dependabot proposals to verify wildcard grouping covers
eligible routine versions and that any group containing a major update
remains outside the non-major-only auto-merge path. Compare actual PR volume
and review effort, inspect unsuccessful grouped updates, and split sensitive
or incompatible actions through a reviewed local exception when warranted.

Verify effective GitHub rulesets, CODEOWNERS, security alerts, and security
updates independently. Existing integration-test and release-validation
requirements remain in force.

## Related Decisions

ADR-001 pins the reviewed DCLint behavior and public MegaLinter integration.
ADR-002 governs tested, checksum-verified descriptor release assets and
separate publication authority. This decision supplements but does not
supersede either accepted contract.
