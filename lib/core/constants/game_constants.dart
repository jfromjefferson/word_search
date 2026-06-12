class GameConstants {
  GameConstants._();

  static const int minWordLength = 3;
  static const int maxWordLength = 15;

  static const Map<String, int> gridSizes = {
    'easy': 8,
    'medium': 10,
    'hard': 12,
    'expert': 15,
    'master': 18,
  };

  static const Map<String, int> minWords = {
    'easy': 5,
    'medium': 8,
    'hard': 12,
    'expert': 18,
    'master': 25,
  };

  static const Map<String, int> maxWords = {
    'easy': 8,
    'medium': 12,
    'hard': 18,
    'expert': 25,
    'master': 35,
  };

  static const Map<String, int> timerSeconds = {
    'easy': 240,
    'medium': 300,
    'hard': 420,
    'expert': 600,
    'master': 900,
  };

  static const Map<String, int> baseXP = {
    'easy': 50,
    'medium': 100,
    'hard': 200,
    'expert': 350,
    'master': 500,
  };

  static const Map<String, int> coinsPerWin = {
    'easy': 10,
    'medium': 25,
    'hard': 50,
    'expert': 100,
    'master': 200,
  };

  static const int perfectCompletionBonus = 50;
  static const int fastCompletionBonus = 30;
  static const int hintPenalty = 10;
  static const int mistakePenalty = 5;

  static const List<int> xpPerLevel = [
    0, 100, 250, 500, 800, 1200, 1700, 2300, 3000, 3800,
    4700, 5700, 6800, 8000, 9300, 10700, 12200, 13800, 15500, 17300,
    19200, 21200, 23300, 25500, 27800, 30200, 32700, 35300, 38000, 40800,
    43700, 46700, 49800, 53000, 56300, 59700, 63200, 66800, 70500, 74300,
    78200, 82200, 86300, 90500, 94800, 99200, 103700, 108300, 113000, 117800,
  ];
}
