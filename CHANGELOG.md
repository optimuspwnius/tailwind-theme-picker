# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/), and this project adheres to [Semantic Versioning](https://semver.org/).

## [0.1.3] - 2026-05-13

### Fixed

- `NameError: uninitialized constant TailwindThemePicker::ViewHelper` when running generators or booting apps where `ActionView` loads before the engine's autoload paths are registered with Zeitwerk. The helper is now required explicitly from the engine.

## [0.1.0] - 2026-05-13

### Added

- Initial release
