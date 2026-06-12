import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:word_search/core/theme/app_theme.dart';
import 'package:word_search/features/settings/settings_provider.dart';
import 'package:word_search/shared/widgets/glass_widgets.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppTheme.surfaceDark,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionTitle('Audio'),
          _buildSwitchTile(
            icon: Icons.music_note,
            title: 'Music',
            value: settings.musicEnabled,
            onChanged: (_) => ref.read(settingsProvider.notifier).toggleMusic(),
          ),
          if (settings.musicEnabled)
            _buildSliderTile(
              context,
              icon: Icons.volume_up,
              label: 'Music Volume',
              value: settings.musicVolume,
              onChanged: (v) =>
                  ref.read(settingsProvider.notifier).setMusicVolume(v),
            ),
          _buildSwitchTile(
            icon: Icons.volume_up,
            title: 'Sound Effects',
            value: settings.sfxEnabled,
            onChanged: (_) => ref.read(settingsProvider.notifier).toggleSfx(),
          ),
          if (settings.sfxEnabled)
            _buildSliderTile(
              context,
              icon: Icons.volume_mute,
              label: 'SFX Volume',
              value: settings.sfxVolume,
              onChanged: (v) =>
                  ref.read(settingsProvider.notifier).setSfxVolume(v),
            ),
          const SizedBox(height: 20),
          _buildSectionTitle('Gameplay'),
          _buildSwitchTile(
            icon: Icons.timer,
            title: 'Show Timer',
            value: settings.showTimer,
            onChanged: (_) => ref.read(settingsProvider.notifier).toggleTimer(),
          ),
          _buildSwitchTile(
            icon: Icons.highlight,
            title: 'Highlight Found Words',
            value: settings.highlightFoundWords,
            onChanged: (_) =>
                ref.read(settingsProvider.notifier).toggleHighlightFound(),
          ),
          _buildSwitchTile(
            icon: Icons.vibration,
            title: 'Haptic Feedback',
            value: settings.hapticFeedback,
            onChanged: (_) => ref.read(settingsProvider.notifier).toggleHaptic(),
          ),
          _buildSwitchTile(
            icon: Icons.save,
            title: 'Auto Save',
            value: settings.autoSave,
            onChanged: (_) =>
                ref.read(settingsProvider.notifier).toggleAutoSave(),
          ),
          _buildSwitchTile(
            icon: Icons.animation,
            title: 'Reduced Motion',
            value: settings.reducedMotion,
            onChanged: (_) =>
                ref.read(settingsProvider.notifier).toggleReducedMotion(),
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('Language'),
          _buildLanguageSelector(context, ref, settings.language),
          const SizedBox(height: 20),
          _buildSectionTitle('About'),
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Word Quest',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'A premium word search puzzle game.\nFind hidden words across multiple categories and difficulty levels.',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.textSecondary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderTile(
    BuildContext ctx, {
    required IconData icon,
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.textSecondary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                  ),
                ),
                SliderTheme(
                  data: SliderTheme.of(ctx).copyWith(
                    activeTrackColor: AppTheme.primaryColor,
                    inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
                    thumbColor: AppTheme.primaryColor,
                    overlayColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                  ),
                  child: Slider(
                    value: value,
                    min: 0,
                    max: 1,
                    divisions: 10,
                    label: '${(value * 100).round()}%',
                    onChanged: onChanged,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(
    BuildContext context,
    WidgetRef ref,
    String currentLanguage,
  ) {
    const languages = [
      ('en', 'English'),
      ('pt', 'Português'),
      ('es', 'Español'),
    ];

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: languages.map((lang) {
          final (code, name) = lang;
          final isSelected = currentLanguage == code;
          return GestureDetector(
            onTap: () => ref.read(settingsProvider.notifier).setLanguage(code),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isSelected)
                    const Icon(Icons.check, color: AppTheme.primaryColor, size: 20),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
