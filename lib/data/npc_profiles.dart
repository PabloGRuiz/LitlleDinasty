import 'dart:math';

import '../models/social_relation.dart';

class NpcProfileData {
  const NpcProfileData({
    required this.age,
    required this.occupation,
    required this.bio,
    required this.familyInfo,
    required this.temperament,
  });

  final int age;
  final String occupation;
  final String bio;
  final String familyInfo;
  final NpcTemperament temperament;
}

class NpcProfileGenerator {
  static NpcProfileData forFather({
    required String villageName,
    required int heroBirthAgeDiff,
  }) {
    return NpcProfileData(
      age: heroBirthAgeDiff,
      occupation: 'Jornalero y leñador de $villageName',
      bio: 'Hombre curtido por el trabajo duro que sostiene el hogar con esfuerzo diario.',
      familyInfo: 'Esposo de tu madre y cabeza de familia.',
      temperament: NpcTemperament.practical,
    );
  }

  static NpcProfileData forMother({
    required String villageName,
    required int heroBirthAgeDiff,
  }) {
    return NpcProfileData(
      age: heroBirthAgeDiff,
      occupation: 'Costurera y cuidadora del hogar en $villageName',
      bio: 'Mujer atenta y previsora que administra las provisiones de la familia.',
      familyInfo: 'Esposa de tu padre y madre devota.',
      temperament: NpcTemperament.warm,
    );
  }

  static NpcProfileData forSibling({
    required bool isMale,
    required String villageName,
  }) {
    return NpcProfileData(
      age: 0,
      occupation: isMale
          ? 'Infante en crecimiento ($villageName)'
          : 'Pequeña del hogar ($villageName)',
      bio: isMale
          ? 'Tu hermano menor, curioso y siempre tras tus pasos.'
          : 'Tu hermana menor, inquieta y llena de energía.',
      familyInfo: 'Hijo menor de tus padres y tu hermano directo.',
      temperament: NpcTemperament.warm,
    );
  }

  static NpcProfileData generateProfile({
    required Random rng,
    required String name,
    required String role,
    required RelationshipGroup group,
    required int heroAge,
    required String villageName,
  }) {
    final lowerRole = role.toLowerCase();

    if (name == 'Padre Anselm' || lowerRole.contains('sacerdote')) {
      return NpcProfileData(
        age: 46 + rng.nextInt(12),
        occupation: 'Sacerdote itinerante de la Orden del Alba',
        bio:
            'Clérigo erudito que recorre aldeas remotas evaluando el despertar arcano de los niños.',
        familyInfo:
            'Consagrado al templo desde joven; considera hermanos a los acólitos de su orden.',
        temperament: NpcTemperament.scholarly,
      );
    }

    if (lowerRole.contains('instructor')) {
      return NpcProfileData(
        age: 32 + rng.nextInt(14),
        occupation: 'Instructor veterano del Gremio de Aventureros',
        bio:
            'Antiguo explorador de mazmorras que sobrevivió a tres inviernos en la frontera.',
        familyInfo:
            'Tiene una hermana mercadera en la capital y un sobrino aprendiz.',
        temperament: NpcTemperament.practical,
      );
    }

    switch (group) {
      case RelationshipGroup.family:
        final age = (heroAge + 20 + rng.nextInt(15)).clamp(16, 75);
        return NpcProfileData(
          age: age,
          occupation: 'Pariente cercano en $villageName',
          bio: 'Miembro de tu linaje que comparte la historia del hogar.',
          familyInfo: 'Forma parte directa de tu círculo familiar.',
          temperament: NpcTemperament.warm,
        );

      case RelationshipGroup.village:
        final occupations = [
          'Herrero local de $villageName',
          'Boticaria del sendero viejo',
          'Panadero del mercado comunal',
          'Carpintero de techumbres',
          'Guardia de la empalizada',
        ];
        final bios = [
          'Vecino de larga data que conoce cada rumor y sendero de la comarca.',
          'Persona trabajadora que rara vez deja $villageName salvo en ferias.',
          'Aldeano observador que recuerda los tiempos previos a la sombra del Rey Demonio.',
        ];
        final families = [
          'Vive con dos hijos jóvenes cerca de la plaza del pozo.',
          'Soltero tras perder a su pareja años atrás; cuida de su padre anciano.',
          'Casado con la familia de molineros de la ribera.',
          'Tiene tres primos trabajando las tierras del norte.',
        ];
        final temps = [
          NpcTemperament.warm,
          NpcTemperament.practical,
          NpcTemperament.reserved,
        ];
        return NpcProfileData(
          age: (heroAge + 8 + rng.nextInt(28)).clamp(14, 72),
          occupation: occupations[rng.nextInt(occupations.length)],
          bio: bios[rng.nextInt(bios.length)],
          familyInfo: families[rng.nextInt(families.length)],
          temperament: temps[rng.nextInt(temps.length)],
        );

      case RelationshipGroup.school:
        final isTeacher =
            lowerRole.contains('maestr') || lowerRole.contains('preceptor');
        final age = isTeacher
            ? 34 + rng.nextInt(24)
            : (heroAge + rng.nextInt(3) - 1).clamp(7, 22);
        return NpcProfileData(
          age: age,
          occupation: isTeacher
              ? 'Preceptor de letras, cálculo y doctrina'
              : 'Estudiante de la academia local',
          bio: isTeacher
              ? 'Erudito exigente que valora la disciplina intelectual por encima de la fuerza bruta.'
              : 'Joven compañero de pupitre que sueña con destacar más allá de la aldea.',
          familyInfo: isTeacher
              ? 'Hijo de antiguos escribas reales; sin descendencia conocida.'
              : 'Proviene de una familia de artesanos que ahorra para sus estudios.',
          temperament: isTeacher
              ? NpcTemperament.scholarly
              : (rng.nextBool()
                  ? NpcTemperament.ambitious
                  : NpcTemperament.scholarly),
        );

      case RelationshipGroup.guild:
        final occupations = [
          'Rastreador de bestias de rango Plata',
          'Espadachín errante del Gremio',
          'Maga de apoyo en expediciones',
          'Oficial de contratos y recompensas',
        ];
        final bios = [
          'Sobreviviente de escaramuzas fronterizas que mide a las personas por su temple.',
          'Veterano pragmático que busca aliados fiables ante el avance demoníaco.',
          'Aventurero ambicioso obsesionado con escalar rangos en el Gremio.',
        ];
        final families = [
          'Su familia regenta una posada en la ruta del este.',
          'Huérfano de guerra criado entre cuarteles del Gremio.',
          'Mantiene a su madre enviando monedas de plata cada trimestre.',
        ];
        final temps = [
          NpcTemperament.practical,
          NpcTemperament.ambitious,
          NpcTemperament.reserved,
        ];
        return NpcProfileData(
          age: (max(16, heroAge - 2) + rng.nextInt(20)).clamp(16, 58),
          occupation: occupations[rng.nextInt(occupations.length)],
          bio: bios[rng.nextInt(bios.length)],
          familyInfo: families[rng.nextInt(families.length)],
          temperament: temps[rng.nextInt(temps.length)],
        );

      case RelationshipGroup.world:
        final occupations = [
          'Emisario de la Corona',
          'Capitán reclutador del frente norte',
          'Archivero real de linajes mágicos',
          'Comandante de la Guardia del Reino',
        ];
        final bios = [
          'Figura influyente encargada de detectar candidatos para enfrentar al Rey Demonio.',
          'Noble austero que desconfía de los impulsivos y respeta el decoro.',
        ];
        final families = [
          'Pertenece a una casa menor emparentada con la corte capitalina.',
          'Sus hermanos sirven en distintas fortalezas de la frontera.',
        ];
        return NpcProfileData(
          age: 28 + rng.nextInt(25),
          occupation: occupations[rng.nextInt(occupations.length)],
          bio: bios[rng.nextInt(bios.length)],
          familyInfo: families[rng.nextInt(families.length)],
          temperament: rng.nextBool()
              ? NpcTemperament.reserved
              : NpcTemperament.ambitious,
        );
    }
  }
}
