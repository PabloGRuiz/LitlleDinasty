import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/events_catalog.dart';
import '../data/medieval_names.dart';
import '../models/character.dart';
import '../models/currency.dart';
import '../models/game_event.dart';
import '../models/game_state.dart';
import '../models/life_stage.dart';
import '../models/profession.dart';
import '../models/semester_action.dart';
import '../models/stats.dart';

const String _storageKey = 'medieval_rebirth_state_v1';

final lifeProvider = NotifierProvider<LifeNotifier, GameState>(
  LifeNotifier.new,
);

/// Controlador principal de la vida medieval RPG, progresión y persistencia.
class LifeNotifier extends Notifier<GameState> {
  final Random _rng = Random();
  Timer? _timer;
  bool _disposed = false;

  @override
  GameState build() {
    ref.onDispose(() {
      _disposed = true;
      _timer?.cancel();
      _timer = null;
    });

    Future.microtask(_loadSavedState);
    return GameState.initialCreation();
  }

  Future<void> _loadSavedState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (_disposed || raw == null || raw.isEmpty) return;

      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final restored = GameState.fromJson(decoded);
      state = restored;
      _syncTimer();
    } catch (_) {
      // Si el guardado está corrupto, se mantiene la creación inicial.
    }
  }

  Future<void> _saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, jsonEncode(state.toJson()));
    } catch (_) {
      // Ignoramos errores transitorios de escritura.
    }
  }

  void _syncTimer() {
    if (_disposed) return;
    _timer?.cancel();
    _timer = null;

    if (state.needsCharacterCreation ||
        state.isPaused ||
        state.isGameOver ||
        state.activeEvent != null) {
      return;
    }

    final interval = state.speedMultiplier >= 2
        ? const Duration(milliseconds: 800)
        : const Duration(milliseconds: 1600);

    _timer = Timer.periodic(interval, (_) {
      if (_disposed) return;
      advanceMonth();
    });
  }

  /// Inicia una nueva vida desde los 0 años con nombre elegido y entorno aleatorio.
  void startNewLife({
    required String name,
    required Gender gender,
    bool startPaused = false,
  }) {
    final trimmed = name.trim();
    final chosenName = trimmed.isEmpty
        ? (gender == Gender.male
            ? pickRandomMaleName(_rng)
            : pickRandomFemaleName(_rng))
        : trimmed;

    final surname = pickRandomSurname(_rng);
    final fatherName = '${pickRandomMaleName(_rng)} $surname';
    final motherName =
        '${pickRandomFemaleName(_rng)} ${pickRandomSurname(_rng)}';
    final villageName = pickRandomVillage(_rng);
    final birthYear = 1120 + _rng.nextInt(80);

    final stats = CharacterStats(
      emotionalIntelligence: 20 + _rng.nextInt(11),
      intellect: 20 + _rng.nextInt(11),
      strength: 6 + _rng.nextInt(7),
      health: 75 + _rng.nextInt(11),
      combatSkill: 2 + _rng.nextInt(5),
      mood: 68 + _rng.nextInt(11),
    );

    final hero = Protagonist(
      name: chosenName,
      surname: surname,
      gender: gender,
      age: 0,
      birthYear: birthYear,
      isAlive: true,
      stats: stats,
      avatarSeed: _rng.nextInt(99999) + 1,
      fatherName: fatherName,
      motherName: motherName,
      villageName: villageName,
    );

    final openingChronicle = ChronicleEntry(
      id: 'rebirth_${DateTime.now().microsecondsSinceEpoch}',
      year: birthYear,
      month: 1,
      age: 0,
      stage: LifeStage.earlyChildhood,
      title: 'Renacimiento en $villageName',
      description:
          'Despiertas como $chosenName $surname con recuerdos confusos de otro mundo. Tus padres, $fatherName y $motherName, te acogen en una modesta cabaña.',
    );

    state = GameState(
      needsCharacterCreation: false,
      hero: hero,
      currency: const RpgCurrency(0),
      year: birthYear,
      month: 1,
      isPaused: startPaused,
      speedMultiplier: 1,
      monthsSinceLastEvent: 0,
      seenEventIds: const {},
      chronicles: [openingChronicle],
    );

    _syncTimer();
    unawaited(_saveState());
  }

  /// Pausa o reanuda el reloj de la simulación.
  void togglePause() {
    if (state.needsCharacterCreation ||
        state.isGameOver ||
        state.activeEvent != null) {
      return;
    }
    state = state.copyWith(isPaused: !state.isPaused);
    _syncTimer();
    unawaited(_saveState());
  }

  /// Alterna entre velocidad x1 (1.6s/mes) y x2 (0.8s/mes).
  void toggleSpeed() {
    final nextSpeed = state.speedMultiplier == 1 ? 2 : 1;
    state = state.copyWith(speedMultiplier: nextSpeed);
    _syncTimer();
    unawaited(_saveState());
  }

  /// Avanza un mes de simulación (edad anual, estipendio, mortalidad y 10% de evento).
  @visibleForTesting
  void advanceMonth() {
    _stepMonth(allowAutoEvent: true);
    _syncTimer();
    unawaited(_saveState());
  }

  /// Avanza mes a mes hasta el inicio del siguiente semestre, deteniéndose ante cualquier evento.
  void advanceToNextSemester() {
    if (state.needsCharacterCreation ||
        state.isGameOver ||
        state.activeEvent != null) {
      return;
    }

    final startSemesterKey = state.currentSemesterKey;
    for (var i = 0; i < 6; i++) {
      _stepMonth(allowAutoEvent: true);
      if (state.isGameOver ||
          state.activeEvent != null ||
          state.currentSemesterKey != startSemesterKey) {
        break;
      }
    }

    _syncTimer();
    unawaited(_saveState());
  }

  void _stepMonth({required bool allowAutoEvent}) {
    if (state.needsCharacterCreation ||
        state.isGameOver ||
        state.activeEvent != null) {
      return;
    }

    var nextMonth = state.month + 1;
    var nextYear = state.year;
    var didNewYear = false;

    if (nextMonth > 12) {
      nextMonth = 1;
      nextYear += 1;
      didNewYear = true;
    }

    var hero = state.hero;
    var nextCurrency = state.currency;
    final chronicles = List<ChronicleEntry>.from(state.chronicles);
    var isGameOver = state.isGameOver;
    String? causeOfDeath;

    // Estipendio mensual del Gremio de Aventureros (mitad en vejez como pensión).
    if (state.profession == ProfessionId.adventurer && hero.isAlive) {
      final rawStipend = state.adventurerRank.monthlyStipendCopper;
      final stipend = hero.age >= 60 ? (rawStipend ~/ 2) : rawStipend;
      nextCurrency = nextCurrency.addCopper(stipend);
    }

    if (didNewYear && hero.isAlive) {
      final prevStage = hero.lifeStage;
      final newAge = hero.age + 1;
      var updatedStats = hero.stats;

      // Desarrollo físico natural en crecimiento y desgaste gradual en vejez.
      if (newAge >= 4 && newAge <= 17) {
        updatedStats = updatedStats.applyDelta(
          const StatDelta(strength: 1, intellect: 1),
        );
      } else if (newAge >= 60) {
        final decay = 1 + _rng.nextInt(3);
        updatedStats = updatedStats.applyDelta(
          StatDelta(health: -decay, strength: -1),
        );
      }

      hero = hero.copyWith(age: newAge, stats: updatedStats);
      final newStage = hero.lifeStage;

      if (newStage != prevStage) {
        chronicles.insert(
          0,
          _makeChronicle(
            year: nextYear,
            month: nextMonth,
            age: newAge,
            stage: newStage,
            title: 'Nueva etapa: ${newStage.label}',
            description:
                'Cumples $newAge años y entras en la etapa de ${newStage.label} (${newStage.ageRangeLabel}).',
          ),
        );
      }

      // Comprobación de mortalidad por salud agotada o vejez avanzada.
      if (hero.stats.health <= 0) {
        isGameOver = true;
        causeOfDeath = 'Tu salud se debilitó por completo a los $newAge años.';
      } else if (newAge >= 60) {
        final moodFactor = hero.stats.mood >= 50 ? 0.9 : 1.15;
        final deathChance =
            ((newAge - 58) *
                    0.015 *
                    (1.35 - (hero.stats.health / 100.0) * 0.85) *
                    moodFactor)
                .clamp(0.01, 0.78);
        if (_rng.nextDouble() < deathChance) {
          isGameOver = true;
          causeOfDeath =
              'Partiste en paz en tu hogar de ${hero.villageName} a los $newAge años.';
        }
      }

      if (isGameOver) {
        hero = hero.copyWith(isAlive: false, deathYear: nextYear);
        chronicles.insert(
          0,
          _makeChronicle(
            year: nextYear,
            month: nextMonth,
            age: newAge,
            stage: hero.lifeStage,
            title: 'Fin del camino',
            description: causeOfDeath ?? 'Tu vida ha llegado a su fin.',
            wasSuccess: false,
          ),
        );
      }
    }

    final nextMonthsSinceEvent = state.monthsSinceLastEvent + 1;

    state = state.copyWith(
      hero: hero,
      currency: nextCurrency,
      year: nextYear,
      month: nextMonth,
      monthsSinceLastEvent: nextMonthsSinceEvent,
      chronicles: chronicles.take(120).toList(),
      isGameOver: isGameOver,
      causeOfDeath: causeOfDeath,
      isPaused: isGameOver ? true : state.isPaused,
    );

    // Probabilidad natural del 10% en cada mes que avanza (sin límites ni forzados).
    if (allowAutoEvent && !isGameOver && _rng.nextDouble() < 0.10) {
      _openStageEvent();
    }
  }

  /// Solo para pruebas unitarias: abre un evento de la etapa actual.
  @visibleForTesting
  bool debugTriggerStageEventForTest() {
    if (state.needsCharacterCreation ||
        state.isGameOver ||
        state.activeEvent != null) {
      return false;
    }
    return _openStageEvent();
  }

  /// Ejecuta el objetivo semestral elegido por el jugador (1 vez por semestre).
  bool performSemesterAction(SemesterAction action) {
    if (!state.hasSemesterActionAvailable || state.activeEvent != null) {
      return false;
    }
    if (!action.allowedStages.contains(state.hero.lifeStage)) {
      return false;
    }

    final nextStats = state.hero.stats.applyDelta(action.statDelta);
    final nextCurrency = state.currency.addCopper(action.copperDelta);
    var nextHero = state.hero.copyWith(stats: nextStats);

    final summaryParts = <String>[];
    final statSummary = action.statDelta.formatSummary();
    if (statSummary.isNotEmpty) summaryParts.add(statSummary);
    if (action.copperDelta != 0) {
      summaryParts.add(RpgCurrency.formatDelta(action.copperDelta));
    }
    final detail = summaryParts.isEmpty ? '' : ' (${summaryParts.join(' · ')})';

    final chronicles = List<ChronicleEntry>.from(state.chronicles)
      ..insert(
        0,
        _makeChronicle(
          year: state.year,
          month: state.month,
          age: nextHero.age,
          stage: nextHero.lifeStage,
          title: 'Objetivo del Semestre ${state.currentSemester}: ${action.title}',
          description: '${action.description}$detail',
          wasSuccess: true,
        ),
      );

    var isGameOver = state.isGameOver;
    String? causeOfDeath;
    if (nextStats.health <= 0 && nextHero.isAlive) {
      isGameOver = true;
      causeOfDeath =
          'El agotamiento superó tu salud a los ${nextHero.age} años.';
      nextHero = nextHero.copyWith(isAlive: false, deathYear: state.year);
      chronicles.insert(
        0,
        _makeChronicle(
          year: state.year,
          month: state.month,
          age: nextHero.age,
          stage: nextHero.lifeStage,
          title: 'Fin del camino',
          description: causeOfDeath,
          wasSuccess: false,
        ),
      );
    }

    state = state.copyWith(
      hero: nextHero,
      currency: nextCurrency,
      lastSemesterActionKey: state.currentSemesterKey,
      chronicles: chronicles.take(120).toList(),
      isGameOver: isGameOver,
      causeOfDeath: causeOfDeath,
      isPaused: isGameOver ? true : state.isPaused,
    );

    _syncTimer();
    unawaited(_saveState());
    return true;
  }

  /// Permite inscribirse como Aventurero al cumplir 15 años o más.
  bool applyForAdventurer() {
    if (!state.canApplyAsAdventurer || state.activeEvent != null) {
      return false;
    }

    final chronicles = List<ChronicleEntry>.from(state.chronicles)
      ..insert(
        0,
        _makeChronicle(
          year: state.year,
          month: state.month,
          age: state.hero.age,
          stage: state.hero.lifeStage,
          title: 'Ingreso al Gremio de Aventureros',
          description:
              'A los ${state.hero.age} años recibes tu placa de Bronce (Rango E) y comienzas oficialmente como Aventurero.',
          wasSuccess: true,
        ),
      );

    state = state.copyWith(
      profession: ProfessionId.adventurer,
      chronicles: chronicles.take(120).toList(),
    );
    unawaited(_saveState());
    return true;
  }

  /// Abandona la profesión actual.
  void retireFromProfession() {
    if (state.profession == ProfessionId.none || state.isGameOver) return;

    final chronicles = List<ChronicleEntry>.from(state.chronicles)
      ..insert(
        0,
        _makeChronicle(
          year: state.year,
          month: state.month,
          age: state.hero.age,
          stage: state.hero.lifeStage,
          title: 'Retiro del Gremio',
          description:
              'Entregas tu placa tras haber alcanzado ${state.adventurerRank.label}.',
        ),
      );

    state = state.copyWith(
      profession: ProfessionId.none,
      chronicles: chronicles.take(120).toList(),
    );
    unawaited(_saveState());
  }

  /// Realiza un encargo del Gremio de Aventureros (1 por semestre) con prueba 0..100%.
  EventResolutionResult? takeGuildQuest(GuildQuest quest) {
    if (!state.hasGuildQuestAvailable || state.activeEvent != null) {
      return null;
    }
    final currentRank = state.adventurerRank;
    if (AdventurerRank.values.indexOf(quest.minRank) >
        AdventurerRank.values.indexOf(currentRank)) {
      return null;
    }

    final chance = quest.statCheck.successChanceFor(state.hero.stats);
    final roll = 1 + _rng.nextInt(100);
    final succeeded = roll <= chance;

    final outcome = succeeded ? quest.successOutcome : quest.failureOutcome;
    final xpGain = succeeded ? quest.xpRewardSuccess : quest.xpRewardFailure;
    final nextXp = state.adventurerXp + xpGain;
    final nextRank = AdventurerRankX.fromXp(nextXp);

    final nextStats = state.hero.stats.applyDelta(outcome.statDelta);
    final nextCurrency = state.currency.addCopper(outcome.copperDelta);
    var nextHero = state.hero.copyWith(stats: nextStats);

    final chronicles = List<ChronicleEntry>.from(state.chronicles)
      ..insert(
        0,
        _makeChronicle(
          year: state.year,
          month: state.month,
          age: nextHero.age,
          stage: nextHero.lifeStage,
          title: 'Encargo del Gremio: ${quest.title}',
          description: '${outcome.description} (+$xpGain XP)',
          wasSuccess: succeeded,
          rollSummary:
              '${quest.statCheck.stat.shortLabel} ($chance% · dado $roll)',
        ),
      );

    if (nextRank != currentRank) {
      chronicles.insert(
        0,
        _makeChronicle(
          year: state.year,
          month: state.month,
          age: nextHero.age,
          stage: nextHero.lifeStage,
          title: '¡Ascenso en el Gremio!',
          description:
              'Tu trayectoria como aventurero te asciende a ${nextRank.label}.',
          wasSuccess: true,
        ),
      );
    }

    var isGameOver = state.isGameOver;
    String? causeOfDeath;
    if (nextStats.health <= 0 && nextHero.isAlive) {
      isGameOver = true;
      causeOfDeath =
          'Caíste en cumplimiento de un encargo del gremio a los ${nextHero.age} años.';
      nextHero = nextHero.copyWith(isAlive: false, deathYear: state.year);
      chronicles.insert(
        0,
        _makeChronicle(
          year: state.year,
          month: state.month,
          age: nextHero.age,
          stage: nextHero.lifeStage,
          title: 'Fin del camino',
          description: causeOfDeath,
          wasSuccess: false,
        ),
      );
    }

    state = state.copyWith(
      hero: nextHero,
      currency: nextCurrency,
      adventurerXp: nextXp,
      completedQuests:
          succeeded ? state.completedQuests + 1 : state.completedQuests,
      lastQuestSemesterKey: state.currentSemesterKey,
      chronicles: chronicles.take(120).toList(),
      isGameOver: isGameOver,
      causeOfDeath: causeOfDeath,
      isPaused: isGameOver ? true : state.isPaused,
    );

    _syncTimer();
    unawaited(_saveState());

    return EventResolutionResult(
      title: quest.title,
      wasCheck: true,
      succeeded: succeeded,
      roll: roll,
      chance: chance,
      statChecked: quest.statCheck.stat,
      description: '${outcome.description} (+$xpGain XP)',
      statDelta: outcome.statDelta,
      copperDelta: outcome.copperDelta,
    );
  }

  bool _openStageEvent() {
    final event = EventsCatalog.pickEventForStage(
      state.hero.lifeStage,
      state.hero,
      state.seenEventIds,
      _rng,
    );
    if (event == null) return false;

    state = state.copyWith(
      activeEvent: event,
      wasPausedBeforeEvent: state.isPaused,
      isPaused: true,
      monthsSinceLastEvent: 0,
    );
    return true;
  }

  /// Resuelve el evento activo evaluando la probabilidad de éxito (0..100%).
  EventResolutionResult resolveActiveEvent(EventChoice choice) {
    final active = state.activeEvent;
    if (active == null) {
      return const EventResolutionResult(
        title: '',
        wasCheck: false,
        succeeded: true,
        description: '',
        statDelta: StatDelta(),
        copperDelta: 0,
      );
    }

    final check = choice.statCheck;
    bool succeeded = true;
    int? roll;
    int? chance;

    if (check != null) {
      chance = check.successChanceFor(state.hero.stats);
      roll = 1 + _rng.nextInt(100);
      succeeded = roll <= chance;
    }

    final outcome = (succeeded || choice.failureOutcome == null)
        ? choice.successOutcome
        : choice.failureOutcome!;

    final nextStats = state.hero.stats.applyDelta(outcome.statDelta);
    final nextCurrency = state.currency.addCopper(outcome.copperDelta);
    var nextHero = state.hero.copyWith(stats: nextStats);

    final nextSeen = Set<String>.from(state.seenEventIds)..add(active.eventId);
    final chronicles = List<ChronicleEntry>.from(state.chronicles);

    final rollText = check != null
        ? '${check.stat.shortLabel} ($chance% · dado $roll)'
        : 'Decisión directa (100%)';

    chronicles.insert(
      0,
      _makeChronicle(
        year: state.year,
        month: state.month,
        age: nextHero.age,
        stage: active.stage,
        title: active.title,
        description: outcome.description,
        wasSuccess: succeeded,
        rollSummary: rollText,
      ),
    );

    var isGameOver = state.isGameOver;
    String? causeOfDeath;
    if (nextStats.health <= 0 && nextHero.isAlive) {
      isGameOver = true;
      causeOfDeath =
          'Tus heridas o enfermedad agotaron tu salud a los ${nextHero.age} años.';
      nextHero = nextHero.copyWith(isAlive: false, deathYear: state.year);
      chronicles.insert(
        0,
        _makeChronicle(
          year: state.year,
          month: state.month,
          age: nextHero.age,
          stage: nextHero.lifeStage,
          title: 'Fin del camino',
          description: causeOfDeath,
          wasSuccess: false,
        ),
      );
    }

    state = state.copyWith(
      hero: nextHero,
      currency: nextCurrency,
      seenEventIds: nextSeen,
      chronicles: chronicles.take(120).toList(),
      clearActiveEvent: true,
      isPaused: isGameOver ? true : state.wasPausedBeforeEvent,
      wasPausedBeforeEvent: false,
      isGameOver: isGameOver,
      causeOfDeath: causeOfDeath,
    );

    _syncTimer();
    unawaited(_saveState());

    return EventResolutionResult(
      title: active.title,
      wasCheck: check != null,
      succeeded: succeeded,
      roll: roll,
      chance: chance,
      statChecked: check?.stat,
      description: outcome.description,
      statDelta: outcome.statDelta,
      copperDelta: outcome.copperDelta,
    );
  }

  /// Borra la partida actual y vuelve a la pantalla de renacimiento.
  Future<void> requestNewLife() async {
    _timer?.cancel();
    _timer = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (_) {}

    state = GameState.initialCreation();
  }

  ChronicleEntry _makeChronicle({
    required int year,
    required int month,
    required int age,
    required LifeStage stage,
    required String title,
    required String description,
    bool? wasSuccess,
    String? rollSummary,
  }) {
    return ChronicleEntry(
      id: 'chr_${year}_${month}_${_rng.nextInt(999999)}',
      year: year,
      month: month,
      age: age,
      stage: stage,
      title: title,
      description: description,
      wasSuccess: wasSuccess,
      rollSummary: rollSummary,
    );
  }
}

