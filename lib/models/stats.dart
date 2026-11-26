import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/medieval_theme.dart';

/// Formatea enteros grandes con separador de miles (ej. 40000 -> 40.000).
String formatStatNumber(int value) {
  final sign = value < 0 ? '-' : '';
  final digits = value.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final remaining = digits.length - i;
    if (i > 0 && remaining % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(digits[i]);
  }
  return '$sign${buffer.toString()}';
}

/// Estadísticas del protagonista (6 base + Maná a los 6 años + 3 avanzadas a los 10 años).
enum StatType {
  emotionalIntelligence,
  intellect,
  strength,
  health,
  combatSkill,
  mood,
  mana,
  fortitude,
  magicPower,
  knowledge,
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
      case StatType.mana:
        return 'Maná';
      case StatType.fortitude:
        return 'Fortaleza';
      case StatType.magicPower:
        return 'Poder Mágico';
      case StatType.knowledge:
        return 'Conocimientos';
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
      case StatType.mana:
        return 'Maná';
      case StatType.fortitude:
        return 'Fortaleza';
      case StatType.magicPower:
        return 'Poder Mágico';
      case StatType.knowledge:
        return 'Conocimientos';
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
      case StatType.mana:
        return Icons.auto_fix_high_rounded;
      case StatType.fortitude:
        return Icons.shield_rounded;
      case StatType.magicPower:
        return Icons.bolt_rounded;
      case StatType.knowledge:
        return Icons.school_rounded;
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
      case StatType.mana:
        return MedievalColors.arcaneViolet;
      case StatType.fortitude:
        return MedievalColors.amberOchre;
      case StatType.magicPower:
        return MedievalColors.arcaneViolet;
      case StatType.knowledge:
        return MedievalColors.royalBlue;
    }
  }
}

/// Límites máximos posibles por cada estadística (100 hasta los 10 años; luego exponenciales).
class StatCaps {
  const StatCaps({
    this.emotionalIntelligence = 100,
    this.intellect = 100,
    this.strength = 100,
    this.health = 100,
    this.combatSkill = 100,
    this.mood = 100,
    this.mana = 100,
    this.fortitude = 100,
    this.magicPower = 100,
    this.knowledge = 100,
  });

  const StatCaps.initial() : this();

  /// Calcula los límites exponenciales tras culminar el desarrollo primario a los 10 años.
  factory StatCaps.fromPrimaryDevelopment(CharacterStats s) {
    final safeHealth = max<int>(1, s.health);
    final safeCombat = max<int>(1, s.combatSkill);
    final safeMana = max<int>(1, s.mana);
    final safeIntellect = max<int>(1, s.intellect);
    final martialProduct = max<int>(100, s.strength * safeHealth * safeCombat);
    return StatCaps(
      emotionalIntelligence: 100,
      intellect: 100,
      strength: max<int>(100, s.strength * safeHealth),
      health: 100,
      combatSkill: martialProduct,
      mood: 100,
      mana: max<int>(100, safeMana * safeIntellect),
      fortitude: martialProduct,
      magicPower: max<int>(100, safeCombat * safeMana * safeIntellect),
      knowledge: max<int>(100, s.intellect * 10),
    );
  }

  final int emotionalIntelligence;
  final int intellect;
  final int strength;
  final int health;
  final int combatSkill;
  final int mood;
  final int mana;
  final int fortitude;
  final int magicPower;
  final int knowledge;

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
      case StatType.mana:
        return mana;
      case StatType.fortitude:
        return fortitude;
      case StatType.magicPower:
        return magicPower;
      case StatType.knowledge:
        return knowledge;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'emotionalIntelligence': emotionalIntelligence,
      'intellect': intellect,
      'strength': strength,
      'health': health,
      'combatSkill': combatSkill,
      'mood': mood,
      'mana': mana,
      'fortitude': fortitude,
      'magicPower': magicPower,
      'knowledge': knowledge,
    };
  }

  factory StatCaps.fromJson(Map<String, dynamic> json) {
    return StatCaps(
      emotionalIntelligence:
          (json['emotionalIntelligence'] as num?)?.toInt() ?? 100,
      intellect: (json['intellect'] as num?)?.toInt() ?? 100,
      strength: (json['strength'] as num?)?.toInt() ?? 100,
      health: (json['health'] as num?)?.toInt() ?? 100,
      combatSkill: (json['combatSkill'] as num?)?.toInt() ?? 100,
      mood: (json['mood'] as num?)?.toInt() ?? 100,
      mana: (json['mana'] as num?)?.toInt() ?? 100,
      fortitude: (json['fortitude'] as num?)?.toInt() ?? 100,
      magicPower: (json['magicPower'] as num?)?.toInt() ?? 100,
      knowledge: (json['knowledge'] as num?)?.toInt() ?? 100,
    );
  }
}

/// Modificación positiva o negativa sobre las estadísticas.
class StatDelta {
  const StatDelta({
    this.emotionalIntelligence = 0,
    this.intellect = 0,
    this.strength = 0,
    this.health = 0,
    this.combatSkill = 0,
    this.mood = 0,
    this.mana = 0,
    this.fortitude = 0,
    this.magicPower = 0,
    this.knowledge = 0,
  });

  final int emotionalIntelligence;
  final int intellect;
  final int strength;
  final int health;
  final int combatSkill;
  final int mood;
  final int mana;
  final int fortitude;
  final int magicPower;
  final int knowledge;

  bool get isEmpty =>
      emotionalIntelligence == 0 &&
      intellect == 0 &&
      strength == 0 &&
      health == 0 &&
      combatSkill == 0 &&
      mood == 0 &&
      mana == 0 &&
      fortitude == 0 &&
      magicPower == 0 &&
      knowledge == 0;

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
    add(mana, StatType.mana.shortLabel);
    add(fortitude, StatType.fortitude.shortLabel);
    add(magicPower, StatType.magicPower.shortLabel);
    add(knowledge, StatType.knowledge.shortLabel);
    return parts.join(' · ');
  }
}

/// Bloque inmutable de estadísticas del protagonista respetando sus límites actuales.
class CharacterStats {
  const CharacterStats({
    required this.emotionalIntelligence,
    required this.intellect,
    required this.strength,
    required this.health,
    required this.combatSkill,
    required this.mood,
    this.mana = 0,
    this.fortitude = 0,
    this.magicPower = 0,
    this.knowledge = 0,
  });

  final int emotionalIntelligence;
  final int intellect;
  final int strength;
  final int health;
  final int combatSkill;
  final int mood;
  final int mana;
  final int fortitude;
  final int magicPower;
  final int knowledge;

  static List<StatType> visibleStats({
    required bool manaAwakened,
    bool primaryDevelopmentCompleted = false,
  }) {
    const advanced = {
      StatType.fortitude,
      StatType.magicPower,
      StatType.knowledge,
    };
    return StatType.values.where((s) {
      if (s == StatType.mana && !manaAwakened) return false;
      if (advanced.contains(s) && !primaryDevelopmentCompleted) return false;
      return true;
    }).toList();
  }

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
      case StatType.mana:
        return mana;
      case StatType.fortitude:
        return fortitude;
      case StatType.magicPower:
        return magicPower;
      case StatType.knowledge:
        return knowledge;
    }
  }

  CharacterStats applyDelta(
    StatDelta delta, {
    StatCaps caps = const StatCaps.initial(),
  }) {
    return CharacterStats(
      emotionalIntelligence:
          (emotionalIntelligence + delta.emotionalIntelligence)
              .clamp(0, caps.emotionalIntelligence),
      intellect: (intellect + delta.intellect).clamp(0, caps.intellect),
      strength: (strength + delta.strength).clamp(0, caps.strength),
      health: (health + delta.health).clamp(0, caps.health),
      combatSkill:
          (combatSkill + delta.combatSkill).clamp(0, caps.combatSkill),
      mood: (mood + delta.mood).clamp(0, caps.mood),
      mana: (mana + delta.mana).clamp(0, caps.mana),
      fortitude: (fortitude + delta.fortitude).clamp(0, caps.fortitude),
      magicPower: (magicPower + delta.magicPower).clamp(0, caps.magicPower),
      knowledge: (knowledge + delta.knowledge).clamp(0, caps.knowledge),
    );
  }

  CharacterStats copyWith({
    int? emotionalIntelligence,
    int? intellect,
    int? strength,
    int? health,
    int? combatSkill,
    int? mood,
    int? mana,
    int? fortitude,
    int? magicPower,
    int? knowledge,
    StatCaps caps = const StatCaps.initial(),
  }) {
    return CharacterStats(
      emotionalIntelligence:
          (emotionalIntelligence ?? this.emotionalIntelligence)
              .clamp(0, caps.emotionalIntelligence),
      intellect: (intellect ?? this.intellect).clamp(0, caps.intellect),
      strength: (strength ?? this.strength).clamp(0, caps.strength),
      health: (health ?? this.health).clamp(0, caps.health),
      combatSkill:
          (combatSkill ?? this.combatSkill).clamp(0, caps.combatSkill),
      mood: (mood ?? this.mood).clamp(0, caps.mood),
      mana: (mana ?? this.mana).clamp(0, caps.mana),
      fortitude: (fortitude ?? this.fortitude).clamp(0, caps.fortitude),
      magicPower: (magicPower ?? this.magicPower).clamp(0, caps.magicPower),
      knowledge: (knowledge ?? this.knowledge).clamp(0, caps.knowledge),
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
      'mana': mana,
      'fortitude': fortitude,
      'magicPower': magicPower,
      'knowledge': knowledge,
    };
  }

  factory CharacterStats.fromJson(Map<String, dynamic> json) {
    return CharacterStats(
      emotionalIntelligence:
          (json['emotionalIntelligence'] as num?)?.toInt() ?? 20,
      intellect: (json['intellect'] as num?)?.toInt() ?? 20,
      strength: (json['strength'] as num?)?.toInt() ?? 10,
      health: (json['health'] as num?)?.toInt() ?? 75,
      combatSkill: (json['combatSkill'] as num?)?.toInt() ?? 5,
      mood: (json['mood'] as num?)?.toInt() ?? 70,
      mana: (json['mana'] as num?)?.toInt() ?? 0,
      fortitude: (json['fortitude'] as num?)?.toInt() ?? 0,
      magicPower: (json['magicPower'] as num?)?.toInt() ?? 0,
      knowledge: (json['knowledge'] as num?)?.toInt() ?? 0,
    );
  }
}
