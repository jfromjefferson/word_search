import 'package:word_search/core/constants/enums.dart';

class ShopItem {
  final String id;
  final ShopItemType type;
  final String name;
  final String description;
  final int price;
  final bool isPremium;
  final String? imagePath;
  final String? colorHex;
  final Map<String, dynamic>? metadata;

  const ShopItem({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.price,
    this.isPremium = false,
    this.imagePath,
    this.colorHex,
    this.metadata,
  });

  static List<ShopItem> get allItems => [
        ..._themes,
        ..._backgrounds,
        ..._avatars,
        ..._effects,
        ..._hintPacks,
      ];

  static List<ShopItem> get _themes => [
        const ShopItem(
          id: 'theme_ocean',
          type: ShopItemType.theme,
          name: 'Ocean Blue',
          description: 'A calming ocean-themed color palette',
          price: 200,
          colorHex: '#0077B6',
        ),
        const ShopItem(
          id: 'theme_sunset',
          type: ShopItemType.theme,
          name: 'Sunset Glow',
          description: 'Warm sunset colors for your word hunt',
          price: 200,
          colorHex: '#FF6B6B',
        ),
        const ShopItem(
          id: 'theme_forest',
          type: ShopItemType.theme,
          name: 'Forest Green',
          description: 'Nature-inspired green theme',
          price: 200,
          colorHex: '#2D6A4F',
        ),
        const ShopItem(
          id: 'theme_galaxy',
          type: ShopItemType.theme,
          name: 'Galaxy',
          description: 'Cosmic purple and blue tones',
          price: 350,
          isPremium: true,
          colorHex: '#6C5CE7',
        ),
        const ShopItem(
          id: 'theme_neon',
          type: ShopItemType.theme,
          name: 'Neon Nights',
          description: 'Bright neon cyberpunk theme',
          price: 350,
          isPremium: true,
          colorHex: '#00FF88',
        ),
        const ShopItem(
          id: 'theme_gold',
          type: ShopItemType.theme,
          name: 'Golden Luxury',
          description: 'Premium gold accents',
          price: 500,
          isPremium: true,
          colorHex: '#FFD700',
        ),
      ];

  static List<ShopItem> get _backgrounds => [
        const ShopItem(
          id: 'bg_night_sky',
          type: ShopItemType.background,
          name: 'Night Sky',
          description: 'Twinkling stars background',
          price: 100,
        ),
        const ShopItem(
          id: 'bg_mountains',
          type: ShopItemType.background,
          name: 'Mountains',
          description: 'Mountain landscape',
          price: 100,
        ),
        const ShopItem(
          id: 'bg_beach',
          type: ShopItemType.background,
          name: 'Beach',
          description: 'Relaxing beach scene',
          price: 100,
        ),
        const ShopItem(
          id: 'bg_city',
          type: ShopItemType.background,
          name: 'City Lights',
          description: 'Urban cityscape at night',
          price: 200,
          isPremium: true,
        ),
        const ShopItem(
          id: 'bg_space',
          type: ShopItemType.background,
          name: 'Deep Space',
          description: 'Nebulae and galaxies',
          price: 200,
          isPremium: true,
        ),
      ];

  static List<ShopItem> get _avatars => [
        const ShopItem(
          id: 'avatar_explorer',
          type: ShopItemType.avatar,
          name: 'Explorer',
          description: 'A brave adventurer avatar',
          price: 150,
        ),
        const ShopItem(
          id: 'avatar_detective',
          type: ShopItemType.avatar,
          name: 'Detective',
          description: 'Sherlock-style detective avatar',
          price: 150,
        ),
        const ShopItem(
          id: 'avatar_wizard',
          type: ShopItemType.avatar,
          name: 'Wizard',
          description: 'Magical wizard avatar',
          price: 200,
        ),
        const ShopItem(
          id: 'avatar_astronaut',
          type: ShopItemType.avatar,
          name: 'Astronaut',
          description: 'Space explorer avatar',
          price: 250,
          isPremium: true,
        ),
        const ShopItem(
          id: 'avatar_phoenix',
          type: ShopItemType.avatar,
          name: 'Phoenix',
          description: 'Legendary phoenix avatar',
          price: 300,
          isPremium: true,
        ),
      ];

  static List<ShopItem> get _effects => [
        const ShopItem(
          id: 'effect_sparkle',
          type: ShopItemType.effect,
          name: 'Sparkle',
          description: 'Sparkling effect on word find',
          price: 100,
        ),
        const ShopItem(
          id: 'effect_fireworks',
          type: ShopItemType.effect,
          name: 'Fireworks',
          description: 'Fireworks on word find',
          price: 150,
        ),
        const ShopItem(
          id: 'effect_glow',
          type: ShopItemType.effect,
          name: 'Neon Glow',
          description: 'Neon glow animation effects',
          price: 200,
          isPremium: true,
        ),
        const ShopItem(
          id: 'effect_particles',
          type: ShopItemType.effect,
          name: 'Particles',
          description: 'Particle burst animations',
          price: 200,
          isPremium: true,
        ),
      ];

  static List<ShopItem> get _hintPacks => [
        const ShopItem(
          id: 'hints_small',
          type: ShopItemType.hintPack,
          name: 'Hint Pack S',
          description: '3 hints to help you find words',
          price: 50,
          metadata: {'hints': 3},
        ),
        const ShopItem(
          id: 'hints_medium',
          type: ShopItemType.hintPack,
          name: 'Hint Pack M',
          description: '7 hints - best value!',
          price: 100,
          metadata: {'hints': 7},
        ),
        const ShopItem(
          id: 'hints_large',
          type: ShopItemType.hintPack,
          name: 'Hint Pack L',
          description: '15 hints for serious players',
          price: 200,
          metadata: {'hints': 15},
        ),
        const ShopItem(
          id: 'hints_mega',
          type: ShopItemType.hintPack,
          name: 'Hint Pack XL',
          description: '40 hints mega bundle',
          price: 450,
          isPremium: true,
          metadata: {'hints': 40},
        ),
      ];

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'name': name,
        'description': description,
        'price': price,
        'isPremium': isPremium,
      };
}
