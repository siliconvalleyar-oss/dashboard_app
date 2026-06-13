# Dashboard — Flutter SaaS Analytics Dashboard

## Descripción
Dashboard analítico premium Flutter con precios de criptomonedas en vivo, datos de batería/ping reales, modo oscuro/claro, responsive (mobile→ultrawide). 16 widgets con gráficos fl_chart, CustomPainter, y animaciones fluidas.

## Comandos Rápidos
```bash
cd salud_app
flutter pub get
flutter run                    # Desarrollo
flutter build apk --debug      # Android debug
flutter build apk --release    # Android release
```

## Dependencias
```bash
flutter pub add flutter_riverpod fl_chart google_fonts flutter_animate intl battery_plus
```

## Arquitectura
```
lib/
├── main.dart
├── app.dart                       # Shell: sidebar + header + SafeArea responsive
├── core/theme/
│   ├── app_colors.dart            # Paleta dark/light, gradientes
│   └── app_theme.dart             # Material 3, Google Fonts Inter
├── core/constants/app_constants.dart
├── core/extensions/context_extensions.dart  # Breakpoints responsive
├── models/dashboard_models.dart    # 15+ modelos (BottomKpi para crypto, etc.)
├── providers/app_providers.dart    # Riverpod: timers para mock, batería, ping, crypto
├── screens/dashboard_screen.dart   # Grid estático con 16 widgets
├── services/
│   ├── mock_data_service.dart      # Generación + fluctuación (sin crypto)
│   └── live_data_service.dart      # CoinGecko API, batería real, ping real
└── widgets/
    ├── charts/   (6 widgets): line, area, radar, tracking, wave, venn
    ├── cards/   (11 widgets): kpi, progress, circular (crypto), storage, speed, battery, etc.
    ├── header/  (1 widget):  HeaderWidget (búsqueda, theme toggle, notificaciones)
    └── sidebar/ (1 widget):  SidebarWidget (colapsable)
```

## Sistema de Datos en Vivo

### Fuentes de datos
| Timer | Intervalo | Fuente | Qué actualiza |
|-------|-----------|--------|---------------|
| `_mockTimer` | 2s | MockDataService.fluctuate() | KPIs mock (menos crypto) |
| `_batteryTimer` | 5s | LiveDataService.battery_plus | BatteryData real |
| `_pingTimer` | 4s | Process.run('ping') + Process.run('ping -s 1400') | SpeedData real |
| `_cryptoTimer` | 30s | CoinGecko API | bottomKpis (BTC, ETH, SOL, XRP) |

### Animaciones
- `TweenAnimationBuilder` → progreso rings, storage, speed gauge, battery %, completion rate crypto
- `AnimationController.forward(from:0)` → KPI counters, sales rings
- fl_chart `animationDuration` → line/area/radar/donut charts
- `CustomPainter.shouldRepaint` → wave chart
- `flutter_animate` fadeIn/slideY → solo al montar (widget tree estable)

### Reglas de Crypto
- Precios solo se actualizan desde CoinGecko API (cada 30s)
- NO se fluctuán en MockDataService — pasan sin modificar
- CoinGecko: `GET /simple/price?ids=bitcoin,ethereum,solana,ripple&vs_currencies=usd&include_24hr_change=true`
- Fallback a datos mock si la API falla

## Cómo Agregar un Nuevo Widget
1. Agregar datos al modelo `DashboardData` y al `fluctuate()` en `MockDataService`
2. Para datos reales: crear método en `LiveDataService` y timer en `DashboardNotifier`
3. Crear widget en `widgets/cards/` o `widgets/charts/`
4. Usar `ConsumerWidget` para reactividad
5. Agregar al grid estático en `DashboardScreen._gridWidgets`
6. Animación: `TweenAnimationBuilder` para transiciones suaves

## Widgets
| Widget | Animación | Datos |
|--------|-----------|-------|
| Line/Area/Radar/Donut | fl_chart built-in | Mock fluctuado |
| KPI Cards | AnimatedCount + AnimationController | Mock fluctuado |
| Progress Bars | TweenAnimationBuilder | Mock fluctuado |
| Storage Monitor | TweenAnimationBuilder | Mock fluctuado |
| Speed Gauge | TweenAnimationBuilder | Ping real |
| Battery % | TweenAnimationBuilder | battery_plus real |
| Circular Rings (crypto) | TweenAnimationBuilder 1.5s easeOutCubic | CoinGecko API |
| Sales Rings | AnimationController restart | Mock fluctuado |
| Wave Chart | CustomPainter shouldRepaint | Mock fluctuado |
| Yearly Performance | flutter_animate entry | CoinGecko API |

## Temas
- Dark: bg #080808, cards #17171A, texto #FFFFFF/#DADADA/#909090
- Light: bg #F6F8FB, cards #FFFFFF, texto #121212/#4A4A4A/#808080
- Gradientes: cyan→purple, orange→pink, green→blue
- Toggle en header, persiste en provider

## Responsive
| Rango | Columnas | Sidebar |
|-------|----------|---------|
| <600px | 1 | oculta + SafeArea notch |
| 600-1024px | 2 | oculta |
| 1024-1600px | 4 | visible |
| ≥1600px | 6 | visible |

## Assets
- `assets/icons/app_icon.svg` — icono vectorial
- `assets/icons/app_icon.png` — icono PNG 1024×1024
- Launcher icons generados en `android/app/src/main/res/mipmap-*`
