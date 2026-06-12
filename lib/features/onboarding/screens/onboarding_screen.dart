import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:word_search/core/constants/app_strings.dart';
import 'package:word_search/core/theme/app_theme.dart';
import 'package:word_search/features/settings/settings_provider.dart';
import 'package:word_search/shared/widgets/glass_widgets.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  final VoidCallback? onComplete;

  const OnboardingScreen({super.key, this.onComplete});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<_OnboardingPage> _pagesFor(String locale) => [
        _OnboardingPage(
          emoji: '🔍',
          title: AppStrings.onboardingTitle1(locale),
          description: AppStrings.onboardDesc1(locale),
          gradient: AppTheme.primaryGradient,
        ),
        _OnboardingPage(
          emoji: '🎯',
          title: AppStrings.onboardingTitle2(locale),
          description: AppStrings.onboardDesc2(locale),
          gradient: AppTheme.secondaryGradient,
        ),
        _OnboardingPage(
          emoji: '🏆',
          title: AppStrings.onboardingTitle3(locale),
          description: AppStrings.onboardDesc3(locale),
          gradient: AppTheme.accentGradient,
        ),
        _OnboardingPage(
          emoji: '📚',
          title: AppStrings.onboardingTitle4(locale),
          description: AppStrings.onboardDesc4(locale),
          gradient: AppTheme.goldGradient,
        ),
      ];

  void _finishOnboarding() {
    ref.read(settingsProvider.notifier).completeOnboarding();
    widget.onComplete?.call();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final pages = _pagesFor(locale);

    return Scaffold(
      backgroundColor: AppTheme.surfaceDark,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                itemCount: pages.length,
                itemBuilder: (context, index) =>
                    _buildPage(context, pages[index]),
              ),
            ),
            _buildBottomControls(context, pages, locale),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, _OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(page.emoji, style: const TextStyle(fontSize: 80)),
          const SizedBox(height: 32),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls(BuildContext context, List<_OnboardingPage> pages, String locale) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: _currentPage == index
                      ? pages[index].gradient
                      : null,
                  color: _currentPage == index
                      ? null
                      : Colors.white.withValues(alpha: 0.2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          GradientButton(
            text: _currentPage == pages.length - 1
                ? AppStrings.getStarted(locale)
                : AppStrings.next(locale),
            gradient: pages[_currentPage].gradient,
            icon: _currentPage == pages.length - 1
                ? Icons.play_arrow
                : Icons.arrow_forward,
            onPressed: () {
              if (_currentPage == pages.length - 1) {
                _finishOnboarding();
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
          if (_currentPage < pages.length - 1) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: _finishOnboarding,
              child: Text(
                AppStrings.skip(locale),
                style: const TextStyle(color: AppTheme.textMuted),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final String emoji;
  final String title;
  final String description;
  final LinearGradient gradient;

  const _OnboardingPage({
    required this.emoji,
    required this.title,
    required this.description,
    required this.gradient,
  });
}
