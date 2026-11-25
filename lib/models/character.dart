import 'life_stage.dart';
import 'stats.dart';

/// Género elegido para el protagonista renacido.
enum Gender { male, female }

/// Modelo del protagonista único que renace a los 0 años en una aldea medieval.
class Protagonist {
  const Protagonist({
    required this.name,
    required this.surname,
    required this.gender,
    required this.age,
    required this.birthYear,
    this.deathYear,
    required this.isAlive,
    required this.stats,
    required this.avatarSeed,
    required this.fatherName,
    required this.motherName,
    required this.villageName,
  });

  final String name;
  final String surname;
  final Gender gender;
  final int age;
  final int birthYear;
  final int? deathYear;
  final bool isAlive;
  final CharacterStats stats;
  final int avatarSeed;
  final String fatherName;
  final String motherName;
  final String villageName;

  String get fullName => '$name $surname';

  LifeStage get lifeStage => LifeStageX.fromAge(age);

  Protagonist copyWith({
    String? name,
    String? surname,
    Gender? gender,
    int? age,
    int? birthYear,
    int? deathYear,
    bool clearDeathYear = false,
    bool? isAlive,
    CharacterStats? stats,
    int? avatarSeed,
    String? fatherName,
    String? motherName,
    String? villageName,
  }) {
    return Protagonist(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      birthYear: birthYear ?? this.birthYear,
      deathYear: clearDeathYear ? null : (deathYear ?? this.deathYear),
      isAlive: isAlive ?? this.isAlive,
      stats: stats ?? this.stats,
      avatarSeed: avatarSeed ?? this.avatarSeed,
      fatherName: fatherName ?? this.fatherName,
      motherName: motherName ?? this.motherName,
      villageName: villageName ?? this.villageName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'gender': gender.name,
      'age': age,
      'birthYear': birthYear,
      'deathYear': deathYear,
      'isAlive': isAlive,
      'stats': stats.toJson(),
      'avatarSeed': avatarSeed,
      'fatherName': fatherName,
      'motherName': motherName,
      'villageName': villageName,
    };
  }

  factory Protagonist.fromJson(Map<String, dynamic> json) {
    return Protagonist(
      name: json['name'] as String? ?? 'Aldric',
      surname: json['surname'] as String? ?? 'del Valle',
      gender: (json['gender'] as String?) == Gender.female.name
          ? Gender.female
          : Gender.male,
      age: (json['age'] as num?)?.toInt() ?? 0,
      birthYear: (json['birthYear'] as num?)?.toInt() ?? 1140,
      deathYear: (json['deathYear'] as num?)?.toInt(),
      isAlive: json['isAlive'] as bool? ?? true,
      stats: CharacterStats.fromJson(
        json['stats'] as Map<String, dynamic>? ?? const {},
      ),
      avatarSeed: (json['avatarSeed'] as num?)?.toInt() ?? 1,
      fatherName: json['fatherName'] as String? ?? 'Gareth',
      motherName: json['motherName'] as String? ?? 'Elara',
      villageName: json['villageName'] as String? ?? 'Vallebruma',
    );
  }
}
