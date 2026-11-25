import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wuxia_dynasty/data/events_catalog.dart';
import 'package:wuxia_dynasty/main.dart';
import 'package:wuxia_dynasty/models/character.dart';
import 'package:wuxia_dynasty/models/currency.dart';
import 'package:wuxia_dynasty/models/game_event.dart';
import 'package:wuxia_dynasty/models/game_state.dart';
import 'package:wuxia_dynasty/models/life_stage.dart';
import 'package:wuxia_dynasty/models/profession.dart';
import 'package:wuxia_dynasty/models/semester_action.dart';
import 'package:wuxia_dynasty/models/stats.dart';
import 'package:wuxia_dynasty/providers/life_provider.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('RpgCurrency convierte correctamente cobre, plata y oro y no baja de 0',
      () {
    final c = RpgCurrency.fromCoins(gold: 1, silver: 23, copper: 45);
    expect(c.totalCopper, 12345);
    expect(c.gold, 1);
    expect(c.silver, 23);
    expect(c.copper, 45);
    expect(c.formatCompact(), '1O 23P 45C');

    final clamped = c.addCopper(-50000);
    expect(clamped.totalCopper, 0);
    expect(RpgCurrency.formatDelta(150), '+1P 50C');
    expect(RpgCurrency.formatDelta(-40), '-40C');
  });

  test('EventsCatalog tiene exactamente 10 eventos por etapa (60 en total)', () {
    expect(EventsCatalog.all.length, 60);
    for (final stage in LifeStage.values) {
      final stageEvents = EventsCatalog.eventsForStage(stage);
      expect(
        stageEvents.length,
        10,
        reason: 'La etapa ${stage.label} debe tener 10 eventos',
      );
      for (final ev in stageEvents) {
        expect(ev.title, isNotEmpty);
        expect(ev.choices.length, inInclusiveRange(2, 3));
      }
    }
  });

  test('StatCheck.successChanceFor devuelve 0..100 y crece con el atributo', () {
    const check = StatCheck(stat: StatType.intellect, requiredScore: 50);

    const low = CharacterStats(
      emotionalIntelligence: 10,
      intellect: 10,
      strength: 10,
      health: 70,
      combatSkill: 5,
      mood: 60,
    );
    const mid = CharacterStats(
      emotionalIntelligence: 10,
      intellect: 50,
      strength: 10,
      health: 70,
      combatSkill: 5,
      mood: 60,
    );
    const high = CharacterStats(
      emotionalIntelligence: 10,
      intellect: 90,
      strength: 10,
      health: 70,
      combatSkill: 5,
      mood: 60,
    );

    expect(check.successChanceFor(low), inInclusiveRange(0, 100));
    expect(check.successChanceFor(mid), inInclusiveRange(0, 100));
    expect(check.successChanceFor(high), inInclusiveRange(0, 100));
    expect(
      check.successChanceFor(low),
      lessThan(check.successChanceFor(mid)),
    );
    expect(
      check.successChanceFor(mid),
      lessThanOrEqualTo(check.successChanceFor(high)),
    );
  });

  test('Acciones semestrales permiten 1 objetivo por semestre y se renuevan',
      () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(lifeProvider.notifier);
    notifier.startNewLife(
      name: 'Lucas',
      gender: Gender.male,
      startPaused: true,
    );

    final start = container.read(lifeProvider);
    expect(start.currentSemester, 1);
    expect(start.hasSemesterActionAvailable, isTrue);

    final actions = SemesterActionsCatalog.forStage(start.hero.lifeStage);
    expect(actions, isNotEmpty);

    final firstOk = notifier.performSemesterAction(actions.first);
    expect(firstOk, isTrue);
    expect(container.read(lifeProvider).hasSemesterActionAvailable, isFalse);

    // No se puede repetir en el mismo semestre
    final secondBlocked = notifier.performSemesterAction(actions.last);
    expect(secondBlocked, isFalse);

    // Avanzamos hasta el semestre 2 (Mes 7), resolviendo cualquier evento natural (10%)
    while (container.read(lifeProvider).currentSemester == 1) {
      final ev = container.read(lifeProvider).activeEvent;
      if (ev != null) {
        notifier.resolveActiveEvent(ev.choices.first);
      }
      notifier.advanceToNextSemester();
    }
    final evAfter = container.read(lifeProvider).activeEvent;
    if (evAfter != null) {
      notifier.resolveActiveEvent(evAfter.choices.first);
    }

    expect(container.read(lifeProvider).currentSemester, 2);
    expect(container.read(lifeProvider).hasSemesterActionAvailable, isTrue);
  });

  test('Profesión Aventurero requiere 15 años, permite encargos y serializa',
      () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(lifeProvider.notifier);
    notifier.startNewLife(
      name: 'Aria',
      gender: Gender.female,
      startPaused: true,
    );

    // Con 0 años no se puede aplicar como Aventurero
    expect(container.read(lifeProvider).canApplyAsAdventurer, isFalse);
    expect(notifier.applyForAdventurer(), isFalse);

    // Avanzamos hasta cumplir 15 años resolviendo cualquier evento natural del 10%
    while (container.read(lifeProvider).hero.age < 15) {
      final ev = container.read(lifeProvider).activeEvent;
      if (ev != null) {
        notifier.resolveActiveEvent(ev.choices.first);
      }
      notifier.advanceToNextSemester();
    }
    final pending = container.read(lifeProvider).activeEvent;
    if (pending != null) {
      notifier.resolveActiveEvent(pending.choices.first);
    }

    expect(container.read(lifeProvider).hero.age, greaterThanOrEqualTo(15));
    expect(container.read(lifeProvider).canApplyAsAdventurer, isTrue);
    expect(notifier.applyForAdventurer(), isTrue);

    final afterJoin = container.read(lifeProvider);
    expect(afterJoin.profession, ProfessionId.adventurer);
    expect(afterJoin.adventurerRank, AdventurerRank.bronzeE);
    expect(afterJoin.hasGuildQuestAvailable, isTrue);

    final quests = GuildQuestCatalog.availableFor(afterJoin.adventurerRank);
    expect(quests, isNotEmpty);
    final res = notifier.takeGuildQuest(quests.first);
    expect(res, isNotNull);

    final afterQuest = container.read(lifeProvider);
    expect(afterQuest.adventurerXp, greaterThan(0));
    expect(afterQuest.hasGuildQuestAvailable, isFalse);

    // Serialización JSON preserva profesión y XP
    final restored = GameState.fromJson(afterQuest.toJson());
    expect(restored.profession, ProfessionId.adventurer);
    expect(restored.adventurerXp, afterQuest.adventurerXp);
    expect(restored.lastQuestSemesterKey, afterQuest.lastQuestSemesterKey);
  });

  testWidgets(
      'MedievalLifeApp muestra 4 pestañas sin botón para forzar eventos',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MedievalLifeApp()),
    );
    await tester.pump();

    await tester.enterText(
      find.byKey(const Key('hero_name_field')),
      'Valeria',
    );
    await tester.ensureVisible(find.byKey(const Key('start_life_button')));
    await tester.tap(find.byKey(const Key('start_life_button')));
    await tester.pump();

    expect(find.text('Mi Vida'), findsOneWidget);
    expect(find.text('Semestre'), findsOneWidget);
    expect(find.text('Oficios'), findsOneWidget);
    expect(find.text('Crónicas'), findsOneWidget);

    // No existe botón para forzar eventos
    expect(find.text('Evento'), findsNothing);
    expect(find.textContaining('Vivir Evento'), findsNothing);

    // Navegamos a Semestre y Oficios para comprobar renderizado sin overflows
    await tester.tap(find.text('Semestre'));
    await tester.pump();
    expect(find.textContaining('Semestre 1'), findsOneWidget);

    await tester.tap(find.text('Oficios'));
    await tester.pump();
    expect(find.text('Gremio de Aventureros'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
