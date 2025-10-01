# mega-linter-plugin-dclint

[![MegaLinter](https://github.com/wesley-dean/mega-linter-plugin-dclint/actions/workflows/megalinter.yml/badge.svg)](https://github.com/wesley-dean/mega-linter-plugin-dclint/actions/workflows/megalinter.yml)
[![Dependabot Updates](https://github.com/wesley-dean/mega-linter-plugin-dclint/actions/workflows/dependabot/dependabot-updates/badge.svg)](https://github.com/wesley-dean/mega-linter-plugin-dclint/actions/workflows/dependabot/dependabot-updates)
[![Scorecard supply-chain security](https://github.com/wesley-dean/mega-linter-plugin-dclint/actions/workflows/scorecard.yml/badge.svg)](https://github.com/wesley-dean/mega-linter-plugin-dclint/actions/workflows/scorecard.yml)


This is a MegaLinter plugin for docker-compose-lint (dclint)

## Introduction

[MegaLinter](https://github.com/oxsecurity/megalinter) by
[OxSecurity](https://github.com/oxsecurity) is a linter tool that supports
various programming languages and file formats. This repository contains a
MegaLinter plugin for
[docker-compose-lint](https://github.com/zavoloklom/docker-compose-linter) by
[zavoloklom](https://github.com/zavoloklom/).

The docker-compose-linter (`dclint`) tool is a linter for Docker Compose files.
It checks for common errors and best practices in Docker Compose files.

## Usage

To use this plugin, you need to have MegaLinter installed. Please refer to the
[MegaLinter documentation](https://nvuillam.github.io/megalinter/) for
installation instructions.

### MegaLinter Configuration

To use this plugin, add the following to your MegaLinter configuration:

```yaml
PLUGINS:
  - "https://raw.githubusercontent.com/wesley-dean/mega-linter-plugin-dclint/refs/heads/main/mega-linter-plugin-dclint/dclint.megalinter-descriptor.yml
```

Simply adding the plugin to the `PLUGINS` section will cause MegaLiner to read
the descriptor and make it available for use.  However, depending on your
MegaLinter configuration, you may need to enable the linter in the `ENABLE_LINTERS`
section as well.  For example:

```yaml
ENABLE_LINTERS:
  - "DOCKERFILE_DCLINT"
```

### Docker-Compose-Lint Configuration

To configure docker-compose-lint, you can create a `.dclintrc` file in the
root of your repository. For more information on configuring, refer to the
[docker-compose-lint documentation](https://github.com/zavoloklom/docker-compose-linter/blob/main/README.md)


### Passing Options to dclint

If you want to pass command line arguments along to the docker-compose linter,
pass a string with the arguments using the `DOCKERFILE_DCLINT_ARGUMENTS`
variable.

```YAML
# append `--fix` to the end of the `dclint` command
DOCKERFILE_DCLINT_ARGUMENTS: "--fix"
```
