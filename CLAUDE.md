# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Registro Panela** is a Flutter monorepo (managed with Melos) for tracking panela production workflows. It has a mobile app and a web app sharing a `core` package, backed by Firebase.

> **Active development scope:** `apps/web` only. The `apps/mobile` app is paused — do not modify it.

## Monorepo Structure

```
registro_panela/
├── melos.yaml               # Monorepo config
├── apps/
│   ├── mobile/              # Flutter mobile app (Android/iOS)
│   └── web/                 # Flutter web app
├── packages/
│   └── core/                # Shared business logic, entities, providers, widgets
└── functions/               # Firebase Cloud Functions (TypeScript)
```

## Common Commands

### Monorepo bootstrap (run after cloning or adding packages)
```bash
melos bootstrap
```

### Run apps
```bash
# Mobile
cd apps/mobile && flutter run

# Web
cd apps/web && flutter run -d chrome
```

### Code generation (Freezed, Riverpod, json_serializable)
Run this inside `packages/core` or any package that uses `build_runner`:
```bash
cd packages/core
dart run build_runner build --delete-conflicting-outputs

# Watch mode
dart run build_runner watch --delete-conflicting-outputs
```

### Lint
```bash
flutter analyze
```

### Tests
```bash
cd packages/core && flutter test
```

### Firebase Functions (TypeScript)
```bash
cd functions
npm install
npm run build       # compile TypeScript
npm run serve       # local emulator
firebase deploy --only functions
```

## Architecture

### Core Package (`packages/core`)

All business logic lives here. Features follow clean architecture:

```
packages/core/lib/features/<feature_name>/
├── data/
│   ├── datasources/    # Firestore queries
│   ├── models/         # JSON serializable models (toJson/fromJson)
│   └── repositories_impl/
├── domain/
│   ├── entities/       # Freezed immutable data classes
│   ├── repositories/   # Abstract interfaces
│   └── usecases/       # Single-responsibility use case classes
└── providers/          # Riverpod providers (riverpod_annotation, @riverpod)
```

Shared UI that both apps use lives in `packages/core/lib/shared/`.

### App Layer

Each app (`mobile`, `web`) only contains:
- `main.dart` — Firebase init, `ProviderScope`, `MaterialApp.router`
- `router/app_router.dart` — GoRouter config with `authRedirect`
- `feature/` — Platform-specific page widgets

### Responsive UI (web app)

Within `apps/web`, every route has **two layout variants** served by `AdaptiveLayout` (breakpoint 600px by default):

| Variant | File prefix | Screen target |
|---|---|---|
| Small-screen | `mobile_*.dart` | phones / narrow browser |
| Large-screen | `web_*.dart` | desktop / tablet |

```dart
AdaptiveLayout(
  mobile: MobileSomePage(),   // small screens
  web: WebSomePage(),          // desktop/tablet
)
```

Large-screen pages use `WebLayout` (side `NavigationRail`) from `apps/web/lib/feature/shared/web_layout.dart`. When adding or changing a feature, always update **both** variants.

### State Management

Riverpod with code generation (`@riverpod`, `riverpod_annotation`). Providers live in `packages/core/lib/features/<feature>/providers/`. Generated files end in `.g.dart` — never edit them manually.

Auth state is in `Auth` notifier (`packages/core/lib/features/auth/providers/auth_provider.dart`), kept alive with `@Riverpod(keepAlive: true)`. GoRouter uses `GoRouterNotifier` + `authRedirect` for route guards.

### Data Models

Entities use `freezed` + `json_serializable`. Every entity has three files:
- `entity.dart` — source with `@freezed` annotation
- `entity.freezed.dart` — generated copyWith/equality
- `entity.g.dart` — generated fromJson/toJson

After modifying any entity, re-run `build_runner`.

### Firestore Collections

| Collection | Stage |
|---|---|
| `stage1` | Delivery registration (gaveras, baskets, preservatives) |
| `stage2` | Load data |
| `stage3` | Weighing |
| `stage4` | Recollection |
| `stage5` | Invoice/summary |
| `users` | User profiles with `role` field |
| `inventory` | Gaveras and canastillas inventory |

### User Roles

Defined in `packages/core/lib/features/auth/domain/enums/user_role.dart`. The `admin` role is enforced server-side via Firebase custom claims in Cloud Functions (`functions/src/index.ts`).

### Routing

Routes are constants in `packages/core/lib/core/router/routes.dart`. Both apps define their own `routerProvider` but share the same `Routes` constants and `authRedirect` logic from core.

### PDF Generation

`packages/core/lib/features/pdf/helpers/generate_and_share_pdf.dart` — uses the `pdf` and `printing` packages. Web uses a stub (`web_download_stub.dart`) because sharing works differently on web vs mobile.
