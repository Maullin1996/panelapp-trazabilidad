# PanelApp – Sistema de trazabilidad


Aplicación móvil para gestionar procesos productivos y control de inventario en entornos reales.

## 🟢 Problema

Las empresas llevaban control manual de insumos y producción, generando pérdidas e inconsistencias en la trazabilidad. Sin visibilidad en tiempo real, era imposible validar el flujo de operaciones.

## 🟢 Solución

Aplicación móvil que permite registrar, validar y monitorear el flujo de producción en tiempo real. Cada etapa del proceso queda registrada con validaciones automáticas y trazabilidad completa.

## 🟢 Funcionalidades

- **Registro de insumos**: Captura detallada en cada etapa del proceso
- **Control de inventario**: Seguimiento en tiempo real de materiales
- **Validación de peso**: Comparación entre peso esperado vs real
- **Registro fotográfico**: Evidencia visual de cada operación
- **Dashboard de métricas**: Visualización de KPIs y tendencias
- **Gestión de usuarios por roles**: Autenticación y permisos granulares
- **Persistencia offline**: Sincronización automática con Firebase
- **Panel administrativo**: Gestión de configuración y usuarios

## 🟢 Tecnologías

- **Flutter** (SDK >= 3.8.1)
- **Firebase**: Auth, Firestore, Storage, Cloud Functions
- **Riverpod**: Gestión de estado
- **GoRouter**: Navegación
- **Build Runner**: Generación de código

## 🟢 Mi rol

Desarrollo completo de la aplicación:
- Arquitectura frontend con Riverpod y GoRouter
- Integración con Firebase (Auth, Firestore, Storage)
- Implementación de flujos por etapas (stage1-stage5)
- Formularios y validaciones
- Sistema de captura de imágenes
- Generación de reportes en PDF
- Testing (unit e integration tests)

## 🟢 Demo

[Ver demostración en video](https://link-to-video.com)

## 🟢 Estado

✅ Aplicación en uso con usuarios reales en producción.

---

## Detalles técnicos

### Arquitectura
- `lib/core`: Router, servicios y utilidades base
- `lib/shared`: Tema, widgets reutilizables y utilidades
- `lib/features`: Módulos por funcionalidad (auth, admin, etapas 1-5)

### Requisitos
- Flutter SDK instalado (>= 3.8.1)
- Firebase configurado:
  - Android: `android/app/google-services.json`
  - iOS: `ios/Runner/GoogleService-Info.plist`
- Conexión de internet para sincronización

### Instalación y uso
```bash
# Instalar dependencias
flutter pub get

# Generar código
flutter pub run build_runner build --delete-conflicting-outputs

# Ejecutar la app
flutter run

# Tests
flutter test
flutter test integration_test
```

### Estructura del proyecto
```
lib/
  core/
    router/
    services/
    storage/
  features/
    admin/
    auth/
    stage1_delivery/
    stage2_load/
    stage3_weigh/
    stage4_recollection/
    stage5_*/
  shared/
    theme/
    utils/
    widgets/
```

---

## 📸 Capturas de pantalla

### Autenticación

<img src="assets/images/logo.png" alt="Logo" width="200"/>
<img src="assets/images/login.png" alt="Login" width="200"/>

### Selección

<img src="assets/images/project_selector.png" alt="Selector de proyecto" width="200"/>
<img src="assets/images/project_selector_2.png" alt="Selector de proyecto 2" width="200"/>
<img src="assets/images/stage_selector.png" alt="Selector de etapa" width="200"/>

### Stage 1 - Entrega

<img src="assets/images/stage1_delivery.png" alt="Stage 1" width="200"/>
<img src="assets/images/stage1_delivery_2.png" alt="Stage 1 - 2" width="200"/>
<img src="assets/images/stage1_delivery_3.png" alt="Stage 1 - 3" width="200"/>

### Stage 2 - Carga

<img src="assets/images/stage2_load.png" alt="Stage 2" width="200"/>
<img src="assets/images/stage2_load_2.png" alt="Stage 2 - 2" width="200"/>
<img src="assets/images/stage2_load_3.png" alt="Stage 2 - 3" width="200"/>

### Stage 3 - Pesaje

<img src="assets/images/stage3_weigh.png" alt="Stage 3" width="200"/>
<img src="assets/images/stage3_weigh_2.png" alt="Stage 3 - 2" width="200"/>
<img src="assets/images/stage3_weigh_3.png" alt="Stage 3 - 3" width="200"/>
<img src="assets/images/stage3_weigh_4.png" alt="Stage 3 - 4" width="200"/>

### Stage 4 - Recolección

<img src="assets/images/stage4_recollection.png" alt="Stage 4" width="200"/>
<img src="assets/images/stage4_recollection_2.png" alt="Stage 4 - 2" width="200"/>
<img src="assets/images/stage4_recollection_3.png" alt="Stage 4 - 3" width="200"/>
<img src="assets/images/stage4_recollection_4.png" alt="Stage 4 - 4" width="200"/>

### Stage 5 - Cierre

<img src="assets/images/stage5.png" alt="Stage 5" width="200"/>

### Stage 5 - Peso faltante

<img src="assets/images/stage5_1_missing_weight.png" alt="Stage 5 - Peso faltante" width="200"/>
<img src="assets/images/stage5_1_missing_weight_2.png" alt="Stage 5 - Peso faltante 2" width="200"/>
<img src="assets/images/stage5_1_missing_weight_3.png" alt="Stage 5 - Peso faltante 3" width="200"/>

### Stage 5 - Resumen

<img src="assets/images/stage5_summary.png" alt="Stage 5 - Resumen" width="200"/>
<img src="assets/images/stage5_summary_2.png" alt="Stage 5 - Resumen 2" width="200"/>
<img src="assets/images/stage5_summary_3.png" alt="Stage 5 - Resumen 3" width="200"/>
<img src="assets/images/stage5_summary_4.png" alt="Stage 5 - Resumen 4" width="200"/>

### Utilidades

<img src="assets/images/camera.png" alt="Cámara" width="200"/>
<img src="assets/images/cambio%20de%20contrase%C3%B1a%20de%20usuarios.png" alt="Admin - Reset de contraseña" width="200"/>
