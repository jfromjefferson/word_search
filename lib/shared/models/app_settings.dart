class AppSettings {
  bool musicEnabled;
  bool sfxEnabled;
  double musicVolume;
  double sfxVolume;
  bool hapticFeedback;
  bool showTimer;
  bool highlightFoundWords;
  bool autoSave;
  String language;
  bool darkMode;
  bool onboardingCompleted;
  bool notificationsEnabled;
  bool reducedMotion;

  AppSettings({
    this.musicEnabled = true,
    this.sfxEnabled = true,
    this.musicVolume = 0.7,
    this.sfxVolume = 1.0,
    this.hapticFeedback = true,
    this.showTimer = true,
    this.highlightFoundWords = true,
    this.autoSave = true,
    this.language = 'pt',
    this.darkMode = true,
    this.onboardingCompleted = false,
    this.notificationsEnabled = true,
    this.reducedMotion = false,
  });

  AppSettings copyWith({
    bool? musicEnabled,
    bool? sfxEnabled,
    double? musicVolume,
    double? sfxVolume,
    bool? hapticFeedback,
    bool? showTimer,
    bool? highlightFoundWords,
    bool? autoSave,
    String? language,
    bool? darkMode,
    bool? onboardingCompleted,
    bool? notificationsEnabled,
    bool? reducedMotion,
  }) {
    return AppSettings(
      musicEnabled: musicEnabled ?? this.musicEnabled,
      sfxEnabled: sfxEnabled ?? this.sfxEnabled,
      musicVolume: musicVolume ?? this.musicVolume,
      sfxVolume: sfxVolume ?? this.sfxVolume,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      showTimer: showTimer ?? this.showTimer,
      highlightFoundWords: highlightFoundWords ?? this.highlightFoundWords,
      autoSave: autoSave ?? this.autoSave,
      language: language ?? this.language,
      darkMode: darkMode ?? this.darkMode,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
      reducedMotion: reducedMotion ?? this.reducedMotion,
    );
  }

  Map<String, dynamic> toJson() => {
        'musicEnabled': musicEnabled,
        'sfxEnabled': sfxEnabled,
        'musicVolume': musicVolume,
        'sfxVolume': sfxVolume,
        'hapticFeedback': hapticFeedback,
        'showTimer': showTimer,
        'highlightFoundWords': highlightFoundWords,
        'autoSave': autoSave,
        'language': language,
        'darkMode': darkMode,
        'onboardingCompleted': onboardingCompleted,
        'notificationsEnabled': notificationsEnabled,
        'reducedMotion': reducedMotion,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        musicEnabled: json['musicEnabled'] as bool? ?? true,
        sfxEnabled: json['sfxEnabled'] as bool? ?? true,
        musicVolume: (json['musicVolume'] as num?)?.toDouble() ?? 0.7,
        sfxVolume: (json['sfxVolume'] as num?)?.toDouble() ?? 1.0,
        hapticFeedback: json['hapticFeedback'] as bool? ?? true,
        showTimer: json['showTimer'] as bool? ?? true,
        highlightFoundWords:
            json['highlightFoundWords'] as bool? ?? true,
        autoSave: json['autoSave'] as bool? ?? true,
        language: json['language'] as String? ?? 'en',
        darkMode: json['darkMode'] as bool? ?? true,
        onboardingCompleted:
            json['onboardingCompleted'] as bool? ?? false,
        notificationsEnabled:
            json['notificationsEnabled'] as bool? ?? true,
        reducedMotion: json['reducedMotion'] as bool? ?? false,
      );
}
