import 'package:flutter/material.dart';

/// Etapas de vida del protagonista desde su renacimiento hasta la vejez.
enum LifeStage {
  earlyChildhood,
  childhood,
  adolescence,
  youth,
  adulthood,
  oldAge,
}

extension LifeStageX on LifeStage {
  String get label {
    switch (this) {
      case LifeStage.earlyChildhood:
        return 'Infancia temprana';
      case LifeStage.childhood:
        return 'Niñez';
      case LifeStage.adolescence:
        return 'Adolescencia';
      case LifeStage.youth:
        return 'Juventud';
      case LifeStage.adulthood:
        return 'Adultez';
      case LifeStage.oldAge:
        return 'Vejez';
    }
  }

  String get ageRangeLabel {
    switch (this) {
      case LifeStage.earlyChildhood:
        return '0–3 años';
      case LifeStage.childhood:
        return '4–11 años';
      case LifeStage.adolescence:
        return '12–17 años';
      case LifeStage.youth:
        return '18–34 años';
      case LifeStage.adulthood:
        return '35–59 años';
      case LifeStage.oldAge:
        return '60+ años';
    }
  }

  IconData get icon {
    switch (this) {
      case LifeStage.earlyChildhood:
        return Icons.child_friendly_outlined;
      case LifeStage.childhood:
        return Icons.toys_outlined;
      case LifeStage.adolescence:
        return Icons.explore_outlined;
      case LifeStage.youth:
        return Icons.hiking_rounded;
      case LifeStage.adulthood:
        return Icons.shield_outlined;
      case LifeStage.oldAge:
        return Icons.elderly_rounded;
    }
  }

  static LifeStage fromAge(int age) {
    if (age <= 3) return LifeStage.earlyChildhood;
    if (age <= 11) return LifeStage.childhood;
    if (age <= 17) return LifeStage.adolescence;
    if (age <= 34) return LifeStage.youth;
    if (age <= 59) return LifeStage.adulthood;
    return LifeStage.oldAge;
  }

  static LifeStage parse(String? raw) {
    for (final stage in LifeStage.values) {
      if (stage.name == raw) return stage;
    }
    return LifeStage.earlyChildhood;
  }
}

