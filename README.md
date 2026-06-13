# SaludSync — Premium SaaS Analytics Dashboard

Dashboard analítico premium construido con Flutter. Diseño moderno inspirado en Stripe, Linear, Vercel y Notion Analytics. Totalmente responsivo con modo oscuro/claro y datos animados en tiempo real.

## Características

### Dashboard en Vivo
- **Datos animados**: todos los indicadores suben y bajan cada 2 segundos simulando datos en vivo
- **16 widgets** en grid responsivo (1-6 columnas según pantalla)
- **Gráficos fl_chart**: línea, área, radar, donut con animación incorporada
- **Animaciones fluidas**: fadeIn, slide, scale usando flutter_animate

### Widgets del Dashboard
| Widget | Tipo | Descripción |
|--------|------|-------------|
| Line Chart | fl_chart | Usuarios nuevos vs perdidos (12 meses) |
| Tracking | fl_chart Donut | Perfil con 3 minidonuts: usuarios, vistas, retorno |
| Radar Chart | fl_chart | Comparativa 3 sectores en 5 categorías |
| Progress Bars | TweenAnimation | 4 barras con gradiente animado |
| Area Chart | fl_chart | Tráfico: visitas, nuevos, recurrentes |
| Wave Stats | CustomPainter | Ondas animadas con estadísticas |
| Venn Diagram | CustomPainter | Superposición de audiencias |
| Circular Progress | AnimationController | 3 anillos (Onboarding, Engagement, Retención) |
| Storage Monitor | TweenAnimation | Barras de almacenamiento |
| Speed Gauge | TweenAnimation | Velocidad de red |
| Battery | ConsumerWidget | Estado de batería |
| KPI Cards | AnimatedCount | 4 KPIs con contadores animados |
| Overview Table | ConsumerWidget | Tabla de tráfico |
| Revenue Card | ConsumerWidget | Ingresos por cliente |
| Sales Rings | AnimationController | Distribución de ventas |
| Hero Banner | StatelessWidget | Banner marketing |
| Bottom KPIs | ConsumerWidget | KPIs anuales |

### Temas
- **Dark Mode**: fondo #080808, cards #17171A, gradientes cyan→purple / orange→pink / green→blue
- **Light Mode**: fondo #F6F8FB, cards #FFFFFF
- Google Fonts Inter, Material Design 3

### Responsive
- Mobile (<600): 1 columna
- Tablet (600-1024): 2 columnas
- Desktop (1024-1600): 4 columnas
- UltraWide (≥1600): 6 columnas

## Tecnologías

| Paquete | Versión | Uso |
|---------|---------|-----|
| flutter_riverpod | ^2.5.1 | State management |
| fl_chart | ^0.68.0 | Gráficos |
| google_fonts | ^6.2.1 | Tipografía Inter |
| flutter_animate | ^4.5.0 | Animaciones |
| intl | ^0.19.0 | Formato numérico |

## Estructura

```
lib/
├── main.dart
├── app.dart                          # Shell: sidebar + header + contenido
├── core/
│   ├── constants/app_constants.dart  # Layout, animaciones, menú
│   ├── extensions/context_extensions.dart  # Responsive, breakpoints
│   └── theme/
│       ├── app_colors.dart           # Paleta dark/light, gradientes
│       └── app_theme.dart            # Temas Material 3 completos
├── models/dashboard_models.dart      # 14+ modelos de datos
├── providers/app_providers.dart      # Riverpod providers + timer fluctuación
├── screens/dashboard_screen.dart     # Grid principal del dashboard
├── services/mock_data_service.dart   # Generación y fluctuación de datos
└── widgets/
    ├── charts/ (6)                   # line, area, radar, tracking, wave, venn
    ├── cards/ (11)                   # kpi, progress, circular, storage, speed, ...
    ├── header/header_widget.dart     # Barra superior
    └── sidebar/sidebar_widget.dart   # Navegación colapsable
```

## Arquitectura de Datos en Vivo

Los datos se actualizan automáticamente cada 2 segundos:

1. **MockDataService.fluctuate()** recibe los datos actuales y devuelve una copia con valores modificados aleatoriamente
2. **DashboardNotifier** ejecuta un `Timer.periodic` que llama a `fluctuate()` y emite el nuevo estado
3. Los widgets `ConsumerWidget` se reconstruyen vía `ref.watch(dashboardProvider)`
4. Las animaciones se re-ejecutan:
   - fl_chart: animación incorporada vía `Duration`
   - KPI AnimatedCount: `AnimationController.forward(from: 0)`
   - Barras: `TweenAnimationBuilder` con tween actualizado
   - Anillos: `ValueKey` sobre `animationSeed` fuerza recreación + animación
   - Wave: `CustomPainter.shouldRepaint` con `seed` variable anima la onda

## Requisitos

- Flutter SDK >=3.6.0
- Dart SDK >=3.6.0

## Instalación

```bash
git clone <repo>
cd salud_app
flutter pub get
flutter run
```

## Compilación para producción

```bash
flutter build apk --release    # Android
flutter build ios --release    # iOS
flutter build web --release    # Web
flutter build linux --release  # Linux
```
