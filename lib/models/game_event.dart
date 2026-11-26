import 'character.dart';
import 'currency.dart';
import 'life_stage.dart';
import 'stats.dart';
import 'world_state.dart';

/// Requisito de atributo con probabilidad de éxito continua (0..100%).
class StatCheck {
  const StatCheck({
    required this.stat,
    required this.requiredScore,
    this.baseFloor = 5,
  });

  final StatType stat;
  final int requiredScore;
  final int baseFloor;

  /// Calcula la probabilidad de éxito (0 a 100) según la estadística del héroe.
  int successChanceFor(CharacterStats stats) {
    if (requiredScore <= 0) return 100;
    final statValue = stats[stat];
    if (statValue <= 0) return baseFloor.clamp(0, 100);
    if (statValue >= requiredScore) {
      return (85 + (statValue - requiredScore)).clamp(0, 100);
    }
    final ratio = statValue / requiredScore;
    return (baseFloor + ratio * (80 - baseFloor)).round().clamp(0, 100);
  }
}

/// Consecuencia concreta de una opción (en éxito o fallo).
class EventOutcome {
  const EventOutcome({
    required this.description,
    this.statDelta = const StatDelta(),
    this.copperDelta = 0,
  });

  final String description;
  final StatDelta statDelta;
  final int copperDelta;

  String formatPreview() {
    final parts = <String>[];
    final statsStr = statDelta.formatSummary();
    if (statsStr.isNotEmpty) parts.add(statsStr);
    if (copperDelta != 0) parts.add(RpgCurrency.formatDelta(copperDelta));
    return parts.isEmpty ? 'Sin cambios de atributos' : parts.join(' · ');
  }
}

/// Opción seleccionable dentro de un evento de etapa vital o hito de destino.
class EventChoice {
  const EventChoice({
    required this.id,
    required this.label,
    this.statCheck,
    required this.successOutcome,
    this.failureOutcome,
    this.minCopperRequired = 0,
    this.isDestinyChoice = false,
    this.destinyPreview,
    this.setsRoute,
    this.setsLocation,
    this.addsFlag,
    this.setsEnrolledInSchool,
    this.setsChildWorker,
  });

  final String id;
  final String label;
  final StatCheck? statCheck;
  final EventOutcome successOutcome;
  final EventOutcome? failureOutcome;
  final int minCopperRequired;
  final bool isDestinyChoice;
  final String? destinyPreview;
  final StoryRoute? setsRoute;
  final WorldLocation? setsLocation;
  final String? addsFlag;
  final bool? setsEnrolledInSchool;
  final bool? setsChildWorker;
}

/// Plantilla de evento perteneciente a una de las 6 etapas de la vida.
class GameEventDefinition {
  const GameEventDefinition({
    required this.id,
    required this.stage,
    required this.title,
    this.requiresManaAwakened = false,
    this.requiresEnrolledInSchool = false,
    required this.narrativeBuilder,
    required this.choices,
  });

  final String id;
  final LifeStage stage;
  final String title;
  final bool requiresManaAwakened;
  final bool requiresEnrolledInSchool;
  final String Function(Protagonist hero, String npcName) narrativeBuilder;
  final List<EventChoice> choices;
}

/// Instancia activa de evento lista para mostrarse en el modal.
class ActiveGameEvent {
  const ActiveGameEvent({
    required this.eventId,
    required this.stage,
    required this.title,
    required this.narrative,
    required this.npcName,
    required this.choices,
    this.isStoryEvent = false,
    this.awakenedManaValue,
    this.triggersPrimaryDevelopment = false,
  });

  final String eventId;
  final LifeStage stage;
  final String title;
  final String narrative;
  final String npcName;
  final List<EventChoice> choices;
  final bool isStoryEvent;
  final int? awakenedManaValue;
  final bool triggersPrimaryDevelopment;
}

/// Resultado devuelto al resolver una opción del evento.
class EventResolutionResult {
  const EventResolutionResult({
    required this.title,
    required this.wasCheck,
    required this.succeeded,
    this.roll,
    this.chance,
    this.statChecked,
    required this.description,
    required this.statDelta,
    required this.copperDelta,
  });

  final String title;
  final bool wasCheck;
  final bool succeeded;
  final int? roll;
  final int? chance;
  final StatType? statChecked;
  final String description;
  final StatDelta statDelta;
  final int copperDelta;
}
