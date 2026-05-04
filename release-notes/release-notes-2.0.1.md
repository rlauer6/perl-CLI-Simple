# CLI::Simple 2.0.1 Release Notes

## Overview

A maintenance release syncing `CLI::Simple` with the updated
`CPAN::Maker::Bootstrapper` 2.0.1 toolchain. The primary change is the
replacement of `YAML::XS` with `YAML::Tiny` throughout, reducing the
dependency footprint by eliminating the `libyaml` system library
requirement. The CI pipeline is also substantially improved.

---

## What's New

**`make workflow` and `make build-ci`**

The updated Bootstrapper managed `Makefile` brings in the full CI
target set introduced in Bootstrapper 2.0.1:

- `make workflow` - installs `builder`, `build-requires`, and
  `.github/workflows/build.yml` from the Bootstrapper share directory
- `make build-ci` - runs the full CI build locally inside a fresh
  Docker container, teed to a timestamped log file
- `make update-available` - checks for newer Bootstrapper versions at
  build time; runs automatically as part of the default `make` target

**`$FAT_ARROW` added to `CLI::Simple::Constants`**

`$FAT_ARROW` (`=>`) is now exported from the `:all` tag alongside the
other punctuation constants.

---

## Changes

**`YAML::XS` replaced by `YAML::Tiny` throughout**

Every `YAML::XS` reference in `CLI::Simple`, `CLI::Simple::Helpers`,
`CLI::Simple::Scaffold`, and `t/cli-simple-manifest.t` has been
updated to `YAML::Tiny`. `YAML::XS` is removed from `requires`,
`test-requires`, `build-requires`, and `cpanfile`.

** `Archive::Tar` is removed from `requires` - it is in core since 5.9

**`buildspec.yml` normalized to hyphenated keys**

Underscore-style keys updated to their canonical hyphenated forms:
`pm_module` => `pm-module`, `test_requires` => `test-requires`,
`exe_files` => `exe-files`.

**GitHub Actions workflow hardened**

Synced with Bootstrapper 2.0.1: pre-installs `git` before the
checkout step, configures `safe.directory` to prevent ownership errors
in containerized builds, adds `dev` to the push trigger alongside
`main`, and switches from the old `./build-github` invocation to
`./builder`.

**`builder` replaces `build-github`**

The minimal `build-github` stub is replaced by the full `builder`
script from Bootstrapper 2.0.1, with support for `cpm` and `cpanm`
installers, declarative mirror and apt-dep files, perltidy and
perlcritic integration, and local CI via `make build-ci`.

**`perl.mk` - temp file cleanup fix**

`check_syntax_pm` and `check_syntax_pl` no longer use `trap ... EXIT`
for temp file cleanup inside `define` blocks, where `EXIT` fires
unexpectedly at the end of each recipe step rather than at shell exit.
Temp files are now tracked in `local_cleanfiles` and cleaned at the
end of the recipe.

**`CLI::Simple::Utils` - POD typo fixed**

`=head1 NAAME` corrected to `=head1 NAME`.

---

## Dependencies

**Removed:** `YAML::XS`, `Archive::Tar`

**Added:** `YAML::Tiny 1.76`
