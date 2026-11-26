import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wuxia_dynasty/data/events_catalog.dart';
import 'package:wuxia_dynasty/data/story_events_catalog.dart';
import 'package:wuxia_dynasty/main.dart';
import 'package:wuxia_dynasty/models/character.dart';
import 'package:wuxia_dynasty/models/currency.dart';
import 'package:wuxia_dynasty/models/family_state.dart';
import 'package:wuxia_dynasty/models/game_state.dart';
import 'package:wuxia_dynasty/models/life_stage.dart';
import 'package:wuxia_dynasty/models/profession.dart';
import 'package:wuxia_dynasty/models/social_relation.dart';
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

  test('EventsCatalog tiene 84 eventos y StoryEventsCatalog tiene 8', () {
    expect(EventsCatalog.all.length, 84);
    expect(StoryEventsCatalog.all.length, 8);
    expect(EventsCatalog.eventsForStage(LifeStage.childhood).length, 16);
    expect(EventsCatalog.eventsForStage(LifeStage.adolescence).length, 16);
  });

  test('FamilyState calcula ingresos, escuela, hermanos y déficit', () {
    final initial = FamilyState.initial();
    expect(initial.familySavingsCopper, 30000); // 3 Oro
    expect(initial.parentsMonthlyIncomeCopper, 2000); // 20 Plata
    expect(initial.heroUpkeepCopper, 500); // 5 Plata
    expect(initial.monthlyNetCopper, 1500); // +15P/mes

    final withSchool = initial.copyWith(isEnrolledInSchool: true);
    expect(withSchool.monthlyNetCopper, 0); // 20P - (5P + 15P) = 0

    final withSiblingAndSchool = withSchool.copyWith(
      siblings: const [
        Sibling(
          id: 's1',
          name: 'Lia del Valle',
          gender: Gender.female,
          birthYear: 1143,
          age: 2,
        ),
      ],
    );
    // 20P - (5P + 15P + 5P) = -5P/mes
    expect(withSiblingAndSchool.monthlyNetCopper, -500);
  });

  test(
      'StatCaps.fromPrimaryDevelopment aplica fórmulas exponenciales y respeta topes 100',
      () {
    const stats = CharacterStats(
      emotionalIntelligence: 40,
      intellect: 30,
      strength: 15,
      health: 80,
      combatSkill: 10,
      mood: 70,
      mana: 50,
    );

    final caps = StatCaps.fromPrimaryDevelopment(stats);
    expect(caps.emotionalIntelligence, 100);
    expect(caps.health, 100);
    expect(caps.mood, 100);
    expect(caps.intellect, 100);

    // Combate y Fortaleza: Fuerza * Salud * Combate = 15 * 80 * 10 = 12.000
    expect(caps.combatSkill, 15 * 80 * 10);
    expect(caps.fortitude, 15 * 80 * 10);
    // Conocimientos: Intelecto * 10 = 300
    expect(caps.knowledge, 30 * 10);
    // Poder Mágico: Combate * Maná * Intelecto = 10 * 50 * 30 = 15.000
    expect(caps.magicPower, 10 * 50 * 30);

    expect(formatStatNumber(12000), '12.000');
  });

  test('Escuela a los 7 años y Desarrollo Primario a los 10 años funcionan',
      () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(lifeProvider.notifier);
    notifier.startNewLife(
      name: 'Kael',
      gender: Gender.male,
      startPaused: true,
    );

    bool sawPriest = false;
    bool sawSchool = false;
    bool sawPrimaryDev = false;
    CharacterStats? statsBeforePrimaryDev;

    while (container.read(lifeProvider).hero.age < 11 &&
        !container.read(lifeProvider).isGameOver) {
      final active = container.read(lifeProvider).activeEvent;
      if (active != null) {
        if (active.eventId == StoryEventsCatalog.priestVisitId) {
          sawPriest = true;
        } else if (active.eventId == StoryEventsCatalog.schoolEnrollmentId) {
          sawSchool = true;
        } else if (active.eventId == StoryEventsCatalog.primaryDevelopmentId) {
          sawPrimaryDev = true;
          statsBeforePrimaryDev = container.read(lifeProvider).hero.stats;
          expect(active.triggersPrimaryDevelopment, isTrue);
        }
        final choice = active.eventId.startsWith('family_economy_pressure_')
            ? active.choices.last
            : active.choices.first;
        notifier.resolveActiveEvent(choice);
        if (active.eventId == StoryEventsCatalog.schoolEnrollmentId) {
          expect(container.read(lifeProvider).familyState.isEnrolledInSchool, isTrue);
        }
        if (sawPrimaryDev) break;
        continue;
      }
      notifier.advanceToNextSemester();
    }

    expect(sawPriest, isTrue);
    expect(sawSchool, isTrue);
    expect(sawPrimaryDev, isTrue);

    final stateAtTen = container.read(lifeProvider);
    expect(
      stateAtTen.worldState.storyFlags.contains('attended_school'),
      isTrue,
    );
    expect(stateAtTen.hero.primaryDevelopmentCompleted, isTrue);
    expect(
      stateAtTen.hero.statCaps.combatSkill,
      max(
        100,
        statsBeforePrimaryDev!.strength *
            statsBeforePrimaryDev.health *
            max(1, statsBeforePrimaryDev.combatSkill),
      ),
    );
    expect(
      stateAtTen.hero.statCaps.knowledge,
      max(100, statsBeforePrimaryDev.intellect * 10),
    );
    expect(
      stateAtTen.hero.statCaps.magicPower,
      max(
        100,
        max(1, statsBeforePrimaryDev.combatSkill) *
            max(1, statsBeforePrimaryDev.mana) *
            max(1, statsBeforePrimaryDev.intellect),
      ),
    );

    // Serialización JSON conserva statCaps, primaryDevelopmentCompleted y familyState
    final restored = GameState.fromJson(stateAtTen.toJson());
    expect(restored.hero.primaryDevelopmentCompleted, isTrue);
    expect(restored.hero.statCaps.combatSkill, stateAtTen.hero.statCaps.combatSkill);
    expect(restored.familyState.isEnrolledInSchool, isTrue);
  });

  test('A los 15 años se independiza y puede ser Aventurero', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(lifeProvider.notifier);
    notifier.startNewLife(
      name: 'Aria',
      gender: Gender.female,
      startPaused: true,
    );

    while (container.read(lifeProvider).hero.age < 15 ||
        !container
            .read(lifeProvider)
            .worldState
            .completedStoryEventIds
            .contains(StoryEventsCatalog.leaveVillageId)) {
      final ev = container.read(lifeProvider).activeEvent;
      if (ev != null) {
        notifier.resolveActiveEvent(ev.choices.first);
        continue;
      }
      if (container.read(lifeProvider).hero.age >= 15 &&
          container
              .read(lifeProvider)
              .worldState
              .completedStoryEventIds
              .contains(StoryEventsCatalog.leaveVillageId)) {
        break;
      }
      notifier.advanceToNextSemester();
    }
    final pending = container.read(lifeProvider).activeEvent;
    if (pending != null) {
      notifier.resolveActiveEvent(pending.choices.first);
    }

    final atFifteen = container.read(lifeProvider);
    expect(atFifteen.hero.age, greaterThanOrEqualTo(15));
    expect(atFifteen.familyState.isFinanciallyIndependent, isTrue);
    expect(notifier.applyForAdventurer(), isTrue);

    final quests = GuildQuestCatalog.availableFor(
      container.read(lifeProvider).adventurerRank,
    );
    expect(notifier.takeGuildQuest(quests.first), isNotNull);
  });

  testWidgets(
      'MedievalLifeApp muestra Economía Familiar a los 0 años y avisa del desarrollo a los 10',
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

    await tester.scrollUntilVisible(
      find.byKey(const Key('family_economy_card')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byKey(const Key('family_economy_card')), findsOneWidget);
    expect(find.text('Economía Familiar'), findsOneWidget);
    expect(find.text('Ahorros: 3O 0P 0C'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.textContaining('a los 10 años'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('a los 10 años'), findsOneWidget);

    // Verificar las 5 pestañas y la vista Social sin overflows
    expect(find.text('Vida'), findsOneWidget);
    expect(find.text('Semestre'), findsOneWidget);
    expect(find.text('Social'), findsOneWidget);
    expect(find.text('Oficios'), findsOneWidget);
    expect(find.text('Crónicas'), findsOneWidget);

    await tester.tap(find.text('Social'));
    await tester.pump();
    expect(find.text('Círculo Social y Afinidades'), findsOneWidget);
    expect(find.text('Gran Vínculo · 82'), findsOneWidget);
    expect(find.text('Conocido: 4/4'), findsAtLeastNWidgets(1));

    await tester.scrollUntilVisible(
      find.text('Cercano · 78'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Cercano · 78'), findsOneWidget);

    // Abrir diálogo de charla y verificar que no muestra porcentajes ni vista previa de afinidad
    await tester.tap(find.text('Charlar').first);
    await tester.pumpAndSettle();
    expect(find.text('Preguntar a qué se dedica'), findsOneWidget);
    expect(find.text('Preguntar sobre su familia'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.textContaining('%'),
      ),
      findsNothing,
    );
    await tester.tap(find.text('Preguntar a qué se dedica'));
    await tester.pumpAndSettle();
    expect(find.text('Cerrar'), findsOneWidget);
    await tester.tap(find.text('Cerrar'));
    await tester.pumpAndSettle();

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  test('Sistema Social registra contactos, afinidades, interacciones y serializa',
      () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(lifeProvider.notifier);
    notifier.startNewLife(
      name: 'Soren',
      gender: Gender.male,
      startPaused: true,
    );

    final initialContacts = container.read(lifeProvider).contacts;
    expect(initialContacts.length, 2);
    final mother = initialContacts.firstWhere((c) => c.role == 'Madre');
    final father = initialContacts.firstWhere((c) => c.role == 'Padre');
    expect(mother.affinityLevel, AffinityLevel.trusted);
    expect(father.affinityLevel, AffinityLevel.friend);
    expect(father.knownFactsCount, 4);
    expect(mother.knownFactsCount, 4);
    final fatherInitialAge = father.age;

    // Charla por tema con Padre (1 vez por semestre)
    final chatResult =
        notifier.chatWithContact('fam_father', ChatTopic.askOccupation);
    expect(chatResult, isNotNull);
    expect(chatResult!.contactId, 'fam_father');
    // Bloquea repetir charla en el mismo semestre
    expect(notifier.chatWithContact('fam_father', ChatTopic.casualTalk), isNull);

    // Avanzamos hasta los 6 años para verificar que Padre Anselm se añade con identidad oculta
    while (container.read(lifeProvider).hero.age < 7 &&
        !container
            .read(lifeProvider)
            .contacts
            .any((c) => c.name == 'Padre Anselm')) {
      final ev = container.read(lifeProvider).activeEvent;
      if (ev != null) {
        notifier.resolveActiveEvent(ev.choices.first);
        continue;
      }
      notifier.advanceToNextSemester();
    }
    final pending = container.read(lifeProvider).activeEvent;
    if (pending != null) {
      notifier.resolveActiveEvent(pending.choices.first);
    }

    final contactsAtSix = container.read(lifeProvider).contacts;
    final fatherLater = contactsAtSix.firstWhere((c) => c.id == 'fam_father');
    expect(
      fatherLater.age,
      fatherInitialAge + container.read(lifeProvider).hero.age,
    );

    final anselm = contactsAtSix.firstWhere((c) => c.name == 'Padre Anselm');
    expect(anselm.knownFactsCount, 0);
    expect(anselm.knowsAge, isFalse);
    expect(anselm.knowsOccupation, isFalse);
    expect(anselm.knowsFamily, isFalse);

    // Charlar con Padre Anselm sobre un tema válido devuelve resultado concreto
    final anselmChat =
        notifier.chatWithContact(anselm.id, ChatTopic.askIdentityAndAge);
    expect(anselmChat, isNotNull);

    // Serialización JSON conserva contactos, identidad y progreso de descubrimiento
    final restored = GameState.fromJson(container.read(lifeProvider).toJson());
    expect(restored.contacts.length, contactsAtSix.length);
    final restoredAnselm =
        restored.contacts.firstWhere((c) => c.name == 'Padre Anselm');
    expect(restoredAnselm.occupation, anselm.occupation);
    expect(restoredAnselm.familyInfo, anselm.familyInfo);
    expect(restoredAnselm.knowsAge, anselmChat!.liked);
  });
}
