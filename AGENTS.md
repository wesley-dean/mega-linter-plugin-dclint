# Repository Instructions

## Governing Standards

Files beneath `doc/standards/` are governing project requirements, not
suggestions. Read every standard applicable to the content being changed before
proposing or making changes.

Presence does not imply applicability. General and cross-cutting standards apply
where relevant, language-specific standards apply to maintained content in that
language, and `doc/standards/examples/` and `doc/standards/templates/` are
illustrative and non-normative unless a governing standard explicitly says
otherwise.

Accepted repository-specific ADRs and explicit local policies may refine or
supersede imported standards. Do not silently deviate from either source. Do not
edit imported standards locally to create an exception; record repository-
specific exceptions in accepted local governance instead.

The adopted standards release and archive digest are recorded in
`.codingstandardrc`. The complete managed snapshot lives under
`doc/standards/`.

## Repository Startup

Before consequential work, read `README.md`, this file, applicable standards,
and any ADRs under `doc/adr/`. Repository documentation and accepted ADRs are
authoritative for this project.

## Scope and Compatibility

Keep changes surgical and reviewable. Preserve the public MegaLinter linter key
`DOCKERFILE_DCLINT` and the plugin descriptor path unless an accepted local
decision explicitly changes those interfaces. Do not combine unrelated cleanup
with requested work.

## Bash

Maintained Bash follows `doc/standards/bash/documentation-standard.md` and the
repository shfmt policy `-i 2 -bn -ci -sr -kp`.

## Testing

Behavioral tests should be deterministic and assert observable behavior. Bats is
the preferred driver for Bash command-line behavior. TAP remains the canonical
console format; JUnit output, when generated for CI publication, is derivative
state beneath ignored `test-results/`.
