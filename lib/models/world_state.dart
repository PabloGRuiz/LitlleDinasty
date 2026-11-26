import 'package:flutter/material.dart';

/// Lugares del mundo que el protagonista puede habitar o visitar.
enum WorldLocation {
  homeVillage,
  borderTown,
  royalCapital,
  arcaneTower,
  demonFrontier,
}

extension WorldLocationX on WorldLocation {
  String labelFor(String homeVillageName) {
    switch (this) {
      case WorldLocation.homeVillage:
        return homeVillageName;
      case WorldLocation.borderTown:
        return 'Villa Fronteriza';
      case WorldLocation.royalCapital:
        return 'Capital Real';
      case WorldLocation.arcaneTower:
        return 'Torre Arcana';
      case WorldLocation.demonFrontier:
        return 'Frontera del Abismo';
    }
  }

  String get description {
    switch (this) {
      case WorldLocation.homeVillage:
        return 'Tu tranquila aldea natal rodeada de bosques y colinas.';
      case WorldLocation.borderTown:
        return 'Cruce bullicioso de caravanas, mercenarios y aventureros.';
      case WorldLocation.royalCapital:
        return 'Corazón del reino, sede del Gremio Central y la convocatoria de héroes.';
      case WorldLocation.arcaneTower:
        return 'Santuario de sabios y magos que estudian el flujo del maná.';
      case WorldLocation.demonFrontier:
        return 'Tierras sombrías cercanas al sello donde acechan las huestes demoníacas.';
    }
  }

  IconData get icon {
    switch (this) {
      case WorldLocation.homeVillage:
        return Icons.cottage_outlined;
      case WorldLocation.borderTown:
        return Icons.storefront_outlined;
      case WorldLocation.royalCapital:
        return Icons.castle_outlined;
      case WorldLocation.arcaneTower:
        return Icons.auto_fix_high_rounded;
      case WorldLocation.demonFrontier:
        return Icons.local_fire_department_outlined;
    }
  }

  int get minAgeToTravel {
    switch (this) {
      case WorldLocation.homeVillage:
        return 0;
      case WorldLocation.borderTown:
      case WorldLocation.royalCapital:
      case WorldLocation.arcaneTower:
        return 15;
      case WorldLocation.demonFrontier:
        return 18;
    }
  }

  static WorldLocation parse(String? raw) {
    for (final loc in WorldLocation.values) {
      if (loc.name == raw) return loc;
    }
    return WorldLocation.homeVillage;
  }
}

/// Rutas narrativas principales forjadas por decisiones de destino.
enum StoryRoute {
  unwritten,
  villageGuardian,
  arcanePath,
  heroCandidate,
  freeWanderer,
}

extension StoryRouteX on StoryRoute {
  String get label {
    switch (this) {
      case StoryRoute.unwritten:
        return 'Destino por Escribir';
      case StoryRoute.villageGuardian:
        return 'Guardián del Hogar';
      case StoryRoute.arcanePath:
        return 'Senda Arcana';
      case StoryRoute.heroCandidate:
        return 'Aspirante a Héroe';
      case StoryRoute.freeWanderer:
        return 'Viajero Libre';
    }
  }

  String get description {
    switch (this) {
      case StoryRoute.unwritten:
        return 'Aún eres joven y tu camino en este mundo mágico está abierto.';
      case StoryRoute.villageGuardian:
        return 'Elegiste echar raíces y proteger a quienes te vieron crecer.';
      case StoryRoute.arcanePath:
        return 'Consagraste tu destino a descifrar el maná y los misterios arcanos.';
      case StoryRoute.heroCandidate:
        return 'Respondiste al llamado de los reinos contra la sombra del Rey Demonio.';
      case StoryRoute.freeWanderer:
        return 'Dejaste tu aldea para recorrer el mundo sin ataduras ni señores.';
    }
  }

  IconData get icon {
    switch (this) {
      case StoryRoute.unwritten:
        return Icons.explore_outlined;
      case StoryRoute.villageGuardian:
        return Icons.shield_outlined;
      case StoryRoute.arcanePath:
        return Icons.auto_fix_high_rounded;
      case StoryRoute.heroCandidate:
        return Icons.military_tech_outlined;
      case StoryRoute.freeWanderer:
        return Icons.hiking_rounded;
    }
  }

  static StoryRoute parse(String? raw) {
    for (final r in StoryRoute.values) {
      if (r.name == raw) return r;
    }
    return StoryRoute.unwritten;
  }
}

/// Eras del mundo vivo según la amenaza del Rey Demonio y los hitos globales.
enum WorldEra {
  quietEra,
  shadowRumors,
  crackedSeal,
  heroesSummons,
  demonWar,
  newDawn,
}

extension WorldEraX on WorldEra {
  String get label {
    switch (this) {
      case WorldEra.quietEra:
        return 'Era de Calma Aparente';
      case WorldEra.shadowRumors:
        return 'Susurros en la Frontera';
      case WorldEra.crackedSeal:
        return 'El Sello Agrietado';
      case WorldEra.heroesSummons:
        return 'Convocatoria de Héroes';
      case WorldEra.demonWar:
        return 'Guerra del Rey Demonio';
      case WorldEra.newDawn:
        return 'Alba de una Nueva Era';
    }
  }

  String get description {
    switch (this) {
      case WorldEra.quietEra:
        return 'Los reinos disfrutan de paz mientras la leyenda del Rey Demonio parece lejana.';
      case WorldEra.shadowRumors:
        return 'Criaturas mágicas inquietas y reportes fronterizos despiertan la alerta real.';
      case WorldEra.crackedSeal:
        return 'El sello ancestral pierde fuerza y los sabios temen el despertar oscuro.';
      case WorldEra.heroesSummons:
        return 'Todos los reinos buscan guerreros, magos y aventureros para el Grupo de Héroes.';
      case WorldEra.demonWar:
        return 'El Rey Demonio ha despertado en el Abismo y las batallas deciden el mundo.';
      case WorldEra.newDawn:
        return 'La gran crisis remite y el continente inicia una etapa de reconstrucción.';
    }
  }

  static WorldEra fromWorld(int threat, Set<String> flags) {
    if (flags.contains('new_dawn_era')) return WorldEra.newDawn;
    if (flags.contains('demon_king_awakened') || threat >= 80) {
      return WorldEra.demonWar;
    }
    if (flags.contains('heroes_summons_active') || threat >= 55) {
      return WorldEra.heroesSummons;
    }
    if (threat >= 35) return WorldEra.crackedSeal;
    if (threat >= 18) return WorldEra.shadowRumors;
    return WorldEra.quietEra;
  }
}

/// Noticia del mundo vivo que ocurre de forma independiente al protagonista.
class WorldNewsEntry {
  const WorldNewsEntry({
    required this.id,
    required this.year,
    required this.month,
    required this.headline,
    required this.details,
  });

  final String id;
  final int year;
  final int month;
  final String headline;
  final String details;

  String get dateLabel => 'Año $year · Mes $month';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'year': year,
      'month': month,
      'headline': headline,
      'details': details,
    };
  }

  factory WorldNewsEntry.fromJson(Map<String, dynamic> json) {
    return WorldNewsEntry(
      id: json['id'] as String,
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      headline: json['headline'] as String,
      details: json['details'] as String,
    );
  }
}

/// Estado persistente del mundo vivo, ruta de historia y progreso canónico.
class WorldState {
  const WorldState({
    required this.currentLocation,
    required this.route,
    required this.demonKingThreat,
    required this.storyFlags,
    required this.completedStoryEventIds,
    required this.worldNews,
  });

  factory WorldState.initial() {
    return const WorldState(
      currentLocation: WorldLocation.homeVillage,
      route: StoryRoute.unwritten,
      demonKingThreat: 8,
      storyFlags: {},
      completedStoryEventIds: {},
      worldNews: [],
    );
  }

  final WorldLocation currentLocation;
  final StoryRoute route;
  final int demonKingThreat;
  final Set<String> storyFlags;
  final Set<String> completedStoryEventIds;
  final List<WorldNewsEntry> worldNews;

  WorldEra get era => WorldEraX.fromWorld(demonKingThreat, storyFlags);

  WorldState copyWith({
    WorldLocation? currentLocation,
    StoryRoute? route,
    int? demonKingThreat,
    Set<String>? storyFlags,
    Set<String>? completedStoryEventIds,
    List<WorldNewsEntry>? worldNews,
  }) {
    return WorldState(
      currentLocation: currentLocation ?? this.currentLocation,
      route: route ?? this.route,
      demonKingThreat: (demonKingThreat ?? this.demonKingThreat).clamp(0, 100),
      storyFlags: storyFlags ?? this.storyFlags,
      completedStoryEventIds:
          completedStoryEventIds ?? this.completedStoryEventIds,
      worldNews: worldNews ?? this.worldNews,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentLocation': currentLocation.name,
      'route': route.name,
      'demonKingThreat': demonKingThreat,
      'storyFlags': storyFlags.toList(),
      'completedStoryEventIds': completedStoryEventIds.toList(),
      'worldNews': worldNews.map((e) => e.toJson()).toList(),
    };
  }

  factory WorldState.fromJson(Map<String, dynamic> json) {
    final flagsRaw = json['storyFlags'] as List<dynamic>? ?? const [];
    final completedRaw =
        json['completedStoryEventIds'] as List<dynamic>? ?? const [];
    final newsRaw = json['worldNews'] as List<dynamic>? ?? const [];

    return WorldState(
      currentLocation: WorldLocationX.parse(json['currentLocation'] as String?),
      route: StoryRouteX.parse(json['route'] as String?),
      demonKingThreat:
          ((json['demonKingThreat'] as num?)?.toInt() ?? 8).clamp(0, 100),
      storyFlags: flagsRaw.map((e) => e.toString()).toSet(),
      completedStoryEventIds: completedRaw.map((e) => e.toString()).toSet(),
      worldNews: newsRaw
          .map((e) => WorldNewsEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

