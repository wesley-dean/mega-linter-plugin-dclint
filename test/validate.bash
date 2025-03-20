#!/usr/bin/env bash

set -euo pipefail

V8R_SCHEMA_URL="${V8R_SCHEMA_URL:-https://raw.githubusercontent.com/oxsecurity/megalinter/refs/heads/main/megalinter/descriptors/schemas/megalinter-descriptor.jsonschema.json}"

v8r --schema "${V8R_SCHEMA_URL}" "mega-linter-plugin-*/*.megalinter-descriptor.yml"
