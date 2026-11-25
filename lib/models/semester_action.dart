import 'package:flutter/material.dart';

import '../theme/medieval_theme.dart';
import 'life_stage.dart';
import 'stats.dart';

/// Acción planificable una vez por semestre (Meses 1–6 y 7–12) para orientar la vida.
class SemesterAction {
  const SemesterAction({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.statDelta,
    this.copperDelta = 0,
    required this.allowedStages,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;
  final StatDelta statDelta;
  final int copperDelta;
  final List<LifeStage> allowedStages;
}

/// Catálogo de objetivos semestrales adaptados a cada etapa vital.
class SemesterActionsCatalog {
  SemesterActionsCatalog._();

  static const List<SemesterAction> all = [
    // Infancia temprana (0–3)
    SemesterAction(
      id: 'sem_early_observe',
      title: 'Observar y Recordar',
      description:
          'Prestas atención al idioma local y ordenas los recuerdos de tu vida pasada.',
      icon: Icons.visibility_outlined,
      accentColor: MedievalColors.royalBlue,
      statDelta: StatDelta(intellect: 4, emotionalIntelligence: 2),
      allowedStages: [LifeStage.earlyChildhood],
    ),
    SemesterAction(
      id: 'sem_early_crawl',
      title: 'Gatear y Fortalecer el Cuerpo',
      description:
          'Ejercitas brazos y piernas por la cabaña para crecer vigoroso.',
      icon: Icons.directions_run_rounded,
      accentColor: MedievalColors.amberOchre,
      statDelta: StatDelta(strength: 4, health: 3),
      allowedStages: [LifeStage.earlyChildhood],
    ),
    SemesterAction(
      id: 'sem_early_bond',
      title: 'Jugar con tus Padres',
      description:
          'Fortaleces los lazos familiares entre risas y canciones junto al fuego.',
      icon: Icons.favorite_outline_rounded,
      accentColor: MedievalColors.plumEmpathy,
      statDelta: StatDelta(emotionalIntelligence: 4, mood: 5),
      allowedStages: [LifeStage.earlyChildhood],
    ),
    SemesterAction(
      id: 'sem_early_rest',
      title: 'Descansar y Nutrirse Bien',
      description:
          'Priorizas siestas largas y caldos tibios para cuidar tu salud.',
      icon: Icons.bedtime_outlined,
      accentColor: MedievalColors.forestGreen,
      statDelta: StatDelta(health: 5, mood: 3),
      allowedStages: [LifeStage.earlyChildhood],
    ),

    // Niñez (4–11)
    SemesterAction(
      id: 'sem_child_wood_sword',
      title: 'Entrenar con Espada de Madera',
      description:
          'Practicas estocadas y bloqueos tras el granero siguiendo tus instintos.',
      icon: Icons.sports_martial_arts_rounded,
      accentColor: MedievalColors.crimsonSeal,
      statDelta: StatDelta(combatSkill: 5, strength: 3, mood: 1),
      allowedStages: [LifeStage.childhood],
    ),
    SemesterAction(
      id: 'sem_child_study',
      title: 'Estudiar Lectura y Cálculo',
      description:
          'Aprendes letras, mapas y cuentas básicas en tablillas de cera.',
      icon: Icons.menu_book_rounded,
      accentColor: MedievalColors.royalBlue,
      statDelta: StatDelta(intellect: 6, mood: 1),
      allowedStages: [LifeStage.childhood],
    ),
    SemesterAction(
      id: 'sem_child_chores',
      title: 'Ayudar en Tareas de la Aldea',
      description:
          'Acarreas agua y recados para los vecinos a cambio de monedas de cobre.',
      icon: Icons.handyman_outlined,
      accentColor: MedievalColors.copperCoin,
      statDelta: StatDelta(strength: 3, emotionalIntelligence: 2),
      copperDelta: 35,
      allowedStages: [LifeStage.childhood],
    ),
    SemesterAction(
      id: 'sem_child_socialize',
      title: 'Socializar en la Plaza',
      description:
          'Compartes juegos y aprendes a leer las intenciones de otros niños.',
      icon: Icons.groups_outlined,
      accentColor: MedievalColors.plumEmpathy,
      statDelta: StatDelta(emotionalIntelligence: 5, mood: 4),
      allowedStages: [LifeStage.childhood],
    ),
    SemesterAction(
      id: 'sem_child_rest',
      title: 'Descansar en el Campo',
      description:
          'Paseas sin prisas por las praderas para recuperar vigor y alegría.',
      icon: Icons.spa_outlined,
      accentColor: MedievalColors.forestGreen,
      statDelta: StatDelta(health: 5, mood: 5),
      allowedStages: [LifeStage.childhood],
    ),

    // Adolescencia (12–17)
    SemesterAction(
      id: 'sem_adol_physique',
      title: 'Entrenamiento Físico Intenso',
      description:
          'Cargas troncos, corres cuestas y templas tu resistencia.',
      icon: Icons.fitness_center_rounded,
      accentColor: MedievalColors.amberOchre,
      statDelta: StatDelta(strength: 6, health: 3, mood: -1),
      allowedStages: [LifeStage.adolescence],
    ),
    SemesterAction(
      id: 'sem_adol_fencing',
      title: 'Practicar Esgrima y Combate',
      description:
          'Perfeccionas guardia, reflejos y golpes preparándote para el gremio.',
      icon: Icons.sports_martial_arts_rounded,
      accentColor: MedievalColors.crimsonSeal,
      statDelta: StatDelta(combatSkill: 6, strength: 2),
      allowedStages: [LifeStage.adolescence],
    ),
    SemesterAction(
      id: 'sem_adol_scrolls',
      title: 'Estudiar Pergaminos y Táctica',
      description:
          'Analizas tratados de historia, geografía y estrategia.',
      icon: Icons.auto_stories_rounded,
      accentColor: MedievalColors.royalBlue,
      statDelta: StatDelta(intellect: 6, emotionalIntelligence: 2),
      allowedStages: [LifeStage.adolescence],
    ),
    SemesterAction(
      id: 'sem_adol_errands',
      title: 'Trabajar de Recadero',
      description:
          'Llevas paquetes y cartas entre granjas reuniendo tus primeros ahorros.',
      icon: Icons.monetization_on_outlined,
      accentColor: MedievalColors.copperCoin,
      statDelta: StatDelta(strength: 2, emotionalIntelligence: 2),
      copperDelta: 80,
      allowedStages: [LifeStage.adolescence],
    ),
    SemesterAction(
      id: 'sem_adol_meditate',
      title: 'Meditar y Recuperar Fuerzas',
      description:
          'Equilibras tu respiración y cuidas tu bienestar físico y mental.',
      icon: Icons.self_improvement_rounded,
      accentColor: MedievalColors.forestGreen,
      statDelta: StatDelta(health: 5, mood: 6, emotionalIntelligence: 2),
      allowedStages: [LifeStage.adolescence],
    ),

    // Juventud y Adultez (18–59)
    SemesterAction(
      id: 'sem_adult_martial',
      title: 'Entrenamiento Marcial Riguroso',
      description:
          'Sesiones exigentes de armas y combate cuerpo a cuerpo.',
      icon: Icons.sports_martial_arts_rounded,
      accentColor: MedievalColors.crimsonSeal,
      statDelta: StatDelta(combatSkill: 6, strength: 3, mood: -1),
      allowedStages: [LifeStage.youth, LifeStage.adulthood],
    ),
    SemesterAction(
      id: 'sem_adult_study',
      title: 'Estudio Avanzado e Investigación',
      description:
          'Profundizas en alquimia básica, cuentas y leyes del reino.',
      icon: Icons.menu_book_rounded,
      accentColor: MedievalColors.royalBlue,
      statDelta: StatDelta(intellect: 6, emotionalIntelligence: 2),
      allowedStages: [LifeStage.youth, LifeStage.adulthood],
    ),
    SemesterAction(
      id: 'sem_adult_endurance',
      title: 'Forjar Resistencia Física',
      description:
          'Rutinas de fuerza y marcha por la montaña para endurecer el cuerpo.',
      icon: Icons.fitness_center_rounded,
      accentColor: MedievalColors.amberOchre,
      statDelta: StatDelta(strength: 6, health: 3),
      allowedStages: [LifeStage.youth, LifeStage.adulthood],
    ),
    SemesterAction(
      id: 'sem_adult_diplomacy',
      title: 'Diplomacia en la Taberna',
      description:
          'Cultivas contactos con mercaderes y viajeros obteniendo comisiones.',
      icon: Icons.forum_outlined,
      accentColor: MedievalColors.plumEmpathy,
      statDelta: StatDelta(emotionalIntelligence: 6, mood: 3),
      copperDelta: 120,
      allowedStages: [LifeStage.youth, LifeStage.adulthood],
    ),
    SemesterAction(
      id: 'sem_adult_labor',
      title: 'Jornales Comarcales',
      description:
          'Trabajas en obras y escoltas locales para llenar el monedero de plata.',
      icon: Icons.work_outline_rounded,
      accentColor: MedievalColors.silverCoin,
      statDelta: StatDelta(strength: 2, mood: -2),
      copperDelta: 250,
      allowedStages: [LifeStage.youth, LifeStage.adulthood],
    ),
    SemesterAction(
      id: 'sem_adult_rest',
      title: 'Reposo y Cuidados de Salud',
      description:
          'Tomas tisanas medicinales y duermes lo necesario para sanar.',
      icon: Icons.healing_outlined,
      accentColor: MedievalColors.forestGreen,
      statDelta: StatDelta(health: 8, mood: 6),
      allowedStages: [LifeStage.youth, LifeStage.adulthood],
    ),

    // Vejez (60+)
    SemesterAction(
      id: 'sem_old_memoirs',
      title: 'Escribir Memorias y Estudiar',
      description:
          'Ordenas tus vivencias en pergaminos y mantienes la mente despierta.',
      icon: Icons.history_edu_outlined,
      accentColor: MedievalColors.royalBlue,
      statDelta: StatDelta(intellect: 5, mood: 4),
      allowedStages: [LifeStage.oldAge],
    ),
    SemesterAction(
      id: 'sem_old_walks',
      title: 'Paseos Suaves de Vigor',
      description:
          'Caminatas matutinas por el valle para conservar movilidad y fuerza.',
      icon: Icons.directions_walk_rounded,
      accentColor: MedievalColors.amberOchre,
      statDelta: StatDelta(health: 5, strength: 2),
      allowedStages: [LifeStage.oldAge],
    ),
    SemesterAction(
      id: 'sem_old_mentor',
      title: 'Aconsejar a los Jóvenes',
      description:
          'Compartes tu experiencia con aprendices y recibes su gratitud.',
      icon: Icons.psychology_alt_outlined,
      accentColor: MedievalColors.plumEmpathy,
      statDelta: StatDelta(emotionalIntelligence: 5, mood: 5),
      copperDelta: 100,
      allowedStages: [LifeStage.oldAge],
    ),
    SemesterAction(
      id: 'sem_old_forms',
      title: 'Mantener Formas Marciales Suaves',
      description:
          'Repasas posturas tranquilas de esgrima para no oxidar los reflejos.',
      icon: Icons.sports_martial_arts_rounded,
      accentColor: MedievalColors.crimsonSeal,
      statDelta: StatDelta(combatSkill: 3, health: 2),
      allowedStages: [LifeStage.oldAge],
    ),
    SemesterAction(
      id: 'sem_old_rest',
      title: 'Descanso Reparador',
      description:
          'Disfrutas de calma absoluta junto al hogar recuperando salud y ánimo.',
      icon: Icons.spa_outlined,
      accentColor: MedievalColors.forestGreen,
      statDelta: StatDelta(health: 8, mood: 7),
      allowedStages: [LifeStage.oldAge],
    ),
  ];

  static List<SemesterAction> forStage(LifeStage stage) {
    return all.where((a) => a.allowedStages.contains(stage)).toList();
  }
}

