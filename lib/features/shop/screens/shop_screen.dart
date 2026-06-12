import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:word_search/core/constants/enums.dart';
import 'package:word_search/core/theme/app_theme.dart';
import 'package:word_search/features/profile/providers/profile_provider.dart';
import 'package:word_search/shared/models/shop_item.dart';
import 'package:word_search/shared/widgets/game_widgets.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildHeader(context, profile),
          const SizedBox(height: 20),
          _buildHintPacks(context, ref, profile),
          const SizedBox(height: 16),
          _buildThemeSection(context, ref, profile),
          const SizedBox(height: 16),
          _buildBackgrounds(context, ref, profile),
          const SizedBox(height: 16),
          _buildAvatars(context, ref, profile),
          const SizedBox(height: 16),
          _buildEffects(context, ref, profile),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, profile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Shop',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        CoinCounter(coins: profile.coins),
      ],
    );
  }

  Widget _buildHintPacks(BuildContext context, WidgetRef ref, profile) {
    final items = ShopItem.allItems
        .where((i) => i.type == ShopItemType.hintPack)
        .toList();
    return _buildSection(
      context,
      title: 'Hint Packs',
      items: items,
      profile: profile,
      ref: ref,
    );
  }

  Widget _buildThemeSection(BuildContext context, WidgetRef ref, profile) {
    final items = ShopItem.allItems
        .where((i) => i.type == ShopItemType.theme)
        .toList();
    return _buildSection(
      context,
      title: 'Themes',
      items: items,
      profile: profile,
      ref: ref,
    );
  }

  Widget _buildBackgrounds(BuildContext context, WidgetRef ref, profile) {
    final items = ShopItem.allItems
        .where((i) => i.type == ShopItemType.background)
        .toList();
    return _buildSection(
      context,
      title: 'Backgrounds',
      items: items,
      profile: profile,
      ref: ref,
    );
  }

  Widget _buildAvatars(BuildContext context, WidgetRef ref, profile) {
    final items = ShopItem.allItems
        .where((i) => i.type == ShopItemType.avatar)
        .toList();
    return _buildSection(
      context,
      title: 'Avatars',
      items: items,
      profile: profile,
      ref: ref,
    );
  }

  Widget _buildEffects(BuildContext context, WidgetRef ref, profile) {
    final items = ShopItem.allItems
        .where((i) => i.type == ShopItemType.effect)
        .toList();
    return _buildSection(
      context,
      title: 'Visual Effects',
      items: items,
      profile: profile,
      ref: ref,
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<ShopItem> items,
    required profile,
    required WidgetRef ref,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final item = items[index];
              final isOwned = item.id == 'default' ||
                  profile.ownedShopItemIds.contains(item.id);
              final isActive = (item.type == ShopItemType.theme &&
                      profile.activeThemeId == item.id) ||
                  (item.type == ShopItemType.background &&
                      profile.activeBackgroundId == item.id) ||
                  (item.type == ShopItemType.avatar &&
                      profile.avatarId == item.id) ||
                  (item.type == ShopItemType.effect &&
                      profile.activeEffectId == item.id);

              return _ShopItemCard(
                item: item,
                isOwned: isOwned,
                isActive: isActive,
                canAfford: profile.coins >= item.price,
                onTap: () => _handlePurchase(
                  context, ref, item, isOwned, isActive, profile),
              );
            },
          ),
        ),
      ],
    );
  }

  void _handlePurchase(
    BuildContext context,
    WidgetRef ref,
    ShopItem item,
    bool isOwned,
    bool isActive,
    profile,
  ) {
    if (isActive) return;

    if (isOwned) {
      _equipItem(ref, item);
      return;
    }

    if (profile.coins < item.price) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough coins!'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    ref.read(profileProvider.notifier).spendCoins(item.price);
    ref.read(profileProvider.notifier).ownShopItem(item.id);
    _equipItem(ref, item);
    ref.read(profileProvider.notifier).save();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} purchased!'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _equipItem(WidgetRef ref, ShopItem item) {
    final notifier = ref.read(profileProvider.notifier);
    switch (item.type) {
      case ShopItemType.theme:
        notifier.setActiveTheme(item.id);
      case ShopItemType.background:
        notifier.setActiveBackground(item.id);
      case ShopItemType.avatar:
        notifier.setAvatar(item.id);
      case ShopItemType.effect:
        notifier.setActiveTheme(item.id);
      case ShopItemType.hintPack:
        final hints = item.metadata?['hints'] as int? ?? 1;
        notifier.addHints(hints);
      default:
        break;
    }
    notifier.save();
  }
}

class _ShopItemCard extends StatelessWidget {
  final ShopItem item;
  final bool isOwned;
  final bool isActive;
  final bool canAfford;
  final VoidCallback onTap;

  const _ShopItemCard({
    required this.item,
    required this.isOwned,
    required this.isActive,
    required this.canAfford,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 110,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isActive ? AppTheme.goldGradient : null,
          color: isActive
              ? null
              : isOwned
                  ? AppTheme.successColor.withValues(alpha: 0.15)
                  : Colors.white.withValues(alpha: 0.08),
          border: Border.all(
            color: isActive
                ? AppTheme.goldColor
                : isOwned
                    ? AppTheme.successColor.withValues(alpha: 0.3)
                    : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: item.colorHex != null
                    ? Color(int.parse(item.colorHex!.replaceFirst('#', '0xFF')))
                    : AppTheme.primaryColor.withValues(alpha: 0.2),
              ),
              child: Center(
                child: Text(
                  _getItemEmoji(item.type),
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.name,
              style: TextStyle(
                color: isActive ? AppTheme.surfaceDark : AppTheme.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            if (isActive)
              const Text('Active',
                  style: TextStyle(
                    color: AppTheme.surfaceDark,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ))
            else if (isOwned)
              const Text('Owned',
                  style: TextStyle(
                    color: AppTheme.successColor,
                    fontSize: 10,
                  ))
            else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🪙', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 2),
                  Text(
                    '${item.price}',
                    style: TextStyle(
                      color: canAfford ? AppTheme.goldColor : AppTheme.errorColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (item.isPremium) ...[
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: AppTheme.goldGradient,
                  ),
                  child: const Text(
                    'PREMIUM',
                    style: TextStyle(
                      color: AppTheme.surfaceDark,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  String _getItemEmoji(ShopItemType type) {
    switch (type) {
      case ShopItemType.theme:
        return '🎨';
      case ShopItemType.background:
        return '🖼️';
      case ShopItemType.avatar:
        return '🧑';
      case ShopItemType.effect:
        return '✨';
      case ShopItemType.hintPack:
        return '💡';
      default:
        return '📦';
    }
  }
}
