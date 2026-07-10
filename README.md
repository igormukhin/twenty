# Twenty

[![Build Windows][windows_build_badge]][windows_build_link]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Twenty is an open-source Windows application that helps you follow the
[20-20-20 rule](https://www.medicalnewstoday.com/articles/321536): take regular
breaks, look into the distance, and reduce digital eye strain.

> [!NOTE]
> This repository is a fork of the archived
> [RoundedInfinity/twenty](https://github.com/RoundedInfinity/twenty) project.
> This fork continues Windows maintenance and provides reproducible Windows
> builds and installer packaging. It is an independent community fork, not an
> official release channel of the upstream project.

## What this fork changes

- Adds a GitHub Actions workflow that analyzes the project, builds the Windows
  application, creates an Inno Setup installer, and uploads build artifacts.
  It runs on pushes to `main`, can be started manually, and publishes permanent
  GitHub Release assets for version tags.
- Provides both a per-user Windows installer and a portable ZIP archive.
- Fixes **Launch at startup** for installer and portable builds. The app now
  writes directly to the current user's Windows Run registry key and verifies
  the resulting state. This addresses
  [upstream issue #9](https://github.com/RoundedInfinity/twenty/issues/9).
- Keeps Microsoft Store/MSIX startup registration support for packaged builds.

## Features

- Visual and audible notifications that remind you to relax your eyes
- A native Windows design
- Configurable reminder and appearance settings
- Optional launch at Windows sign-in
- Free and open-source software under the MIT license

## Download and install

The Windows build runs on 64-bit Windows 10 or later. For a stable build:

1. Open [GitHub Releases](https://github.com/igormukhin/twenty/releases).
2. Select the latest release.
3. Download and run `TwentySetup.exe`.

The installer is per-user, does not require administrator privileges, and
installs Twenty under `%LOCALAPPDATA%\Programs\Twenty`. The
`twenty-windows-release.zip` asset from the same release contains the portable
build.

> [!WARNING]
> The installer is community-built and is not currently digitally signed.
> Windows may display an unknown-publisher or Microsoft Defender SmartScreen
> warning. Install and use it at your own risk. Verify that the artifact came
> from this repository's successful workflow, review the source, or build it
> yourself if you require stronger assurance. The software is provided without
> warranty under the terms of the MIT license.

Preview builds are available from the
[Windows build workflow](https://github.com/igormukhin/twenty/actions/workflows/build-windows.yaml),
but workflow artifacts are retained for a limited time. Files attached to a
GitHub Release do not have that artifact expiration period.

## Screenshots

![Screenshot of a Twenty notification](./doc/screenshots/toast.png)
![Screenshot of Twenty onboarding](./doc/screenshots/onboarding.png)

## Build locally

Install the
[Flutter SDK](https://docs.flutter.dev/get-started/install/windows/desktop) and
the Windows desktop development prerequisites, then run:

```powershell
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
flutter build windows --release --target lib/main_production.dart
```

For development:

```powershell
flutter run -d windows -t lib/main_development.dart
```

The installer is defined in
[`installer/windows/twenty.iss`](./installer/windows/twenty.iss) and built with
[Inno Setup 6](https://jrsoftware.org/isinfo.php). The
[`build-windows` workflow](./.github/workflows/build-windows.yaml) is the
reference packaging process.

## Contributing

Contributions and focused bug reports are welcome. Please
[open issues in this fork](https://github.com/igormukhin/twenty/issues) rather
than in the archived upstream repository. This fork currently targets Windows
desktop; changes should keep `flutter analyze` clean and include tests for new
or corrected behavior where practical.

The original project and its contributors remain credited through the Git
history and upstream repository. Fork-specific changes are maintained here.

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[windows_build_badge]: https://github.com/igormukhin/twenty/actions/workflows/build-windows.yaml/badge.svg
[windows_build_link]: https://github.com/igormukhin/twenty/actions/workflows/build-windows.yaml
