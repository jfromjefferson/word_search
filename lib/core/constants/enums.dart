enum Difficulty {
  easy,
  medium,
  hard,
  expert,
  master;

  String labelFor(String locale) => switch (this) {
        Difficulty.easy => locale == 'pt'
            ? 'Fácil'
            : locale == 'es'
                ? 'Fácil'
                : 'Easy',
        Difficulty.medium => 'Médio',
        Difficulty.hard => locale == 'pt'
            ? 'Difícil'
            : locale == 'es'
                ? 'Difícil'
                : 'Hard',
        Difficulty.expert => locale == 'pt'
            ? 'Expert'
            : locale == 'es'
                ? 'Experto'
                : 'Expert',
        Difficulty.master => locale == 'pt'
            ? 'Mestre'
            : locale == 'es'
                ? 'Maestro'
                : 'Master',
      };
}

enum WordDirection {
  horizontal,
  vertical,
  diagonal,
  reverseHorizontal,
  reverseVertical,
  reverseDiagonal;

  bool get isReversed => switch (this) {
        WordDirection.reverseHorizontal => true,
        WordDirection.reverseVertical => true,
        WordDirection.reverseDiagonal => true,
        _ => false,
      };

  (int, int) get delta => switch (this) {
        WordDirection.horizontal => (0, 1),
        WordDirection.vertical => (1, 0),
        WordDirection.diagonal => (1, 1),
        WordDirection.reverseHorizontal => (0, -1),
        WordDirection.reverseVertical => (-1, 0),
        WordDirection.reverseDiagonal => (-1, -1),
      };

  bool get isHorizontal =>
      this == WordDirection.horizontal ||
      this == WordDirection.reverseHorizontal;

  bool get isVertical =>
      this == WordDirection.vertical || this == WordDirection.reverseVertical;

  bool get isDiagonal =>
      this == WordDirection.diagonal || this == WordDirection.reverseDiagonal;
}

enum GameMode {
  classic,
  timed,
  relax,
  daily,
  endless;

  String labelFor(String locale) => switch (this) {
        GameMode.classic => locale == 'pt'
            ? 'Clássico'
            : locale == 'es'
                ? 'Clásico'
                : 'Classic',
        GameMode.timed => locale == 'pt'
            ? 'Cronometrado'
            : locale == 'es'
                ? 'Contrarreloj'
                : 'Timed',
        GameMode.relax => locale == 'pt'
            ? 'Relaxar'
            : locale == 'es'
                ? 'Relajado'
                : 'Relax',
        GameMode.daily => locale == 'pt'
            ? 'Diário'
            : locale == 'es'
                ? 'Diario'
                : 'Daily',
        GameMode.endless => locale == 'pt'
            ? 'Infinito'
            : locale == 'es'
                ? 'Infinito'
                : 'Endless',
      };

  String descFor(String locale) => switch (this) {
        GameMode.classic => locale == 'pt'
            ? 'Sem cronômetro, relaxe'
            : locale == 'es'
                ? 'Sin cronómetro, relájate'
                : 'No timer, just relax',
        GameMode.timed => locale == 'pt'
            ? 'Corra contra o tempo!'
            : locale == 'es'
                ? '¡Contra el reloj!'
                : 'Beat the clock!',
        GameMode.relax => locale == 'pt'
            ? 'Sem pressão, só diversão'
            : locale == 'es'
                ? 'Sin presión, solo diversión'
                : 'No pressure, just fun',
        GameMode.daily => locale == 'pt'
            ? 'Desafio do dia'
            : locale == 'es'
                ? 'Desafío del día'
                : 'Daily challenge',
        GameMode.endless => locale == 'pt'
            ? 'Puzzles infinitos'
            : locale == 'es'
                ? 'Puzzles infinitos'
                : 'Infinite puzzles',
      };
}

enum HintType { revealLetter, revealWord, highlightArea, directionRadar }

enum ThemeCategory {
  animals,
  countries,
  food,
  sports,
  science,
  technology,
  movies,
  nature,
  history,
  space,
  mixed;

  String displayNameFor(String locale) => switch (this) {
        ThemeCategory.animals => locale == 'pt'
            ? 'Animais'
            : locale == 'es'
                ? 'Animales'
                : 'Animals',
        ThemeCategory.countries => locale == 'pt'
            ? 'Países'
            : locale == 'es'
                ? 'Países'
                : 'Countries',
        ThemeCategory.food => locale == 'pt'
            ? 'Comida'
            : locale == 'es'
                ? 'Comida'
                : 'Food',
        ThemeCategory.sports => locale == 'pt'
            ? 'Esportes'
            : locale == 'es'
                ? 'Deportes'
                : 'Sports',
        ThemeCategory.science => locale == 'pt'
            ? 'Ciência'
            : locale == 'es'
                ? 'Ciencia'
                : 'Science',
        ThemeCategory.technology => locale == 'pt'
            ? 'Tecnologia'
            : locale == 'es'
                ? 'Tecnología'
                : 'Technology',
        ThemeCategory.movies => locale == 'pt'
            ? 'Filmes'
            : locale == 'es'
                ? 'Películas'
                : 'Movies',
        ThemeCategory.nature => locale == 'pt'
            ? 'Natureza'
            : locale == 'es'
                ? 'Naturaleza'
                : 'Nature',
        ThemeCategory.history => locale == 'pt'
            ? 'História'
            : locale == 'es'
                ? 'Historia'
                : 'History',
        ThemeCategory.space => locale == 'pt'
            ? 'Espaço'
            : locale == 'es'
                ? 'Espacio'
                : 'Space',
        ThemeCategory.mixed => locale == 'pt'
            ? 'Misto'
            : locale == 'es'
                ? 'Mixto'
                : 'Mixed',
      };

  String get emoji => switch (this) {
        ThemeCategory.animals => '🐾',
        ThemeCategory.countries => '🌍',
        ThemeCategory.food => '🍕',
        ThemeCategory.sports => '⚽',
        ThemeCategory.science => '🔬',
        ThemeCategory.technology => '💻',
        ThemeCategory.movies => '🎬',
        ThemeCategory.nature => '🌿',
        ThemeCategory.history => '📜',
        ThemeCategory.space => '🚀',
        ThemeCategory.mixed => '🎲',
      };
}

enum AchievementType {
  firstVictory,
  tenPuzzles,
  hundredWords,
  sevenDayStreak,
  perfectPuzzle,
  speedMaster,
  puzzleLegend,
  noHintsUsed,
  allCategories,
  coinCollector,
  levelTen,
  levelTwentyFive,
  levelFifty,
  quickSolver,
  marathoner,
  wordHunter;

  String get id => name;
}

enum ShopItemType { theme, background, avatar, animation, effect, hintPack }

enum AudioType { music, sfx }
