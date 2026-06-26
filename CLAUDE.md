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

## Feature: Moliendas

### Arquitectura
- Colección Firestore: /moliendas/{moliendaId}
- Subcolección: /moliendas/{moliendaId}/entregas/{entregaId}
- Búsqueda por QR: collectionGroup('entregas').where('qrToken', isEqualTo: qrToken)

### Entidades (packages/core/lib/features/molienda/domain/entities/)
- Molienda: id, nombre, telefono, creadoEn
- Entrega: id, moliendaId, produccionId, fechaEntrega, qrToken

### Providers (packages/core/lib/features/molienda/providers/molienda_providers.dart)
- moliendaDatasourceProvider
- moliendaRepositoryProvider
- moliendaItemsProvider (Stream)
- syncMoliendaItemsProvider (lista sincrónica para dropdowns)
- moliendaEntregasProvider(moliendaId) (Stream con parámetro)
- MoliendaForm notifier: save(isNew), delete, createEntrega

### Navegación web
- Ruta: Routes.moliendas = '/moliendas' → WebMoliendaPage (selectedIndex: 3 en WebLayout)
- Ruta: Routes.loteDetail = '/lote' → /lote/:produccionId → WebLoteDetailPage (sin WebLayout)
- Ruta: /moliendas/:moliendaId/entrega/:entregaId → WebEntregaDetailPage (sin WebLayout)
- NavigationRail índice 3 en web_layout.dart
- Manejado en web_inventory_page.dart y web_project_selector_page.dart
- PopupMenu en mobile_project_selector_page.dart (solo admin)

### Pantallas web (apps/web/lib/feature/molienda/)
Cada pantalla tiene variante mobile_*.dart (ListView/Cards, ModalBottomSheet) y web_*.dart (DataTable, Dialog), servidas por AdaptiveLayout en el router — igual que el resto de features en apps/web/.

- mobile_molienda_page.dart / web_molienda_page.dart — lista de moliendas, CRUD
- mobile_lote_detail_page.dart / web_lote_detail_page.dart — vista del lote escaneado, sin NavigationRail
- mobile_entrega_detail_page.dart / web_entrega_detail_page.dart — muestra QrImageView(data: entrega.qrToken), fecha y botón "Ver lote"
- molienda_form_dialog.dart — formulario crear/editar compartido entre variantes

### QR
- Paquete: qr_flutter ^4.1.0 (agregado en packages/core/pubspec.yaml)
- El QR usa entrega.qrToken como data de QrImageView

### Stage1FormData y Stage1FormModel
- Campo moliendaId: String? agregado en Stage1FormData (después de name)
- Stage1FormModel: moliendaId mapeado en fromJson, toJson, fromEntity, toEntity (patrón igual que photoPath)
- web_stage1_form.dart usa CustomFromDropdown<Molienda> con syncMoliendaItemsProvider
- Al guardar Stage1, se crea automáticamente una Entrega si moliendaId != null

### Búsqueda de lote por ID
- stage1ProjectByIdRemoteProvider(String id) — FutureProvider.family
- Busca directamente en Firestore por id, NO usa la lista paginada en memoria
- El provider síncrono stage1ProjectByIdProvider sigue igual (no tocar)

### Tests
- test/unit/feature/molienda/data/molienda_model_test.dart (10 tests)
- test/unit/feature/molienda/data/molienda_repository_impl_test.dart (9 tests)
- test/unit/feature/molienda/data/stage1_form_model_molienda_id_test.dart (8 tests)
- test/widget/web_lote_detail_page_test.dart (3 tests)
- test/widget/web_entrega_detail_page_test.dart (2 tests)
- Total proyecto: 179/179 en verde

### Patrones aprendidos
- No modificar archivos existentes masivamente; cambios puntuales por archivo
- La app principal es web; mobile está desactualizado y no se toca
- onDestinationSelected en páginas que no manejan un índice simplemente no hace nada
- stage1ProjectByIdProvider (síncrono, paginado) ≠ stage1ProjectByIdRemoteProvider (Firestore directo)

### Escáner QR (qr_scanner_page.dart)
- Implementación WebRTC propia (sin mobile_scanner ni camera plugin)
- Mismo patrón que camera_preview_screen_web.dart: getUserMedia + HTMLVideoElement + ui_web.platformViewRegistry
- Decodificación con zxing_lib ^1.1.4 (agregado en packages/core/pubspec.yaml)
- Timer.periodic cada 600ms: captura frame con HTMLCanvasElement → getImageData RGBA → RGBLuminanceSource → BinaryBitmap → QRCodeReader
- Al detectar token: getEntregaByQrToken → navega a loteDetail
- Ruta: /qr-scanner (name: 'qrScanner', sin AdaptiveLayout)
- Acceso: PopupMenu en mobile_project_selector_page.dart y botón en web_project_selector_page.dart

### Compartir QR como imagen
- Captura PNG con RepaintBoundary + GlobalKey → toImage(pixelRatio:3) → toByteData
- Export condicional (patrón idéntico a web_download.dart):
  - qr_share.dart — barrel con if (dart.library.js_interop)
  - qr_share_web.dart — Web Share API nativa con navigator.canShare/share + fallback a descarga Blob
  - qr_share_stub.dart — stub vacío para VM/tests
- NUNCA usar dart:html (obsoleto) ni Share.shareXFiles en --release (falla en web)
- Web Share API solo funciona en HTTPS — en local (HTTP) siempre cae al fallback de descarga

### Índice Firestore requerido
- collectionGroup('entregas') con where('qrToken') requiere un índice COLLECTION_GROUP_ASC
- Sin el índice Firestore lanza failed-precondition silenciosamente (retorna vacío)
- Crear en: Firebase Console → Firestore → Indexes → Collection group: entregas, campo: qrToken ASC
