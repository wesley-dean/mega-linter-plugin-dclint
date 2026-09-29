#!/usr/bin/env bash
# shellcheck shell=bash
## @file tests/validate.bash
## @brief Validates a dclint plugin descriptor against MegaLinter's pinned schema.
## @details
## Uses the same pinned MegaLinter image as integration testing so descriptor
## validation does not depend on a separately installed v8r executable. The
## selected descriptor is mounted read-only into a dedicated container working
## directory and passed to v8r by relative path so generated files beneath
## ignored build directories are validated directly.
##
## @par STDIN
## Nothing is read from STDIN.
## @par STDOUT
## v8r writes its ordinary validation report to STDOUT.
## @par STDERR
## Docker and v8r diagnostics may be written to STDERR.
##
## @returns v8r's descriptor-validation output.
## @retval 0 The descriptor satisfies the pinned MegaLinter schema.
## @retval 66 The requested descriptor does not exist or is not readable.
## @note Non-zero Docker or v8r exit statuses are propagated unchanged.

set -euo pipefail

readonly DCLINT_EX_NOINPUT=66
readonly MEGALINTER_IMAGE="${MEGALINTER_IMAGE:-ghcr.io/oxsecurity/megalinter-ci_light:v10.1.0}"
readonly V8R_SCHEMA_URL="${V8R_SCHEMA_URL:-https://raw.githubusercontent.com/oxsecurity/megalinter/v10.1.0/megalinter/descriptors/schemas/megalinter-descriptor.jsonschema.json}"
readonly DESCRIPTOR_PATH="${1:-mega-linter-plugin-dclint/dclint.megalinter-descriptor.yml}"
readonly CONTAINER_WORKDIR="/tmp/dclint-descriptor"
readonly CONTAINER_DESCRIPTOR="dclint.megalinter-descriptor.yml"

if [[ ! -r ${DESCRIPTOR_PATH} ]]; then
  printf 'Descriptor is not readable: %s\n' "${DESCRIPTOR_PATH}" >&2
  exit "${DCLINT_EX_NOINPUT}"
fi

docker run \
  --rm \
  --entrypoint v8r \
  -v "${PWD}/${DESCRIPTOR_PATH}:${CONTAINER_WORKDIR}/${CONTAINER_DESCRIPTOR}:ro" \
  -w "${CONTAINER_WORKDIR}" \
  "${MEGALINTER_IMAGE}" \
  --schema "${V8R_SCHEMA_URL}" \
  "${CONTAINER_DESCRIPTOR}"
