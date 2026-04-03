# UI & Theming

Flutter uses Material Design with Material 3 enabled by default (since Flutter 3.16).

Theme files are in `lib/core/theme/`:
- `AppTheme` — light/dark `ThemeData` (`app_theme.dart`)
- `AppColors` — semantic color constants (`app_colors.dart`)
- `AppTypography` — text styles via `TextTheme` (`app_typography.dart`)
- `AppDimensions` — spacing, radii, icon sizes (`app_dimensions.dart`)

---

## ThemeData

### Use ThemeData, Not Conditional Logic
Widgets should inherit styles from the theme, not use conditional brightness checks:

**Good:**
```dart
final colorScheme = Theme.of(context).colorScheme;
final textTheme = Theme.of(context).textTheme;

Container(
  color: colorScheme.surface,
  child: Text('Hello', style: textTheme.bodyLarge),
)
```

**Bad:**
```dart
Container(
  color: MediaQuery.of(context).platformBrightness == Brightness.dark
      ? AppColors.surfaceDark
      : AppColors.surfaceLight,
  child: Text('Hello'),
)
```

### Accessing the Theme
Use `Theme.of(context)` to pull `ThemeData`, `ColorScheme`, `TextTheme`, etc. Keep references local to the `build` method:

```dart
@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final colors = theme.colorScheme;
  final text = theme.textTheme;
  // ...
}
```

---

## Typography

### Use the TextTheme
Always pull text styles from the theme instead of creating ad-hoc `TextStyle` values:

**Good:**
```dart
Text('Title', style: Theme.of(context).textTheme.headlineMedium)
```

**Bad:**
```dart
Text('Title', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600))
```

### Customising a Theme Style
Use `copyWith` when you need a small tweak:

```dart
Text(
  'Subtitle',
  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
    color: AppColors.textSecondaryLight,
  ),
)
```

---

## Colors

### Use AppColors and ColorScheme
Reference `AppColors` constants for semantic colors and `Theme.of(context).colorScheme` for theme-aware colors:

**Good:**
```dart
final colors = Theme.of(context).colorScheme;
Container(color: colors.surface)

// Semantic finance colors
Container(color: AppColors.income)
Container(color: AppColors.expense)
```

**Bad:**
```dart
Container(color: Color(0xFFFFFFFF))
Container(color: Colors.green)
```

### Opacity
Use `Color.withValues(alpha: ...)` instead of the deprecated `withOpacity`:

```dart
AppColors.primary.withValues(alpha: 0.12)
```

---

## Spacing

### Use AppDimensions
All spacing and sizing values come from `AppDimensions`:

**Good:**
```dart
Padding(
  padding: EdgeInsets.all(AppDimensions.paddingM),
  child: child,
)

BorderRadius.circular(AppDimensions.radiusL)
```

**Bad:**
```dart
Padding(
  padding: EdgeInsets.all(16),
  child: child,
)

BorderRadius.circular(16)
```

### Common Values
| Token | Getter | Typical Use |
|-------|--------|-------------|
| `paddingXS` | 4 | Tight inner gaps |
| `paddingS` | 8 | Small gaps, icon padding |
| `paddingM` | 16 | Standard content padding |
| `paddingL` | 24 | Section padding |
| `paddingXL` | 32 | Page-level padding |

---

## Component Theming

### Prefer Theme-Level Configuration
Style components via `ThemeData` sub-themes (`AppBarTheme`, `CardThemeData`, `ElevatedButtonThemeData`, etc.) rather than per-widget `style` parameters:

**Good (theme-level, in `AppTheme`):**
```dart
cardTheme: CardThemeData(
  color: AppColors.cardLight,
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
    side: const BorderSide(color: AppColors.divider),
  ),
),
```

Then the widget just uses defaults:
```dart
const Card(child: content)
```

**Bad (per-widget overrides scattered everywhere):**
```dart
Card(
  color: Colors.white,
  elevation: 0,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  child: content,
)
```

---

## Widget Structure (Page / View Pattern)

### Separate Page (route) from View (UI)
- **Page widget** — owns the route, provides BLoC/providers, contains no visual layout.
- **View widget** — pure UI tree, receives dependencies from the page.

```dart
// transactions_page.dart
class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TransactionsCubit(getIt<TransactionRepository>()),
      child: const TransactionsView(),
    );
  }
}

// transactions_view.dart
class TransactionsView extends StatelessWidget {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: // ...
    );
  }
}
```

---

## Widget Composition

### Extract Widgets, Don't Extract Methods
Split large `build` methods into separate widget classes, not private `_build*` helper methods. Separate widgets get their own `BuildContext` and rebuild independently.

**Good:**
```dart
class TransactionsList extends StatelessWidget {
  const TransactionsList({super.key, required this.transactions});
  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) { /* ... */ }
}
```

**Bad:**
```dart
Widget _buildTransactionsList() {
  // loses independent rebuild, shares parent context
}
```

### Keep Widgets Small
Aim for `build` methods under ~50 lines. If a widget is growing beyond that, extract a child widget.

---

## Layout Best Practices

### Avoid Unbounded Constraints
Never place a `ListView` or `Column` inside another scrollable without bounding it:

```dart
// Inside a Column that scrolls
Expanded(
  child: ListView.builder(
    itemCount: items.length,
    itemBuilder: (_, i) => ItemTile(item: items[i]),
  ),
)
```

### Responsive Sizing
Use `flutter_screenutil` extensions (`.w`, `.h`, `.sp`, `.r`) for dimensions that should scale with device size. `AppDimensions` already applies these.

### Prefer `const` Constructors
Mark widgets and helper objects `const` wherever possible to reduce rebuilds:

```dart
const SizedBox(height: 16)
const EdgeInsets.symmetric(horizontal: 16)
```

---

## Accessibility

### Semantic Labels
Provide `semanticsLabel` on icons and images that convey meaning:

```dart
Icon(Icons.delete, semanticsLabel: 'Delete transaction')
```

### Touch Targets
Ensure interactive elements meet the minimum 48x48 dp touch target. Material widgets handle this by default; custom `GestureDetector` / `InkWell` widgets may need explicit sizing.

### Contrast
Use the theme's `ColorScheme` to maintain sufficient contrast ratios across light and dark modes. Avoid hardcoded colors that may fail contrast checks in one mode.
