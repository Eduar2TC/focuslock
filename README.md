# FocusLock

Sistema de enforcement de concentración para Android.

FocusLock no es un temporizador Pomodoro. Es un sistema que ayuda al usuario a abandonar físicamente el teléfono durante sesiones de trabajo enfocado.

**INTENTION + ENFORCEMENT + FEEDBACK**

## Características principales

- Sesiones Pomodoro configurables (5-120 minutos)
- Bloqueo de aplicaciones distractoras mediante Accessibility Service
- Persistencia local-first (sin backend)
- Score de rendimiento y streaks
- Dark mode
- UI extremadamente minimalista durante sesiones

## Requisitos

- Flutter 3.13+
- Android SDK 24+ (Android 7.0)
- Java 17

## Instalación

```bash
cd focuslock
flutter pub get
flutter build apk
```

## Arquitectura

Clean Architecture + Feature-first organization:

```
lib/
├── app/                    # App config, routing, DI
├── core/                   # Constants, errors, services, utils
├── features/
│   ├── onboarding/         # Welcome flow
│   ├── focus/              # Session domain + UI
│   ├── apps/               # Blocked apps management
│   ├── settings/           # App configuration
│   ├── statistics/         # Progress tracking
│   └── achievements/       # Milestones
└── shared/                 # Theme, widgets
```

Each feature follows:

```
feature/
├── data/       # datasources, models, repositories
├── domain/     # entities, repositories, usecases
└── presentation/  # pages, widgets, controllers
```

## Stack tecnológico

| Capa | Tecnología |
|------|-----------|
| UI | Flutter + Material 3 |
| State | Riverpod |
| Routing | GoRouter |
| Database | Drift (SQLite) |
| Preferences | SharedPreferences |
| Android | Kotlin + MethodChannel |

## Motor Pomodoro

El temporizador usa `endTimestamp` como fuente de verdad, no `Timer.periodic`. Esto garantiza precisión después de que Android suspende la app.

```dart
remaining = endTimestamp - DateTime.now()
```

## Máquina de estados

```
IDLE → PREPARING → FOCUS → PAUSED → FOCUS
                    ↓
                  BREAK → FOCUS (next cycle)
                    ↓
                COMPLETED
```

## Permisos de Android

| Permiso | Uso |
|---------|-----|
| Usage Access | Detectar aplicación en primer plano |
| Accessibility Service | Intervenir al abrir app bloqueada |
| Foreground Service | Mantener sesión activa en background |
| Notifications | Notificar estado de sesión |

## Testing

```bash
# Unit tests
flutter test

# Widget tests
flutter test test/widget/

# Integration tests
flutter test integration_test/
```

## Estructura de datos

### focus_sessions
| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | int | Primary key |
| task | String | Intención del usuario |
| started_at | DateTime | Inicio de sesión |
| ended_at | DateTime? | Fin de sesión |
| planned_seconds | int | Duración planeada |
| actual_seconds | int | Duración real |
| status | String | Estado actual |
| cycles | int | Ciclos completados |
| interruptions | int | Interrupciones |
| blocked_attempts | int | Intentos de abrir apps bloqueadas |
| score | int | Puntaje de la sesión |

### blocked_apps
| Campo | Tipo | Descripción |
|-------|------|-------------|
| package_name | String | Package de Android |
| app_name | String | Nombre visible |
| enabled | bool | Si está activo |

### session_events
| Campo | Tipo | Descripción |
|-------|------|-------------|
| session_id | int | Referencia a sesión |
| timestamp | DateTime | Cuándo ocurrió |
| type | String | Tipo de evento |
| metadata | String | Datos adicionales (JSON) |

## Foco del producto

> "El usuario debe iniciar FocusLock, dejar el teléfono, y olvidarse de la aplicación hasta que termine la sesión."

Evitar:
- Notificaciones innecesarias
- Gamificación excesiva
- Animaciones distractantes
- Analytics que incentiven revisar el teléfono

## License

MIT
