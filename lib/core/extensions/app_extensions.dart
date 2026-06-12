import 'package:flutter/material.dart';
import 'package:word_search/core/constants/app_constants.dart';

extension BuildContextX on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  double get statusBarHeight => MediaQuery.of(this).padding.top;
  double get bottomBarHeight => MediaQuery.of(this).padding.bottom;
  bool get isSmallScreen => screenWidth < 360;
  bool get isMediumScreen => screenWidth >= 360 && screenWidth < 600;
  bool get isLargeScreen => screenWidth >= 600;
  double get contentWidth =>
      screenWidth > AppConstants.maxWidth ? AppConstants.maxWidth : screenWidth;
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;
}

extension StringX on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get capitalizeEach {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.capitalize)
        .join(' ');
  }

  String get titleCase {
    if (isEmpty) return this;
    return split(' ')
        .map((word) =>
            word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }
}

extension IntX on int {
  String get formatted {
    if (this >= 1000000) return '${(this / 1000000).toStringAsFixed(1)}M';
    if (this >= 1000) return '${(this / 1000).toStringAsFixed(1)}K';
    return toString();
  }

  String get ordinal {
    if (this >= 11 && this <= 13) return '${this}th';
    switch (this % 10) {
      case 1:
        return '${this}st';
      case 2:
        return '${this}nd';
      case 3:
        return '${this}rd';
      default:
        return '${this}th';
    }
  }

  String get timerFormat {
    final minutes = (this ~/ 60).toString().padLeft(2, '0');
    final seconds = (this % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

extension DoubleX on double {
  String get formattedPercent => '${toStringAsFixed(1)}%';
  String get formattedDecimal => toStringAsFixed(2);
  String get formattedCompact {
    if (this >= 1000000) return '${(this / 1000000).toStringAsFixed(1)}M';
    if (this >= 1000) return '${(this / 1000).toStringAsFixed(1)}K';
    return toStringAsFixed(0);
  }
}

extension DurationX on Duration {
  String get formatted {
    if (inHours > 0) {
      final hours = inHours.toString().padLeft(2, '0');
      final minutes = (inMinutes % 60).toString().padLeft(2, '0');
      final seconds = (inSeconds % 60).toString().padLeft(2, '0');
      return '$hours:$minutes:$seconds';
    }
    final minutes = inMinutes.toString().padLeft(2, '0');
    final seconds = (inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get formattedShort {
    if (inHours > 0) return '${inHours}h ${inMinutes % 60}m';
    if (inMinutes > 0) return '${inMinutes}m ${inSeconds % 60}s';
    return '${inSeconds}s';
  }
}
