#!/usr/bin/env bats

setup() {
  DESCRIPTOR="${BATS_TEST_DIRNAME}/../mega-linter-plugin-dclint/dclint.megalinter-descriptor.yml"
}

@test "descriptor pins the reviewed dclint release" {
  grep -Fq 'RUN npm install --global dclint@3.1.0' "${DESCRIPTOR}"
}

@test "descriptor identifies the upstream linter repository" {
  grep -Fq 'linter_repo: "https://github.com/zavoloklom/docker-compose-linter"' "${DESCRIPTOR}"
  grep -Fq 'linter_url: "https://github.com/zavoloklom/docker-compose-linter"' "${DESCRIPTOR}"
}

@test "descriptor matches the upstream Docker Compose filename contract" {
  grep -Fq '  - "^(docker-)?compose.*\\.ya?ml$"' "${DESCRIPTOR}"
}

@test "descriptor pins upstream rule documentation to dclint 3.1.0" {
  grep -Fq '472be0872d03fbcb9d3b53b9c69eba00aeabb9af/docs/rules.md' "${DESCRIPTOR}"
  grep -Fq '472be0872d03fbcb9d3b53b9c69eba00aeabb9af/docs/configuration-comments.md#disabling-rules' "${DESCRIPTOR}"
}

@test "descriptor exposes list_of_files mode only" {
  grep -Fq 'cli_lint_mode: "list_of_files"' "${DESCRIPTOR}"
  grep -Fq 'supported_cli_lint_modes:' "${DESCRIPTOR}"
  grep -Fq '      - "list_of_files"' "${DESCRIPTOR}"
}

@test "descriptor counts both dclint errors and warnings" {
  grep -Fq 'cli_lint_errors_count: "regex_number"' "${DESCRIPTOR}"
  grep -Fq 'cli_lint_warnings_count: "regex_number"' "${DESCRIPTOR}"
}
