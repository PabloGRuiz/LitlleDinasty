import 'dart:math';

import '../models/currency.dart';
import '../models/game_event.dart';
import '../models/game_state.dart';
import '../models/life_stage.dart';
import '../models/stats.dart';
import '../models/world_state.dart';

/// Definición de un hito de historia predefinido y obligatorio.
class StoryEventMilestone {
  const StoryEventMilestone({
    required this.id,
    required this.triggerAge,
    required this.stage,
    required this.title,
  });

  final String id;
  final int triggerAge;
  final LifeStage stage;
  final String title;
}

/// Catálogo de eventos canónicos que SIEMPRE ocurren en la historia del jugador.
/// Sus opciones moldean el destino, ruta y ubicación sin probabilidad de fallo.
class StoryEventsCatalog {
  StoryEventsCatalog._();

  static const String priestVisitId = 'story_age6_priest_visit';
  static const String schoolEnrollmentId = 'story_age7_school_enrollment';
  static const String primaryDevelopmentId = 'story_age10_primary_development';
  static const String demonOmenId = 'story_age12_demon_omen';
  static const String leaveVillageId = 'story_age15_leave_village';
  static const String heroesSummonsId = 'story_age22_heroes_summons';
  static const String demonAwakeningId = 'story_age35_demon_awakening';
  static const String newEraId = 'story_age55_new_era';

  static const List<StoryEventMilestone> all = [
    StoryEventMilestone(
      id: priestVisitId,
      triggerAge: 6,
      stage: LifeStage.childhood,
      title: 'La Visita del Sacerdote del Templo',
    ),
    StoryEventMilestone(
      id: schoolEnrollmentId,
      triggerAge: 7,
      stage: LifeStage.childhood,
      title: 'La Escuela de la Aldea',
    ),
    StoryEventMilestone(
      id: primaryDevelopmentId,
      triggerAge: 10,
      stage: LifeStage.childhood,
      title: 'Culminación del Desarrollo Primario',
    ),
    StoryEventMilestone(
      id: demonOmenId,
      triggerAge: 12,
      stage: LifeStage.adolescence,
      title: 'El Presagio del Sello Agrietado',
    ),
    StoryEventMilestone(
      id: leaveVillageId,
      triggerAge: 15,
      stage: LifeStage.adolescence,
      title: 'La Encrucijada del Destino',
    ),
    StoryEventMilestone(
      id: heroesSummonsId,
      triggerAge: 22,
      stage: LifeStage.youth,
      title: 'Convocatoria del Grupo de Héroes',
    ),
    StoryEventMilestone(
      id: demonAwakeningId,
      triggerAge: 35,
      stage: LifeStage.adulthood,
      title: 'El Despertar del Rey Demonio',
    ),
    StoryEventMilestone(
      id: newEraId,
      triggerAge: 55,
      stage: LifeStage.adulthood,
      title: 'Alba de una Nueva Era',
    ),
  ];

  /// Devuelve el próximo hito obligatorio pendiente según la edad actual.
  static ActiveGameEvent? nextPendingEvent(GameState state, Random rng) {
    final hero = state.hero;
    if (!hero.isAlive || state.isGameOver) return null;

    final completed = state.worldState.completedStoryEventIds;

    for (final milestone in all) {
      if (hero.age < milestone.triggerAge || completed.contains(milestone.id)) {
        continue;
      }

      switch (milestone.id) {
        case priestVisitId:
          return _buildPriestVisitEvent(state, rng);
        case schoolEnrollmentId:
          return _buildSchoolEnrollmentEvent(state);
        case primaryDevelopmentId:
          return _buildPrimaryDevelopmentEvent(state);
        case demonOmenId:
          return _buildDemonOmenEvent(state);
        case leaveVillageId:
          return _buildLeaveVillageEvent(state);
        case heroesSummonsId:
          return _buildHeroesSummonsEvent(state);
        case demonAwakeningId:
          return _buildDemonAwakeningEvent(state);
        case newEraId:
          return _buildNewEraEvent(state);
      }
    }

    return null;
  }

  static ActiveGameEvent _buildSchoolEnrollmentEvent(GameState state) {
    final fam = state.familyState;
    final savings = fam.savingsCurrency.formatCompact();
    final netWithSchool = fam.monthlyIncomeCopper -
        (fam.heroUpkeepCopper +
            fam.schoolCostCopper +
            fam.dependentSiblingsCount * fam.siblingUpkeepCopper);

    return ActiveGameEvent(
      eventId: schoolEnrollmentId,
      stage: LifeStage.childhood,
      title: 'La Escuela de la Aldea',
      isStoryEvent: true,
      npcName: 'Maestro Corwin',
      narrative:
          'Al cumplir los 7 años, el maestro local abre las inscripciones de la escuela de ${state.hero.villageName} para aprender lectura, historia y cálculo formal.\n\n'
          'Economía familiar actual: ahorros $savings · Ingreso padres +20P/mes · Tu mantención -5P/mes · Hermanos -${fam.dependentSiblingsCount * 5}P/mes. '
          'La matrícula escolar cuesta 15 Plata/mes (balance si asistes: ${RpgCurrency.formatDelta(netWithSchool)}/mes).',
      choices: const [
        EventChoice(
          id: 'enroll_school',
          label: 'Inscribirte en la escuela (15 Plata/mes)',
          isDestinyChoice: true,
          destinyPreview:
              'Asistes a la escuela · Ganas Intelecto y Conocimientos · Gasto familiar +15P/mes',
          setsEnrolledInSchool: true,
          addsFlag: 'attended_school',
          successOutcome: EventOutcome(
            description:
                'Tus padres ajustan el cinturón con orgullo para que recibas educación formal.',
          ),
        ),
        EventChoice(
          id: 'decline_school_save',
          label: 'Estudiar por tu cuenta y cuidar los ahorros familiares',
          isDestinyChoice: true,
          destinyPreview:
              'No pagas escuela · La familia mantiene mayor margen de ahorro',
          setsEnrolledInSchool: false,
          successOutcome: EventOutcome(
            description:
                'Decides aprender observando y preguntando en la aldea para no exigir de más al hogar.',
          ),
        ),
      ],
    );
  }

  static ActiveGameEvent _buildPrimaryDevelopmentEvent(GameState state) {
    final s = state.hero.stats;
    final caps = StatCaps.fromPrimaryDevelopment(s);

    return ActiveGameEvent(
      eventId: primaryDevelopmentId,
      stage: LifeStage.childhood,
      title: 'Culminación del Desarrollo Primario',
      isStoryEvent: true,
      triggersPrimaryDevelopment: true,
      npcName: 'Voz Interior',
      narrative:
          'Al cumplir 10 años, tu cuerpo y espíritu cierran su desarrollo primario. Inteligencia Emocional, Salud, Intelecto y Ánimo mantienen tope 100, mientras se desbloquean Fortaleza, Poder Mágico y Conocimientos con nuevos límites exponenciales:\n'
          '• Combate y Fortaleza: hasta ${formatStatNumber(caps.combatSkill)}\n'
          '• Conocimientos: hasta ${formatStatNumber(caps.knowledge)}\n'
          '• Poder Mágico: hasta ${formatStatNumber(caps.magicPower)}\n'
          '• Fuerza: ${formatStatNumber(caps.strength)} · Maná: ${formatStatNumber(caps.mana)}',
      choices: const [
        EventChoice(
          id: 'focus_martial_potential',
          label: 'Enfocar tu crecimiento hacia la Senda Marcial y la Fortaleza',
          isDestinyChoice: true,
          destinyPreview:
              'Desbloqueas Fortaleza, Poder Mágico y Conocimientos con límites exponenciales',
          addsFlag: 'focus_martial_potential',
          successOutcome: EventOutcome(
            description:
                'Sientes cómo tu cuerpo supera las barreras infantiles para forjar una fuerza y resistencia extraordinarias.',
          ),
        ),
        EventChoice(
          id: 'focus_arcane_potential',
          label: 'Enfocar tu crecimiento hacia el Poder Mágico y el Maná',
          isDestinyChoice: true,
          destinyPreview:
              'Desbloqueas Fortaleza, Poder Mágico y Conocimientos con límites exponenciales',
          addsFlag: 'focus_arcane_potential',
          successOutcome: EventOutcome(
            description:
                'Tu núcleo de maná se expande trazando un potencial arcano inmenso.',
          ),
        ),
        EventChoice(
          id: 'focus_scholarly_potential',
          label: 'Enfocar tu crecimiento hacia los Conocimientos y el Saber',
          isDestinyChoice: true,
          destinyPreview:
              'Desbloqueas Fortaleza, Poder Mágico y Conocimientos con límites exponenciales',
          addsFlag: 'focus_scholarly_potential',
          successOutcome: EventOutcome(
            description:
                'Tu memoria de dos vidas se ordena abriendo un horizonte vastísimo de conocimientos.',
          ),
        ),
      ],
    );
  }

  /// Evento de presión económica cuando los gastos familiares son negativos.
  static ActiveGameEvent buildChildLaborPressureEvent(GameState state) {
    final fam = state.familyState;
    return ActiveGameEvent(
      eventId: 'family_economy_pressure_${state.year}_${state.month}',
      stage: state.hero.lifeStage,
      title: 'Aprietos Económicos en el Hogar',
      npcName: state.hero.fatherName,
      narrative:
          'Los gastos del hogar (${RpgCurrency(fam.monthlyExpensesCopper).formatCompact()}/mes) superan los ingresos (${RpgCurrency(fam.monthlyIncomeCopper).formatCompact()}/mes) y los ahorros están en ${fam.savingsCurrency.formatCompact()}. ${state.hero.fatherName} te mira preocupado hablando de buscar un jornal para ayudar en casa.',
      choices: [
        const EventChoice(
          id: 'accept_child_work',
          label: 'Ir a trabajar a temprana edad (+8 Plata/mes, dejas la escuela)',
          setsChildWorker: true,
          setsEnrolledInSchool: false,
          successOutcome: EventOutcome(
            description:
                'Comienzas a trabajar acarreando sacos y recados para aliviar la mesa familiar.',
            statDelta: StatDelta(strength: 4, mood: -3),
          ),
        ),
        if (fam.isEnrolledInSchool)
          const EventChoice(
            id: 'work_and_keep_school',
            label: 'Trabajar medio turno sin dejar la escuela (+8 Plata/mes)',
            statCheck: StatCheck(stat: StatType.health, requiredScore: 68),
            setsChildWorker: true,
            setsEnrolledInSchool: true,
            successOutcome: EventOutcome(
              description:
                  'A base de esfuerzo sobrehumano logras trabajar y seguir estudiando.',
              statDelta: StatDelta(strength: 3, emotionalIntelligence: 3, mood: -4),
            ),
            failureOutcome: EventOutcome(
              description:
                  'El cansancio doble pasa factura a tu salud y rendimiento.',
              statDelta: StatDelta(health: -10, mood: -7),
            ),
          ),
        if (fam.familySavingsCopper >= 3000)
          const EventChoice(
            id: 'convince_hold_savings',
            label: 'Pedir a tus padres aguantar un poco más usando los ahorros',
            statCheck: StatCheck(
              stat: StatType.emotionalIntelligence,
              requiredScore: 34,
            ),
            successOutcome: EventOutcome(
              description:
                  'Tus padres acceden a sostener la situación unos meses más con los ahorros.',
              statDelta: StatDelta(emotionalIntelligence: 3, mood: 2),
            ),
            failureOutcome: EventOutcome(
              description:
                  'Los números mandan: al final te toca empezar a trabajar.',
              statDelta: StatDelta(mood: -5),
              // Nota: el usuario igual puede ajustar o queda sin cambio forzoso.
            ),
          ),
      ],
    );
  }

  static ActiveGameEvent _buildPriestVisitEvent(GameState state, Random rng) {
    final roll = rng.nextInt(100);
    final int manaRolled;
    final String affinityTitle;
    if (roll < 25) {
      manaRolled = 10 + rng.nextInt(11); // 10..20
      affinityTitle = 'Chispa Tenue';
    } else if (roll < 65) {
      manaRolled = 26 + rng.nextInt(17); // 26..42
      affinityTitle = 'Afinidad Común';
    } else if (roll < 90) {
      manaRolled = 48 + rng.nextInt(21); // 48..68
      affinityTitle = 'Talento Notable';
    } else {
      manaRolled = 74 + rng.nextInt(19); // 74..92
      affinityTitle = 'Don Prodigioso';
    }

    return ActiveGameEvent(
      eventId: priestVisitId,
      stage: LifeStage.childhood,
      title: 'La Visita del Sacerdote del Templo',
      isStoryEvent: true,
      awakenedManaValue: manaRolled,
      npcName: 'Padre Anselm',
      narrative:
          'Cumplidos tus 6 años, un sacerdote de túnica alba llega a la casa de ${state.hero.villageName} portando un cristal de maná. Al apoyar tus manos, la gema destella revelando "$affinityTitle" ($manaRolled de Maná). Se despierta en ti una nueva estadística: Maná.',
      choices: const [
        EventChoice(
          id: 'embrace_arcane_path',
          label: 'Jurar que estudiarás los secretos de la magia',
          isDestinyChoice: true,
          destinyPreview:
              'Despiertas Maná · Ruta: Senda Arcana · El templo te recuerda',
          setsRoute: StoryRoute.arcanePath,
          addsFlag: 'embraced_magic',
          successOutcome: EventOutcome(
            description:
                'El sacerdote anota tu nombre en el registro arcano y te bendice antes de partir.',
          ),
        ),
        EventChoice(
          id: 'humble_family_awakening',
          label: 'Aceptarlo con serenidad y permanecer junto a tus padres',
          isDestinyChoice: true,
          destinyPreview:
              'Despiertas Maná · Tu vida en la aldea sigue sin ataduras',
          addsFlag: 'humble_awakening',
          successOutcome: EventOutcome(
            description:
                'Agradeces la ceremonia y guardas la sensación mágica en tu interior.',
          ),
        ),
        EventChoice(
          id: 'hide_true_spark',
          label: 'Disimular la intensidad de tu don para evitar miradas',
          isDestinyChoice: true,
          destinyPreview:
              'Despiertas Maná · Mantienes en secreto tu verdadero potencial',
          addsFlag: 'hidden_talent',
          successOutcome: EventOutcome(
            description:
                'El sacerdote concluye la prueba sin sospechar de tus recuerdos de otro mundo.',
          ),
        ),
      ],
    );
  }

  static ActiveGameEvent _buildDemonOmenEvent(GameState state) {
    return ActiveGameEvent(
      eventId: demonOmenId,
      stage: LifeStage.adolescence,
      title: 'El Presagio del Sello Agrietado',
      isStoryEvent: true,
      npcName: 'Heraldo Real',
      narrative:
          'Una aurora carmesí cruza el cielo sobre ${state.hero.villageName}. Un heraldo real anuncia que el sello antiguo del Rey Demonio empieza a resquebrajarse y todos los reinos buscan futuros campeones y aventureros.',
      choices: const [
        EventChoice(
          id: 'swear_against_demon',
          label: 'Prometer que algún día enfrentarás esa amenaza',
          isDestinyChoice: true,
          destinyPreview:
              'Marca tu destino: Juramento contra el Rey Demonio',
          setsRoute: StoryRoute.heroCandidate,
          addsFlag: 'sworn_against_demon',
          successOutcome: EventOutcome(
            description:
                'El cielo escarlata queda grabado en tu memoria como el inicio de tu gesta.',
          ),
        ),
        EventChoice(
          id: 'seek_hidden_truth',
          label: 'Decidir investigar qué esconde realmente la leyenda',
          isDestinyChoice: true,
          destinyPreview:
              'Marca tu destino: Buscador de la Verdad del Sello',
          addsFlag: 'legend_seeker',
          successOutcome: EventOutcome(
            description:
                'Observas con ojo crítico el cielo mientras planeas descubrir los secretos de este mundo.',
          ),
        ),
        EventChoice(
          id: 'protect_local_home',
          label: 'Priorizar la seguridad de tu aldea antes que las guerras reales',
          isDestinyChoice: true,
          destinyPreview: 'Ruta: Guardián del Hogar',
          setsRoute: StoryRoute.villageGuardian,
          addsFlag: 'village_protector',
          successOutcome: EventOutcome(
            description:
                'Decides que nadie dañará a quienes te criaron en este valle.',
          ),
        ),
      ],
    );
  }

  static ActiveGameEvent _buildLeaveVillageEvent(GameState state) {
    final hero = state.hero;
    final canGoArcane =
        hero.stats.mana >= 35 || state.worldState.storyFlags.contains('embraced_magic');

    return ActiveGameEvent(
      eventId: leaveVillageId,
      stage: LifeStage.adolescence,
      title: 'La Encrucijada del Destino',
      isStoryEvent: true,
      npcName: 'Maestre de Caravana',
      narrative:
          'A los 15 años ya tienes edad para recorrer el mundo y optar al Gremio de Aventureros. Una caravana mercante y reclutadores reales pasan por ${hero.villageName}. ¿Partirás de tu pueblo natal o echarás raíces aquí?',
      choices: [
        const EventChoice(
          id: 'depart_to_capital',
          label: 'Dejar el pueblo y partir hacia la Capital Real',
          isDestinyChoice: true,
          destinyPreview:
              'Dejas tu aldea natal · Ubicación: Capital Real · Ruta: Aspirante a Héroe',
          setsLocation: WorldLocation.royalCapital,
          setsRoute: StoryRoute.heroCandidate,
          addsFlag: 'left_village',
          successOutcome: EventOutcome(
            description:
                'Te despides de tus padres al alba y marchas hacia las grandes murallas de la Capital Real.',
          ),
        ),
        if (canGoArcane)
          const EventChoice(
            id: 'depart_to_arcane_tower',
            label: 'Viajar a la Torre Arcana para dominar tu maná',
            isDestinyChoice: true,
            destinyPreview:
                'Dejas tu aldea natal · Ubicación: Torre Arcana · Ruta: Senda Arcana',
            setsLocation: WorldLocation.arcaneTower,
            setsRoute: StoryRoute.arcanePath,
            addsFlag: 'left_village',
            successOutcome: EventOutcome(
              description:
                  'Sigues el llamado del maná hacia los chapiteles cristalinos de la Torre Arcana.',
            ),
          )
        else
          const EventChoice(
            id: 'depart_to_border_town',
            label: 'Emprender viaje libre hacia la Villa Fronteriza',
            isDestinyChoice: true,
            destinyPreview:
                'Dejas tu aldea natal · Ubicación: Villa Fronteriza · Ruta: Viajero Libre',
            setsLocation: WorldLocation.borderTown,
            setsRoute: StoryRoute.freeWanderer,
            addsFlag: 'left_village',
            successOutcome: EventOutcome(
              description:
                  'Con tu mochila al hombro, dejas el valle natal rumbo a la bulliciosa frontera.',
            ),
          ),
        const EventChoice(
          id: 'stay_in_home_village',
          label: 'Quedarte en tu aldea natal junto a tu familia',
          isDestinyChoice: true,
          destinyPreview:
              'Permaneces en tu aldea (podrás viajar luego desde Mundo) · Ruta: Guardián del Hogar',
          setsLocation: WorldLocation.homeVillage,
          setsRoute: StoryRoute.villageGuardian,
          addsFlag: 'stayed_at_fifteen',
          successOutcome: EventOutcome(
            description:
                'Eliges permanecer en tu valle natal, aunque los caminos del mundo quedan abiertos para ti.',
          ),
        ),
      ],
    );
  }

  static ActiveGameEvent _buildHeroesSummonsEvent(GameState state) {
    return ActiveGameEvent(
      eventId: heroesSummonsId,
      stage: LifeStage.youth,
      title: 'Convocatoria del Grupo de Héroes',
      isStoryEvent: true,
      npcName: 'Comandante Real',
      narrative:
          'Los reinos aliados emiten el edicto oficial: se busca formar el Grupo de Héroes antes de que el sello del Rey Demonio termine de romperse. Estás ante el estandarte de reclutamiento.',
      choices: const [
        EventChoice(
          id: 'answer_hero_summons',
          label: 'Inscribirte en las filas de los aspirantes a Héroe',
          isDestinyChoice: true,
          destinyPreview:
              'Ubicación: Capital Real · Bandera: Enlistado en la Convocatoria',
          setsLocation: WorldLocation.royalCapital,
          setsRoute: StoryRoute.heroCandidate,
          addsFlag: 'joined_hero_party',
          successOutcome: EventOutcome(
            description:
                'Tu nombre queda sellado entre los elegidos que entrenarán frente a la crisis venidera.',
          ),
        ),
        EventChoice(
          id: 'support_from_frontier',
          label: 'Operar como aliado independiente en las fronteras',
          isDestinyChoice: true,
          destinyPreview:
              'Ubicación: Villa Fronteriza · Bandera: Aliado de Frontera',
          setsLocation: WorldLocation.borderTown,
          addsFlag: 'frontier_ally',
          successOutcome: EventOutcome(
            description:
                'Evitas las intrigas cortesanas para defender directamente las rutas amenazadas.',
          ),
        ),
        EventChoice(
          id: 'walk_own_way',
          label: 'Rechazar la convocatoria y seguir tu propio camino',
          isDestinyChoice: true,
          destinyPreview: 'Ruta: Viajero Libre · Independencia absoluta',
          setsRoute: StoryRoute.freeWanderer,
          addsFlag: 'independent_soul',
          successOutcome: EventOutcome(
            description:
                'No atas tu destino a ningún rey; vivirás bajo tus propias reglas.',
          ),
        ),
      ],
    );
  }

  static ActiveGameEvent _buildDemonAwakeningEvent(GameState state) {
    return ActiveGameEvent(
      eventId: demonAwakeningId,
      stage: LifeStage.adulthood,
      title: 'El Despertar del Rey Demonio',
      isStoryEvent: true,
      npcName: 'General del Reino',
      narrative:
          'Un estruendo resuena más allá de las cordilleras: el Rey Demonio ha despertado y ejércitos de criaturas oscuras avanzan desde el Abismo. El Grupo de Héroes parte hacia el frente.',
      choices: const [
        EventChoice(
          id: 'march_to_demon_frontier',
          label: 'Marchar a la Frontera del Abismo junto a la vanguardia',
          isDestinyChoice: true,
          destinyPreview:
              'Ubicación: Frontera del Abismo · Bandera: Veterano del Frente Demoníaco',
          setsLocation: WorldLocation.demonFrontier,
          addsFlag: 'fought_demon_king',
          successOutcome: EventOutcome(
            description:
                'Cruzas hacia tierras cenicientas para plantar cara a la marea oscura.',
          ),
        ),
        EventChoice(
          id: 'command_arcane_defense',
          label: 'Reforzar las barreras mágicas y logística desde la retaguardia',
          isDestinyChoice: true,
          destinyPreview:
              'Bandera: Estratega de la Gran Guerra · Sin cambio de ubicación',
          addsFlag: 'war_strategist',
          successOutcome: EventOutcome(
            description:
                'Tu conocimiento sostiene las líneas de suministro y los escudos de los reinos.',
          ),
        ),
        EventChoice(
          id: 'shield_civilians',
          label: 'Proteger los pueblos y refugiados lejos del frente',
          isDestinyChoice: true,
          destinyPreview:
              'Bandera: Escudo de los Inocentes · Proteges la población civil',
          addsFlag: 'protector_of_weak',
          successOutcome: EventOutcome(
            description:
                'Mientras los campeones chocan en el Abismo, salvas incontables aldeas de los saqueos.',
          ),
        ),
      ],
    );
  }

  static ActiveGameEvent _buildNewEraEvent(GameState state) {
    return ActiveGameEvent(
      eventId: newEraId,
      stage: LifeStage.adulthood,
      title: 'Alba de una Nueva Era',
      isStoryEvent: true,
      npcName: 'Cronista Real',
      narrative:
          'Tras dos décadas de conflicto, el poder del Rey Demonio se ha quebrado gracias al sacrificio de los héroes y los reinos. La paz vuelve al continente. ¿Dónde cerrarás este capítulo de tu vida?',
      choices: const [
        EventChoice(
          id: 'return_to_village_peace',
          label: 'Regresar a tu aldea natal a vivir en serenidad',
          isDestinyChoice: true,
          destinyPreview:
              'Ubicación: Aldea natal · Era: Alba de una Nueva Era',
          setsLocation: WorldLocation.homeVillage,
          addsFlag: 'new_dawn_era',
          successOutcome: EventOutcome(
            description:
                'Vuelves por el mismo sendero que te vio nacer, llevando contigo un mundo de recuerdos.',
          ),
        ),
        EventChoice(
          id: 'stay_as_living_legend',
          label: 'Permanecer en la Capital Real como figura respetada',
          isDestinyChoice: true,
          destinyPreview:
              'Ubicación: Capital Real · Era: Alba de una Nueva Era',
          setsLocation: WorldLocation.royalCapital,
          addsFlag: 'new_dawn_era',
          successOutcome: EventOutcome(
            description:
                'Tu nombre pasa a formar parte de las crónicas de reconstrucción del reino.',
          ),
        ),
        EventChoice(
          id: 'retire_to_arcane_archives',
          label: 'Consagrar tu madurez a los archivos de la Torre Arcana',
          isDestinyChoice: true,
          destinyPreview:
              'Ubicación: Torre Arcana · Era: Alba de una Nueva Era',
          setsLocation: WorldLocation.arcaneTower,
          addsFlag: 'new_dawn_era',
          successOutcome: EventOutcome(
            description:
                'Preservas el saber mágico de dos mundos para las generaciones futuras.',
          ),
        ),
      ],
    );
  }
}
