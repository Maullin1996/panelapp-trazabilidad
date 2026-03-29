# PanelApp – Sistema de trazabilidad de producción

Aplicación móvil utilizada en operación real para gestionar procesos productivos y control de inventario.

## 🚀 Demo
[![Demo](https://img.youtube.com/vi/enNVjhjFtxQ/hqdefault.jpg)](https://youtube.com/shorts/enNVjhjFtxQ)

## 🧩 Problema

El control manual de insumos y producción generaba pérdidas de materiales y falta de trazabilidad en el proceso.

## ✅ Solución

Aplicación móvil que permite registrar, validar y monitorear el flujo de producción en tiempo real.

## ⚙️ Funcionalidades

- Registro de insumos enviados a producción  
- Control de inventario y materiales retornados  
- Validación de peso esperado vs real  
- Registro fotográfico por unidad  
- Dashboard con métricas de producción  
- Gestión de usuarios por roles  

## 🧠 Tecnologías

- Flutter  
- Firebase (Auth, Firestore, Storage)  
- Riverpod  

## 👨‍💻 Mi rol

Desarrollo completo de la aplicación (frontend, lógica y backend).

## 📊 Estado

Aplicación en uso con usuarios reales.

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
