import 'character.dart';
import 'currency.dart';
import 'family_state.dart';
import 'game_event.dart';
import 'life_stage.dart';
import 'profession.dart';
import 'social_relation.dart';
import 'stats.dart';
import 'world_state.dart';

/// Entrada en el diario cronológico del protagonista.
class ChronicleEntry {
  const ChronicleEntry({
    required this.id,
    required this.year,
    required this.month,
    required this.age,
    required this.stage,
    required this.title,
    required this.description,
    this.wasSuccess,
    this.rollSummary,
  });

  final String id;
  final int year;
  final int month;
  final int age;
  final LifeStage stage;
  final String title;
  final String description;
  final bool? wasSuccess;
  final String? rollSummary;

  String get dateLabel => 'Año $year · Mes $month ($age a.)';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'year': year,
      'month': month,
      'age': age,
      'stage': stage.name,
      'title': title,
      'description': description,
      'wasSuccess': wasSuccess,
      'rollSummary': rollSummary,
    };
  }

  factory ChronicleEntry.fromJson(Map<String, dynamic> json) {
    return ChronicleEntry(
      id: json['id'] as String,
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      age: (json['age'] as num?)?.toInt() ?? 0,
      stage: LifeStageX.parse(json['stage'] as String?),
      title: json['title'] as String,
      description: json['description'] as String,
      wasSuccess: json['wasSuccess'] as bool?,
      rollSummary: json['rollSummary'] as String?,
    );
  }
}

/// Estado global serializable de la partida actual.
class GameState {
  const GameState({
    required this.needsCharacterCreation,
    required this.hero,
    required this.currency,
    required this.year,
    required this.month,
    required this.isPaused,
    required this.speedMultiplier,
    required this.monthsSinceLastEvent,
    required this.seenEventIds,
    required this.chronicles,
    this.profession = ProfessionId.none,
    this.adventurerXp = 0,
    this.completedQuests = 0,
    this.lastSemesterActionKey,
    this.lastQuestSemesterKey,
    this.worldState = const WorldState(
      currentLocation: WorldLocation.homeVillage,
      route: StoryRoute.unwritten,
      demonKingThreat: 8,
      storyFlags: {},
      completedStoryEventIds: {},
      worldNews: [],
    ),
    this.familyState = const FamilyState(familySavingsCopper: 30000),
    this.contacts = const [],
    this.activeEvent,
    this.wasPausedBeforeEvent = false,
    this.isGameOver = false,
    this.causeOfDeath,
  });

  factory GameState.initialCreation() {
    return GameState(
      needsCharacterCreation: true,
      hero: const Protagonist(
        name: '',
        surname: 'del Valle',
        gender: Gender.male,
        age: 0,
        birthYear: 1140,
        isAlive: true,
        stats: CharacterStats(
          emotionalIntelligence: 25,
          intellect: 25,
          strength: 10,
          health: 80,
          combatSkill: 5,
          mood: 75,
        ),
        avatarSeed: 1,
        fatherName: 'Aldo',
        motherName: 'Mirella',
        villageName: 'Vallebruma',
      ),
      currency: const RpgCurrency(0),
      year: 1140,
      month: 1,
      isPaused: true,
      speedMultiplier: 1,
      monthsSinceLastEvent: 0,
      seenEventIds: const {},
      chronicles: const [],
      worldState: WorldState.initial(),
      familyState: FamilyState.initial(),
    );
  }

  final bool needsCharacterCreation;
  final Protagonist hero;
  final RpgCurrency currency;
  final int year;
  final int month;
  final bool isPaused;
  final int speedMultiplier;
  final int monthsSinceLastEvent;
  final Set<String> seenEventIds;
  final List<ChronicleEntry> chronicles;
  final ProfessionId profession;
  final int adventurerXp;
  final int completedQuests;
  final String? lastSemesterActionKey;
  final String? lastQuestSemesterKey;
  final WorldState worldState;
  final FamilyState familyState;
  final List<SocialContact> contacts;
  final ActiveGameEvent? activeEvent;
  final bool wasPausedBeforeEvent;
  final bool isGameOver;
  final String? causeOfDeath;

  String get formattedDate => 'Año $year - Mes $month';

  int get currentSemester => month <= 6 ? 1 : 2;
  String get currentSemesterKey => '$year-$currentSemester';

  bool get hasSemesterActionAvailable =>
      !needsCharacterCreation &&
      !isGameOver &&
      lastSemesterActionKey != currentSemesterKey;

  bool get canApplyAsAdventurer =>
      !needsCharacterCreation &&
      !isGameOver &&
      hero.isAlive &&
      hero.age >= 15 &&
      profession == ProfessionId.none;

  bool get hasGuildQuestAvailable =>
      !needsCharacterCreation &&
      !isGameOver &&
      profession == ProfessionId.adventurer &&
      lastQuestSemesterKey != currentSemesterKey;

  AdventurerRank get adventurerRank => AdventurerRankX.fromXp(adventurerXp);

  GameState copyWith({
    bool? needsCharacterCreation,
    Protagonist? hero,
    RpgCurrency? currency,
    int? year,
    int? month,
    bool? isPaused,
    int? speedMultiplier,
    int? monthsSinceLastEvent,
    Set<String>? seenEventIds,
    List<ChronicleEntry>? chronicles,
    ProfessionId? profession,
    int? adventurerXp,
    int? completedQuests,
    String? lastSemesterActionKey,
    String? lastQuestSemesterKey,
    WorldState? worldState,
    FamilyState? familyState,
    List<SocialContact>? contacts,
    ActiveGameEvent? activeEvent,
    bool clearActiveEvent = false,
    bool? wasPausedBeforeEvent,
    bool? isGameOver,
    String? causeOfDeath,
    bool clearCauseOfDeath = false,
  }) {
    return GameState(
      needsCharacterCreation:
          needsCharacterCreation ?? this.needsCharacterCreation,
      hero: hero ?? this.hero,
      currency: currency ?? this.currency,
      year: year ?? this.year,
      month: month ?? this.month,
      isPaused: isPaused ?? this.isPaused,
      speedMultiplier: speedMultiplier ?? this.speedMultiplier,
      monthsSinceLastEvent: monthsSinceLastEvent ?? this.monthsSinceLastEvent,
      seenEventIds: seenEventIds ?? this.seenEventIds,
      chronicles: chronicles ?? this.chronicles,
      profession: profession ?? this.profession,
      adventurerXp: adventurerXp ?? this.adventurerXp,
      completedQuests: completedQuests ?? this.completedQuests,
      lastSemesterActionKey:
          lastSemesterActionKey ?? this.lastSemesterActionKey,
      lastQuestSemesterKey: lastQuestSemesterKey ?? this.lastQuestSemesterKey,
      worldState: worldState ?? this.worldState,
      familyState: familyState ?? this.familyState,
      contacts: contacts ?? this.contacts,
      activeEvent: clearActiveEvent ? null : (activeEvent ?? this.activeEvent),
      wasPausedBeforeEvent: wasPausedBeforeEvent ?? this.wasPausedBeforeEvent,
      isGameOver: isGameOver ?? this.isGameOver,
      causeOfDeath:
          clearCauseOfDeath ? null : (causeOfDeath ?? this.causeOfDeath),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'needsCharacterCreation': needsCharacterCreation,
      'hero': hero.toJson(),
      'totalCopper': currency.totalCopper,
      'year': year,
      'month': month,
      'isPaused': isPaused,
      'speedMultiplier': speedMultiplier,
      'monthsSinceLastEvent': monthsSinceLastEvent,
      'seenEventIds': seenEventIds.toList(),
      'chronicles': chronicles.map((e) => e.toJson()).toList(),
      'profession': profession.name,
      'adventurerXp': adventurerXp,
      'completedQuests': completedQuests,
      'lastSemesterActionKey': lastSemesterActionKey,
      'lastQuestSemesterKey': lastQuestSemesterKey,
      'worldState': worldState.toJson(),
      'familyState': familyState.toJson(),
      'contacts': contacts.map((c) => c.toJson()).toList(),
      'isGameOver': isGameOver,
      'causeOfDeath': causeOfDeath,
    };
  }

  factory GameState.fromJson(Map<String, dynamic> json) {
    final seenRaw = json['seenEventIds'] as List<dynamic>? ?? const [];
    final chroniclesRaw = json['chronicles'] as List<dynamic>? ?? const [];
    final worldJson = json['worldState'] as Map<String, dynamic>?;
    final familyJson = json['familyState'] as Map<String, dynamic>?;
    final contactsRaw = json['contacts'] as List<dynamic>? ?? const [];

    return GameState(
      needsCharacterCreation: json['needsCharacterCreation'] as bool? ?? true,
      hero: Protagonist.fromJson(
        json['hero'] as Map<String, dynamic>? ?? const {},
      ),
      currency: RpgCurrency((json['totalCopper'] as num?)?.toInt() ?? 0),
      year: (json['year'] as num?)?.toInt() ?? 1140,
      month: (json['month'] as num?)?.toInt() ?? 1,
      isPaused: json['isPaused'] as bool? ?? false,
      speedMultiplier: (json['speedMultiplier'] as num?)?.toInt() ?? 1,
      monthsSinceLastEvent:
          (json['monthsSinceLastEvent'] as num?)?.toInt() ?? 0,
      seenEventIds: seenRaw.map((e) => e.toString()).toSet(),
      chronicles: chroniclesRaw
          .map((e) => ChronicleEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      profession: ProfessionIdX.parse(json['profession'] as String?),
      adventurerXp: (json['adventurerXp'] as num?)?.toInt() ?? 0,
      completedQuests: (json['completedQuests'] as num?)?.toInt() ?? 0,
      lastSemesterActionKey: json['lastSemesterActionKey'] as String?,
      lastQuestSemesterKey: json['lastQuestSemesterKey'] as String?,
      worldState: worldJson != null
          ? WorldState.fromJson(worldJson)
          : WorldState.initial(),
      familyState: familyJson != null
          ? FamilyState.fromJson(familyJson)
          : FamilyState.initial(),
      contacts: contactsRaw
          .map((e) => SocialContact.fromJson(e as Map<String, dynamic>))
          .toList(),
      isGameOver: json['isGameOver'] as bool? ?? false,
      causeOfDeath: json['causeOfDeath'] as String?,
    );
  }
}

