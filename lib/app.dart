import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/settings_provider.dart';
import 'providers/service_providers.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/history_screen.dart';
import 'screens/history_detail_screen.dart';

class ShunkanApp extends ConsumerStatefulWidget {
  const ShunkanApp({super.key});

  @override
  ConsumerState<ShunkanApp> createState() => _ShunkanAppState();
}

class _ShunkanAppState extends ConsumerState<ShunkanApp> {
  @override
  void initState() {
    super.initState();
    _initSettings();
  }

  Future<void> _initSettings() async {
    final notifier = ref.read(settingsNotifierProvider.notifier);
    await notifier.load();

    final settings = ref.read(settingsNotifierProvider);
    if (settings.apiKey.isNotEmpty) {
      final translation = ref.read(translationServiceProvider);
      translation.configure(apiKey: settings.apiKey);
    }
  }

  static ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF4F46E5), // Expressive indigo
      brightness: brightness,
    );
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      // Filled buttons: fully rounded
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const StadiumBorder(),
        ),
      ),
      appBarTheme: AppBarTheme(
        scrolledUnderElevation: 2,
        surfaceTintColor: colorScheme.surfaceTint,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '瞬間',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/history': (_) => const HistoryScreen(),
        '/history/detail': (_) => const HistoryDetailScreen(),
      },
    );
  }
}
