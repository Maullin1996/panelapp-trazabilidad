# Registro Panela

Aplicacion Flutter para registrar y hacer seguimiento de un flujo por etapas (entrega, carga, pesaje, recoleccion y cierre), con autenticacion y almacenamiento en Firebase.

**Contenido**
1. Descripcion
2. Funcionalidades
3. Stack y dependencias clave
4. Arquitectura
5. Requisitos y configuracion
6. Comandos utiles
7. Estructura del proyecto
8. Capturas de pantalla

**Descripcion**
Registro Panela es una app movil construida en Flutter. Usa Firebase (Auth, Firestore, Storage, Functions) para autenticacion, persistencia y archivos. La navegacion esta basada en GoRouter y el estado en Riverpod. El flujo principal esta organizado por etapas (stage1 a stage5) con pantallas de detalle, formularios y resumenes.

**Funcionalidades**
- Login y gestion de sesion.
- Selector de proyecto y selector de etapa.
- Registro por etapas: entrega (stage1), carga (stage2), pesaje (stage3), recoleccion (stage4) y cierre (stage5).
- Formularios y resumenes por etapa.
- Registro de peso faltante y resumen final.
- Visualizacion de imagenes y uso de camara.
- Panel administrativo con reinicio de contrasena.
- Persistencia offline de Firestore habilitada.

**Stack y dependencias clave**
- Flutter SDK (>= 3.8.1)
- Firebase: `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `cloud_functions`
- Estado: `flutter_riverpod`
- Navegacion: `go_router`
- Formularios: `flutter_form_builder`, `form_builder_validators`
- Camara e imagenes: `camera`, `image_picker`, `flutter_image_compress`, `cached_network_image`
- Reportes: `pdf`, `printing`, `share_plus`
- Serializacion y codigo generado: `freezed`, `json_serializable`, `build_runner`

**Arquitectura**
- `lib/core`: router, servicios y utilidades base.
- `lib/shared`: tema, widgets reutilizables y utilidades.
- `lib/features`: modulos por funcionalidad (auth, admin, selector de proyecto, etapas 1-5, etc.).
- `lib/firebase_options.dart`: configuracion generada por FlutterFire.

**Requisitos y configuracion**
1. Flutter SDK instalado (compatible con `sdk: ^3.8.1`).
2. Configuracion de Firebase.
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`
   - Si deseas correr en web, considera inicializar con `DefaultFirebaseOptions.currentPlatform`.
3. Dependencias instaladas con `flutter pub get`.

**Comandos utiles**
```bash
flutter pub get
flutter run
```

Generacion de codigo:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Iconos y splash:
```bash
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create
```

Tests:
```bash
flutter test
flutter test integration_test
```

**Estructura del proyecto**
```text
lib/
  core/
    router/
    services/
    storage/
  features/
    admin/
    auth/
    image_view/
    project_selector/
    splash/
    stage_selector/
    stage1_delivery/
    stage2_load/
    stage3_weigh/
    stage4_recollection/
    stage5/
    stage5_1_missing_weight/
    stage5_2_records/
    stage5_summary/
  shared/
    theme/
    utils/
    widgets/
  firebase_options.dart
  main.dart
assets/
  images/
```

**Capturas de pantalla**
**Logo**
![Logo](assets/images/logo.png)

**Login**
![Login](assets/images/login.png)

**Selector de proyecto**
![Project selector](assets/images/project_selector.png)
![Project selector 2](assets/images/project_selector_2.png)

**Selector de etapa**
![Stage selector](assets/images/stage_selector.png)

**Stage 1 - Entrega**
![Stage1](assets/images/stage1_delivery.png)
![Stage1 2](assets/images/stage1_delivery_2.png)
![Stage1 3](assets/images/stage1_delivery_3.png)

**Stage 2 - Carga**
![Stage2](assets/images/stage2_load.png)
![Stage2 2](assets/images/stage2_load_2.png)
![Stage2 3](assets/images/stage2_load_3.png)

**Stage 3 - Pesaje**
![Stage3](assets/images/stage3_weigh.png)
![Stage3 2](assets/images/stage3_weigh_2.png)
![Stage3 3](assets/images/stage3_weigh_3.png)
![Stage3 4](assets/images/stage3_weigh_4.png)

**Stage 4 - Recoleccion**
![Stage4](assets/images/stage4_recollection.png)
![Stage4 2](assets/images/stage4_recollection_2.png)
![Stage4 3](assets/images/stage4_recollection_3.png)
![Stage4 4](assets/images/stage4_recollection_4.png)

**Stage 5 - Cierre**
![Stage5](assets/images/stage5.png)

**Stage 5 - Peso faltante**
![Stage5 missing weight](assets/images/stage5_1_missing_weight.png)
![Stage5 missing weight 2](assets/images/stage5_1_missing_weight_2.png)
![Stage5 missing weight 3](assets/images/stage5_1_missing_weight_3.png)

**Stage 5 - Resumen**
![Stage5 summary](assets/images/stage5_summary.png)
![Stage5 summary 2](assets/images/stage5_summary_2.png)
![Stage5 summary 3](assets/images/stage5_summary_3.png)
![Stage5 summary 4](assets/images/stage5_summary_4.png)

**Camara**
![Camera](assets/images/camera.png)

**Administracion - Reset de contrasena**
![Admin reset password](assets/images/cambio%20de%20contrase%C3%B1a%20de%20usuarios.png)
