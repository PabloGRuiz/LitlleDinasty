import 'package:flutter/material.dart';

import '../theme/medieval_theme.dart';

/// Las 6 estadísticas base del protagonista (rango 0..100).
enum StatType {
  emotionalIntelligence,
  intellect,
  strength,
  health,
  combatSkill,
  mood,
}

extension StatTypeX on StatType {
  String get label {
    switch (this) {
      case StatType.emotionalIntelligence:
        return 'Inteligencia Emocional';
      case StatType.intellect:
        return 'Intelecto';
      case StatType.strength:
        return 'Fuerza';
      case StatType.health:
        return 'Salud';
      case StatType.combatSkill:
        return 'Habilidad de Combate';
      case StatType.mood:
        return 'Ánimo';
    }
  }

  String get shortLabel {
    switch (this) {
      case StatType.emotionalIntelligence:
        return 'Int. Emocional';
      case StatType.intellect:
        return 'Intelecto';
      case StatType.strength:
        return 'Fuerza';
      case StatType.health:
        return 'Salud';
      case StatType.combatSkill:
        return 'Combate';
      case StatType.mood:
        return 'Ánimo';
    }
  }

  IconData get icon {
    switch (this) {
      case StatType.emotionalIntelligence:
        return Icons.psychology_alt_outlined;
      case StatType.intellect:
        return Icons.menu_book_rounded;
      case StatType.strength:
        return Icons.fitness_center_rounded;
      case StatType.health:
        return Icons.favorite_outline_rounded;
      case StatType.combatSkill:
        return Icons.sports_martial_arts_rounded;
      case StatType.mood:
        return Icons.wb_sunny_outlined;
    }
  }

  Color get color {
    switch (this) {
      case StatType.emotionalIntelligence:
        return MedievalColors.plumEmpathy;
      case StatType.intellect:
        return MedievalColors.royalBlue;
      case StatType.strength:
        return MedievalColors.amberOchre;
      case StatType.health:
        return MedievalColors.forestGreen;
      case StatType.combatSkill:
        return MedievalColors.crimsonSeal;
      case StatType.mood:
        return MedievalColors.goldCoin;
    }
  }
}

/// Modificación positiva o negativa sobre las 6 estadísticas.
class StatDelta {
  const StatDelta({
    this.emotionalIntelligence = 0,
    this.intellect = 0,
    this.strength = 0,
    this.health = 0,
    this.combatSkill = 0,
    this.mood = 0,
  });

  final int emotionalIntelligence;
  final int intellect;
  final int strength;
  final int health;
  final int combatSkill;
  final int mood;

  bool get isEmpty =>
      emotionalIntelligence == 0 &&
      intellect == 0 &&
      strength == 0 &&
      health == 0 &&
      combatSkill == 0 &&
      mood == 0;

  String formatSummary() {
    final parts = <String>[];
    void add(int val, String label) {
      if (val != 0) parts.add('${val > 0 ? '+' : ''}$val $label');
    }

    add(emotionalIntelligence, StatType.emotionalIntelligence.shortLabel);
    add(intellect, StatType.intellect.shortLabel);
    add(strength, StatType.strength.shortLabel);
    add(health, StatType.health.shortLabel);
    add(combatSkill, StatType.combatSkill.shortLabel);
    add(mood, StatType.mood.shortLabel);
    return parts.join(' · ');
  }
}

/// Bloque inmutable de estadísticas del protagonista (cada una entre 0 y 100).
class CharacterStats {
  const CharacterStats({
    required this.emotionalIntelligence,
    required this.intellect,
    required this.strength,
    required this.health,
    required this.combatSkill,
    required this.mood,
  });

  final int emotionalIntelligence;
  final int intellect;
  final int strength;
  final int health;
  final int combatSkill;
  final int mood;

  int operator [](StatType type) {
    switch (type) {
      case StatType.emotionalIntelligence:
        return emotionalIntelligence;
      case StatType.intellect:
        return intellect;
      case StatType.strength:
        return strength;
      case StatType.health:
        return health;
      case StatType.combatSkill:
        return combatSkill;
      case StatType.mood:
        return mood;
    }
  }

  CharacterStats applyDelta(StatDelta delta) {
    return CharacterStats(
      emotionalIntelligence:
          (emotionalIntelligence + delta.emotionalIntelligence).clamp(0, 100),
      intellect: (intellect + delta.intellect).clamp(0, 100),
      strength: (strength + delta.strength).clamp(0, 100),
      health: (health + delta.health).clamp(0, 100),
      combatSkill: (combatSkill + delta.combatSkill).clamp(0, 100),
      mood: (mood + delta.mood).clamp(0, 100),
    );
  }

  CharacterStats copyWith({
    int? emotionalIntelligence,
    int? intellect,
    int? strength,
    int? health,
    int? combatSkill,
    int? mood,
  }) {
    return CharacterStats(
      emotionalIntelligence:
          (emotionalIntelligence ?? this.emotionalIntelligence).clamp(0, 100),
      intellect: (intellect ?? this.intellect).clamp(0, 100),
      strength: (strength ?? this.strength).clamp(0, 100),
      health: (health ?? this.health).clamp(0, 100),
      combatSkill: (combatSkill ?? this.combatSkill).clamp(0, 100),
      mood: (mood ?? this.mood).clamp(0, 100),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emotionalIntelligence': emotionalIntelligence,
      'intellect': intellect,
      'strength': strength,
      'health': health,
      'combatSkill': combatSkill,
      'mood': mood,
    };
  }

  factory CharacterStats.fromJson(Map<String, dynamic> json) {
    return CharacterStats(
      emotionalIntelligence:
          ((json['emotionalIntelligence'] as num?)?.toInt() ?? 20).clamp(0, 100),
      intellect: ((json['intellect'] as num?)?.toInt() ?? 20).clamp(0, 100),
      strength: ((json['strength'] as num?)?.toInt() ?? 10).clamp(0, 100),
      health: ((json['health'] as num?)?.toInt() ?? 75).clamp(0, 100),
      combatSkill: ((json['combatSkill'] as num?)?.toInt() ?? 5).clamp(0, 100),
      mood: ((json['mood'] as num?)?.toInt() ?? 70).clamp(0, 100),
    );
  }
}

