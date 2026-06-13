# SaludSync — Flutter SaaS Analytics Dashboard

## Descripción
Dashboard analítico premium Flutter con datos animados en vivo, modo oscuro/claro, responsive (mobile→ultrawide). 16 widgets con gráficos fl_chart, CustomPainter, y animaciones continuas.

## Comandos Rápidos
```bash
cd salud_app
flutter pub get
flutter run                    # Desarrollo
flutter build apk --release    # Android
flutter build web --release    # Web
```

## Dependencias
```bash
flutter pub add flutter_riverpod fl_chart google_fonts flutter_animate intl
```

## Arquitectura
```
lib/
├── main.dart
├── app.dart                       # Shell: sidebar + header + contenido animado
├── core/theme/
│   ├── app_colors.dart            # Paleta dark/light, gradientes
│   └── app_theme.dart             # Material 3, Google Fonts Inter
├── core/constants/app_constants.dart  # Layout, animaciones, menú sidebar
├── core/extensions/context_extensions.dart  # Breakpoints responsive
├── models/dashboard_models.dart    # 14 modelos de datos (ChartPoint, KpiCardData, etc.)
├── providers/app_providers.dart    # Riverpod: theme, dashboard (con timer fluctuación)
├── screens/dashboard_screen.dart   # Grid responsivo con 16 widgets
├── services/mock_data_service.dart # Generación + fluctuación aleatoria de datos
└── widgets/
    ├── charts/   (6 widgets): line, area, radar, tracking, wave, venn
    ├── cards/   (11 widgets): kpi, progress, circular, storage, speed, battery, etc.
    ├── header/  (1 widget):  HeaderWidget
    └── sidebar/ (1 widget):  SidebarWidget (colapsable)
```

## Sistema de Datos en Vivo

Los indicadores se mueven solos cada 2 segundos vía:

1. **Timer.periodic** en `DashboardNotifier` → llama `MockDataService.fluctuate()`
2. **fluctuate()** varía cada valor ±3-15% aleatoriamente
3. Widgets **ConsumerWidget** se reconstruyen con `ref.watch(dashboardProvider)`
4. Animaciones se re-ejecutan:
   - `TweenAnimationBuilder` → barras de progreso, storage, speed gauge, battery %
   - `AnimationController.forward(from:0)` → KPI counters, sales rings
   - `ValueKey(animationSeed)` → circular progress rings (recrea controllers)
   - `CustomPainter.shouldRepaint(seed)` → wave chart animado
   - fl_chart `LineChart`/`RadarChart`/`PieChart` → animación incorporada

## Cómo Agregar un Nuevo Widget

1. Agregar datos al modelo `DashboardData` y al método `fluctuate()` en `MockDataService`
2. Crear widget en `widgets/cards/` o `widgets/charts/`
3. Usar `ConsumerWidget` para que se reconstruya automáticamente
4. Agregar al grid en `DashboardScreen._gridWidgets`
5. Para animación continua al cambiar datos:
   - Valores numéricos: `TweenAnimationBuilder`
   - CustomPainter: comparar `animationSeed` en `shouldRepaint`

## Widgets y sus Animaciones

| Widget | Tipo Animación | Gatillo |
|--------|---------------|---------|
| Line/Area/Radar/Donut | fl_chart animationDuration | Cambio de datos |
| KPI Cards | AnimatedCount + AnimationController | didUpdateWidget |
| Progress Bars | TweenAnimationBuilder | Nuevo valor tween |
| Storage Monitor | TweenAnimationBuilder | Nuevo ratio |
| Speed Gauge | TweenAnimationBuilder | Nueva velocidad |
| Battery % | TweenAnimationBuilder | Nuevo porcentaje |
| Circular Rings | AnimationController restart | animationSeed change |
| Sales Rings | AnimationController restart | didUpdateWidget value |
| Wave Chart | CustomPainter shouldRepaint | seed change |
| Wave Stats | TweenAnimationBuilder | Nuevos valores |
| Others | flutter_animate (entry) | Solo primera vez |

## Sidebar
- 10 items: Dashboard, Analytics, Marketing, Customers, Sales, Reports, Finance, Storage, Notifications, Settings
- Colapsable (260px → 72px)
- Icono activo con gradiente, hover animado

## Temas
- Dark: bg #080808, cards #17171A, texto #FFFFFF/#DADADA/#909090
- Light: bg #F6F8FB, cards #FFFFFF, texto #121212/#4A4A4A/#808080
- Gradientes: cyan→purple, orange→pink, green→blue
- Toggle en header, persiste en provider

## Responsive Breakpoints
| Rango | Columnas | Sidebar |
|-------|----------|---------|
| <600px | 1 | oculta |
| 600-1024px | 2 | oculta |
| 1024-1600px | 4 | visible |
| ≥1600px | 6 | visible |

## Colores de Referencia
```dart
// Dark
Color(0xFF080808)  // bg primary
Color(0xFF17171A)  // card primary
Color(0xFF2A2A30)  // card border

// Gradients
LinearGradient([Color(0xFF4EF2FF), Color(0xFFB05CFF)])  // cyanPurple
LinearGradient([Color(0xFFFFC14D), Color(0xFFFF5EA8)])  // orangePink
LinearGradient([Color(0xFF64FFC8), Color(0xFF5DAEFF)])  // greenBlue
```
