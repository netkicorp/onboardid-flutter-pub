# OnboardID Flutter SDK (Distribution)

## Project Overview
This is the **distribution repository** for the OnboardID Flutter SDK. It contains the publishable Flutter package that customers integrate into their apps.

**Source repository:** `onboardid-flutter` (private)
**This repository:** Public distribution for customer integration

## Integration

Customers add this to their `pubspec.yaml`:

```yaml
dependencies:
  netki_sdk:
    git:
      url: https://github.com/netkicorp/onboardid-flutter-pub.git
      ref: v11.0.0  # Use specific version tag
```

For beta versions:
```yaml
dependencies:
  netki_sdk:
    git:
      url: https://github.com/netkicorp/onboardid-flutter-pub.git
      ref: 11.0.0-beta.42  # Beta version tag
```

## How Updates Work

```
onboardid-flutter (source, private)
        │
        ▼ builds & copies
onboardid-flutter-pub (this repo, public)
        │
        ▼ creates release
GitHub Release + Tag
        │
        ▼ callbacks
mobile-platform-hub (tracks release)
```

## Versioning

| Type | Format | Example |
|------|--------|---------|
| Beta | `X.Y.Z-beta.N` | `11.0.0-beta.42` |
| Production | `vX.Y.Z` | `v11.0.0` |

## Branch Strategy

- `main` - Production releases
- `qa` - Beta/QA releases
- Beta versions are branches, production versions are tags

## DO NOT

- **Do not edit this repo directly** - all changes come from onboardid-flutter
- **Do not add example apps** - this is distribution only
- **Do not add internal documentation** - this is public

## Workflows

| Workflow | Trigger | Action |
|----------|---------|--------|
| `create-release.yml` | Tag push (v* or *-beta.*) | Validates package only |

**Note:** This repo has NO secrets. All release logic (push, tag, release creation, Slack, hub callback) is handled by `onboardid-flutter` source repo. This repo is treated like an external platform (similar to npm, CocoaPods, pub.dev).

## Related Repositories

| Repository | Purpose |
|------------|---------|
| `onboardid-flutter` | Source code (private) |
| `onboardid-android` | Android SDK source |
| `onboardid-ios` | iOS SDK source |
| `mobile-platform-hub` | Release coordination |
