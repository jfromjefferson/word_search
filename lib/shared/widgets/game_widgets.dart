import 'package:flutter/material.dart';
import 'package:word_search/core/constants/enums.dart';
import 'package:word_search/core/extensions/app_extensions.dart';
import 'package:word_search/core/theme/app_theme.dart';
import 'package:word_search/shared/widgets/glass_widgets.dart';

class XpBar extends StatelessWidget {
  final int currentXp;
  final int level;
  final double progress;
  final int xpToNext;
  final double height;
  final bool compact;

  const XpBar({
    super.key,
    required this.currentXp,
    required this.level,
    required this.progress,
    required this.xpToNext,
    this.height = 12,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!compact)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Level $level',
                style: const TextStyle(
                  color: AppTheme.xpColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                '$currentXp / ${currentXp + xpToNext} XP',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        if (!compact) const SizedBox(height: 6),
        Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height / 2),
            color: Colors.white.withValues(alpha: 0.1),
          ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(height / 2),
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(height / 2),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withValues(alpha: 0.3),
                            Colors.transparent,
                          ],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.overlay,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ),
        if (compact)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Level $level',
              style: const TextStyle(
                color: AppTheme.xpColor,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
      ],
    );
  }
}

class CoinCounter extends StatelessWidget {
  final int coins;
  final bool compact;
  final VoidCallback? onTap;

  const CoinCounter({
    super.key,
    required this.coins,
    this.compact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 12,
          vertical: compact ? 4 : 8,
        ),
        borderRadius: 20,
        opacity: 0.12,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🪙',
              style: TextStyle(fontSize: compact ? 16 : 20),
            ),
            const SizedBox(width: 6),
            Text(
              coins.formatted,
              style: TextStyle(
                color: AppTheme.goldColor,
                fontWeight: FontWeight.bold,
                fontSize: compact ? 13 : 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LevelBadge extends StatelessWidget {
  final int level;
  final double size;
  final bool showGlow;

  const LevelBadge({
    super.key,
    required this.level,
    this.size = 48,
    this.showGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppTheme.primaryGradient,
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.5),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          level.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.35,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class WordChip extends StatelessWidget {
  final String word;
  final bool isFound;
  final bool isSelected;
  final VoidCallback? onTap;

  const WordChip({
    super.key,
    required this.word,
    this.isFound = false,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isFound
              ? AppTheme.successColor.withValues(alpha: 0.3)
              : isSelected
                  ? AppTheme.primaryColor.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.1),
          border: Border.all(
            color: isFound
                ? AppTheme.successColor.withValues(alpha: 0.5)
                : isSelected
                    ? AppTheme.primaryColor
                    : Colors.white.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isFound) ...[
              const Icon(Icons.check, size: 14, color: AppTheme.successColor),
              const SizedBox(width: 4),
            ],
            Text(
              word.toUpperCase(),
              style: TextStyle(
                color: isFound
                    ? AppTheme.successColor
                    : isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                decoration: isFound ? TextDecoration.lineThrough : null,
                decorationColor: AppTheme.successColor.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryIcon extends StatelessWidget {
  final ThemeCategory category;
  final double size;
  final bool selected;

  const CategoryIcon({
    super.key,
    required this.category,
    this.size = 56,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: size,
      constraints: BoxConstraints(
        minHeight: size,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: selected ? AppTheme.gameCategoryGradient(category) : null,
        color: selected ? null : Colors.white.withValues(alpha: 0.1),
        border: Border.all(
          color: selected
              ? Colors.white.withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.1),
          width: selected ? 2 : 1,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: AppTheme.gameCategoryGradient(category).colors.first
                      .withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              category.emoji,
              style: TextStyle(fontSize: size * 0.35),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              category.displayNameFor(locale),
              style: TextStyle(
                color: selected ? Colors.white : AppTheme.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
