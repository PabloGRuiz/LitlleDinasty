import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/events_catalog.dart';
import '../data/medieval_names.dart';
import '../data/npc_profiles.dart';
import '../data/story_events_catalog.dart';
import '../data/world_news_catalog.dart';
import '../models/character.dart';
import '../models/currency.dart';
import '../models/family_state.dart';
import '../models/game_event.dart';
import '../models/game_state.dart';
import '../models/life_stage.dart';
import '../models/profession.dart';
import '../models/semester_action.dart';
import '../models/social_relation.dart';
import '../models/stats.dart';
import '../models/world_state.dart';

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

    final initialNews = WorldNewsCatalog.pickNews(
      era: WorldEra.quietEra,
      year: birthYear,
      month: 1,
      rng: _rng,
    );

    final fatherProfile = NpcProfileGenerator.forFather(
      villageName: villageName,
      heroBirthAgeDiff: 24 + _rng.nextInt(10),
    );
    final motherProfile = NpcProfileGenerator.forMother(
      villageName: villageName,
      heroBirthAgeDiff: 22 + _rng.nextInt(9),
    );

    final initialContacts = [
      SocialContact(
        id: 'fam_father',
        name: fatherName,
        role: 'Padre',
        group: RelationshipGroup.family,
        affinity: 78,
        firstMetYear: birthYear,
        firstMetAge: 0,
        lastInteractionNote: 'Te recibió con calidez al nacer en $villageName.',
        age: fatherProfile.age,
        occupation: fatherProfile.occupation,
        bio: fatherProfile.bio,
        familyInfo: fatherProfile.familyInfo,
        temperament: fatherProfile.temperament,
        knowsAge: true,
        knowsOccupation: true,
        knowsBio: true,
        knowsFamily: true,
      ),
      SocialContact(
        id: 'fam_mother',
        name: motherName,
        role: 'Madre',
        group: RelationshipGroup.family,
        affinity: 82,
        firstMetYear: birthYear,
        firstMetAge: 0,
        lastInteractionNote: 'Cuidó de ti desde tu primer aliento.',
        age: motherProfile.age,
        occupation: motherProfile.occupation,
        bio: motherProfile.bio,
        familyInfo: motherProfile.familyInfo,
        temperament: motherProfile.temperament,
        knowsAge: true,
        knowsOccupation: true,
        knowsBio: true,
        knowsFamily: true,
      ),
    ];

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
      worldState: WorldState.initial().copyWith(worldNews: [initialNews]),
      familyState: FamilyState.initial(),
      contacts: initialContacts,
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
    var nextWorld = state.worldState;
    var nextFamily = state.familyState;
    var nextContacts = List<SocialContact>.from(state.contacts);
    final chronicles = List<ChronicleEntry>.from(state.chronicles);
    var isGameOver = state.isGameOver;
    String? causeOfDeath;

    // Estipendio mensual del Gremio de Aventureros (mitad en vejez como pensión).
    if (state.profession == ProfessionId.adventurer && hero.isAlive) {
      final rawStipend = state.adventurerRank.monthlyStipendCopper;
      final stipend = hero.age >= 60 ? (rawStipend ~/ 2) : rawStipend;
      nextCurrency = nextCurrency.addCopper(stipend);
    }

    // Economía familiar mensual y efectos diarios de escuela/trabajo infantil (< 15 años).
    if (!nextFamily.isFinanciallyIndependent && hero.isAlive) {
      final nextSavings =
          (nextFamily.familySavingsCopper + nextFamily.monthlyNetCopper)
              .clamp(0, 999999999);
      nextFamily = nextFamily.copyWith(familySavingsCopper: nextSavings);

      var updatedStats = hero.stats;
      if (nextFamily.isEnrolledInSchool && nextMonth.isEven) {
        updatedStats = updatedStats.applyDelta(
          StatDelta(
            intellect: 1,
            knowledge: hero.primaryDevelopmentCompleted ? 3 : 0,
          ),
          caps: hero.statCaps,
        );
      }
      if (nextFamily.isChildWorker && nextMonth % 3 == 0) {
        updatedStats = updatedStats.applyDelta(
          const StatDelta(strength: 1),
          caps: hero.statCaps,
        );
      }
      hero = hero.copyWith(stats: updatedStats);
    }

    if (didNewYear && hero.isAlive) {
      final prevStage = hero.lifeStage;
      final newAge = hero.age + 1;
      var updatedStats = hero.stats;

      // Desarrollo físico natural en crecimiento y desgaste gradual en vejez.
      if (newAge >= 4 && newAge <= 17) {
        updatedStats = updatedStats.applyDelta(
          const StatDelta(strength: 1, intellect: 1),
          caps: hero.statCaps,
        );
      } else if (newAge >= 60) {
        final decay = 1 + _rng.nextInt(3);
        updatedStats = updatedStats.applyDelta(
          StatDelta(health: -decay, strength: -1),
          caps: hero.statCaps,
        );
      }

      hero = hero.copyWith(age: newAge, stats: updatedStats);
      final newStage = hero.lifeStage;

      // Envejecer contactos sociales vivos y hermanos, y evaluar nacimiento de nuevo hermano.
      nextContacts = nextContacts
          .map((c) => c.isAlive ? c.copyWith(age: c.age + 1) : c)
          .toList();
      if (nextFamily.siblings.isNotEmpty) {
        nextFamily = nextFamily.copyWith(
          siblings: nextFamily.siblings
              .map((s) => s.isAlive ? s.copyWith(age: s.age + 1) : s)
              .toList(),
        );
      }
      if (!nextFamily.isFinanciallyIndependent &&
          newAge >= 1 &&
          newAge <= 12 &&
          nextFamily.siblings.length < 3 &&
          _rng.nextDouble() < 0.14) {
        final sibGender = _rng.nextBool() ? Gender.male : Gender.female;
        final sibName = sibGender == Gender.male
            ? pickRandomMaleName(_rng)
            : pickRandomFemaleName(_rng);
        final sibling = Sibling(
          id: 'sib_${nextYear}_${nextFamily.siblings.length + 1}',
          name: '$sibName ${hero.surname}',
          gender: sibGender,
          birthYear: nextYear,
          age: 0,
        );
        nextFamily = nextFamily.copyWith(
          siblings: [...nextFamily.siblings, sibling],
        );
        final sibProfile = NpcProfileGenerator.forSibling(
          isMale: sibGender == Gender.male,
          villageName: hero.villageName,
        );
        nextContacts.add(
          SocialContact(
            id: 'fam_${sibling.id}',
            name: sibling.name,
            role: sibGender == Gender.male ? 'Hermano menor' : 'Hermana menor',
            group: RelationshipGroup.family,
            affinity: 70,
            firstMetYear: nextYear,
            firstMetAge: newAge,
            lastInteractionNote: 'Nació en el seno de tu hogar.',
            age: sibProfile.age,
            occupation: sibProfile.occupation,
            bio: sibProfile.bio,
            familyInfo: sibProfile.familyInfo,
            temperament: sibProfile.temperament,
            knowsAge: true,
            knowsOccupation: true,
            knowsBio: true,
            knowsFamily: true,
          ),
        );
        chronicles.insert(
          0,
          _makeChronicle(
            year: nextYear,
            month: nextMonth,
            age: newAge,
            stage: newStage,
            title: sibGender == Gender.male
                ? 'Nacimiento de un hermano'
                : 'Nacimiento de una hermana',
            description:
                'Nace ${sibling.name}. Los gastos del hogar aumentan en 5 Plata/mes.',
          ),
        );
      }

      // Al cumplir 15 años: graduación escolar (si asistió) e independencia económica.
      if (newAge == 15 && !nextFamily.isFinanciallyIndependent) {
        if (nextFamily.isEnrolledInSchool) {
          hero = hero.copyWith(
            stats: hero.stats.applyDelta(
              const StatDelta(intellect: 5, knowledge: 20),
              caps: hero.statCaps,
            ),
          );
          chronicles.insert(
            0,
            _makeChronicle(
              year: nextYear,
              month: nextMonth,
              age: newAge,
              stage: newStage,
              title: 'Graduación de la escuela',
              description:
                  'Concluyes tus estudios escolares a los 15 años (+5 Intelecto, +20 Conocimientos).',
              wasSuccess: true,
            ),
          );
        }

        final startingGift =
            ((nextFamily.familySavingsCopper * 0.15).round()).clamp(0, 5000);
        if (startingGift > 0) {
          nextCurrency = nextCurrency.addCopper(startingGift);
        }
        nextFamily = nextFamily.copyWith(
          familySavingsCopper: nextFamily.familySavingsCopper - startingGift,
          isEnrolledInSchool: false,
          isChildWorker: false,
          isFinanciallyIndependent: true,
        );
        chronicles.insert(
          0,
          _makeChronicle(
            year: nextYear,
            month: nextMonth,
            age: newAge,
            stage: newStage,
            title: 'Independencia económica',
            description: startingGift > 0
                ? 'A los 15 años pasas a valerte por ti mismo. Tus padres te entregan ${RpgCurrency(startingGift).formatCompact()} de los ahorros del hogar.'
                : 'A los 15 años pasas a valerte por ti mismo y administrar tu propia bolsa.',
          ),
        );
      }

      // Evolución orgánica del mundo vivo (amenaza del Rey Demonio y noticias).
      final int threatDelta;
      if (nextWorld.storyFlags.contains('new_dawn_era') || newAge >= 55) {
        threatDelta = -6;
      } else if (newAge >= 35) {
        threatDelta = 4;
      } else if (newAge >= 22) {
        threatDelta = 3;
      } else {
        threatDelta = 2;
      }
      final updatedFlags = Set<String>.from(nextWorld.storyFlags);
      if (newAge >= 22) updatedFlags.add('heroes_summons_active');
      if (newAge >= 35) updatedFlags.add('demon_king_awakened');
      if (newAge >= 55) updatedFlags.add('new_dawn_era');

      nextWorld = nextWorld.copyWith(
        demonKingThreat: nextWorld.demonKingThreat + threatDelta,
        storyFlags: updatedFlags,
      );

      if (newAge % 3 == 0 || _rng.nextDouble() < 0.35) {
        final newsItem = WorldNewsCatalog.pickNews(
          era: nextWorld.era,
          year: nextYear,
          month: nextMonth,
          rng: _rng,
        );
        nextWorld = nextWorld.copyWith(
          worldNews: [newsItem, ...nextWorld.worldNews].take(30).toList(),
        );
      }

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
              'Partiste en paz en ${nextWorld.currentLocation.labelFor(hero.villageName)} a los $newAge años.';
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
      worldState: nextWorld,
      familyState: nextFamily,
      contacts: nextContacts,
      isGameOver: isGameOver,
      causeOfDeath: causeOfDeath,
      isPaused: isGameOver ? true : state.isPaused,
    );

    if (isGameOver) return;

    // Prioridad 1: Eventos canónicos obligatorios (siempre ocurren en su edad hito).
    final storyEvent = StoryEventsCatalog.nextPendingEvent(state, _rng);
    if (storyEvent != null) {
      state = state.copyWith(
        activeEvent: storyEvent,
        wasPausedBeforeEvent: state.isPaused,
        isPaused: true,
        monthsSinceLastEvent: 0,
      );
      return;
    }

    // Prioridad 2: Presión económica familiar por déficit -> posible trabajo infantil.
    if (allowAutoEvent &&
        !nextFamily.isFinanciallyIndependent &&
        nextFamily.monthlyNetCopper < 0 &&
        hero.age >= 8 &&
        hero.age < 15 &&
        !nextFamily.isChildWorker) {
      final pressureChance = nextFamily.familySavingsCopper == 0
          ? 0.35
          : (nextFamily.familySavingsCopper < 15000 ? 0.14 : 0.06);
      if (_rng.nextDouble() < pressureChance) {
        state = state.copyWith(
          activeEvent: StoryEventsCatalog.buildChildLaborPressureEvent(state),
          wasPausedBeforeEvent: state.isPaused,
          isPaused: true,
          monthsSinceLastEvent: 0,
        );
        return;
      }
    }

    // Prioridad 3: Probabilidad natural del 10% en cada mes que avanza.
    if (allowAutoEvent && _rng.nextDouble() < 0.10) {
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
    if (action.requiresManaAwakened && !state.hero.manaAwakened) {
      return false;
    }
    if (action.requiresEnrolledInSchool &&
        !state.familyState.isEnrolledInSchool) {
      return false;
    }

    final effectiveDelta = state.hero.primaryDevelopmentCompleted
        ? _scaleExponentialDelta(action.statDelta, state.hero.statCaps)
        : action.statDelta;

    final nextStats = state.hero.stats.applyDelta(
      effectiveDelta,
      caps: state.hero.statCaps,
    );
    final nextCurrency = state.currency.addCopper(action.copperDelta);
    var nextHero = state.hero.copyWith(stats: nextStats);

    final summaryParts = <String>[];
    final statSummary = effectiveDelta.formatSummary();
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

    var nextContacts = List<SocialContact>.from(state.contacts);
    if (action.id == 'sem_early_bond') {
      nextContacts = nextContacts
          .map(
            (c) => c.group == RelationshipGroup.family
                ? c.copyWith(
                    affinity: c.affinity + 5,
                    lastInteractionNote: 'Compartieron juegos y afecto.',
                  )
                : c,
          )
          .toList();
    } else if (action.id == 'sem_child_socialize' ||
        action.id == 'sem_adult_diplomacy' ||
        action.id == 'sem_old_mentor') {
      var boosted = 0;
      nextContacts = nextContacts.map((c) {
        if (boosted < 2 && c.group != RelationshipGroup.family) {
          boosted++;
          return c.copyWith(
            affinity: c.affinity + 4,
            lastInteractionNote: 'Conversaron durante el semestre.',
          );
        }
        return c;
      }).toList();
    }

    state = state.copyWith(
      hero: nextHero,
      currency: nextCurrency,
      lastSemesterActionKey: state.currentSemesterKey,
      chronicles: chronicles.take(120).toList(),
      contacts: nextContacts,
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

    final instructorName =
        '${pickRandomMaleName(_rng)} ${pickRandomSurname(_rng)}';
    final instructorProfile = NpcProfileGenerator.generateProfile(
      rng: _rng,
      name: instructorName,
      role: 'Instructor del Gremio',
      group: RelationshipGroup.guild,
      heroAge: state.hero.age,
      villageName: state.hero.villageName,
    );
    final nextContacts = List<SocialContact>.from(state.contacts)
      ..add(
        SocialContact(
          id: 'guild_inst_${state.year}_${_rng.nextInt(999)}',
          name: instructorName,
          role: 'Instructor del Gremio',
          group: RelationshipGroup.guild,
          affinity: 55,
          firstMetYear: state.year,
          firstMetAge: state.hero.age,
          lastInteractionNote:
              'Te entregó tu placa de Bronce (Rango E) en el gremio.',
          age: instructorProfile.age,
          occupation: instructorProfile.occupation,
          bio: instructorProfile.bio,
          familyInfo: instructorProfile.familyInfo,
          temperament: instructorProfile.temperament,
        ),
      );

    state = state.copyWith(
      profession: ProfessionId.adventurer,
      contacts: nextContacts,
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

    final nextStats = state.hero.stats.applyDelta(
      outcome.statDelta,
      caps: state.hero.statCaps,
    );
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
      isEnrolledInSchool: state.familyState.isEnrolledInSchool,
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

  /// Inscribe o retira manualmente al niño/adolescente de la escuela (7–14 años).
  bool toggleSchoolEnrollment() {
    final fam = state.familyState;
    if (state.isGameOver ||
        state.activeEvent != null ||
        fam.isFinanciallyIndependent ||
        state.hero.age < 7) {
      return false;
    }
    final enrolling = !fam.isEnrolledInSchool;
    final chronicles = List<ChronicleEntry>.from(state.chronicles)
      ..insert(
        0,
        _makeChronicle(
          year: state.year,
          month: state.month,
          age: state.hero.age,
          stage: state.hero.lifeStage,
          title: enrolling ? 'Matrícula en la escuela' : 'Salida de la escuela',
          description: enrolling
              ? 'Comienzas a asistir a la escuela formal (15 Plata/mes).'
              : 'Dejas la escuela para aliviar los gastos familiares.',
        ),
      );
    state = state.copyWith(
      familyState: fam.copyWith(isEnrolledInSchool: enrolling),
      chronicles: chronicles.take(120).toList(),
    );
    unawaited(_saveState());
    return true;
  }

  /// Activa o desactiva trabajo infantil para ayudar a la economía del hogar (8–14 años).
  bool toggleChildWork() {
    final fam = state.familyState;
    if (state.isGameOver ||
        state.activeEvent != null ||
        fam.isFinanciallyIndependent ||
        state.hero.age < 8) {
      return false;
    }
    final working = !fam.isChildWorker;
    final chronicles = List<ChronicleEntry>.from(state.chronicles)
      ..insert(
        0,
        _makeChronicle(
          year: state.year,
          month: state.month,
          age: state.hero.age,
          stage: state.hero.lifeStage,
          title: working ? 'Trabajo infantil en la aldea' : 'Fin del jornal infantil',
          description: working
              ? 'Empiezas a trabajar en faenas locales aportando +8 Plata/mes al hogar.'
              : 'Dejas el jornal infantil al estabilizarse la economía familiar.',
        ),
      );
    state = state.copyWith(
      familyState: fam.copyWith(isChildWorker: working),
      chronicles: chronicles.take(120).toList(),
    );
    unawaited(_saveState());
    return true;
  }

  /// Permite aportar monedas personales del niño a los ahorros familiares.
  bool donateToFamily(int copperAmount) {
    final fam = state.familyState;
    if (state.isGameOver ||
        fam.isFinanciallyIndependent ||
        copperAmount <= 0 ||
        state.currency.totalCopper < copperAmount) {
      return false;
    }
    state = state.copyWith(
      currency: state.currency.addCopper(-copperAmount),
      familyState: fam.copyWith(
        familySavingsCopper: fam.familySavingsCopper + copperAmount,
      ),
    );
    unawaited(_saveState());
    return true;
  }

  /// Permite viajar entre ubicaciones del mundo a partir de los 15 años.
  bool travelTo(WorldLocation destination) {
    if (state.needsCharacterCreation ||
        state.isGameOver ||
        state.activeEvent != null) {
      return false;
    }
    if (state.hero.age < destination.minAgeToTravel) return false;
    if (state.worldState.currentLocation == destination) return false;

    final nextFlags = Set<String>.from(state.worldState.storyFlags);
    if (destination != WorldLocation.homeVillage) {
      nextFlags.add('left_village');
    }

    final nextRoute = state.worldState.route == StoryRoute.unwritten &&
            destination != WorldLocation.homeVillage
        ? StoryRoute.freeWanderer
        : state.worldState.route;

    final destLabel = destination.labelFor(state.hero.villageName);
    final chronicles = List<ChronicleEntry>.from(state.chronicles)
      ..insert(
        0,
        _makeChronicle(
          year: state.year,
          month: state.month,
          age: state.hero.age,
          stage: state.hero.lifeStage,
          title: 'Viaje a $destLabel',
          description:
              'Empacas tus pertenencias y emprendes camino hacia $destLabel.',
        ),
      );

    state = state.copyWith(
      worldState: state.worldState.copyWith(
        currentLocation: destination,
        route: nextRoute,
        storyFlags: nextFlags,
      ),
      chronicles: chronicles.take(120).toList(),
    );
    unawaited(_saveState());
    return true;
  }

  /// Resuelve el evento activo (aleatorio o hito obligatorio de destino).
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

    var baseStats = state.hero.stats;
    var manaAwakened = state.hero.manaAwakened;
    var primaryCompleted = state.hero.primaryDevelopmentCompleted;
    var nextCaps = state.hero.statCaps;

    if (active.awakenedManaValue != null) {
      manaAwakened = true;
      baseStats = baseStats.copyWith(
        mana: active.awakenedManaValue,
        caps: nextCaps,
      );
    }

    if (active.triggersPrimaryDevelopment && !primaryCompleted) {
      primaryCompleted = true;
      nextCaps = StatCaps.fromPrimaryDevelopment(baseStats);
      baseStats = baseStats.copyWith(
        fortitude: baseStats.strength + (baseStats.health ~/ 2),
        knowledge: baseStats.intellect,
        magicPower: baseStats.mana,
        caps: nextCaps,
      );
    }

    final nextStats = baseStats.applyDelta(outcome.statDelta, caps: nextCaps);
    final nextCurrency = state.currency.addCopper(outcome.copperDelta);
    var nextHero = state.hero.copyWith(
      stats: nextStats,
      manaAwakened: manaAwakened,
      primaryDevelopmentCompleted: primaryCompleted,
      statCaps: nextCaps,
    );

    var nextFamily = state.familyState;
    if (choice.setsEnrolledInSchool != null) {
      nextFamily = nextFamily.copyWith(
        isEnrolledInSchool: choice.setsEnrolledInSchool,
      );
    }
    if (choice.setsChildWorker != null) {
      nextFamily = nextFamily.copyWith(
        isChildWorker: choice.setsChildWorker,
      );
    }

    final nextSeen = active.isStoryEvent
        ? state.seenEventIds
        : (Set<String>.from(state.seenEventIds)..add(active.eventId));

    var nextWorld = state.worldState;
    if (active.isStoryEvent) {
      nextWorld = nextWorld.copyWith(
        completedStoryEventIds: {
          ...nextWorld.completedStoryEventIds,
          active.eventId,
        },
      );
    }
    if (choice.setsRoute != null) {
      nextWorld = nextWorld.copyWith(route: choice.setsRoute);
    }
    if (choice.setsLocation != null) {
      final locFlags = Set<String>.from(nextWorld.storyFlags);
      if (choice.setsLocation != WorldLocation.homeVillage) {
        locFlags.add('left_village');
      }
      nextWorld = nextWorld.copyWith(
        currentLocation: choice.setsLocation,
        storyFlags: locFlags,
      );
    }
    if (choice.addsFlag != null) {
      nextWorld = nextWorld.copyWith(
        storyFlags: {...nextWorld.storyFlags, choice.addsFlag!},
      );
    }

    final chronicles = List<ChronicleEntry>.from(state.chronicles);

    final String? rollText;
    if (check != null) {
      rollText = '${check.stat.shortLabel} ($chance% · dado $roll)';
    } else if (choice.isDestinyChoice) {
      rollText = choice.destinyPreview ?? 'Decisión de destino';
    } else {
      rollText = null;
    }

    chronicles.insert(
      0,
      _makeChronicle(
        year: state.year,
        month: state.month,
        age: nextHero.age,
        stage: active.stage,
        title: active.isStoryEvent ? '★ ${active.title}' : active.title,
        description: outcome.description,
        wasSuccess: check != null ? succeeded : null,
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

    var nextContacts = List<SocialContact>.from(state.contacts);
    final npcName = active.npcName.trim();
    if (npcName.isNotEmpty && npcName != 'Voz Interior') {
      final info = _inferRoleAndGroup(active, state.worldState.currentLocation);
      final delta = (check != null && !succeeded) ? -6 : 6;
      final existingIdx = nextContacts.indexWhere(
        (c) => c.name.toLowerCase() == npcName.toLowerCase(),
      );
      if (existingIdx >= 0) {
        final existing = nextContacts[existingIdx];
        final newAffinity = (existing.affinity + delta).clamp(0, 100);
        final fullTrust = newAffinity >= 80;
        nextContacts[existingIdx] = existing.copyWith(
          affinity: newAffinity,
          lastInteractionNote: '${active.title}: ${outcome.description}',
          knowsAge: existing.knowsAge || fullTrust,
          knowsOccupation: existing.knowsOccupation || fullTrust,
          knowsBio: existing.knowsBio || fullTrust,
          knowsFamily: existing.knowsFamily || fullTrust,
        );
      } else {
        final initialAffinity = (check != null && !succeeded) ? 36 : 54;
        final npcProfile = NpcProfileGenerator.generateProfile(
          rng: _rng,
          name: npcName,
          role: info.role,
          group: info.group,
          heroAge: nextHero.age,
          villageName: nextHero.villageName,
        );
        final isFamily = info.group == RelationshipGroup.family;
        nextContacts.add(
          SocialContact(
            id: 'npc_${state.year}_${nextContacts.length}_${_rng.nextInt(999)}',
            name: npcName,
            role: info.role,
            group: info.group,
            affinity: initialAffinity,
            firstMetYear: state.year,
            firstMetAge: nextHero.age,
            lastInteractionNote: '${active.title}: ${outcome.description}',
            age: npcProfile.age,
            occupation: npcProfile.occupation,
            bio: npcProfile.bio,
            familyInfo: npcProfile.familyInfo,
            temperament: npcProfile.temperament,
            knowsAge: isFamily,
            knowsOccupation: isFamily,
            knowsBio: isFamily,
            knowsFamily: isFamily,
          ),
        );
      }
    }

    state = state.copyWith(
      hero: nextHero,
      currency: nextCurrency,
      seenEventIds: nextSeen,
      chronicles: chronicles.take(120).toList(),
      worldState: nextWorld,
      familyState: nextFamily,
      contacts: nextContacts,
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

  /// Permite interactuar con un contacto social (1 vez por semestre por persona).
  bool interactWithContact(String contactId, {bool giveGift = false}) {
    if (state.needsCharacterCreation ||
        state.isGameOver ||
        state.activeEvent != null) {
      return false;
    }
    final idx = state.contacts.indexWhere((c) => c.id == contactId);
    if (idx < 0) return false;

    final target = state.contacts[idx];
    if (!target.canInteractIn(state.currentSemesterKey)) return false;

    const giftCost = 20;
    if (giveGift && state.currency.totalCopper < giftCost) return false;

    final eqBonus = state.hero.stats.emotionalIntelligence ~/ 25;
    final affinityGain = giveGift ? (10 + eqBonus) : (4 + eqBonus);
    final moodGain = giveGift ? 2 : 1;

    final note = giveGift
        ? 'Le obsequiaste un detalle (20C, +$affinityGain afinidad).'
        : 'Compartieron una amena charla (+$affinityGain afinidad).';

    final updatedContacts = List<SocialContact>.from(state.contacts);
    final newAffinity = (target.affinity + affinityGain).clamp(0, 100);
    final fullTrust = newAffinity >= 80;
    updatedContacts[idx] = target.copyWith(
      affinity: newAffinity,
      lastInteractionNote: note,
      lastInteractionSemesterKey: state.currentSemesterKey,
      knowsAge: target.knowsAge || fullTrust,
      knowsOccupation: target.knowsOccupation || fullTrust,
      knowsBio: target.knowsBio || fullTrust,
      knowsFamily: target.knowsFamily || fullTrust,
    );

    final nextHero = state.hero.copyWith(
      stats: state.hero.stats.applyDelta(
        StatDelta(mood: moodGain),
        caps: state.hero.statCaps,
      ),
    );
    final nextCurrency =
        giveGift ? state.currency.addCopper(-giftCost) : state.currency;

    final chronicles = List<ChronicleEntry>.from(state.chronicles)
      ..insert(
        0,
        _makeChronicle(
          year: state.year,
          month: state.month,
          age: state.hero.age,
          stage: state.hero.lifeStage,
          title: giveGift
              ? 'Obsequio para ${target.name}'
              : 'Encuentro con ${target.name}',
          description: note,
          wasSuccess: true,
        ),
      );

    state = state.copyWith(
      hero: nextHero,
      currency: nextCurrency,
      contacts: updatedContacts,
      chronicles: chronicles.take(120).toList(),
    );
    unawaited(_saveState());
    return true;
  }

  /// Charla eligiendo un tema concreto sin resultados garantizados ni vista previa.
  /// Puede agradar al PNJ (revela datos y sube afinidad) o incomodarle (baja afinidad).
  ChatOutcomeResult? chatWithContact(String contactId, ChatTopic topic) {
    if (state.needsCharacterCreation ||
        state.isGameOver ||
        state.activeEvent != null) {
      return null;
    }
    final idx = state.contacts.indexWhere((c) => c.id == contactId);
    if (idx < 0) return null;

    final target = state.contacts[idx];
    if (!target.canInteractIn(state.currentSemesterKey)) return null;

    var chance = 0.58 +
        (state.hero.stats.emotionalIntelligence - 40) * 0.003 +
        (target.affinity - 50) * 0.0025;

    switch (target.temperament) {
      case NpcTemperament.warm:
        chance += (topic == ChatTopic.askFamily || topic == ChatTopic.casualTalk)
            ? 0.18
            : 0.12;
        break;
      case NpcTemperament.reserved:
        switch (topic) {
          case ChatTopic.askFamily:
            chance -= 0.22;
            break;
          case ChatTopic.askIdentityAndAge:
            chance -= 0.14;
            break;
          case ChatTopic.askOccupation:
            chance += 0.02;
            break;
          case ChatTopic.casualTalk:
            chance += 0.08;
            break;
        }
        break;
      case NpcTemperament.ambitious:
        switch (topic) {
          case ChatTopic.askOccupation:
            chance += 0.14;
            break;
          case ChatTopic.casualTalk:
            chance += 0.06;
            break;
          case ChatTopic.askFamily:
            chance -= 0.08;
            break;
          case ChatTopic.askIdentityAndAge:
            chance += 0.02;
            break;
        }
        break;
      case NpcTemperament.scholarly:
        switch (topic) {
          case ChatTopic.askOccupation:
            chance += 0.15;
            break;
          case ChatTopic.askIdentityAndAge:
            chance += 0.08;
            break;
          case ChatTopic.casualTalk:
            chance -= 0.04;
            break;
          case ChatTopic.askFamily:
            chance += 0.0;
            break;
        }
        break;
      case NpcTemperament.practical:
        switch (topic) {
          case ChatTopic.askOccupation:
            chance += 0.14;
            break;
          case ChatTopic.casualTalk:
            chance += 0.10;
            break;
          case ChatTopic.askFamily:
            chance -= 0.06;
            break;
          case ChatTopic.askIdentityAndAge:
            chance += 0.03;
            break;
        }
        break;
    }

    final liked = _rng.nextDouble() < chance.clamp(0.20, 0.90);
    final eqBonus = state.hero.stats.emotionalIntelligence ~/ 25;
    final affinityDelta =
        liked ? (4 + eqBonus + _rng.nextInt(4)) : -(3 + _rng.nextInt(5));
    final newAffinity = (target.affinity + affinityDelta).clamp(0, 100);

    var knowsAge = target.knowsAge;
    var knowsOccupation = target.knowsOccupation;
    var knowsBio = target.knowsBio;
    var knowsFamily = target.knowsFamily;
    final discovered = <String>[];

    String npcReply;
    if (liked) {
      switch (topic) {
        case ChatTopic.askOccupation:
          if (!knowsOccupation) {
            knowsOccupation = true;
            discovered.add('Oficio: ${target.occupation}');
          } else if (!knowsBio) {
            knowsBio = true;
            discovered.add('Sobre su persona: ${target.bio}');
          }
          npcReply =
              '«Me dedico a esto con orgullo: ${target.occupation.toLowerCase()}.»';
          break;
        case ChatTopic.askIdentityAndAge:
          if (!knowsAge) {
            knowsAge = true;
            discovered.add('Edad: ${target.age} años');
          }
          if (!knowsBio) {
            knowsBio = true;
            discovered.add('Sobre su persona: ${target.bio}');
          } else if (!knowsOccupation) {
            knowsOccupation = true;
            discovered.add('Oficio: ${target.occupation}');
          }
          npcReply =
              '«Tengo ${target.age} años. ${target.bio}»';
          break;
        case ChatTopic.askFamily:
          if (!knowsFamily) {
            knowsFamily = true;
            discovered.add('Familia: ${target.familyInfo}');
          } else if (!knowsBio) {
            knowsBio = true;
            discovered.add('Sobre su persona: ${target.bio}');
          }
          npcReply = '«Te lo confiaré: ${target.familyInfo}»';
          break;
        case ChatTopic.casualTalk:
          final hidden = <int>[
            if (!knowsOccupation) 0,
            if (!knowsAge) 1,
            if (!knowsBio) 2,
            if (!knowsFamily) 3,
          ];
          if (hidden.isNotEmpty) {
            final pick = hidden[_rng.nextInt(hidden.length)];
            if (pick == 0) {
              knowsOccupation = true;
              discovered.add('Oficio: ${target.occupation}');
            } else if (pick == 1) {
              knowsAge = true;
              discovered.add('Edad: ${target.age} años');
            } else if (pick == 2) {
              knowsBio = true;
              discovered.add('Sobre su persona: ${target.bio}');
            } else {
              knowsFamily = true;
              discovered.add('Familia: ${target.familyInfo}');
            }
            npcReply =
                'Entre risas y rumores de la comarca, dejó escapar un detalle personal.';
          } else {
            npcReply =
                'Compartieron noticias recientes con mucha sintonía y confianza.';
          }
          break;
      }

      if (newAffinity >= 80 &&
          (!knowsAge || !knowsOccupation || !knowsBio || !knowsFamily)) {
        if (!knowsAge) {
          knowsAge = true;
          discovered.add('Edad: ${target.age} años');
        }
        if (!knowsOccupation) {
          knowsOccupation = true;
          discovered.add('Oficio: ${target.occupation}');
        }
        if (!knowsBio) {
          knowsBio = true;
          discovered.add('Sobre su persona: ${target.bio}');
        }
        if (!knowsFamily) {
          knowsFamily = true;
          discovered.add('Familia: ${target.familyInfo}');
        }
      }
    } else {
      switch (topic) {
        case ChatTopic.askFamily:
          npcReply =
              '«Mis asuntos familiares no son tema para cualquiera.» Se aparta con frialdad.';
          break;
        case ChatTopic.askIdentityAndAge:
          npcReply =
              '«¿Por qué tanta curiosidad indiscreta sobre mí?» La charla se vuelve tensa.';
          break;
        case ChatTopic.askOccupation:
          npcReply =
              '«No tengo humor para interrogatorios sobre mi trabajo.» Corta la conversación.';
          break;
        case ChatTopic.casualTalk:
          npcReply =
              'Tus comentarios no le hicieron gracia y prefirió seguir su camino.';
          break;
      }
    }

    final sign = affinityDelta >= 0 ? '+$affinityDelta' : '$affinityDelta';
    final note = liked
        ? 'Charlar (${topic.label.toLowerCase()}) le agradó ($sign afinidad).'
        : 'Tu pregunta sobre "${topic.label.toLowerCase()}" le incomodó ($sign afinidad).';

    final updatedContacts = List<SocialContact>.from(state.contacts);
    updatedContacts[idx] = target.copyWith(
      affinity: newAffinity,
      lastInteractionNote: note,
      lastInteractionSemesterKey: state.currentSemesterKey,
      knowsAge: knowsAge,
      knowsOccupation: knowsOccupation,
      knowsBio: knowsBio,
      knowsFamily: knowsFamily,
    );

    final nextHero = state.hero.copyWith(
      stats: state.hero.stats.applyDelta(
        StatDelta(mood: liked ? 1 : -1),
        caps: state.hero.statCaps,
      ),
    );

    final chronicles = List<ChronicleEntry>.from(state.chronicles)
      ..insert(
        0,
        _makeChronicle(
          year: state.year,
          month: state.month,
          age: state.hero.age,
          stage: state.hero.lifeStage,
          title: 'Charla con ${target.name}',
          description: note,
          wasSuccess: liked,
        ),
      );

    state = state.copyWith(
      hero: nextHero,
      contacts: updatedContacts,
      chronicles: chronicles.take(120).toList(),
    );
    unawaited(_saveState());

    return ChatOutcomeResult(
      contactId: target.id,
      contactName: target.name,
      topic: topic,
      liked: liked,
      affinityDelta: affinityDelta,
      newAffinity: newAffinity,
      npcReply: npcReply,
      discoveredFacts: discovered,
    );
  }

  ({String role, RelationshipGroup group}) _inferRoleAndGroup(
    ActiveGameEvent active,
    WorldLocation location,
  ) {
    if (active.eventId == StoryEventsCatalog.priestVisitId) {
      return (role: 'Sacerdote del Templo', group: RelationshipGroup.world);
    }
    if (active.eventId == StoryEventsCatalog.schoolEnrollmentId ||
        active.eventId.startsWith('school_')) {
      return (role: 'Ámbito escolar', group: RelationshipGroup.school);
    }
    if (active.eventId.startsWith('family_')) {
      return (role: 'Padre', group: RelationshipGroup.family);
    }
    if (active.isStoryEvent) {
      return (role: 'Figura del destino', group: RelationshipGroup.world);
    }
    if (location == WorldLocation.homeVillage &&
        (active.stage == LifeStage.earlyChildhood ||
            active.stage == LifeStage.childhood)) {
      return (role: 'Vecino de la aldea', group: RelationshipGroup.village);
    }
    if (location == WorldLocation.homeVillage) {
      return (role: 'Conocido comarcal', group: RelationshipGroup.village);
    }
    return (role: 'Conocido de viaje', group: RelationshipGroup.world);
  }

  StatDelta _scaleExponentialDelta(StatDelta base, StatCaps caps) {
    int scale(int val, int cap) {
      if (val <= 0 || cap <= 100) return val;
      return max(val, (cap * 0.015).round());
    }

    return StatDelta(
      emotionalIntelligence: base.emotionalIntelligence,
      intellect: base.intellect,
      strength: scale(base.strength, caps.strength),
      health: base.health,
      combatSkill: scale(base.combatSkill, caps.combatSkill),
      mood: base.mood,
      mana: scale(base.mana, caps.mana),
      fortitude: scale(base.fortitude, caps.fortitude),
      magicPower: scale(base.magicPower, caps.magicPower),
      knowledge: scale(base.knowledge, caps.knowledge),
    );
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

