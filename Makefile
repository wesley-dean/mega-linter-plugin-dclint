SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

TEST_RESULTS_DIR := test-results
DIST_DIR ?= dist
SOURCE_DESCRIPTOR := mega-linter-plugin-dclint/dclint.megalinter-descriptor.yml
DIST_DESCRIPTOR := $(DIST_DIR)/dclint.megalinter-descriptor.yml
DIST_CHECKSUM := $(DIST_DESCRIPTOR).sha256
MEGALINTER_IMAGE ?= ghcr.io/oxsecurity/megalinter-ci_light:v10.1.0
VERSION ?= 0.0.0-dev
BUILD_REF ?= $(shell git rev-parse HEAD 2>/dev/null || true)
DCLINT_VERSION := 3.1.0

.PHONY: build clean integration-test test validate validate-release

build:
	@[[ "$(VERSION)" =~ ^[0-9]+\.[0-9]+\.[0-9]+([.-][0-9A-Za-z.-]+)?$$ ]] || { \
		printf 'Invalid VERSION: %s\n' "$(VERSION)" >&2; \
		exit 1; \
	}
	@[[ "$(BUILD_REF)" =~ ^[0-9a-f]{40}$$ ]] || { \
		printf 'BUILD_REF must be a 40-character lowercase Git commit SHA: %s\n' "$(BUILD_REF)" >&2; \
		exit 1; \
	}
	@count=$$(grep -Fo 'dclint@$(DCLINT_VERSION)' "$(SOURCE_DESCRIPTOR)" | wc -l | tr -d ' ' || true); \
	[[ "$$count" == 1 ]] || { \
		printf 'Expected exactly one dclint@%s installation pin; found %s\n' "$(DCLINT_VERSION)" "$$count" >&2; \
		exit 1; \
	}
	@mkdir -p "$(DIST_DIR)"
	@tmp="$(DIST_DESCRIPTOR).tmp"; \
	trap 'rm -f "$$tmp"' EXIT; \
	{ \
		IFS= read -r first_line; \
		printf '%s\n' "$$first_line"; \
		printf '%s\n' '# Generated release artifact. Do not edit directly.'; \
		printf '# Release version: v%s\n' "$(VERSION)"; \
		printf '# Source commit: %s\n' "$(BUILD_REF)"; \
		while IFS= read -r line || [[ -n "$$line" ]]; do printf '%s\n' "$$line"; done; \
	} < "$(SOURCE_DESCRIPTOR)" > "$$tmp"; \
	mv "$$tmp" "$(DIST_DESCRIPTOR)"; \
	trap - EXIT
	@digest=''; \
	if command -v sha256sum >/dev/null 2>&1; then \
		read -r digest _ < <(sha256sum "$(DIST_DESCRIPTOR)"); \
	elif command -v shasum >/dev/null 2>&1; then \
		read -r digest _ < <(shasum -a 256 "$(DIST_DESCRIPTOR)"); \
	else \
		printf '%s\n' 'No SHA-256 command is available for release checksums.' >&2; \
		exit 1; \
	fi; \
	printf '%s  %s\n' "$$digest" "$(notdir $(DIST_DESCRIPTOR))" > "$(DIST_CHECKSUM).tmp"; \
	mv "$(DIST_CHECKSUM).tmp" "$(DIST_CHECKSUM)"

test:
	rm -rf "$(TEST_RESULTS_DIR)"
	mkdir -p "$(TEST_RESULTS_DIR)/unit"
	bats \
		--formatter tap \
		--report-formatter junit \
		--output "$(TEST_RESULTS_DIR)/unit" \
		tests/descriptor.bats \
		tests/release.bats

validate:
	MEGALINTER_IMAGE="$(MEGALINTER_IMAGE)" tests/validate.bash "$(SOURCE_DESCRIPTOR)"

validate-release: build
	MEGALINTER_IMAGE="$(MEGALINTER_IMAGE)" tests/validate.bash "$(DIST_DESCRIPTOR)"
	@cd "$(DIST_DIR)" && sha256sum -c "$(notdir $(DIST_CHECKSUM))"

integration-test: build
	DCLINT_DESCRIPTOR="$(DIST_DESCRIPTOR)" \
	MEGALINTER_IMAGE="$(MEGALINTER_IMAGE)" \
	tests/megalinter.bash

clean:
	rm -rf "$(DIST_DIR)" "$(TEST_RESULTS_DIR)"
