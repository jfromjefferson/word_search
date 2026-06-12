import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:word_search/core/theme/app_theme.dart';
import 'package:word_search/features/home/screens/home_screen.dart';
import 'package:word_search/features/onboarding/screens/onboarding_screen.dart';
import 'package:word_search/features/onboarding/screens/splash_screen.dart';
import 'package:word_search/features/settings/settings_provider.dart';
import 'package:word_search/shared/models/app_settings.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:word_search/l10n/app_localizations.dart';

final _initializedProvider = FutureProvider<void>((ref) async {
  final storage = ref.watch(storageServiceProvider);
  await storage.init();
  final settingsNotifier = ref.watch(settingsProvider.notifier);
  await settingsNotifier.init();
  _detectAndSetDeviceLanguage(ref);
});

void _detectAndSetDeviceLanguage(Ref ref) {
  final settings = ref.read(settingsProvider);
  if (settings.onboardingCompleted) return;
  final deviceLocale = ui.PlatformDispatcher.instance.locale;
  final deviceLang = deviceLocale.languageCode;
  if (['pt', 'es'].contains(deviceLang) && settings.language == 'pt') {
    ref.read(settingsProvider.notifier).setLanguage(deviceLang);
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: WordQuestApp()));
}

class WordQuestApp extends ConsumerWidget {
  const WordQuestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final init = ref.watch(_initializedProvider);
    final settings = ref.watch(settingsProvider);
    final locale = Locale(settings.language);

    return MaterialApp(
      key: ValueKey(settings.language),
      title: 'Word Quest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      locale: locale,
      supportedLocales: const [
        Locale('en'),
        Locale('pt'),
        Locale('es'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: init.when(
        loading: () => const Scaffold(
          backgroundColor: AppTheme.surfaceDark,
          body: Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          ),
        ),
        error: (err, _) => Scaffold(
          backgroundColor: AppTheme.surfaceDark,
          body: Center(
            child: Text('Error: $err',
                style: const TextStyle(color: AppTheme.textPrimary)),
          ),
        ),
        data: (_) => _buildStartupWidget(settings, ref),
      ),
    );
  }

  Widget _buildStartupWidget(AppSettings settings, WidgetRef ref) {
    if (settings.onboardingCompleted) {
      return const HomeScreen();
    }
    return _SplashThenOnboarding(
      onOnboardingDone: () {
        ref.read(settingsProvider.notifier).completeOnboarding();
      },
    );
  }
}

class _SplashThenOnboarding extends StatefulWidget {
  final VoidCallback onOnboardingDone;

  const _SplashThenOnboarding({required this.onOnboardingDone});

  @override
  State<_SplashThenOnboarding> createState() => _SplashThenOnboardingState();
}

class _SplashThenOnboardingState extends State<_SplashThenOnboarding> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showSplash = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) return const SplashScreen();
    return _OnboardingFlow(onDone: widget.onOnboardingDone);
  }
}

class _OnboardingFlow extends StatelessWidget {
  final VoidCallback onDone;

  const _OnboardingFlow({required this.onDone});

  @override
  Widget build(BuildContext context) {
    return OnboardingScreen(onComplete: onDone);
  }
}
