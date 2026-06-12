import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:word_search/core/constants/enums.dart';

class WordListService {
  static final WordListService _instance = WordListService._internal();
  factory WordListService() => _instance;
  WordListService._internal();

  final _cache = <String, List<String>>{};

  String _baseFileName(ThemeCategory category) => 'words_${category.name}';

  Future<List<String>> getWords(ThemeCategory category, {String locale = 'en'}) async {
    final cacheKey = '${category.name}_$locale';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    if (category == ThemeCategory.mixed) {
      return _getMixedWords(locale);
    }

    final words = await _loadWords(category, locale);
    _cache[cacheKey] = words;
    return words;
  }

  Future<List<String>> _loadWords(ThemeCategory category, String locale) async {
    final baseName = _baseFileName(category);
    final paths = <String>[
      'assets/data/${baseName}_$locale.json',
      'assets/data/$baseName.json',
    ];

    for (final path in paths) {
      try {
        final jsonStr = await rootBundle.loadString(path);
        final data = jsonDecode(jsonStr) as Map<String, dynamic>;
        return List<String>.from(data['words'] as List);
      } catch (_) {}
    }

    return _getFallbackWords(category, locale);
  }

  Future<List<String>> _getMixedWords(String locale) async {
    final allCategories = ThemeCategory.values.where((c) => c != ThemeCategory.mixed);
    final allWords = <String>{};
    for (final cat in allCategories) {
      final words = await getWords(cat, locale: locale);
      allWords.addAll(words.map((w) => w.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '')));
    }
    return allWords.toList();
  }

  List<String> _getFallbackWords(ThemeCategory category, String locale) {
    final en = [
      ['LION', 'TIGER', 'BEAR', 'WOLF', 'EAGLE', 'SHARK', 'WHALE', 'DEER', 'FROG', 'HAWK', 'HORSE', 'ZEBRA', 'PANDA', 'SNAKE'],
      ['BRAZIL', 'CANADA', 'FRANCE', 'JAPAN', 'INDIA', 'SPAIN', 'ITALY', 'EGYPT', 'CHILE', 'PERU', 'MEXICO', 'CHINA', 'CUBA'],
      ['PIZZA', 'BREAD', 'CHEESE', 'APPLE', 'GRAPE', 'LEMON', 'STEAK', 'PASTA', 'RICE', 'BEANS', 'CAKE', 'MILK', 'EGGS', 'FISH'],
      ['SOCCER', 'TENNIS', 'BOXING', 'HOCKEY', 'RUGBY', 'GOLF', 'KARATE', 'JUDO', 'SURF', 'SKI', 'POLO', 'DARTS', 'CHESS'],
      ['ATOM', 'CELL', 'GENE', 'MASS', 'WAVE', 'DATA', 'MOON', 'STAR', 'LASER', 'ROBOT', 'VIRUS', 'NOVA', 'ORBIT'],
      ['CODE', 'BYTE', 'CHIP', 'APP', 'DATA', 'CLOUD', 'MOUSE', 'DRIVE', 'PIXEL', 'CACHE', 'LINUX', 'JAVA', 'RUBY'],
      ['AVATAR', 'CINEMA', 'COMEDY', 'DRAMA', 'ACTOR', 'SCENE', 'SCRIPT', 'HORROR', 'ACTION', 'SEQUEL', 'OSCAR', 'CAMERA'],
      ['RIVER', 'OCEAN', 'FOREST', 'DESERT', 'ISLAND', 'VALLEY', 'GLACIER', 'MEADOW', 'JUNGLE', 'PRAIRIE', 'GARDEN', 'STREAM'],
      ['ROME', 'CASTLE', 'EMPIRE', 'PYRAMID', 'TEMPLE', 'MEDIEVAL', 'VIKING', 'PHARAOH', 'KNIGHT', 'SAMURAI', 'COLONY', 'ANCIENT'],
      ['ORBIT', 'COMET', 'MARS', 'VENUS', 'PLUTO', 'SOLAR', 'LUNAR', 'NOVA', 'SPACE', 'ROCKET', 'GALAXY', 'NEBULA', 'STAR'],
    ];

    final pt = [
      ['LEAO', 'TIGRE', 'URSO', 'LOBO', 'AGUIA', 'TUBARAO', 'BALEIA', 'CERVO', 'SAPO', 'GAVIAO', 'CAVALO', 'ZEBRA', 'PANDA', 'COBRA'],
      ['BRASIL', 'CANADA', 'FRANCA', 'JAPAO', 'INDIA', 'ESPANHA', 'ITALIA', 'EGITO', 'CHILE', 'PERU', 'MEXICO', 'CHINA', 'CUBA'],
      ['PIZZA', 'PAO', 'QUEIJO', 'MACA', 'UVA', 'LIMAO', 'CARNE', 'MASSA', 'ARROZ', 'FEIJAO', 'BOLO', 'LEITE', 'OVO', 'PEIXE'],
      ['FUTEBOL', 'TENIS', 'BOXE', 'HOQUEI', 'RUGBY', 'GOLFE', 'KARATE', 'JUDO', 'SURFE', 'ESQUI', 'POLO', 'DARDO', 'XADREZ'],
      ['ATOMO', 'CELULA', 'GENE', 'MASSA', 'ONDA', 'DADO', 'LUA', 'ESTRELA', 'LASER', 'ROBO', 'VIRUS', 'NOVA', 'ORBITA'],
      ['CODIGO', 'BYTE', 'CHIP', 'APP', 'DADOS', 'NUVEM', 'MOUSE', 'DRIVE', 'PIXEL', 'CACHE', 'LINUX', 'JAVA', 'RUBY'],
      ['AVATAR', 'CINEMA', 'COMEDIA', 'DRAMA', 'ATOR', 'CENA', 'ROTEIRO', 'TERROR', 'ACAO', 'OSCAR', 'CAMERA', 'EDICAO', 'ESTREIA'],
      ['RIO', 'OCEANO', 'FLORESTA', 'DESERTO', 'ILHA', 'VALE', 'GELEIRA', 'PRADO', 'SELVA', 'PRADARIA', 'JARDIM', 'RIACHO'],
      ['ROMA', 'CASTELO', 'IMPERIO', 'PIRAMIDE', 'TEMPLO', 'MEDIEVAL', 'VIKING', 'FARAO', 'CAVALEIRO', 'SAMURAI', 'COLONIA', 'ANTIGO'],
      ['ORBITA', 'COMETA', 'MARTE', 'VENUS', 'PLUTAO', 'SOLAR', 'LUNAR', 'NOVA', 'ESPACO', 'FOGUETE', 'GALAXIA', 'NEBULOSA', 'ESTRELA'],
    ];

    final es = [
      ['LEON', 'TIGRE', 'OSO', 'LOBO', 'AGUILA', 'TIBURON', 'BALLENA', 'CIERVO', 'RANA', 'HALCON', 'CABALLO', 'CEBRA', 'PANDA', 'SERPIENTE'],
      ['BRASIL', 'CANADA', 'FRANCIA', 'JAPON', 'INDIA', 'ESPANA', 'ITALIA', 'EGIPTO', 'CHILE', 'PERU', 'MEXICO', 'CHINA', 'CUBA'],
      ['PIZZA', 'PAN', 'QUESO', 'MANZANA', 'UVA', 'LIMON', 'CARNE', 'PASTA', 'ARROZ', 'FRIJOL', 'PASTEL', 'LECHE', 'HUEVO', 'PESCADO'],
      ['FUTBOL', 'TENIS', 'BOXEO', 'HOCKEY', 'RUGBY', 'GOLF', 'KARATE', 'JUDO', 'SURF', 'ESQUI', 'POLO', 'DARDOS', 'AJEDREZ'],
      ['ATOMO', 'CELULA', 'GEN', 'MASA', 'ONDA', 'DATO', 'LUNA', 'ESTRELLA', 'LASER', 'ROBOT', 'VIRUS', 'NOVA', 'ORBITA'],
      ['CODIGO', 'BYTE', 'CHIP', 'APP', 'DATOS', 'NUBE', 'RATON', 'DISCO', 'PIXEL', 'CACHE', 'LINUX', 'JAVA', 'RUBY'],
      ['AVATAR', 'CINE', 'COMEDIA', 'DRAMA', 'ACTOR', 'ESCENA', 'GUION', 'TERROR', 'ACCION', 'OSCAR', 'CAMARA', 'EDICION', 'ESTRENO'],
      ['RIO', 'OCEANO', 'BOSQUE', 'DESIERTO', 'ISLA', 'VALLE', 'GLACIAR', 'PRADO', 'SELVA', 'PRADERA', 'JARDIN', 'ARROYO'],
      ['ROMA', 'CASTILLO', 'IMPERIO', 'PIRAMIDE', 'TEMPLO', 'MEDIEVAL', 'VIKINGO', 'FARAON', 'CABALLERO', 'SAMURAI', 'COLONIA', 'ANTIGUO'],
      ['ORBITA', 'COMETA', 'MARTE', 'VENUS', 'PLUTON', 'SOLAR', 'LUNAR', 'NOVA', 'ESPACIO', 'COHETE', 'GALAXIA', 'NEBULOSA', 'ESTRELLA'],
    ];

    final index = ThemeCategory.values.indexOf(category);
    if (index < 0 || index >= 10) {
      return en[0];
    }

    final list = locale == 'pt' ? pt[index] : locale == 'es' ? es[index] : en[index];
    return list;
  }
}
