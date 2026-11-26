import 'character.dart';
import 'currency.dart';

/// Hermano o hermana del protagonista que comparte la economía familiar.
class Sibling {
  const Sibling({
    required this.id,
    required this.name,
    required this.gender,
    required this.birthYear,
    required this.age,
    this.isAlive = true,
  });

  final String id;
  final String name;
  final Gender gender;
  final int birthYear;
  final int age;
  final bool isAlive;

  bool get isDependent => isAlive && age < 16;

  Sibling copyWith({
    String? id,
    String? name,
    Gender? gender,
    int? birthYear,
    int? age,
    bool? isAlive,
  }) {
    return Sibling(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birthYear: birthYear ?? this.birthYear,
      age: age ?? this.age,
      isAlive: isAlive ?? this.isAlive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender.name,
      'birthYear': birthYear,
      'age': age,
      'isAlive': isAlive,
    };
  }

  factory Sibling.fromJson(Map<String, dynamic> json) {
    return Sibling(
      id: json['id'] as String,
      name: json['name'] as String,
      gender: (json['gender'] as String?) == Gender.female.name
          ? Gender.female
          : Gender.male,
      birthYear: (json['birthYear'] as num?)?.toInt() ?? 1142,
      age: (json['age'] as num?)?.toInt() ?? 0,
      isAlive: json['isAlive'] as bool? ?? true,
    );
  }
}

/// Economía familiar durante la infancia y adolescencia temprana (hasta los 15 años).
class FamilyState {
  const FamilyState({
    required this.familySavingsCopper,
    this.parentsMonthlyIncomeCopper = 2000, // 20 Plata/mes
    this.heroUpkeepCopper = 500, // 5 Plata/mes
    this.schoolCostCopper = 1500, // 15 Plata/mes
    this.siblingUpkeepCopper = 500, // 5 Plata/mes por hermano dependiente
    this.childWorkIncomeCopper = 800, // 8 Plata/mes si trabaja de menor
    this.isEnrolledInSchool = false,
    this.isChildWorker = false,
    this.isFinanciallyIndependent = false,
    this.siblings = const [],
  });

  /// Economía inicial humilde: 3 monedas de oro (30.000 cobre), +20P padres, -5P mantención.
  factory FamilyState.initial() {
    return const FamilyState(
      familySavingsCopper: 30000,
    );
  }

  final int familySavingsCopper;
  final int parentsMonthlyIncomeCopper;
  final int heroUpkeepCopper;
  final int schoolCostCopper;
  final int siblingUpkeepCopper;
  final int childWorkIncomeCopper;
  final bool isEnrolledInSchool;
  final bool isChildWorker;
  final bool isFinanciallyIndependent;
  final List<Sibling> siblings;

  int get dependentSiblingsCount =>
      siblings.where((s) => s.isDependent).length;

  int get monthlyIncomeCopper =>
      parentsMonthlyIncomeCopper +
      (isChildWorker ? childWorkIncomeCopper : 0);

  int get monthlyExpensesCopper =>
      heroUpkeepCopper +
      (isEnrolledInSchool ? schoolCostCopper : 0) +
      dependentSiblingsCount * siblingUpkeepCopper;

  int get monthlyNetCopper => monthlyIncomeCopper - monthlyExpensesCopper;

  RpgCurrency get savingsCurrency => RpgCurrency(familySavingsCopper);

  FamilyState copyWith({
    int? familySavingsCopper,
    int? parentsMonthlyIncomeCopper,
    int? heroUpkeepCopper,
    int? schoolCostCopper,
    int? siblingUpkeepCopper,
    int? childWorkIncomeCopper,
    bool? isEnrolledInSchool,
    bool? isChildWorker,
    bool? isFinanciallyIndependent,
    List<Sibling>? siblings,
  }) {
    return FamilyState(
      familySavingsCopper:
          (familySavingsCopper ?? this.familySavingsCopper) < 0
              ? 0
              : (familySavingsCopper ?? this.familySavingsCopper),
      parentsMonthlyIncomeCopper:
          parentsMonthlyIncomeCopper ?? this.parentsMonthlyIncomeCopper,
      heroUpkeepCopper: heroUpkeepCopper ?? this.heroUpkeepCopper,
      schoolCostCopper: schoolCostCopper ?? this.schoolCostCopper,
      siblingUpkeepCopper: siblingUpkeepCopper ?? this.siblingUpkeepCopper,
      childWorkIncomeCopper:
          childWorkIncomeCopper ?? this.childWorkIncomeCopper,
      isEnrolledInSchool: isEnrolledInSchool ?? this.isEnrolledInSchool,
      isChildWorker: isChildWorker ?? this.isChildWorker,
      isFinanciallyIndependent:
          isFinanciallyIndependent ?? this.isFinanciallyIndependent,
      siblings: siblings ?? this.siblings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'familySavingsCopper': familySavingsCopper,
      'parentsMonthlyIncomeCopper': parentsMonthlyIncomeCopper,
      'heroUpkeepCopper': heroUpkeepCopper,
      'schoolCostCopper': schoolCostCopper,
      'siblingUpkeepCopper': siblingUpkeepCopper,
      'childWorkIncomeCopper': childWorkIncomeCopper,
      'isEnrolledInSchool': isEnrolledInSchool,
      'isChildWorker': isChildWorker,
      'isFinanciallyIndependent': isFinanciallyIndependent,
      'siblings': siblings.map((s) => s.toJson()).toList(),
    };
  }

  factory FamilyState.fromJson(Map<String, dynamic> json) {
    final siblingsRaw = json['siblings'] as List<dynamic>? ?? const [];
    return FamilyState(
      familySavingsCopper:
          (json['familySavingsCopper'] as num?)?.toInt() ?? 30000,
      parentsMonthlyIncomeCopper:
          (json['parentsMonthlyIncomeCopper'] as num?)?.toInt() ?? 2000,
      heroUpkeepCopper: (json['heroUpkeepCopper'] as num?)?.toInt() ?? 500,
      schoolCostCopper: (json['schoolCostCopper'] as num?)?.toInt() ?? 1500,
      siblingUpkeepCopper:
          (json['siblingUpkeepCopper'] as num?)?.toInt() ?? 500,
      childWorkIncomeCopper:
          (json['childWorkIncomeCopper'] as num?)?.toInt() ?? 800,
      isEnrolledInSchool: json['isEnrolledInSchool'] as bool? ?? false,
      isChildWorker: json['isChildWorker'] as bool? ?? false,
      isFinanciallyIndependent:
          json['isFinanciallyIndependent'] as bool? ?? false,
      siblings: siblingsRaw
          .map((e) => Sibling.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

