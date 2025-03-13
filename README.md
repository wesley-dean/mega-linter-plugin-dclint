# mega-linter-plugin-dclint

[![MegaLinter](https://github.com/wesley-dean/mega-linter-plugin-dclint/actions/workflows/megalinter.yml/badge.svg)](https://github.com/wesley-dean/mega-linter-plugin-dclint/actions/workflows/megalinter.yml)
[![Dependabot Updates](https://github.com/wesley-dean/mega-linter-plugin-dclint/actions/workflows/dependabot/dependabot-updates/badge.svg)](https://github.com/wesley-dean/mega-linter-plugin-dclint/actions/workflows/dependabot/dependabot-updates)



This is a MegaLinter plugin for docker-compose-lint (dclint)

## Introduction

[MegaLinter](https://github.com/oxsecurity/megalinter) by
[OxSecurity](https://github.com/oxsecurity) is a linter tool that supports
various programming languages and file formats. This repository contains a
MegaLinter plugin for
[docker-compose-lint](https://github.com/zavoloklom/docker-compose-linter) by
[zavoloklom](https://github.com/zavoloklom/).

## Usage

To use this plugin, you need to have MegaLinter installed. Please refer to the
[MegaLinter documentation](https://nvuillam.github.io/megalinter/) for
installation instructions.

### MegaLinter Configuration

To use this plugin, add the following to your MegaLinter configuration:

```yaml
ENABLE_LINTERS: "dclint"
```

and

```yaml
PLUGINS:
  - "https://raw.githubusercontent.com/wesley-dean/mega-linter-plugin-dclint/refs/heads/main/mega-linter-plugin-dclint/dclint.megalinter-descriptor.yml
```

### Docker-Compose-Lint Configuration

To configure docker-compose-lint, you can create a `.dclintrc` file in the
root of your repository. For more information on configuring, refer to the
[docker-compose-lint documentation](https://github.com/zavoloklom/docker-compose-linter/blob/main/README.md)
