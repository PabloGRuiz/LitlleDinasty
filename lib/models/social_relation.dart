import 'package:flutter/material.dart';

import '../theme/medieval_theme.dart';

/// Grupo o ámbito en el que el protagonista conoce a una persona.
enum RelationshipGroup {
  family,
  village,
  school,
  guild,
  world,
}

extension RelationshipGroupX on RelationshipGroup {
  String get label {
    switch (this) {
      case RelationshipGroup.family:
        return 'Familia';
      case RelationshipGroup.village:
        return 'Aldea';
      case RelationshipGroup.school:
        return 'Escuela';
      case RelationshipGroup.guild:
        return 'Gremio';
      case RelationshipGroup.world:
        return 'Mundo';
    }
  }

  IconData get icon {
    switch (this) {
      case RelationshipGroup.family:
        return Icons.home_outlined;
      case RelationshipGroup.village:
        return Icons.cottage_outlined;
      case RelationshipGroup.school:
        return Icons.school_outlined;
      case RelationshipGroup.guild:
        return Icons.explore_outlined;
      case RelationshipGroup.world:
        return Icons.public_rounded;
    }
  }

  Color get color {
    switch (this) {
      case RelationshipGroup.family:
        return MedievalColors.amberOchre;
      case RelationshipGroup.village:
        return MedievalColors.forestGreen;
      case RelationshipGroup.school:
        return MedievalColors.royalBlue;
      case RelationshipGroup.guild:
        return MedievalColors.crimsonSeal;
      case RelationshipGroup.world:
        return MedievalColors.arcaneViolet;
    }
  }

  static RelationshipGroup parse(String? raw) {
    for (final g in RelationshipGroup.values) {
      if (g.name == raw) return g;
    }
    return RelationshipGroup.village;
  }
}

/// Rango cualitativo según el puntaje de afinidad (0–100).
enum AffinityLevel {
  hostile,
  distant,
  acquaintance,
  friend,
  trusted,
  unbreakable,
}

extension AffinityLevelX on AffinityLevel {
  String get label {
    switch (this) {
      case AffinityLevel.hostile:
        return 'Hostil';
      case AffinityLevel.distant:
        return 'Distante';
      case AffinityLevel.acquaintance:
        return 'Conocido';
      case AffinityLevel.friend:
        return 'Cercano';
      case AffinityLevel.trusted:
        return 'Gran Vínculo';
      case AffinityLevel.unbreakable:
        return 'Inseparable';
    }
  }

  Color get color {
    switch (this) {
      case AffinityLevel.hostile:
        return MedievalColors.crimsonSeal;
      case AffinityLevel.distant:
        return MedievalColors.amberOchre;
      case AffinityLevel.acquaintance:
        return MedievalColors.royalBlue;
      case AffinityLevel.friend:
        return MedievalColors.forestGreen;
      case AffinityLevel.trusted:
        return MedievalColors.arcaneViolet;
      case AffinityLevel.unbreakable:
        return MedievalColors.goldCoin;
    }
  }

  Color get bgColor {
    switch (this) {
      case AffinityLevel.hostile:
        return MedievalColors.crimsonSealBg;
      case AffinityLevel.distant:
        return MedievalColors.amberOchreBg;
      case AffinityLevel.acquaintance:
        return MedievalColors.royalBlueBg;
      case AffinityLevel.friend:
        return MedievalColors.forestGreenBg;
      case AffinityLevel.trusted:
        return MedievalColors.arcaneVioletBg;
      case AffinityLevel.unbreakable:
        return MedievalColors.amberOchreBg;
    }
  }

  static AffinityLevel fromScore(int affinity) {
    if (affinity < 20) return AffinityLevel.hostile;
    if (affinity < 40) return AffinityLevel.distant;
    if (affinity < 60) return AffinityLevel.acquaintance;
    if (affinity < 80) return AffinityLevel.friend;
    if (affinity < 95) return AffinityLevel.trusted;
    return AffinityLevel.unbreakable;
  }
}

enum NpcTemperament {
  warm,
  reserved,
  ambitious,
  scholarly,
  practical;

  static NpcTemperament parse(String? value) {
    return NpcTemperament.values.firstWhere(
      (e) => e.name == value,
      orElse: () => NpcTemperament.practical,
    );
  }
}

enum ChatTopic {
  askOccupation,
  askIdentityAndAge,
  askFamily,
  casualTalk;

  String get label {
    switch (this) {
      case ChatTopic.askOccupation:
        return 'Preguntar a qué se dedica';
      case ChatTopic.askIdentityAndAge:
        return 'Preguntar quién es y su edad';
      case ChatTopic.askFamily:
        return 'Preguntar sobre su familia';
      case ChatTopic.casualTalk:
        return 'Conversar sobre la aldea y rumores';
    }
  }
}

class ChatOutcomeResult {
  const ChatOutcomeResult({
    required this.contactId,
    required this.contactName,
    required this.topic,
    required this.liked,
    required this.affinityDelta,
    required this.newAffinity,
    required this.npcReply,
    required this.discoveredFacts,
  });

  final String contactId;
  final String contactName;
  final ChatTopic topic;
  final bool liked;
  final int affinityDelta;
  final int newAffinity;
  final String npcReply;
  final List<String> discoveredFacts;
}

/// Persona conocida por el protagonista con su rol, ámbito, identidad y afinidad (0..100).
class SocialContact {
  const SocialContact({
    required this.id,
    required this.name,
    required this.role,
    required this.group,
    required this.affinity,
    required this.firstMetYear,
    required this.firstMetAge,
    required this.lastInteractionNote,
    this.lastInteractionSemesterKey,
    this.isAlive = true,
    this.age = 25,
    this.occupation = 'Oficio por descubrir',
    this.bio = 'Alguien cuyo pasado aún desconoces.',
    this.familyInfo = 'Sin datos sobre sus lazos familiares.',
    this.temperament = NpcTemperament.practical,
    this.knowsAge = false,
    this.knowsOccupation = false,
    this.knowsBio = false,
    this.knowsFamily = false,
  });

  final String id;
  final String name;
  final String role;
  final RelationshipGroup group;
  final int affinity;
  final int firstMetYear;
  final int firstMetAge;
  final String lastInteractionNote;
  final String? lastInteractionSemesterKey;
  final bool isAlive;
  final int age;
  final String occupation;
  final String bio;
  final String familyInfo;
  final NpcTemperament temperament;
  final bool knowsAge;
  final bool knowsOccupation;
  final bool knowsBio;
  final bool knowsFamily;

  AffinityLevel get affinityLevel => AffinityLevelX.fromScore(affinity);

  int get knownFactsCount =>
      (knowsAge ? 1 : 0) +
      (knowsOccupation ? 1 : 0) +
      (knowsBio ? 1 : 0) +
      (knowsFamily ? 1 : 0);

  bool canInteractIn(String semesterKey) =>
      isAlive && lastInteractionSemesterKey != semesterKey;

  SocialContact copyWith({
    String? id,
    String? name,
    String? role,
    RelationshipGroup? group,
    int? affinity,
    int? firstMetYear,
    int? firstMetAge,
    String? lastInteractionNote,
    String? lastInteractionSemesterKey,
    bool? isAlive,
    int? age,
    String? occupation,
    String? bio,
    String? familyInfo,
    NpcTemperament? temperament,
    bool? knowsAge,
    bool? knowsOccupation,
    bool? knowsBio,
    bool? knowsFamily,
  }) {
    return SocialContact(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      group: group ?? this.group,
      affinity: (affinity ?? this.affinity).clamp(0, 100),
      firstMetYear: firstMetYear ?? this.firstMetYear,
      firstMetAge: firstMetAge ?? this.firstMetAge,
      lastInteractionNote: lastInteractionNote ?? this.lastInteractionNote,
      lastInteractionSemesterKey:
          lastInteractionSemesterKey ?? this.lastInteractionSemesterKey,
      isAlive: isAlive ?? this.isAlive,
      age: age ?? this.age,
      occupation: occupation ?? this.occupation,
      bio: bio ?? this.bio,
      familyInfo: familyInfo ?? this.familyInfo,
      temperament: temperament ?? this.temperament,
      knowsAge: knowsAge ?? this.knowsAge,
      knowsOccupation: knowsOccupation ?? this.knowsOccupation,
      knowsBio: knowsBio ?? this.knowsBio,
      knowsFamily: knowsFamily ?? this.knowsFamily,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'group': group.name,
      'affinity': affinity,
      'firstMetYear': firstMetYear,
      'firstMetAge': firstMetAge,
      'lastInteractionNote': lastInteractionNote,
      'lastInteractionSemesterKey': lastInteractionSemesterKey,
      'isAlive': isAlive,
      'age': age,
      'occupation': occupation,
      'bio': bio,
      'familyInfo': familyInfo,
      'temperament': temperament.name,
      'knowsAge': knowsAge,
      'knowsOccupation': knowsOccupation,
      'knowsBio': knowsBio,
      'knowsFamily': knowsFamily,
    };
  }

  factory SocialContact.fromJson(Map<String, dynamic> json) {
    return SocialContact(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String? ?? 'Conocido',
      group: RelationshipGroupX.parse(json['group'] as String?),
      affinity: ((json['affinity'] as num?)?.toInt() ?? 50).clamp(0, 100),
      firstMetYear: (json['firstMetYear'] as num?)?.toInt() ?? 1140,
      firstMetAge: (json['firstMetAge'] as num?)?.toInt() ?? 0,
      lastInteractionNote: json['lastInteractionNote'] as String? ?? '',
      lastInteractionSemesterKey:
          json['lastInteractionSemesterKey'] as String?,
      isAlive: json['isAlive'] as bool? ?? true,
      age: (json['age'] as num?)?.toInt() ?? 25,
      occupation: json['occupation'] as String? ?? 'Oficio por descubrir',
      bio: json['bio'] as String? ?? 'Alguien cuyo pasado aún desconoces.',
      familyInfo:
          json['familyInfo'] as String? ?? 'Sin datos sobre sus lazos familiares.',
      temperament: NpcTemperament.parse(json['temperament'] as String?),
      knowsAge: json['knowsAge'] as bool? ?? false,
      knowsOccupation: json['knowsOccupation'] as bool? ?? false,
      knowsBio: json['knowsBio'] as bool? ?? false,
      knowsFamily: json['knowsFamily'] as bool? ?? false,
    );
  }
}

