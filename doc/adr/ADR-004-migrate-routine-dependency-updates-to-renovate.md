# ADR-004: Migrate Routine Dependency Updates to Centrally Managed Renovate

Date: 2026-11-26

## Status

Accepted

## Decision

This repository SHALL explicitly enroll in the existing Jenkins-hosted
Renovate service through a minimal root `renovate.json`. Each active
Dependabot ecosystem SHALL set `open-pull-requests-limit: 0` to stop
scheduled routine version-update PRs. The rest of the Dependabot
configuration remains intact. Dependabot vulnerability alerts and
advisory-driven security updates remain independent and SHALL NOT be
disabled or delayed.

Dependabot-scoped non-major auto-merge automation remains restricted to
`dependabot[bot]`. No additional credentials, repository Actions,
automatic PR approval, bypass of CODEOWNER review, or weakening of
required checks is authorized.

This decision **partially supersedes ADR-003** for its active
Dependabot routine scheduling, grouping, PR-limit policy, and instruction
to retain routine PRs until replacements are validated. Its requirements
concerning separate security updates, review of major changes, and
supply-chain assurance remain applicable. The prior ADR remains on record.

## Context and Constraints

Centralized Jenkins Renovate now manages the maintainer's routine
dependency proposals across `wesley-dean/*`. Parallel Dependabot
version-update schedules cause duplicate PRs and review work.

The accepted repository architecture includes reviewed dclint 3.1.0 integration, validated descriptor assets, SHA256 checksums, and separate release publication.
The migration does not authorize runtime, API, artifact, test, executable
dependency manifest, publishing privilege, or imported coding standards
changes.

## Assumptions and Dependencies

- Jenkins already discovers the repository and uses explicit Renovate
  enrollment; no Jenkins modifications are needed here.
- The maintainer provisions the Renovate account's repository access
  when approving the migration PR.
- Effective branch protection, required tests and CODEOWNER review
  continue to govern native auto-merge.
- GitHub security updates and vulnerability alerts are configured
  separately and cannot be verified from this YAML alone.
- A merged configuration is not proof that Renovate has run successfully.

## Alternatives Considered

1. Keep both scheduled providers. Rejected due to duplicate updates.
2. Delete Dependabot YAML. Rejected: preserving security-update context
   and the previous ecosystem configuration is preferable.
3. Add repository-specific Renovate Actions or credentials. Rejected due to
   duplicated centralized administration and security complexity.
4. Extend Dependabot's auto-merge logic to Renovate. Rejected because this
   crosses bot-identity and approval boundaries.
5. Replace every immutable action SHA with a floating version. Rejected
   when an upstream SHA/tag mapping is verified; preserve the SHA instead.

## Migration and Risk

Add root Renovate enrollment, disable each routine Dependabot ecosystem,
and update maintenance documentation. GitHub Actions annotations may be
normalized only when their existing SHA matches an upstream release tag.
When no reliable release mapping can be established, replace the action's
SHA and obsolete pin comment with a syntactically valid `@version`
reference. This temporarily weakens immutable supply-chain pinning until
Renovate proposes and reviewers approve a verified replacement. Do not
change unrelated executable dependency pins.

Close conclusively non-security Dependabot version PRs after the migration
PR exists, with an explanatory comment linking the new PR. Security,
ambiguous, or human-modified PRs remain open. This is a change in provider
ownership, not evidence that Renovate has yet generated equivalent updates.

The centralized account acquires branch/PR-writing authority; upstream
dependency compromise, unsigned changes, privileged release actions, and
untested updates remain threats. Retain immutable verified pins, signed
commits, mandatory reviews, least privilege, independent advisory response,
CI gates, and targeted scrutiny for release or financial integration paths.

## Related Decisions

ADR-003 documents the prior grouped Dependabot policy.
Other accepted ADRs governing reviewed dclint 3.1.0 integration, validated descriptor assets, SHA256 checksums, and separate release publication remain authoritative.
