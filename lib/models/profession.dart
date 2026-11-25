import 'game_event.dart';
import 'stats.dart';

/// Profesiones disponibles en el mundo medieval.
enum ProfessionId {
  none,
  adventurer,
}

extension ProfessionIdX on ProfessionId {
  String get label {
    switch (this) {
      case ProfessionId.none:
        return 'Sin oficio';
      case ProfessionId.adventurer:
        return 'Aventurero';
    }
  }

  static ProfessionId parse(String? raw) {
    for (final value in ProfessionId.values) {
      if (value.name == raw) return value;
    }
    return ProfessionId.none;
  }
}

/// Rangos del Gremio de Aventureros (Bronce E hasta Mithril A).
enum AdventurerRank {
  bronzeE,
  ironD,
  silverC,
  goldB,
  mithrilA,
}

extension AdventurerRankX on AdventurerRank {
  String get label {
    switch (this) {
      case AdventurerRank.bronzeE:
        return 'Rango E · Bronce';
      case AdventurerRank.ironD:
        return 'Rango D · Hierro';
      case AdventurerRank.silverC:
        return 'Rango C · Plata';
      case AdventurerRank.goldB:
        return 'Rango B · Oro';
      case AdventurerRank.mithrilA:
        return 'Rango A · Mithril';
    }
  }

  int get minXp {
    switch (this) {
      case AdventurerRank.bronzeE:
        return 0;
      case AdventurerRank.ironD:
        return 30;
      case AdventurerRank.silverC:
        return 70;
      case AdventurerRank.goldB:
        return 130;
      case AdventurerRank.mithrilA:
        return 220;
    }
  }

  /// Ingreso mensual pasivo en monedas de cobre por patrullas y encargos menores.
  int get monthlyStipendCopper {
    switch (this) {
      case AdventurerRank.bronzeE:
        return 15;
      case AdventurerRank.ironD:
        return 35;
      case AdventurerRank.silverC:
        return 80;
      case AdventurerRank.goldB:
        return 160;
      case AdventurerRank.mithrilA:
        return 320;
    }
  }

  AdventurerRank? get nextRank {
    final idx = AdventurerRank.values.indexOf(this);
    if (idx + 1 < AdventurerRank.values.length) {
      return AdventurerRank.values[idx + 1];
    }
    return null;
  }

  static AdventurerRank fromXp(int xp) {
    var current = AdventurerRank.bronzeE;
    for (final rank in AdventurerRank.values) {
      if (xp >= rank.minXp) {
        current = rank;
      }
    }
    return current;
  }
}

/// Encargo semestral del Gremio de Aventureros.
class GuildQuest {
  const GuildQuest({
    required this.id,
    required this.title,
    required this.description,
    required this.minRank,
    required this.statCheck,
    required this.successOutcome,
    required this.failureOutcome,
    required this.xpRewardSuccess,
    required this.xpRewardFailure,
  });

  final String id;
  final String title;
  final String description;
  final AdventurerRank minRank;
  final StatCheck statCheck;
  final EventOutcome successOutcome;
  final EventOutcome failureOutcome;
  final int xpRewardSuccess;
  final int xpRewardFailure;
}

/// Catálogo de encargos disponibles en el tablón del Gremio.
class GuildQuestCatalog {
  GuildQuestCatalog._();

  static const List<GuildQuest> all = [
    GuildQuest(
      id: 'quest_lunar_herbs',
      title: 'Recolectar Hierbas Lunares',
      description:
          'El boticario del gremio solicita raíces luminosas en la linde del bosque.',
      minRank: AdventurerRank.bronzeE,
      statCheck: StatCheck(stat: StatType.intellect, requiredScore: 30),
      successOutcome: EventOutcome(
        description:
            'Identificas los brotes puros sin tocar las plantas tóxicas.',
        statDelta: StatDelta(intellect: 3, mood: 3),
        copperDelta: 65,
      ),
      failureOutcome: EventOutcome(
        description:
            'Te pierdes entre los helechos y regresas con una cesta escasa.',
        statDelta: StatDelta(health: -4, mood: -3),
        copperDelta: 15,
      ),
      xpRewardSuccess: 14,
      xpRewardFailure: 5,
    ),
    GuildQuest(
      id: 'quest_grain_escort',
      title: 'Escoltar Carreta de Grano',
      description:
          'Protege un convoy lento hasta el cruce comercial de la comarca.',
      minRank: AdventurerRank.bronzeE,
      statCheck: StatCheck(stat: StatType.strength, requiredScore: 32),
      successOutcome: EventOutcome(
        description:
            'Empujas ruedas atascadas en el barro y ahuyentas merodeadores.',
        statDelta: StatDelta(strength: 4, combatSkill: 2, mood: 3),
        copperDelta: 90,
      ),
      failureOutcome: EventOutcome(
        description:
            'Un eje roto retrasa el viaje y el mercader descuenta parte de la paga.',
        statDelta: StatDelta(health: -5, mood: -4),
        copperDelta: 25,
      ),
      xpRewardSuccess: 16,
      xpRewardFailure: 6,
    ),
    GuildQuest(
      id: 'quest_track_wolves',
      title: 'Rastrear Lobos en la Cañada',
      description:
          'Una manada inquieta ronda los pastos del norte desde hace semanas.',
      minRank: AdventurerRank.ironD,
      statCheck: StatCheck(stat: StatType.combatSkill, requiredScore: 42),
      successOutcome: EventOutcome(
        description:
            'Abates al macho alfa tras una persecución precisa y cobras la recompensa.',
        statDelta: StatDelta(combatSkill: 5, strength: 2, mood: 5),
        copperDelta: 240,
      ),
      failureOutcome: EventOutcome(
        description:
            'La jauría te rodea en la espesura y te obliga a retirarte herido.',
        statDelta: StatDelta(health: -12, combatSkill: 2, mood: -5),
        copperDelta: 40,
      ),
      xpRewardSuccess: 22,
      xpRewardFailure: 8,
    ),
    GuildQuest(
      id: 'quest_goblin_den',
      title: 'Despejar Cubil de Trasgos',
      description:
          'Saqueadores trasgos han ocupado una vieja cantera junto al río.',
      minRank: AdventurerRank.silverC,
      statCheck: StatCheck(stat: StatType.combatSkill, requiredScore: 54),
      successOutcome: EventOutcome(
        description:
            'Limpias las galerías con táctica certera y recuperas bienes robados.',
        statDelta: StatDelta(combatSkill: 6, strength: 3, mood: 6),
        copperDelta: 550,
      ),
      failureOutcome: EventOutcome(
        description:
            'Una trampa de lanzas de madera te hiere y debes replegarte.',
        statDelta: StatDelta(health: -16, mood: -7),
        copperDelta: 80,
      ),
      xpRewardSuccess: 30,
      xpRewardFailure: 10,
    ),
    GuildQuest(
      id: 'quest_sunken_ruin',
      title: 'Explorar Ruina Subterránea',
      description:
          'Descifra los mecanismos de una bóveda antigua sin activar sus sellos.',
      minRank: AdventurerRank.goldB,
      statCheck: StatCheck(stat: StatType.intellect, requiredScore: 62),
      successOutcome: EventOutcome(
        description:
            'Resuelves las runas de piedra y extraes reliquias valiosas en oro.',
        statDelta: StatDelta(intellect: 6, emotionalIntelligence: 3, mood: 8),
        copperDelta: 11000,
      ),
      failureOutcome: EventOutcome(
        description:
            'Una placa de presión libera gas soporífero y escapas por poco.',
        statDelta: StatDelta(health: -14, mood: -6),
        copperDelta: 250,
      ),
      xpRewardSuccess: 40,
      xpRewardFailure: 12,
    ),
    GuildQuest(
      id: 'quest_highland_beast',
      title: 'Cazar Bestia de las Colinas',
      description:
          'Un grifo joven aterroriza las rutas comerciales de la meseta alta.',
      minRank: AdventurerRank.mithrilA,
      statCheck: StatCheck(stat: StatType.combatSkill, requiredScore: 72),
      successOutcome: EventOutcome(
        description:
            'Tu nombre resuena por todo el reino tras abatir a la bestia.',
        statDelta: StatDelta(combatSkill: 7, strength: 4, mood: 10),
        copperDelta: 25000,
      ),
      failureOutcome: EventOutcome(
        description:
            'Sus garras rompen tu guardia; sobrevives de milagro con heridas graves.',
        statDelta: StatDelta(health: -22, combatSkill: 2, mood: -8),
        copperDelta: 600,
      ),
      xpRewardSuccess: 55,
      xpRewardFailure: 15,
    ),
  ];

  static List<GuildQuest> availableFor(AdventurerRank rank) {
    final rankIdx = AdventurerRank.values.indexOf(rank);
    return all
        .where((q) => AdventurerRank.values.indexOf(q.minRank) <= rankIdx)
        .toList();
  }
}

