import 'dart:math';

import '../models/character.dart';
import '../models/game_event.dart';
import '../models/life_stage.dart';
import '../models/stats.dart';
import 'medieval_names.dart';

/// Catálogo de 30 eventos medievales (5 por cada una de las 6 etapas vitales).
class EventsCatalog {
  EventsCatalog._();

  static final List<GameEventDefinition> all = [
    // =========================================================================
    // 1. INFANCIA TEMPRANA (0–3 años) — 5 eventos
    // =========================================================================
    GameEventDefinition(
      id: 'early_spark_other_world',
      stage: LifeStage.earlyChildhood,
      title: 'Chispa de Otra Vida',
      narrativeBuilder: (hero, _) =>
          'Recostado en la cuna de madera en ${hero.villageName}, recuerdas fragmentos de tu vida pasada mientras ${hero.motherName} tararea una canción de cuna.',
      choices: const [
        EventChoice(
          id: 'calm_mind',
          label: 'Asimilar el renacimiento en silencio',
          statCheck: StatCheck(
            stat: StatType.emotionalIntelligence,
            requiredScore: 22,
          ),
          successOutcome: EventOutcome(
            description: 'Aceptas tu nuevo destino con sorprendente madurez para un bebé.',
            statDelta: StatDelta(emotionalIntelligence: 6, mood: 5),
          ),
          failureOutcome: EventOutcome(
            description: 'El desconcierto te agobia un poco, aunque el calor del hogar te calma.',
            statDelta: StatDelta(emotionalIntelligence: 2, mood: -4),
          ),
        ),
        EventChoice(
          id: 'observe_surroundings',
          label: 'Escuchar con atención cada palabra de tus padres',
          successOutcome: EventOutcome(
            description: 'Empiezas a descifrar el dialecto de la aldea desde muy temprana edad.',
            statDelta: StatDelta(intellect: 5, emotionalIntelligence: 2),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'early_first_steps',
      stage: LifeStage.earlyChildhood,
      title: 'Primeros Pasos en la Tierra',
      narrativeBuilder: (hero, _) =>
          'En el patio de tierra apisonada, ${hero.fatherName} extiende los brazos animándote a caminar hasta él sin caer.',
      choices: const [
        EventChoice(
          id: 'bold_stride',
          label: 'Intentar correr con decisión',
          statCheck: StatCheck(stat: StatType.strength, requiredScore: 12),
          successOutcome: EventOutcome(
            description:
                'Mantienes el equilibrio y llegas riendo a sus brazos.',
            statDelta: StatDelta(strength: 5, health: 3, mood: 6),
          ),
          failureOutcome: EventOutcome(
            description: 'Tropezaste con una piedrecilla, pero aprendiste a levantarte solo.',
            statDelta: StatDelta(strength: 2, health: -3, mood: -2),
          ),
        ),
        EventChoice(
          id: 'careful_balance',
          label: 'Avanzar paso a paso con cautela',
          successOutcome: EventOutcome(
            description: 'Caminas firme y observador bajo la mirada orgullosa de tus padres.',
            statDelta: StatDelta(strength: 3, emotionalIntelligence: 3),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'early_cabin_frost',
      stage: LifeStage.earlyChildhood,
      title: 'Helada en la Cabaña',
      narrativeBuilder: (hero, _) =>
          'Una nevada temprana cubre los tejados de ${hero.villageName}. El viento se cuela por las rendijas mientras la leña escasea.',
      choices: const [
        EventChoice(
          id: 'endure_cold',
          label: 'Respirar hondo y resistir el frío bajo la manta',
          statCheck: StatCheck(stat: StatType.health, requiredScore: 65),
          successOutcome: EventOutcome(
            description:
                'Tu cuerpo pequeño se adapta al invierno sin contraer fiebres.',
            statDelta: StatDelta(health: 4, strength: 2),
          ),
          failureOutcome: EventOutcome(
            description:
                'El relente nocturno te provoca un resfriado pasajero.',
            statDelta: StatDelta(health: -8, mood: -5),
          ),
        ),
        EventChoice(
          id: 'cry_for_warmth',
          label: 'Acurrucarte junto al fuego y pedir abrigo',
          successOutcome: EventOutcome(
            description:
                '${'Tus padres'} avivan las brasas y te envuelven en pieles de oveja.',
            statDelta: StatDelta(health: 2, mood: 4),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'early_wooden_blocks',
      stage: LifeStage.earlyChildhood,
      title: 'Bloques de Madera Tallada',
      narrativeBuilder: (hero, _) =>
          '${hero.fatherName} te regala piezas de madera sobrantes del taller con formas de torres, puentes y animales.',
      choices: const [
        EventChoice(
          id: 'build_fortress',
          label: 'Construir una muralla compleja',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 26),
          successOutcome: EventOutcome(
            description: 'Alineas contrapesos sorprendentes; tus padres murmuran que eres prodigioso.',
            statDelta: StatDelta(intellect: 6, mood: 5),
          ),
          failureOutcome: EventOutcome(
            description: 'La torre se derrumba una y otra vez, pero estimula tu ingenio.',
            statDelta: StatDelta(intellect: 3, mood: -2),
          ),
        ),
        EventChoice(
          id: 'play_with_mother',
          label: 'Inventar historias con ${'las figuras'}',
          successOutcome: EventOutcome(
            description:
                'Compartir el juego fortalece tu vínculo afectivo y empatía.',
            statDelta: StatDelta(emotionalIntelligence: 5, mood: 5),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'early_watchdog',
      stage: LifeStage.earlyChildhood,
      title: 'El Perro Guardián del Patio',
      narrativeBuilder: (_, _) => 'Un mastín viejo y peludo de la granja vecina se acerca olfateando la puerta. Es tan grande como un ternero.',
      choices: const [
        EventChoice(
          id: 'befriend_hound',
          label: 'Acariciarle el hocico sin miedo',
          statCheck: StatCheck(
            stat: StatType.emotionalIntelligence,
            requiredScore: 25,
          ),
          successOutcome: EventOutcome(
            description: 'El perro mueve la cola y se tumba a protegerte; encuentras una moneda bajo su pata.',
            statDelta: StatDelta(emotionalIntelligence: 5, mood: 6),
            copperDelta: 8,
          ),
          failureOutcome: EventOutcome(
            description:
                'Un ladrido grave te asusta y sales gateando hacia la cocina.',
            statDelta: StatDelta(mood: -6, combatSkill: 1),
          ),
        ),
        EventChoice(
          id: 'brandish_spoon',
          label: 'Agitar una cuchara de madera como espada',
          successOutcome: EventOutcome(
            description: 'El animal retrocede intrigado; despiertas un pequeño instinto marcial.',
            statDelta: StatDelta(combatSkill: 4, strength: 2),
          ),
        ),
      ],
    ),

    // =========================================================================
    // 2. NIÑEZ (4–11 años) — 5 eventos
    // =========================================================================
    GameEventDefinition(
      id: 'child_wooden_swords',
      stage: LifeStage.childhood,
      title: 'Espadas de Rama en la Plaza',
      narrativeBuilder: (_, npc) =>
          'Los chicos mayores de la aldea, encabezados por $npc, juegan a ser caballeros con ramas de roble junto al pilón.',
      choices: const [
        EventChoice(
          id: 'duel_wooden_sword',
          label: 'Aceptar un duelo amistoso',
          statCheck: StatCheck(stat: StatType.combatSkill, requiredScore: 15),
          successOutcome: EventOutcome(
            description: 'Usas reflejos de otra vida para desarmar a tu rival entre aplausos.',
            statDelta: StatDelta(combatSkill: 7, strength: 4, mood: 6),
            copperDelta: 12,
          ),
          failureOutcome: EventOutcome(
            description: 'Recibes varios golpes en los nudillos, pero tu postura mejora.',
            statDelta: StatDelta(combatSkill: 3, health: -5, mood: -3),
          ),
        ),
        EventChoice(
          id: 'act_as_referee',
          label: 'Organizar los equipos y reglas del torneo',
          successOutcome: EventOutcome(
            description:
                'Todos aceptan tu arbitraje y terminan el juego en armonía.',
            statDelta: StatDelta(emotionalIntelligence: 6, intellect: 3),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'child_mill_pouch',
      stage: LifeStage.childhood,
      title: 'La Bolsa Junto al Molino',
      narrativeBuilder: (_, npc) =>
          'Mientras recoges harina, encuentras una bolsita de cuero con monedas caída cerca del carro de $npc, el molinero.',
      choices: const [
        EventChoice(
          id: 'return_pouch',
          label: 'Devolver la bolsa íntegra al molinero',
          successOutcome: EventOutcome(
            description: 'Conmovido por tu honradez, te recompensa con monedas de cobre y pan dulce.',
            statDelta: StatDelta(emotionalIntelligence: 6, mood: 6),
            copperDelta: 25,
          ),
        ),
        EventChoice(
          id: 'keep_pouch_quietly',
          label: 'Esconderla en tu bolsillo sin decir nada',
          statCheck: StatCheck(
            stat: StatType.emotionalIntelligence,
            requiredScore: 30,
          ),
          successOutcome: EventOutcome(
            description: 'Nadie nota nada, aunque la culpa pesa ligeramente en tu ánimo.',
            statDelta: StatDelta(mood: -5),
            copperDelta: 65,
          ),
          failureOutcome: EventOutcome(
            description:
                'El aprendiz te vio recogerla; debes devolverla entre regaños.',
            statDelta: StatDelta(emotionalIntelligence: -4, mood: -8),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'child_herbalist_hut',
      stage: LifeStage.childhood,
      title: 'La Cabaña del Herbolario',
      narrativeBuilder: (_, npc) =>
          '$npc, el viejo boticario del bosque, busca un ayudante menudo que sepa distinguir raíces medicinales de hierbas venenosas.',
      choices: const [
        EventChoice(
          id: 'memorize_herbs',
          label: 'Estudiar su herbario manuscrito',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 30),
          successOutcome: EventOutcome(
            description: 'Clasificas manzanilla, valeriana y belladona sin un solo error.',
            statDelta: StatDelta(intellect: 7, health: 4),
            copperDelta: 35,
          ),
          failureOutcome: EventOutcome(
            description: 'Confundes dos tallos amargos y te pasas la tarde limpiando morteros.',
            statDelta: StatDelta(intellect: 2, mood: -4),
            copperDelta: 10,
          ),
        ),
        EventChoice(
          id: 'carry_baskets',
          label: 'Ayudar cargando cestos de leña y agua',
          successOutcome: EventOutcome(
            description: 'El trabajo físico curte tus hombros y te ganas una paga modesta.',
            statDelta: StatDelta(strength: 6, health: 3),
            copperDelta: 20,
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'child_swollen_stream',
      stage: LifeStage.childhood,
      title: 'Corriente Crecida en el Arroyo',
      narrativeBuilder: (_, npc) =>
          'Tras tres días de aguacero, un cordero de la familia de $npc queda atrapado en un islote del arroyo crecido.',
      choices: const [
        EventChoice(
          id: 'wade_into_stream',
          label: 'Cruzar el vado sujeto a una soga',
          statCheck: StatCheck(stat: StatType.strength, requiredScore: 22),
          successOutcome: EventOutcome(
            description: 'Sujetas al animal contra tu pecho y regresas a la orilla como un pequeño héroe.',
            statDelta: StatDelta(
              strength: 5,
              mood: 7,
              emotionalIntelligence: 3,
            ),
            copperDelta: 30,
          ),
          failureOutcome: EventOutcome(
            description: 'La corriente te arrastra unos metros antes de que te saquen tiritando.',
            statDelta: StatDelta(health: -10, mood: -6, strength: 2),
          ),
        ),
        EventChoice(
          id: 'build_plank_bridge',
          label: 'Improvisar un puente con tablones y piedras',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 32),
          successOutcome: EventOutcome(
            description: 'Apoyas una viga larga en dos rocas; el cordero cruza sano y salvo.',
            statDelta: StatDelta(intellect: 6, mood: 5),
            copperDelta: 30,
          ),
          failureOutcome: EventOutcome(
            description:
                'El tablón resbala al agua y deben buscar al pastor mayor.',
            statDelta: StatDelta(intellect: 2, mood: -4),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'child_well_bully',
      stage: LifeStage.childhood,
      title: 'El Abusón del Pozo',
      narrativeBuilder: (_, npc) =>
          'El fornido $npc bloquea el paso al pozo comunal exigiendo un peaje de canicas o monedas a los niños más pequeños.',
      choices: const [
        EventChoice(
          id: 'stand_your_ground',
          label: 'Plantarle cara con puños en alto',
          statCheck: StatCheck(stat: StatType.combatSkill, requiredScore: 18),
          successOutcome: EventOutcome(
            description: 'Con un rápido barrido lo haces sentar en el barro; ya no molesta a nadie.',
            statDelta: StatDelta(combatSkill: 6, strength: 4, mood: 6),
          ),
          failureOutcome: EventOutcome(
            description: 'Te derriba de un empujón, dejándote moretones pero más temple.',
            statDelta: StatDelta(health: -8, combatSkill: 3, mood: -5),
          ),
        ),
        EventChoice(
          id: 'talk_him_down',
          label: 'Conversar para descubrir por qué está furioso',
          statCheck: StatCheck(
            stat: StatType.emotionalIntelligence,
            requiredScore: 32,
          ),
          successOutcome: EventOutcome(
            description: 'Descubres que temía llegar tarde a casa; te lo ganas como aliado.',
            statDelta: StatDelta(emotionalIntelligence: 7, mood: 5),
          ),
          failureOutcome: EventOutcome(
            description: 'Se burla de tus palabras y te obliga a rodear por el otro sendero.',
            statDelta: StatDelta(mood: -5, emotionalIntelligence: 2),
          ),
        ),
      ],
    ),

    // =========================================================================
    // 3. ADOLESCENCIA (12–17 años) — 5 eventos
    // =========================================================================
    GameEventDefinition(
      id: 'adol_wolf_tracks',
      stage: LifeStage.adolescence,
      title: 'Huellas de Lobo en el Linde',
      narrativeBuilder: (hero, _) =>
          'Al caer la tarde cerca de los pinares de ${hero.villageName}, encuentras huellas frescas de una manada rondando el redil.',
      choices: const [
        EventChoice(
          id: 'track_with_spear',
          label: 'Vigilar el linde con una lanza de caza',
          statCheck: StatCheck(stat: StatType.combatSkill, requiredScore: 30),
          successOutcome: EventOutcome(
            description: 'Ahuyentas a un lobo explorador con un golpe certero y obtienes su piel.',
            statDelta: StatDelta(combatSkill: 8, strength: 4, mood: 5),
            copperDelta: 90,
          ),
          failureOutcome: EventOutcome(
            description: 'Un zarpazo roza tu brazo antes de que los perros de la aldea acudan.',
            statDelta: StatDelta(health: -12, combatSkill: 4, mood: -4),
          ),
        ),
        EventChoice(
          id: 'warn_watchmen',
          label: 'Alertar a los leñadores y encender antorchas',
          successOutcome: EventOutcome(
            description:
                'El fuego mantiene a la manada lejos del ganado toda la noche.',
            statDelta: StatDelta(intellect: 4, emotionalIntelligence: 3),
            copperDelta: 35,
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'adol_wandering_scribe',
      stage: LifeStage.adolescence,
      title: 'El Escriba Ambulante',
      narrativeBuilder: (_, npc) =>
          'El letrado $npc hace noche en la taberna local y ofrece enseñar caligrafía y aritmética a cambio de ayuda o unas monedas.',
      choices: const [
        EventChoice(
          id: 'pay_lessons',
          label: 'Pagar 50C por lecciones privadas nocturnas',
          minCopperRequired: 50,
          successOutcome: EventOutcome(
            description: 'Tu memoria adulta acelera el aprendizaje y dominas la pluma en días.',
            statDelta: StatDelta(intellect: 10, emotionalIntelligence: 3),
            copperDelta: -50,
          ),
        ),
        EventChoice(
          id: 'debate_logic',
          label: 'Debatir con él sobre historia y cálculo',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 38),
          successOutcome: EventOutcome(
            description: 'Impresionado por tu agudeza, te regala un códice y te paga por copiar cartas.',
            statDelta: StatDelta(intellect: 7, mood: 6),
            copperDelta: 80,
          ),
          failureOutcome: EventOutcome(
            description: 'Te corrige con severidad delante de los parroquianos, pero aprendes.',
            statDelta: StatDelta(intellect: 3, mood: -5),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'adol_harvest_tournament',
      stage: LifeStage.adolescence,
      title: 'Torneo de la Cosecha',
      narrativeBuilder: (hero, _) =>
          'En la fiesta de otoño de ${hero.villageName}, los jóvenes compiten levantando sacos de grano y luchando en el círculo de paja.',
      choices: const [
        EventChoice(
          id: 'enter_wrestling',
          label: 'Competir en la lucha del círculo',
          statCheck: StatCheck(stat: StatType.strength, requiredScore: 34),
          successOutcome: EventOutcome(
            description: 'Derribas a los finalistas y alzas la bolsa de premio de plata.',
            statDelta: StatDelta(strength: 7, combatSkill: 5, mood: 8),
            copperDelta: 150,
          ),
          failureOutcome: EventOutcome(
            description: 'Quedas en tercer lugar tras un combate duro que deja dolor muscular.',
            statDelta: StatDelta(strength: 4, health: -6, mood: -2),
            copperDelta: 40,
          ),
        ),
        EventChoice(
          id: 'rally_crowd',
          label: 'Animar a los participantes y ayudar en la organización',
          successOutcome: EventOutcome(
            description: 'Tu carisma hace brillar la fiesta y recibes un jornal del concejo.',
            statDelta: StatDelta(emotionalIntelligence: 6, mood: 6),
            copperDelta: 60,
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'adol_autumn_fever',
      stage: LifeStage.adolescence,
      title: 'Fiebre de Otoño en la Aldea',
      narrativeBuilder: (hero, _) =>
          'Una gripe severa azota ${hero.villageName}, dejando a varios vecinos postrados y con escasez de agua limpia.',
      choices: const [
        EventChoice(
          id: 'boil_water_care',
          label: 'Aplicar higiene moderna y hervir agua para todos',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 40),
          successOutcome: EventOutcome(
            description:
                'Frenas el contagio usando conocimientos de tu vida anterior.',
            statDelta: StatDelta(
              intellect: 6,
              health: 5,
              emotionalIntelligence: 5,
            ),
            copperDelta: 120,
          ),
          failureOutcome: EventOutcome(
            description:
                'Muchos dudan de tus métodos y acabas contagiándote levemente.',
            statDelta: StatDelta(health: -10, mood: -5, intellect: 2),
          ),
        ),
        EventChoice(
          id: 'stay_healthy_resist',
          label: 'Cuidar tu propia salud y la de tu hogar',
          statCheck: StatCheck(stat: StatType.health, requiredScore: 68),
          successOutcome: EventOutcome(
            description:
                'Sobrellevas el brote sin contratiempos y fortaleces tu vigor.',
            statDelta: StatDelta(health: 4, mood: 2),
          ),
          failureOutcome: EventOutcome(
            description:
                'Pasas una semana febril en cama antes de recuperarte.',
            statDelta: StatDelta(health: -12, strength: -3, mood: -6),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'adol_nostalgia',
      stage: LifeStage.adolescence,
      title: 'Nostalgia de Otro Mundo',
      narrativeBuilder: (_, _) => 'Bajo la lluvia nocturna, la dureza de la vida medieval te hace añorar las comodidades perdidas de tu antigua existencia.',
      choices: const [
        EventChoice(
          id: 'embrace_new_life',
          label: 'Transformar la nostalgia en propósito',
          statCheck: StatCheck(stat: StatType.mood, requiredScore: 55),
          successOutcome: EventOutcome(
            description: 'Aceptas este mundo como tuyo y sientes una determinación renovada.',
            statDelta: StatDelta(mood: 10, emotionalIntelligence: 6),
          ),
          failureOutcome: EventOutcome(
            description:
                'La melancolía persiste unos días, restándote energía.',
            statDelta: StatDelta(mood: -10, health: -3),
          ),
        ),
        EventChoice(
          id: 'train_through_rain',
          label: 'Despejar la mente entrenando bajo la lluvia',
          successOutcome: EventOutcome(
            description:
                'Cada flexión y estocada al aire disipa las dudas de tu pecho.',
            statDelta: StatDelta(strength: 5, combatSkill: 4, mood: 3),
          ),
        ),
      ],
    ),

    // =========================================================================
    // 4. JUVENTUD (18–34 años) — 5 eventos
    // =========================================================================
    GameEventDefinition(
      id: 'youth_road_ambush',
      stage: LifeStage.youth,
      title: 'Emboscada en el Camino Real',
      narrativeBuilder: (_, npc) =>
          'Mientras escoltas un carro hacia el mercado comarcal junto a $npc, tres bandidos salen de entre los matorrales.',
      choices: const [
        EventChoice(
          id: 'fight_bandits',
          label: 'Desenvainar el arma y cargar contra el líder',
          statCheck: StatCheck(stat: StatType.combatSkill, requiredScore: 48),
          successOutcome: EventOutcome(
            description: 'Desarmas al cabecilla y los demás huyen dejando parte de su botín.',
            statDelta: StatDelta(combatSkill: 9, strength: 4, mood: 6),
            copperDelta: 350, // 3P 50C
          ),
          failureOutcome: EventOutcome(
            description: 'Recibes una herida en el costado y debes entregar parte de la bolsa.',
            statDelta: StatDelta(health: -16, combatSkill: 3, mood: -8),
            copperDelta: -120,
          ),
        ),
        EventChoice(
          id: 'bluff_patrol',
          label: 'Fingir que una patrulla del señor feudal viene detrás',
          statCheck: StatCheck(
            stat: StatType.emotionalIntelligence,
            requiredScore: 46,
          ),
          successOutcome: EventOutcome(
            description:
                'Tu aplomo los convence y se retiran al bosque sin luchar.',
            statDelta: StatDelta(emotionalIntelligence: 7, intellect: 4),
            copperDelta: 120,
          ),
          failureOutcome: EventOutcome(
            description:
                'No te creen y cobran un peaje forzoso para dejarte seguir.',
            statDelta: StatDelta(mood: -6),
            copperDelta: -100,
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'youth_broken_bridge',
      stage: LifeStage.youth,
      title: 'El Puente Quebrado',
      narrativeBuilder: (_, npc) =>
          'El puente de piedra sobre el desfiladero cedió tras un desprendimiento. El mercader $npc ofrece plata a quien logre restablecer el paso.',
      choices: const [
        EventChoice(
          id: 'design_truss',
          label: 'Diseñar una estructura de celosía con vigas',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 52),
          successOutcome: EventOutcome(
            description: 'Tu diseño moderno soporta carros cargados; el mercader paga con creces.',
            statDelta: StatDelta(intellect: 9, mood: 7),
            copperDelta: 450,
          ),
          failureOutcome: EventOutcome(
            description: 'Los cálculos improvisados fallan y solo sirve para paso a pie.',
            statDelta: StatDelta(intellect: 3, mood: -5),
            copperDelta: 80,
          ),
        ),
        EventChoice(
          id: 'haul_timber',
          label: 'Cargar troncos de roble a hombro limpio',
          statCheck: StatCheck(stat: StatType.strength, requiredScore: 45),
          successOutcome: EventOutcome(
            description:
                'Tu fuerza sobresale entre los obreros y cobras doble jornal.',
            statDelta: StatDelta(strength: 8, health: 2),
            copperDelta: 250,
          ),
          failureOutcome: EventOutcome(
            description:
                'Un tronco resbala y te magulla la espalda durante la faena.',
            statDelta: StatDelta(health: -10, strength: 3),
            copperDelta: 90,
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'youth_errant_knight',
      stage: LifeStage.youth,
      title: 'El Caballero sin Señor',
      narrativeBuilder: (_, npc) =>
          'Sir $npc, un veterano cubierto de polvo y cicatrices, descansa en la fuente y busca un discípulo digno para transmitir su técnica.',
      choices: const [
        EventChoice(
          id: 'sparring_test',
          label: 'Solicitar un intercambio de golpes de prueba',
          statCheck: StatCheck(stat: StatType.combatSkill, requiredScore: 44),
          successOutcome: EventOutcome(
            description: 'Resististe diez asaltos. El caballero te enseña su guardia secreta.',
            statDelta: StatDelta(combatSkill: 10, strength: 5, mood: 6),
          ),
          failureOutcome: EventOutcome(
            description: 'Caes de bruces al segundo asalto, pero comprendes tus puntos débiles.',
            statDelta: StatDelta(combatSkill: 4, health: -6, mood: -3),
          ),
        ),
        EventChoice(
          id: 'invite_supper',
          label: 'Invitarle una jarra de vino y comida (1 Plata)',
          minCopperRequired: 100,
          successOutcome: EventOutcome(
            description: 'Entre anécdotas de guerra comparte valiosos consejos tácticos y vitales.',
            statDelta: StatDelta(
              combatSkill: 6,
              emotionalIntelligence: 5,
              intellect: 3,
            ),
            copperDelta: -100,
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'youth_old_mine',
      stage: LifeStage.youth,
      title: 'Veta en la Gruta Vieja',
      narrativeBuilder: (hero, _) =>
          'En los riscos sobre ${hero.villageName}, un derrumbe dejó al descubierto una galería olvidada con destellos minerales.',
      choices: const [
        EventChoice(
          id: 'explore_deep',
          label: 'Adentrarse con antorcha y pico',
          statCheck: StatCheck(stat: StatType.strength, requiredScore: 46),
          successOutcome: EventOutcome(
            description:
                'Extraes mineral de plata pura antes de que oscurezca.',
            statDelta: StatDelta(strength: 6, mood: 8),
            copperDelta: 650,
          ),
          failureOutcome: EventOutcome(
            description: 'El aire viciado te marea y debes salir a rastras con las manos vacías.',
            statDelta: StatDelta(health: -12, mood: -6),
          ),
        ),
        EventChoice(
          id: 'map_entrance',
          label: 'Cartografiar la entrada y vender el mapa al gremio',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 48),
          successOutcome: EventOutcome(
            description: 'El gremio minero compra tus planos exactos sin arriesgar tu pellejo.',
            statDelta: StatDelta(intellect: 6, mood: 4),
            copperDelta: 320,
          ),
          failureOutcome: EventOutcome(
            description:
                'El gremio considera el boceto impreciso y paga una miseria.',
            statDelta: StatDelta(intellect: 2),
            copperDelta: 60,
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'youth_tavern_brawl',
      stage: LifeStage.youth,
      title: 'Riña en la Posada del Jabalí',
      narrativeBuilder: (_, npc) =>
          'Una discusión por los dados escala rápido: el mercenario $npc arroja una jarra y la taberna entera está a punto de estallar.',
      choices: const [
        EventChoice(
          id: 'defuse_tension',
          label: 'Intervenir con serenidad y apaciguar a ambos bandos',
          statCheck: StatCheck(
            stat: StatType.emotionalIntelligence,
            requiredScore: 50,
          ),
          successOutcome: EventOutcome(
            description: 'Tu temple sereno frena la pelea; el posadero agradece el gesto en plata.',
            statDelta: StatDelta(emotionalIntelligence: 8, mood: 6),
            copperDelta: 180,
          ),
          failureOutcome: EventOutcome(
            description: 'Recibes un sillazo perdido antes de poder mediar.',
            statDelta: StatDelta(health: -9, mood: -6),
          ),
        ),
        EventChoice(
          id: 'knockout_instigator',
          label: 'Inmovilizar al mercenario al instante',
          statCheck: StatCheck(stat: StatType.combatSkill, requiredScore: 50),
          successOutcome: EventOutcome(
            description: 'Una llave rápida termina el escándalo; ganas fama en la comarca.',
            statDelta: StatDelta(combatSkill: 7, strength: 4, mood: 5),
            copperDelta: 220,
          ),
          failureOutcome: EventOutcome(
            description:
                'El mercenario es más recio de lo esperado y acabas magullado.',
            statDelta: StatDelta(health: -14, combatSkill: 2, mood: -5),
          ),
        ),
      ],
    ),

    // =========================================================================
    // 5. ADULTEZ (35–59 años) — 5 eventos
    // =========================================================================
    GameEventDefinition(
      id: 'adult_baron_bailiff',
      stage: LifeStage.adulthood,
      title: 'El Alguacil del Barón',
      narrativeBuilder: (hero, npc) =>
          'El alguacil $npc llega a ${hero.villageName} exigiendo un tributo extraordinario por supuestas deudas atrasadas de la comarca.',
      choices: const [
        EventChoice(
          id: 'audit_ledger',
          label: 'Revisar sus pergaminos fiscales y señalar errores',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 62),
          successOutcome: EventOutcome(
            description: 'Demuestras que las cuentas estaban infladas; el concejo te premia en oro.',
            statDelta: StatDelta(intellect: 7, mood: 8),
            copperDelta: 12000, // 1O 20P
          ),
          failureOutcome: EventOutcome(
            description: 'El alguacil impone su autoridad y debes pagar parte de la multa.',
            statDelta: StatDelta(mood: -8),
            copperDelta: -600,
          ),
        ),
        EventChoice(
          id: 'negotiate_reduction',
          label: 'Negociar una tregua justa en nombre del pueblo',
          statCheck: StatCheck(
            stat: StatType.emotionalIntelligence,
            requiredScore: 60,
          ),
          successOutcome: EventOutcome(
            description:
                'Convences al oficial de aceptar grano y una suma menor.',
            statDelta: StatDelta(emotionalIntelligence: 8, mood: 5),
            copperDelta: 450,
          ),
          failureOutcome: EventOutcome(
            description: 'No cede ni un ápice y terminas asumiendo el coste.',
            statDelta: StatDelta(mood: -6),
            copperDelta: -400,
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'adult_black_frost',
      stage: LifeStage.adulthood,
      title: 'Invierno de Escarcha Negra',
      narrativeBuilder: (hero, _) =>
          'El invierno más crudo en treinta años amenaza con congelar los silos y rebaños de ${hero.villageName}.',
      choices: const [
        EventChoice(
          id: 'lead_relief',
          label: 'Coordinar el racionamiento y los refugios',
          statCheck: StatCheck(
            stat: StatType.emotionalIntelligence,
            requiredScore: 58,
          ),
          successOutcome: EventOutcome(
            description: 'Nadie pasa hambre gracias a tu organización; recibes honores y donativos.',
            statDelta: StatDelta(
              emotionalIntelligence: 7,
              intellect: 4,
              mood: 7,
            ),
            copperDelta: 800,
          ),
          failureOutcome: EventOutcome(
            description:
                'Las disputas por la leña desgastan tu salud y tu ánimo.',
            statDelta: StatDelta(health: -10, mood: -9),
          ),
        ),
        EventChoice(
          id: 'clear_roads_force',
          label: 'Abrir camino en la nieve a fuerza de brazo',
          statCheck: StatCheck(stat: StatType.strength, requiredScore: 56),
          successOutcome: EventOutcome(
            description:
                'Despejas la ruta del carro de víveres salvando la estación.',
            statDelta: StatDelta(strength: 6, health: 2, mood: 5),
            copperDelta: 600,
          ),
          failureOutcome: EventOutcome(
            description: 'El sobreesfuerzo en la ventisca pasa factura a tus articulaciones.',
            statDelta: StatDelta(health: -14, strength: -2, mood: -5),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'adult_capital_caravan',
      stage: LifeStage.adulthood,
      title: 'Caravana Hacia la Capital',
      narrativeBuilder: (_, npc) =>
          'El gremio de $npc prepara una gran caravana de paños y especias y busca un socio de confianza para invertir o liderarla.',
      choices: const [
        EventChoice(
          id: 'invest_gold_caravan',
          label: 'Invertir 5 Platas y supervisar la ruta',
          minCopperRequired: 500,
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 56),
          successOutcome: EventOutcome(
            description: 'La venta en la capital supera todo cálculo. ¡Regresas con oro!',
            statDelta: StatDelta(intellect: 5, mood: 10),
            copperDelta: 15000, // +1O 50P
          ),
          failureOutcome: EventOutcome(
            description:
                'Los aranceles imprevistos consumen casi toda tu inversión.',
            statDelta: StatDelta(mood: -8),
            copperDelta: -500,
          ),
        ),
        EventChoice(
          id: 'guard_caravan',
          label: 'Servir como capitán de escolta',
          statCheck: StatCheck(stat: StatType.combatSkill, requiredScore: 58),
          successOutcome: EventOutcome(
            description: 'Mantienes a raya a los salteadores del paso y cobras en monedas de oro.',
            statDelta: StatDelta(combatSkill: 6, strength: 3, mood: 6),
            copperDelta: 10000, // +1O
          ),
          failureOutcome: EventOutcome(
            description: 'Una escaramuza nocturna te deja herido, aunque salvan la carga.',
            statDelta: StatDelta(health: -14, combatSkill: 3),
            copperDelta: 300,
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'adult_foreign_champion',
      stage: LifeStage.adulthood,
      title: 'El Reto del Campeón Forastero',
      narrativeBuilder: (_, npc) =>
          'Un duelista itinerante llamado $npc clava su espada en la plaza retando al luchador más capaz de la región.',
      choices: const [
        EventChoice(
          id: 'accept_duel',
          label: 'Aceptar el duelo ante toda la aldea',
          statCheck: StatCheck(stat: StatType.combatSkill, requiredScore: 64),
          successOutcome: EventOutcome(
            description: 'Tu técnica impecable quiebra su guardia; paga la bolsa apostada.',
            statDelta: StatDelta(combatSkill: 8, mood: 9),
            copperDelta: 11000, // 1O 10P
          ),
          failureOutcome: EventOutcome(
            description: 'Cedes ante un golpe veloz y pasas semanas recuperando el aliento.',
            statDelta: StatDelta(health: -16, mood: -8, combatSkill: 2),
          ),
        ),
        EventChoice(
          id: 'offer_hospitality_wisdom',
          label: 'Invitarle a compartir mesa y evitar sangre inútil',
          successOutcome: EventOutcome(
            description:
                'El forastero respeta tu madurez y parte dejando un obsequio.',
            statDelta: StatDelta(emotionalIntelligence: 6, mood: 4),
            copperDelta: 250,
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'adult_chronic_ailment',
      stage: LifeStage.adulthood,
      title: 'Dolencia Persistente',
      narrativeBuilder: (_, _) => 'Los años de esfuerzo dejan huella: una punzada persistente en el pecho y las rodillas te obliga a replantear tu ritmo.',
      choices: const [
        EventChoice(
          id: 'buy_apothecary_cure',
          label: 'Costear tónicos del maestro boticario (3 Platas)',
          minCopperRequired: 300,
          successOutcome: EventOutcome(
            description: 'Los bálsamos restauran tu vitalidad para afrontar los próximos años.',
            statDelta: StatDelta(health: 12, mood: 6),
            copperDelta: -300,
          ),
        ),
        EventChoice(
          id: 'overcome_naturally',
          label: 'Seguir una disciplina estricta de descanso y dieta',
          statCheck: StatCheck(stat: StatType.health, requiredScore: 60),
          successOutcome: EventOutcome(
            description:
                'Tu constitución responde bien y recuperas el equilibrio.',
            statDelta: StatDelta(health: 6, emotionalIntelligence: 3),
          ),
          failureOutcome: EventOutcome(
            description:
                'La dolencia empeora durante meses antes de estabilizarse.',
            statDelta: StatDelta(health: -12, strength: -4, mood: -6),
          ),
        ),
      ],
    ),

    // =========================================================================
    // 6. VEJEZ (60+ años) — 5 eventos
    // =========================================================================
    GameEventDefinition(
      id: 'old_elders_council',
      stage: LifeStage.oldAge,
      title: 'Consejo de Ancianos',
      narrativeBuilder: (hero, _) =>
          'Los ancianos de ${hero.villageName} te invitan a presidir la resolución de un conflicto de tierras que divide a dos familias.',
      choices: const [
        EventChoice(
          id: 'wise_mediation',
          label: 'Dictar un acuerdo justo atendiendo ambas partes',
          statCheck: StatCheck(
            stat: StatType.emotionalIntelligence,
            requiredScore: 65,
          ),
          successOutcome: EventOutcome(
            description: 'Tu sentencia es aclamada por todos; te ofrecen un tributo de gratitud.',
            statDelta: StatDelta(emotionalIntelligence: 6, mood: 8),
            copperDelta: 10000,
          ),
          failureOutcome: EventOutcome(
            description: 'Una de las familias queda resentida pese a tus buenas intenciones.',
            statDelta: StatDelta(mood: -6),
          ),
        ),
        EventChoice(
          id: 'draft_boundary_deed',
          label: 'Redactar un registro catastral inapelable',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 65),
          successOutcome: EventOutcome(
            description: 'Los linderos quedan claros por generaciones; ganas honra y oro.',
            statDelta: StatDelta(intellect: 6, mood: 7),
            copperDelta: 10000,
          ),
          failureOutcome: EventOutcome(
            description:
                'Faltan testigos antiguos y la disputa queda aplazada.',
            statDelta: StatDelta(mood: -4),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'old_final_blade_lesson',
      stage: LifeStage.oldAge,
      title: 'Una Última Lección de Acero',
      narrativeBuilder: (_, npc) =>
          'Un joven guardia llamado $npc acude a tu puerta rogando que le muestres la forma correcta de sostener el escudo y la espada.',
      choices: const [
        EventChoice(
          id: 'demonstrate_form',
          label: 'Tomar la espada de práctica y enseñarle en el patio',
          statCheck: StatCheck(stat: StatType.combatSkill, requiredScore: 58),
          successOutcome: EventOutcome(
            description: 'Tu maestría intacta asombra al muchacho; te entrega su bolsa de aprendiz.',
            statDelta: StatDelta(combatSkill: 4, mood: 9),
            copperDelta: 600,
          ),
          failureOutcome: EventOutcome(
            description: 'Un tirón en el hombro interrumpe la clase, aunque agradeces el intento.',
            statDelta: StatDelta(health: -8, mood: -3),
          ),
        ),
        EventChoice(
          id: 'teach_strategy_orally',
          label: 'Explicar táctica y temple sentado junto al fuego',
          successOutcome: EventOutcome(
            description:
                'Tus palabras siembran sabiduría sin forzar tu cuerpo.',
            statDelta: StatDelta(
              intellect: 4,
              emotionalIntelligence: 4,
              mood: 5,
            ),
            copperDelta: 300,
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'old_great_winter',
      stage: LifeStage.oldAge,
      title: 'El Gran Invierno del Norte',
      narrativeBuilder: (hero, _) =>
          'Una ventisca histórica aísla ${hero.villageName} durante semanas. A tu edad, cada noche helada es una prueba de resistencia.',
      choices: const [
        EventChoice(
          id: 'endure_hearth',
          label: 'Mantener el ánimo firme y cuidar tu respiración',
          statCheck: StatCheck(stat: StatType.health, requiredScore: 62),
          successOutcome: EventOutcome(
            description: 'Recibes la primavera entero, convertido en ejemplo de longevidad.',
            statDelta: StatDelta(health: 4, mood: 7),
          ),
          failureOutcome: EventOutcome(
            description: 'El frío cala en tus pulmones y debilita tus fuerzas.',
            statDelta: StatDelta(health: -15, strength: -4, mood: -6),
          ),
        ),
        EventChoice(
          id: 'buy_furs_herbs',
          label: 'Comprar pieles finas y ungüentos (1 Oro)',
          minCopperRequired: 10000,
          successOutcome: EventOutcome(
            description:
                'Pasas el invierno cálido y bien nutrido pese a la tormenta.',
            statDelta: StatDelta(health: 10, mood: 8),
            copperDelta: -10000,
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'old_shire_chronicler',
      stage: LifeStage.oldAge,
      title: 'El Cronista de la Comarca',
      narrativeBuilder: (_, npc) =>
          'El historiador $npc recorre la región recopilando relatos de vidas extraordinarias para los archivos del reino.',
      choices: const [
        EventChoice(
          id: 'dictate_memoirs',
          label: 'Dictar tus memorias y conocimientos',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 60),
          successOutcome: EventOutcome(
            description: 'Tu historia queda grabada con brillo y recibes un premio de la corte.',
            statDelta: StatDelta(intellect: 5, mood: 10),
            copperDelta: 12000,
          ),
          failureOutcome: EventOutcome(
            description: 'Los detalles dispersos confunden al cronista, pero disfrutas recordando.',
            statDelta: StatDelta(mood: 3),
          ),
        ),
        EventChoice(
          id: 'share_humble_wisdom',
          label: 'Contar anécdotas sencillas sobre la gente del pueblo',
          successOutcome: EventOutcome(
            description: 'El cronista sonríe ante tu humildad y deja unas monedas de plata.',
            statDelta: StatDelta(emotionalIntelligence: 5, mood: 6),
            copperDelta: 500,
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'old_hilltop_sunset',
      stage: LifeStage.oldAge,
      title: 'Atardecer Sobre la Colina',
      narrativeBuilder: (hero, _) =>
          'Contemplas los tejados humildes de ${hero.villageName} teñidos de ámbar, recordando el largo camino desde el día en que renaciste.',
      choices: const [
        EventChoice(
          id: 'serene_acceptance',
          label: 'Abrazar la paz de todo lo vivido',
          statCheck: StatCheck(stat: StatType.mood, requiredScore: 60),
          successOutcome: EventOutcome(
            description: 'Una serenidad profunda renueva tu espíritu y fortalece tu corazón.',
            statDelta: StatDelta(mood: 12, health: 5, emotionalIntelligence: 4),
          ),
          failureOutcome: EventOutcome(
            description: 'Un dejo de cansancio te envuelve al bajar la colina al anochecer.',
            statDelta: StatDelta(mood: -5, health: -4),
          ),
        ),
        EventChoice(
          id: 'leave_village_gift',
          label: 'Donar 5 Platas para reparar la escuela rural',
          minCopperRequired: 500,
          successOutcome: EventOutcome(
            description:
                'Las risas de los niños llenan tu corazón de gratitud y dicha.',
            statDelta: StatDelta(mood: 14, emotionalIntelligence: 6),
            copperDelta: -500,
          ),
        ),
      ],
    ),

    // =========================================================================
    // +5 NUEVOS POR ETAPA (30 adicionales -> 60 eventos en total)
    // =========================================================================

    // --- Infancia temprana (+5 -> total 10) ---
    GameEventDefinition(
      id: 'early_fireflies',
      stage: LifeStage.earlyChildhood,
      title: 'Luciérnagas en la Ventana',
      narrativeBuilder: (hero, _) =>
          'Una noche cálida en ${hero.villageName}, decenas de luciérnagas entran flotando por el postigo entreabierto sobre tu cuna.',
      choices: const [
        EventChoice(
          id: 'reach_fireflies',
          label: 'Estirar los brazos intentando atrapar una',
          statCheck: StatCheck(stat: StatType.strength, requiredScore: 10),
          successOutcome: EventOutcome(
            description: 'Logras posar un pequeño punto de luz en tu palma antes de soltarlo riendo.',
            statDelta: StatDelta(strength: 3, mood: 6),
          ),
          failureOutcome: EventOutcome(
            description: 'Tu manita golpea el borde de la cuna, aunque el brillo te fascina.',
            statDelta: StatDelta(mood: 2, health: -2),
          ),
        ),
        EventChoice(
          id: 'watch_pattern',
          label: 'Contemplar su danza luminosa en calma',
          successOutcome: EventOutcome(
            description:
                'Sientes una paz inesperada que asienta tu espíritu renacido.',
            statDelta: StatDelta(emotionalIntelligence: 4, mood: 4),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'early_bitter_brew',
      stage: LifeStage.earlyChildhood,
      title: 'El Brebaje Amargo',
      narrativeBuilder: (hero, _) =>
          '${hero.motherName} acerca una cuchara humeante con caldo oscuro de raíces para fortalecer tus defensas antes del invierno.',
      choices: const [
        EventChoice(
          id: 'swallow_brave',
          label: 'Tragarlo de un sorbo sin rechistar',
          statCheck: StatCheck(stat: StatType.health, requiredScore: 72),
          successOutcome: EventOutcome(
            description:
                'Tu estómago lo asimila rápido y sientes un calor vigoroso.',
            statDelta: StatDelta(health: 5, mood: 2),
          ),
          failureOutcome: EventOutcome(
            description:
                'El sabor amargo te revuelve un poco el estómago esa tarde.',
            statDelta: StatDelta(health: 1, mood: -5),
          ),
        ),
        EventChoice(
          id: 'sip_slowly',
          label: 'Tomarlo poco a poco con miel',
          successOutcome: EventOutcome(
            description: 'La dulzura suaviza las hierbas y te reconforta.',
            statDelta: StatDelta(health: 3, emotionalIntelligence: 2),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'early_hearth_sparks',
      stage: LifeStage.earlyChildhood,
      title: 'Chispas del Hogar',
      narrativeBuilder: (_, _) => 'Una brasa salta de la chimenea hacia la alfombra de esparto mientras tus padres atienden fuera un instante.',
      choices: const [
        EventChoice(
          id: 'kick_rug_away',
          label: 'Empujar la brasa con tu zapato de cuero',
          statCheck: StatCheck(stat: StatType.combatSkill, requiredScore: 10),
          successOutcome: EventOutcome(
            description: 'Reaccionas con reflejos impropios de tu edad y apagas la chispa.',
            statDelta: StatDelta(combatSkill: 4, strength: 2),
          ),
          failureOutcome: EventOutcome(
            description:
                'Te quemas levemente un dedito antes de que entre tu padre.',
            statDelta: StatDelta(health: -5, mood: -4),
          ),
        ),
        EventChoice(
          id: 'call_parents_loud',
          label: 'Llamar con fuerza a tus padres de inmediato',
          successOutcome: EventOutcome(
            description:
                'Acuden al instante, apagan la brasa y elogian tu viveza.',
            statDelta: StatDelta(intellect: 4, emotionalIntelligence: 3),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'early_village_minstrel',
      stage: LifeStage.earlyChildhood,
      title: 'El Juglar de la Plaza',
      narrativeBuilder: (hero, npc) =>
          'El juglar ambulante $npc toca el laúd en ${hero.villageName} cantando gestas de caballeros y dragones antiguos.',
      choices: const [
        EventChoice(
          id: 'hum_melody',
          label: 'Seguir el compás y repetir las estrofas',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 24),
          successOutcome: EventOutcome(
            description: 'Memorizas versos enteros y el juglar te regala un cascabel de cobre.',
            statDelta: StatDelta(intellect: 5, mood: 5),
            copperDelta: 10,
          ),
          failureOutcome: EventOutcome(
            description:
                'Te trabas con las palabras nuevas, pero disfrutas la música.',
            statDelta: StatDelta(mood: 3, intellect: 1),
          ),
        ),
        EventChoice(
          id: 'clap_with_crowd',
          label: 'Reír y aplaudir junto a los aldeanos',
          successOutcome: EventOutcome(
            description: 'Contagias alegría a todos los presentes en la plaza.',
            statDelta: StatDelta(emotionalIntelligence: 4, mood: 6),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'early_first_clear_words',
      stage: LifeStage.earlyChildhood,
      title: 'Primeras Palabras Claras',
      narrativeBuilder: (hero, _) =>
          'Tus padres notan que pronuncias frases completas mucho antes que cualquier otro niño de ${hero.villageName}.',
      choices: const [
        EventChoice(
          id: 'ask_about_world',
          label: 'Hacer preguntas sobre el reino y las ciudades',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 26),
          successOutcome: EventOutcome(
            description:
                'Tu padre te relata mapas y caminos reales con asombro.',
            statDelta: StatDelta(intellect: 6, mood: 3),
          ),
          failureOutcome: EventOutcome(
            description:
                'Las respuestas simples te dejan con aún más curiosidad.',
            statDelta: StatDelta(intellect: 3),
          ),
        ),
        EventChoice(
          id: 'comfort_mother',
          label: 'Decir palabras cariñosas a tu madre cansada',
          successOutcome: EventOutcome(
            description:
                'Tu madre te abraza emocionada al escuchar tanta dulzura.',
            statDelta: StatDelta(emotionalIntelligence: 6, mood: 5),
          ),
        ),
      ],
    ),

    // --- Niñez (+5 -> total 10) ---
    GameEventDefinition(
      id: 'child_great_oak',
      stage: LifeStage.childhood,
      title: 'El Gran Roble del Lindero',
      narrativeBuilder: (_, npc) =>
          '$npc reta a los niños a escalar hasta la horquilla más alta del roble milenario para ver las colinas lejanas.',
      choices: const [
        EventChoice(
          id: 'climb_top',
          label: 'Trepar hasta la copa por la corteza gruesa',
          statCheck: StatCheck(stat: StatType.strength, requiredScore: 24),
          successOutcome: EventOutcome(
            description: 'Contemplas todo el valle desde lo alto y hallas un nido con una moneda brillante.',
            statDelta: StatDelta(strength: 5, mood: 7),
            copperDelta: 18,
          ),
          failureOutcome: EventOutcome(
            description:
                'Una rama seca cede y caes sobre unos arbustos con rasguños.',
            statDelta: StatDelta(health: -8, mood: -4, strength: 2),
          ),
        ),
        EventChoice(
          id: 'spot_route_below',
          label: 'Guiar desde abajo señalando las ramas firmes',
          successOutcome: EventOutcome(
            description:
                'Tu ojo agudo evita caídas y todos agradecen tus indicaciones.',
            statDelta: StatDelta(intellect: 5, emotionalIntelligence: 3),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'child_blacksmith_forge',
      stage: LifeStage.childhood,
      title: 'La Fragua del Herrero',
      narrativeBuilder: (_, npc) =>
          'El herrero $npc necesita quien tire del fuelle mientras templa herraduras y puntas de lanza al rojo vivo.',
      choices: const [
        EventChoice(
          id: 'pump_bellows',
          label: 'Mantener el ritmo del fuelle pesado',
          statCheck: StatCheck(stat: StatType.strength, requiredScore: 22),
          successOutcome: EventOutcome(
            description:
                'Avivas la fragua sin flaquear y el herrero te paga en cobre.',
            statDelta: StatDelta(strength: 6, health: 2),
            copperDelta: 30,
          ),
          failureOutcome: EventOutcome(
            description:
                'El calor y el peso te agotan antes de terminar la tanda.',
            statDelta: StatDelta(health: -5, strength: 2, mood: -3),
            copperDelta: 10,
          ),
        ),
        EventChoice(
          id: 'observe_forging',
          label: 'Observar cómo templa el acero y ordenar herramientas',
          successOutcome: EventOutcome(
            description:
                'Comprendes la diferencia entre hierro dulce y acero templado.',
            statDelta: StatDelta(intellect: 4, combatSkill: 3),
            copperDelta: 15,
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'child_wounded_fox',
      stage: LifeStage.childhood,
      title: 'El Zorro Herido en el Zarzal',
      narrativeBuilder: (_, _) => 'Encuentras un zorro joven con una pata atrapada en un lazo oxidado cerca del seto.',
      choices: const [
        EventChoice(
          id: 'soothe_and_free',
          label: 'Calmarlo en voz baja y abrir el lazo',
          statCheck: StatCheck(
            stat: StatType.emotionalIntelligence,
            requiredScore: 30,
          ),
          successOutcome: EventOutcome(
            description: 'El animal confía en ti, se deja liberar y corre libre hacia el bosque.',
            statDelta: StatDelta(emotionalIntelligence: 7, mood: 7),
          ),
          failureOutcome: EventOutcome(
            description: 'Asustado, te da un mordisco rápido en la mano antes de escapar.',
            statDelta: StatDelta(health: -6, emotionalIntelligence: 2),
          ),
        ),
        EventChoice(
          id: 'use_lever_stick',
          label: 'Usar un palo como palanca para soltarlo a distancia',
          successOutcome: EventOutcome(
            description:
                'Liberas al zorro sin poner los dedos cerca de sus colmillos.',
            statDelta: StatDelta(intellect: 5, mood: 4),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'child_peddler_riddle',
      stage: LifeStage.childhood,
      title: 'El Acertijo del Buhonero',
      narrativeBuilder: (_, npc) =>
          'Un buhonero ambulante llamado $npc promete un puñado de monedas de cobre al niño que resuelva su acertijo numérico.',
      choices: const [
        EventChoice(
          id: 'solve_riddle',
          label: 'Calcular la respuesta mentalmente y responder',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 32),
          successOutcome: EventOutcome(
            description: 'Aciertas al instante; el mercader cumple su palabra asombrado.',
            statDelta: StatDelta(intellect: 6, mood: 6),
            copperDelta: 45,
          ),
          failureOutcome: EventOutcome(
            description:
                'Te precipitas con una cifra errónea y pierdes la apuesta.',
            statDelta: StatDelta(mood: -4, intellect: 2),
          ),
        ),
        EventChoice(
          id: 'chat_trade_stories',
          label: 'Preguntarle por las rutas y pueblos vecinos',
          successOutcome: EventOutcome(
            description:
                'Te regala un silbato de madera y amplía tu visión del mundo.',
            statDelta: StatDelta(emotionalIntelligence: 4, intellect: 3),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'child_storm_shelter',
      stage: LifeStage.childhood,
      title: 'Refugio Bajo la Tormenta',
      narrativeBuilder: (_, npc) =>
          'Un aguacero repentino te sorprende lejos de casa junto al pequeño $npc bajo un cobertizo medio derruido.',
      choices: const [
        EventChoice(
          id: 'comfort_friend',
          label: 'Contar historias para calmar el miedo a los truenos',
          successOutcome: EventOutcome(
            description: 'Mantienes alto el ánimo de ambos hasta que escampa el temporal.',
            statDelta: StatDelta(emotionalIntelligence: 6, mood: 5),
          ),
        ),
        EventChoice(
          id: 'dash_home_rain',
          label: 'Correr entre los charcos buscando el camino más corto',
          statCheck: StatCheck(stat: StatType.health, requiredScore: 68),
          successOutcome: EventOutcome(
            description:
                'Llegas empapado pero sano, demostrando gran resistencia.',
            statDelta: StatDelta(health: 3, strength: 4),
          ),
          failureOutcome: EventOutcome(
            description:
                'El frío de la lluvia te deja tiritando en cama dos días.',
            statDelta: StatDelta(health: -9, mood: -4),
          ),
        ),
      ],
    ),

    // --- Adolescencia (+5 -> total 10) ---
    GameEventDefinition(
      id: 'adol_palisade_watch',
      stage: LifeStage.adolescence,
      title: 'Guardia Nocturna en la Empalizada',
      narrativeBuilder: (hero, npc) =>
          'Faltan hombres adultos en la ronda de ${hero.villageName}; el capitán $npc pide voluntarios jóvenes para vigilar la puerta norte.',
      choices: const [
        EventChoice(
          id: 'stand_armed_watch',
          label: 'Tomar una pica y vigilar hasta el alba',
          statCheck: StatCheck(stat: StatType.combatSkill, requiredScore: 32),
          successOutcome: EventOutcome(
            description: 'Detectas sombras sospechosas a tiempo y cobras paga de guardia.',
            statDelta: StatDelta(combatSkill: 6, strength: 3),
            copperDelta: 110,
          ),
          failureOutcome: EventOutcome(
            description: 'El sueño te vence en el último turno y recibes una reprimenda.',
            statDelta: StatDelta(health: -5, mood: -6),
            copperDelta: 25,
          ),
        ),
        EventChoice(
          id: 'keep_watchfires_lit',
          label: 'Mantener las hogueras y relevar mensajes',
          successOutcome: EventOutcome(
            description: 'Cumples con seriedad y recibes una recompensa justa.',
            statDelta: StatDelta(health: 2, emotionalIntelligence: 3),
            copperDelta: 65,
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'adol_adventurer_posters',
      stage: LifeStage.adolescence,
      title: 'Carteles del Gremio de Aventureros',
      narrativeBuilder: (_, npc) => 'Un mensajero clava en la taberna bandos del Gremio de Aventureros anunciando que todo joven de 15 años puede aspirar a Rango E.',
      choices: const [
        EventChoice(
          id: 'ask_veteran_tips',
          label: 'Preguntar a un veterano en la taberna qué exige el gremio',
          statCheck: StatCheck(
            stat: StatType.emotionalIntelligence,
            requiredScore: 36,
          ),
          successOutcome: EventOutcome(
            description: 'Te revela trucos de supervivencia y te regala una piedra de afilar.',
            statDelta: StatDelta(combatSkill: 5, intellect: 4, mood: 6),
          ),
          failureOutcome: EventOutcome(
            description:
                'El veterano gruñe que los novatos no duran un invierno.',
            statDelta: StatDelta(mood: -4, intellect: 2),
          ),
        ),
        EventChoice(
          id: 'memorize_quest_rules',
          label: 'Leer con detalle las normas y tarifas de los rangos',
          successOutcome: EventOutcome(
            description: 'Trazas tu plan para abrirte camino en este mundo.',
            statDelta: StatDelta(intellect: 5, mood: 4),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'adol_orchard_boar',
      stage: LifeStage.adolescence,
      title: 'Jabalí en los Huertos',
      narrativeBuilder: (_, npc) =>
          'Un jabalí furioso de colmillos curvos destroza las cercas del huerto de $npc en plena mañana.',
      choices: const [
        EventChoice(
          id: 'confront_boar',
          label: 'Enfrentarlo con un venablo y escudo de madera',
          statCheck: StatCheck(stat: StatType.combatSkill, requiredScore: 34),
          successOutcome: EventOutcome(
            description: 'Esquivas su embestida y lo abates; la carne y recompensa son tuyas.',
            statDelta: StatDelta(combatSkill: 7, strength: 4, mood: 6),
            copperDelta: 140,
          ),
          failureOutcome: EventOutcome(
            description: 'Te arroja al suelo rozándote la pierna antes de huir al monte.',
            statDelta: StatDelta(health: -14, mood: -5, combatSkill: 2),
          ),
        ),
        EventChoice(
          id: 'drive_out_noise',
          label: 'Coordinar a los vecinos con cacerolas y antorchas',
          successOutcome: EventOutcome(
            description: 'Espantan al animal sin que nadie salga herido.',
            statDelta: StatDelta(emotionalIntelligence: 5, intellect: 3),
            copperDelta: 55,
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'adol_stuck_wagon',
      stage: LifeStage.adolescence,
      title: 'El Carro del Mercader Atascado',
      narrativeBuilder: (_, npc) =>
          'La carreta de telas del mercader $npc quedó hundida hasta el eje en un barrizal a las afueras.',
      choices: const [
        EventChoice(
          id: 'lift_axle',
          label: 'Alzar el eje trasero a fuerza bruta',
          statCheck: StatCheck(stat: StatType.strength, requiredScore: 34),
          successOutcome: EventOutcome(
            description:
                'Levantas la carreta lo justo para calzar piedras y liberarla.',
            statDelta: StatDelta(strength: 6, mood: 5),
            copperDelta: 130,
          ),
          failureOutcome: EventOutcome(
            description:
                'Un tirón lumbar te obliga a soltar antes de sacarla del todo.',
            statDelta: StatDelta(health: -8, strength: 2),
          ),
        ),
        EventChoice(
          id: 'rig_pulley_lever',
          label: 'Montar una palanca con un tronco y cuerda',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 36),
          successOutcome: EventOutcome(
            description: 'La física básica hace maravillas; el mercader te paga en plata.',
            statDelta: StatDelta(intellect: 6, mood: 5),
            copperDelta: 150,
          ),
          failureOutcome: EventOutcome(
            description: 'La cuerda se rompe en el primer intento y deben buscar bueyes.',
            statDelta: StatDelta(intellect: 2, mood: -3),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'adol_starlight_oath',
      stage: LifeStage.adolescence,
      title: 'Juramento Bajo las Estrellas',
      narrativeBuilder: (hero, _) =>
          'En lo alto del otero sobre ${hero.villageName}, el cielo nocturno parece distinto al de tu antiguo mundo.',
      choices: const [
        EventChoice(
          id: 'vow_adventure',
          label: 'Jurar que recorrerás este mundo sin arrepentimientos',
          successOutcome: EventOutcome(
            description: 'Sientes arder una ambición serena en tu pecho.',
            statDelta: StatDelta(mood: 9, combatSkill: 3),
          ),
        ),
        EventChoice(
          id: 'vow_wisdom',
          label: 'Prometer cuidar tu mente y proteger a los tuyos',
          successOutcome: EventOutcome(
            description:
                'Tu determinación emocional se vuelve firme como la piedra.',
            statDelta: StatDelta(emotionalIntelligence: 6, mood: 6),
          ),
        ),
      ],
    ),

    // --- Juventud (+5 -> total 10) ---
    GameEventDefinition(
      id: 'youth_goblin_scouts',
      stage: LifeStage.youth,
      title: 'Exploradores Trasgos en la Cañada',
      narrativeBuilder: (hero, _) =>
          'Una pareja de trasgos armados con hondas acecha los rebaños en los barrancos cercanos a ${hero.villageName}.',
      choices: const [
        EventChoice(
          id: 'ambush_scouts',
          label: 'Tenderles una emboscada desde las rocas',
          statCheck: StatCheck(stat: StatType.combatSkill, requiredScore: 46),
          successOutcome: EventOutcome(
            description: 'Los reduces en segundos y recuperas una bolsa de plata robada.',
            statDelta: StatDelta(combatSkill: 8, strength: 3, mood: 6),
            copperDelta: 320,
          ),
          failureOutcome: EventOutcome(
            description:
                'Una piedra de honda golpea tu frente y logran escapar.',
            statDelta: StatDelta(health: -14, mood: -6, combatSkill: 2),
          ),
        ),
        EventChoice(
          id: 'track_to_camp',
          label: 'Seguir su rastro a distancia para vender la ubicación',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 48),
          successOutcome: EventOutcome(
            description:
                'Entregas un informe exacto a la guardia y cobras recompensa.',
            statDelta: StatDelta(intellect: 6, mood: 4),
            copperDelta: 240,
          ),
          failureOutcome: EventOutcome(
            description:
                'Pierdes las huellas sobre la grava seca del barranco.',
            statDelta: StatDelta(mood: -4, intellect: 2),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'youth_ruined_shrine',
      stage: LifeStage.youth,
      title: 'Santuario en Ruinas',
      narrativeBuilder: (_, _) => 'Entre la hiedra de una colina olvidada aparece una capilla derrumbada con inscripciones antiguas y un cofre sellado.',
      choices: const [
        EventChoice(
          id: 'decipher_seal',
          label: 'Analizar los símbolos del cierre antes de abrirlo',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 52),
          successOutcome: EventOutcome(
            description:
                'Desactivas el mecanismo y hallas monedas antiguas de plata.',
            statDelta: StatDelta(intellect: 8, mood: 7),
            copperDelta: 520,
          ),
          failureOutcome: EventOutcome(
            description:
                'Una aguja oculta pincha tu muñeca y el cofre está vacío.',
            statDelta: StatDelta(health: -11, mood: -5),
          ),
        ),
        EventChoice(
          id: 'pry_stone_lid',
          label: 'Forzar la tapa de piedra con una barra',
          statCheck: StatCheck(stat: StatType.strength, requiredScore: 50),
          successOutcome: EventOutcome(
            description:
                'Rompes la cerradura oxidada y recuperas plata y un amuleto.',
            statDelta: StatDelta(strength: 6, mood: 5),
            copperDelta: 400,
          ),
          failureOutcome: EventOutcome(
            description: 'La piedra cede mal y aplasta tus dedos con dolor.',
            statDelta: StatDelta(health: -12, mood: -4),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'youth_neighbor_debt',
      stage: LifeStage.youth,
      title: 'Deuda del Vecino',
      narrativeBuilder: (_, npc) =>
          'Tu vecino $npc está a punto de perder su yunta ante un prestamista implacable si no reúne 2 Platas antes del anochecer.',
      choices: const [
        EventChoice(
          id: 'lend_silver',
          label: 'Prestarle 2 Platas de tu bolsa',
          minCopperRequired: 200,
          successOutcome: EventOutcome(
            description: 'Salvas el sustento de su familia; te devuelve su gratitud eterna.',
            statDelta: StatDelta(emotionalIntelligence: 8, mood: 9),
            copperDelta: -200,
          ),
        ),
        EventChoice(
          id: 'mediate_loan',
          label: 'Negociar un plazo justo con el prestamista',
          statCheck: StatCheck(
            stat: StatType.emotionalIntelligence,
            requiredScore: 48,
          ),
          successOutcome: EventOutcome(
            description: 'Consigues una prórroga sin intereses abusivos y te pagan por tu gestión.',
            statDelta: StatDelta(emotionalIntelligence: 7, intellect: 3),
            copperDelta: 110,
          ),
          failureOutcome: EventOutcome(
            description:
                'El prestamista se niega en redondo y se marcha furioso.',
            statDelta: StatDelta(mood: -5),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'youth_frost_flower',
      stage: LifeStage.youth,
      title: 'Flor de Escarcha en el Risco',
      narrativeBuilder: (_, npc) =>
          'La boticaria $npc ofrece una generosa suma de plata por una flor medicinal que solo crece en los acantilados fríos.',
      choices: const [
        EventChoice(
          id: 'climb_cliff',
          label: 'Escalar el risco helado sin arnés',
          statCheck: StatCheck(stat: StatType.strength, requiredScore: 48),
          successOutcome: EventOutcome(
            description:
                'Arrancas dos flores intactas y cobras una espléndida paga.',
            statDelta: StatDelta(strength: 6, health: 2, mood: 6),
            copperDelta: 480,
          ),
          failureOutcome: EventOutcome(
            description:
                'Resbalas sobre el musgo helado sufriendo contusiones.',
            statDelta: StatDelta(health: -15, mood: -6),
          ),
        ),
        EventChoice(
          id: 'climb_with_ropes',
          label: 'Comprar cuerda y asegurar el descenso (1 Plata)',
          minCopperRequired: 100,
          successOutcome: EventOutcome(
            description:
                'Desciendes con total seguridad y obtienes ganancia neta.',
            statDelta: StatDelta(intellect: 4, mood: 5),
            copperDelta: 320,
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'youth_county_fair',
      stage: LifeStage.youth,
      title: 'Feria del Condado',
      narrativeBuilder: (_, _) => 'Mercaderes, acróbatas y espadachines llenan la feria anual comarcal con competiciones y apuestas.',
      choices: const [
        EventChoice(
          id: 'dueling_ring',
          label: 'Inscribirse en el torneo de espada de madera',
          statCheck: StatCheck(stat: StatType.combatSkill, requiredScore: 48),
          successOutcome: EventOutcome(
            description:
                'Alcanzas la final invicto y te llevas la bolsa de plata.',
            statDelta: StatDelta(combatSkill: 7, mood: 8),
            copperDelta: 400,
          ),
          failureOutcome: EventOutcome(
            description: 'Caes en semifinales tras un duro combate.',
            statDelta: StatDelta(combatSkill: 3, health: -7, mood: -2),
            copperDelta: 80,
          ),
        ),
        EventChoice(
          id: 'charm_merchants',
          label: 'Vender artesanías locales y hacer contactos',
          statCheck: StatCheck(
            stat: StatType.emotionalIntelligence,
            requiredScore: 46,
          ),
          successOutcome: EventOutcome(
            description: 'Tu labia atrae compradores y haces muy buen negocio.',
            statDelta: StatDelta(emotionalIntelligence: 6, mood: 6),
            copperDelta: 340,
          ),
          failureOutcome: EventOutcome(
            description:
                'Los puestos rivales acaparan al público y apenas vendes.',
            statDelta: StatDelta(mood: -4),
            copperDelta: 60,
          ),
        ),
      ],
    ),

    // --- Adultez (+5 -> total 10) ---
    GameEventDefinition(
      id: 'adult_shadow_hills',
      stage: LifeStage.adulthood,
      title: 'Sombra Sobre las Colinas',
      narrativeBuilder: (hero, _) =>
          'Una banda numerosa de salteadores acampa en las colinas cercanas a ${hero.villageName} amenazando las rutas de otoño.',
      choices: const [
        EventChoice(
          id: 'lead_militia',
          label: 'Encabezar la milicia al amanecer',
          statCheck: StatCheck(stat: StatType.combatSkill, requiredScore: 62),
          successOutcome: EventOutcome(
            description: 'Desbandas el campamento y el señor local te recompensa en oro.',
            statDelta: StatDelta(combatSkill: 7, strength: 3, mood: 8),
            copperDelta: 12000,
          ),
          failureOutcome: EventOutcome(
            description:
                'Una lluvia de flechas te hiere antes de forzar su retirada.',
            statDelta: StatDelta(health: -18, combatSkill: 3, mood: -7),
            copperDelta: 400,
          ),
        ),
        EventChoice(
          id: 'plan_supply_cut',
          label: 'Cortar sus suministros y negociar su rendición',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 60),
          successOutcome: EventOutcome(
            description: 'Sin víveres ni salida, se entregan sin apenas lucha.',
            statDelta: StatDelta(intellect: 7, emotionalIntelligence: 4),
            copperDelta: 8000,
          ),
          failureOutcome: EventOutcome(
            description:
                'Descubren tu maniobra y logran escapar con parte del botín.',
            statDelta: StatDelta(mood: -6),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'adult_impulsive_youth',
      stage: LifeStage.adulthood,
      title: 'El Joven Impulsivo',
      narrativeBuilder: (_, npc) =>
          'Un muchacho temerario llamado $npc insiste en partir solo hacia un bosque infestado de monstruos para demostrar su valía.',
      choices: const [
        EventChoice(
          id: 'persuade_patiently',
          label: 'Escucharlo y aconsejarlo con empatía',
          statCheck: StatCheck(
            stat: StatType.emotionalIntelligence,
            requiredScore: 58,
          ),
          successOutcome: EventOutcome(
            description:
                'Comprende que la temeridad no es valentía y agradece tu guía.',
            statDelta: StatDelta(emotionalIntelligence: 7, mood: 7),
            copperDelta: 350,
          ),
          failureOutcome: EventOutcome(
            description:
                'No te hace caso y debes salir a rescatarlo horas después.',
            statDelta: StatDelta(health: -8, mood: -5),
          ),
        ),
        EventChoice(
          id: 'spar_reality_check',
          label: 'Darle un duelo instructivo para mostrar sus carencias',
          statCheck: StatCheck(stat: StatType.combatSkill, requiredScore: 56),
          successOutcome: EventOutcome(
            description: 'Lo desarmas en tres segundos; promete entrenar con disciplina.',
            statDelta: StatDelta(combatSkill: 5, mood: 5),
            copperDelta: 250,
          ),
          failureOutcome: EventOutcome(
            description:
                'Un golpe fortuito suyo te sorprende y quedas en evidencia.',
            statDelta: StatDelta(mood: -6, health: -6),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'adult_shady_proposal',
      stage: LifeStage.adulthood,
      title: 'Propuesta en la Penumbra',
      narrativeBuilder: (_, npc) =>
          'Un tratante llamado $npc te ofrece participar en un cargamento sin pagar aranceles reales, prometiendo oro fácil.',
      choices: const [
        EventChoice(
          id: 'reject_expose',
          label: 'Rechazar el trato y advertir al concejo',
          successOutcome: EventOutcome(
            description:
                'Tu integridad consolida tu prestigio entre los vecinos.',
            statDelta: StatDelta(emotionalIntelligence: 5, mood: 6),
            copperDelta: 450,
          ),
        ),
        EventChoice(
          id: 'smuggle_shipment',
          label: 'Aceptar el riesgo por el beneficio',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 62),
          successOutcome: EventOutcome(
            description:
                'Eludes los controles sin dejar rastro y cobras en oro puro.',
            statDelta: StatDelta(mood: -3),
            copperDelta: 14000,
          ),
          failureOutcome: EventOutcome(
            description:
                'Los guardias confiscan la mercancía y pagas una fuerte multa.',
            statDelta: StatDelta(mood: -10, emotionalIntelligence: -3),
            copperDelta: -1200,
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'adult_spring_flood',
      stage: LifeStage.adulthood,
      title: 'Riada de Primavera',
      narrativeBuilder: (hero, _) =>
          'El deshielo desborda el río junto a ${hero.villageName}, amenazando con arrastrar los diques de contención.',
      choices: const [
        EventChoice(
          id: 'haul_sandbags',
          label: 'Reforzar el dique cargando sacos y piedras',
          statCheck: StatCheck(stat: StatType.strength, requiredScore: 58),
          successOutcome: EventOutcome(
            description:
                'El muro resiste la crecida y salvas las cosechas del valle.',
            statDelta: StatDelta(strength: 6, health: -2, mood: 8),
            copperDelta: 900,
          ),
          failureOutcome: EventOutcome(
            description:
                'El agua helada te golpea y sufres un fuerte enfriamiento.',
            statDelta: StatDelta(health: -14, mood: -6),
          ),
        ),
        EventChoice(
          id: 'dig_relief_channel',
          label: 'Dirigir la excavación de un canal de alivio',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 58),
          successOutcome: EventOutcome(
            description:
                'Desvías la presión del agua con ingenio y sin víctimas.',
            statDelta: StatDelta(intellect: 6, mood: 7),
            copperDelta: 950,
          ),
          failureOutcome: EventOutcome(
            description:
                'La zanja no basta y parte de los huertos queda inundada.',
            statDelta: StatDelta(mood: -7),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'adult_old_rival',
      stage: LifeStage.adulthood,
      title: 'Reencuentro con un Viejo Rival',
      narrativeBuilder: (_, npc) =>
          '$npc, aquel rival de tu juventud que buscó fortuna en la capital, regresa montado en un corcel de guerra.',
      choices: const [
        EventChoice(
          id: 'friendly_toast',
          label: 'Invitarle una copa y limar viejas asperezas',
          successOutcome: EventOutcome(
            description:
                'Ríen de sus viejas disputas y forjan un trato provechoso.',
            statDelta: StatDelta(emotionalIntelligence: 6, mood: 7),
            copperDelta: 650,
          ),
        ),
        EventChoice(
          id: 'match_prowess',
          label: 'Medir fuerzas en un lance amistoso de armas',
          statCheck: StatCheck(stat: StatType.combatSkill, requiredScore: 60),
          successOutcome: EventOutcome(
            description:
                'Superas su esgrima refinada y se inclina con respeto.',
            statDelta: StatDelta(combatSkill: 6, mood: 8),
            copperDelta: 1000,
          ),
          failureOutcome: EventOutcome(
            description:
                'Su entrenamiento cortesano se impone, dejándote pensativo.',
            statDelta: StatDelta(combatSkill: 2, mood: -5, health: -6),
          ),
        ),
      ],
    ),

    // --- Vejez (+5 -> total 10) ---
    GameEventDefinition(
      id: 'old_distant_letter',
      stage: LifeStage.oldAge,
      title: 'Carta de Tierras Lejanas',
      narrativeBuilder: (_, npc) =>
          'Un mensajero te entrega una carta sellada con lacre de $npc, antiguo compañero que recuerda un favor olvidado.',
      choices: const [
        EventChoice(
          id: 'claim_gratitude',
          label: 'Aceptar el obsequio enviado desde el puerto',
          successOutcome: EventOutcome(
            description:
                'La misiva llega acompañada de un cofre con monedas de oro.',
            statDelta: StatDelta(mood: 9),
            copperDelta: 10000,
          ),
        ),
        EventChoice(
          id: 'reply_with_counsel',
          label: 'Responder con sabios consejos para sus asuntos',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 58),
          successOutcome: EventOutcome(
            description:
                'Tu consejo resuelve su problema y envía un segundo regalo.',
            statDelta: StatDelta(
              intellect: 4,
              emotionalIntelligence: 4,
              mood: 8,
            ),
            copperDelta: 13000,
          ),
          failureOutcome: EventOutcome(
            description: 'Agradece la carta afectuosa aunque sus asuntos ya habían cerrado.',
            statDelta: StatDelta(mood: 4),
            copperDelta: 5000,
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'old_attic_chest',
      stage: LifeStage.oldAge,
      title: 'El Baúl del Desván',
      narrativeBuilder: (_, _) => 'Ordenando el desván de tu casa, encuentras un arcón polvoriento con recuerdos de todas las décadas que has vivido.',
      choices: const [
        EventChoice(
          id: 'organize_archive',
          label: 'Catalogar tus mapas, notas y diarios',
          successOutcome: EventOutcome(
            description: 'Redescubres apuntes de tu vida pasada que llenan tu corazón de orgullo.',
            statDelta: StatDelta(intellect: 5, mood: 8),
          ),
        ),
        EventChoice(
          id: 'move_heavy_chest',
          label: 'Bajarlo tú mismo para restaurar la madera',
          statCheck: StatCheck(stat: StatType.strength, requiredScore: 45),
          successOutcome: EventOutcome(
            description: 'Aún conservas vigor y hallas una bolsa oculta en el doble fondo.',
            statDelta: StatDelta(strength: 3, mood: 6),
            copperDelta: 800,
          ),
          failureOutcome: EventOutcome(
            description:
                'Un tirón en la espalda te recuerda el peso de los años.',
            statDelta: StatDelta(health: -8, mood: -4),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'old_plaza_tribute',
      stage: LifeStage.oldAge,
      title: 'Homenaje en la Plaza',
      narrativeBuilder: (hero, _) =>
          'Los habitantes de ${hero.villageName} organizan un brindis honorífico reconociendo tus años de servicio y ejemplo.',
      choices: const [
        EventChoice(
          id: 'deliver_speech',
          label: 'Pronunciar unas palabras emotivas al pueblo',
          statCheck: StatCheck(
            stat: StatType.emotionalIntelligence,
            requiredScore: 60,
          ),
          successOutcome: EventOutcome(
            description: 'Tu discurso arranca vítores y lágrimas de emoción en la plaza.',
            statDelta: StatDelta(emotionalIntelligence: 6, mood: 12),
            copperDelta: 700,
          ),
          failureOutcome: EventOutcome(
            description: 'La voz se te quiebra por la emoción, pero todos aplauden con cariño.',
            statDelta: StatDelta(mood: 6),
          ),
        ),
        EventChoice(
          id: 'toast_silently',
          label: 'Sonreír con sencillez y brindar con todos',
          successOutcome: EventOutcome(
            description:
                'Disfrutas del aprecio sincero de toda la aldea sin fatigarte.',
            statDelta: StatDelta(mood: 8, health: 3),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'old_forest_pilgrim',
      stage: LifeStage.oldAge,
      title: 'El Peregrino de los Bosques',
      narrativeBuilder: (_, npc) =>
          'Un viajero encapuchado llamado $npc pide agua en tu puerta y comenta haber oído rumores sobre alguien que conoce cosas imposibles.',
      choices: const [
        EventChoice(
          id: 'converse_cryptic',
          label: 'Conversar sobre destinos y mundos lejanos',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 62),
          successOutcome: EventOutcome(
            description: 'El peregrino asiente en silencio y te deja una piedra de oro puro.',
            statDelta: StatDelta(
              intellect: 5,
              emotionalIntelligence: 4,
              mood: 8,
            ),
            copperDelta: 10000,
          ),
          failureOutcome: EventOutcome(
            description:
                'Mantiene el misterio, aunque la charla aviva tu curiosidad.',
            statDelta: StatDelta(mood: 3),
          ),
        ),
        EventChoice(
          id: 'offer_bread_and_rest',
          label: 'Ofrecerle pan y reposo sin hacer preguntas',
          successOutcome: EventOutcome(
            description:
                'Te bendice antes de partir dejándote una gran serenidad.',
            statDelta: StatDelta(health: 4, mood: 7),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'old_lightning_night',
      stage: LifeStage.oldAge,
      title: 'Noche de Relámpagos',
      narrativeBuilder: (_, _) => 'Una tormenta eléctrica sacude los postigos mientras el frío nocturno pone a prueba tu cansado cuerpo.',
      choices: const [
        EventChoice(
          id: 'breathe_and_resist',
          label: 'Mantener la calma y respirar profundo bajo las mantas',
          statCheck: StatCheck(stat: StatType.health, requiredScore: 58),
          successOutcome: EventOutcome(
            description:
                'Amaneces despejado y con el corazón sereno al salir el sol.',
            statDelta: StatDelta(health: 4, mood: 6),
          ),
          failureOutcome: EventOutcome(
            description:
                'La mala noche te deja fatigado y con los huesos doloridos.',
            statDelta: StatDelta(health: -12, mood: -6),
          ),
        ),
        EventChoice(
          id: 'drink_warm_infusion',
          label: 'Preparar una infusión caliente de jengibre y miel',
          successOutcome: EventOutcome(
            description:
                'El calor alivia tus articulaciones y duermes plácidamente.',
            statDelta: StatDelta(health: 5, mood: 4),
          ),
        ),
      ],
    ),

    // =========================================================================
    // +3 NUEVOS DE MAGIA, CRIATURAS Y MUNDO VIVO POR ETAPA (+18 -> 78 eventos)
    // =========================================================================

    // --- Infancia temprana (+3 -> total 13) ---
    GameEventDefinition(
      id: 'early_will_o_wisp',
      stage: LifeStage.earlyChildhood,
      title: 'Fuego Fatuo en el Jardín',
      narrativeBuilder: (hero, _) =>
          'Una esfera azulada de magia salvaje flota suavemente junto al cercado de ${hero.villageName} iluminando la hierba nocturna.',
      choices: const [
        EventChoice(
          id: 'gaze_wisp',
          label: 'Observar su resplandor con asombro',
          successOutcome: EventOutcome(
            description: 'El fuego fatuo gira sobre tu cabeza y se disipa en polvo brillante.',
            statDelta: StatDelta(emotionalIntelligence: 4, mood: 6),
          ),
        ),
        EventChoice(
          id: 'babble_at_wisp',
          label: 'Extender la mano imitando su brillo',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 24),
          successOutcome: EventOutcome(
            description:
                'El espíritu elemental responde con un tintineo armonioso.',
            statDelta: StatDelta(intellect: 5, mood: 5),
          ),
          failureOutcome: EventOutcome(
            description:
                'El destello frío te sobresalta y regresas gateando adentro.',
            statDelta: StatDelta(mood: -3, health: -2),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'early_two_tailed_cat',
      stage: LifeStage.earlyChildhood,
      title: 'El Gato de Dos Colas',
      narrativeBuilder: (_, _) => 'Un gato montés de pelaje plateado y dos colas se posa en el alféizar observándote con ojos inteligentes.',
      choices: const [
        EventChoice(
          id: 'share_milk_crumb',
          label: 'Ofrecerle un trocito de queso en silencio',
          successOutcome: EventOutcome(
            description:
                'La criatura ronronea y deja caer una piedrecilla brillante.',
            statDelta: StatDelta(emotionalIntelligence: 5, mood: 5),
            copperDelta: 12,
          ),
        ),
        EventChoice(
          id: 'try_catch_tail',
          label: 'Intentar agarrar sus dos colas juguetón',
          statCheck: StatCheck(stat: StatType.combatSkill, requiredScore: 10),
          successOutcome: EventOutcome(
            description: 'El felino esquiva de un brinco pero te deja rascarle tras la oreja.',
            statDelta: StatDelta(combatSkill: 3, strength: 2, mood: 4),
          ),
          failureOutcome: EventOutcome(
            description: 'Te da un zarpazo suave de advertencia antes de saltar al tejado.',
            statDelta: StatDelta(health: -4, mood: -3),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'early_rune_dreams',
      stage: LifeStage.earlyChildhood,
      title: 'Sueños de Runas Brillantes',
      narrativeBuilder: (_, _) => 'Mientras duermes profundamente, líneas luminosas flotan en tus sueños mezclando recuerdos de tu antigua vida con el aire mágico de este mundo.',
      choices: const [
        EventChoice(
          id: 'follow_runes',
          label: 'Seguir el trazo de las runas en sueños',
          successOutcome: EventOutcome(
            description: 'Despiertas con la mente sorprendentemente despejada.',
            statDelta: StatDelta(intellect: 5, emotionalIntelligence: 3),
          ),
        ),
        EventChoice(
          id: 'sleep_deeply',
          label: 'Abandonarte al descanso cálido sin pensar',
          successOutcome: EventOutcome(
            description: 'Amaneces rebosante de energía y buen humor.',
            statDelta: StatDelta(health: 5, mood: 6),
          ),
        ),
      ],
    ),

    // --- Niñez (+3 -> total 13) ---
    GameEventDefinition(
      id: 'child_blue_slime',
      stage: LifeStage.childhood,
      title: 'Limo Azul en el Estanque',
      narrativeBuilder: (hero, _) =>
          'Junto al lavadero de ${hero.villageName}, un pequeño limo translúcido devora restos de fruta antes de que nadie lo vea.',
      choices: const [
        EventChoice(
          id: 'poke_slime_stick',
          label: 'Despejarlo con una vara y proteger el agua',
          statCheck: StatCheck(stat: StatType.combatSkill, requiredScore: 18),
          successOutcome: EventOutcome(
            description: 'Dispersas el núcleo del limo y recoges una gema menor vendible.',
            statDelta: StatDelta(combatSkill: 5, strength: 3),
            copperDelta: 40,
          ),
          failureOutcome: EventOutcome(
            description:
                'El limo salpica ácido leve sobre tus manos antes de huir.',
            statDelta: StatDelta(health: -7, mood: -4),
          ),
        ),
        EventChoice(
          id: 'capture_in_jar',
          label: 'Atraerlo a un tarro de barro con miel',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 30),
          successOutcome: EventOutcome(
            description:
                'El boticario compra el limo íntegro para sus filtros mágicos.',
            statDelta: StatDelta(intellect: 5, mood: 4),
            copperDelta: 55,
          ),
          failureOutcome: EventOutcome(
            description:
                'El tarro se resbala y el limo escapa entre los juncos.',
            statDelta: StatDelta(mood: -3),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'child_mana_crystal_peddler',
      stage: LifeStage.childhood,
      title: 'El Buhonero de Cristales de Maná',
      narrativeBuilder: (_, npc) =>
          'El mercader $npc exhibe en su carro esquirlas de cristal luminoso traídas de la Torre Arcana.',
      choices: const [
        EventChoice(
          id: 'buy_mana_shard',
          label: 'Comprar una esquirla para entrenar (40 Cobre)',
          minCopperRequired: 40,
          successOutcome: EventOutcome(
            description: 'Absorbes su tenue resonancia mágica fortaleciendo mente y vitalidad.',
            statDelta: StatDelta(intellect: 4, mana: 5, mood: 4),
            copperDelta: -40,
          ),
        ),
        EventChoice(
          id: 'ask_arcane_lore',
          label: 'Preguntar por la Torre Arcana y las criaturas mágicas',
          successOutcome: EventOutcome(
            description: 'El viajero te cuenta leyendas sobre el Rey Demonio y los magos.',
            statDelta: StatDelta(intellect: 4, emotionalIntelligence: 3),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'child_dryad_whispers',
      stage: LifeStage.childhood,
      title: 'Susurros de la Dríade del Bosque',
      requiresManaAwakened: true,
      narrativeBuilder: (_, _) => 'Al percibir tu maná recién despertado, una dríade de corteza esmeralda asoma entre los sauces ofreciéndote una prueba de armonía.',
      choices: const [
        EventChoice(
          id: 'resonate_mana_dryad',
          label: 'Sincronizar tu maná con las hojas del bosque',
          statCheck: StatCheck(stat: StatType.mana, requiredScore: 28),
          successOutcome: EventOutcome(
            description:
                'Un hilo de luz verde envuelve tus manos expandiendo tu maná.',
            statDelta: StatDelta(mana: 9, health: 4, mood: 7),
          ),
          failureOutcome: EventOutcome(
            description: 'La energía silvestre te marea levemente antes de desvanecerse.',
            statDelta: StatDelta(mana: 3, mood: -4),
          ),
        ),
        EventChoice(
          id: 'bow_respectfully',
          label: 'Inclinarte con respeto y escuchar su canto',
          successOutcome: EventOutcome(
            description: 'La dríade bendice tu calma emocional y desaparece en el tronco.',
            statDelta: StatDelta(emotionalIntelligence: 6, mood: 5),
          ),
        ),
      ],
    ),

    // --- Adolescencia (+3 -> total 13) ---
    GameEventDefinition(
      id: 'adol_winged_beast',
      stage: LifeStage.adolescence,
      title: 'Bestia Alada Sobre el Valle',
      narrativeBuilder: (hero, _) =>
          'Un grifo joven herido planea en círculos sobre los pastos de ${hero.villageName} buscando refugio o presa.',
      choices: const [
        EventChoice(
          id: 'drive_griffin_away',
          label: 'Espantarlo con flechas incendiarias y gritos',
          statCheck: StatCheck(stat: StatType.combatSkill, requiredScore: 36),
          successOutcome: EventOutcome(
            description: 'La bestia remonta el vuelo dejando caer una pluma mágica valiosa.',
            statDelta: StatDelta(combatSkill: 7, mood: 6),
            copperDelta: 180,
          ),
          failureOutcome: EventOutcome(
            description:
                'Una ráfaga de sus alas te arroja contra la cerca de madera.',
            statDelta: StatDelta(health: -12, mood: -5),
          ),
        ),
        EventChoice(
          id: 'leave_meat_distraction',
          label: 'Lanzar despojos lejos del ganado para evitar combate',
          successOutcome: EventOutcome(
            description:
                'La criatura toma la ofrenda y se aleja sin causar bajas.',
            statDelta: StatDelta(intellect: 5, emotionalIntelligence: 4),
            copperDelta: 60,
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'adol_lost_mage_apprentice',
      stage: LifeStage.adolescence,
      title: 'El Aprendiz de Mago Perdido',
      requiresManaAwakened: true,
      narrativeBuilder: (_, npc) =>
          'El joven aprendiz $npc de la Torre Arcana se extravió buscando hierbas rúnicas y pide intercambiar apuntes de conjuros.',
      choices: const [
        EventChoice(
          id: 'exchange_mana_theory',
          label: 'Practicar un hechizo de chispa luminosa junto a él',
          statCheck: StatCheck(stat: StatType.mana, requiredScore: 38),
          successOutcome: EventOutcome(
            description: 'Canalizas el maná con precisión y él te regala un grimorio básico.',
            statDelta: StatDelta(mana: 8, intellect: 5, mood: 6),
            copperDelta: 120,
          ),
          failureOutcome: EventOutcome(
            description:
                'El conjuro chisporrotea sin fuerza, pero aprendes la teoría.',
            statDelta: StatDelta(mana: 3, intellect: 2),
          ),
        ),
        EventChoice(
          id: 'guide_back_road',
          label: 'Acompañarlo hasta el camino real por una propina',
          successOutcome: EventOutcome(
            description:
                'Agradece tu ayuda con monedas de plata y elogios al gremio.',
            statDelta: StatDelta(emotionalIntelligence: 4, mood: 4),
            copperDelta: 140,
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'adol_kingdom_recruiters',
      stage: LifeStage.adolescence,
      title: 'Rumores de Reclutas del Reino',
      narrativeBuilder: (_, npc) =>
          'En la posada, soldados reales comandados por $npc comentan cómo el reino busca jóvenes promesas ante las grietas del sello demoníaco.',
      choices: const [
        EventChoice(
          id: 'spar_with_soldier',
          label: 'Pedir un entrenamiento breve con uno de los soldados',
          statCheck: StatCheck(stat: StatType.combatSkill, requiredScore: 34),
          successOutcome: EventOutcome(
            description:
                'Impresionas al sargento y te enseña cortes militares.',
            statDelta: StatDelta(combatSkill: 6, strength: 3, mood: 5),
          ),
          failureOutcome: EventOutcome(
            description:
                'Te derriba en segundos, aunque te anima a seguir entrenando.',
            statDelta: StatDelta(combatSkill: 3, health: -5),
          ),
        ),
        EventChoice(
          id: 'listen_world_news',
          label: 'Invitarles una jarra para conocer el estado de los reinos',
          successOutcome: EventOutcome(
            description: 'Comprendes mejor la geografía política y los peligros del continente.',
            statDelta: StatDelta(intellect: 4, emotionalIntelligence: 4),
          ),
        ),
      ],
    ),

    // --- Juventud (+3 -> total 13) ---
    GameEventDefinition(
      id: 'youth_gargoyle_caravan',
      stage: LifeStage.youth,
      title: 'Caravana Atacada por Gárgolas',
      narrativeBuilder: (_, npc) =>
          'Gárgolas de piedra animadas por miasma descienden sobre los carros del mercader $npc en el paso montañoso.',
      choices: const [
        EventChoice(
          id: 'shatter_gargoyles',
          label: 'Romper su caparazón con golpes certeros',
          statCheck: StatCheck(stat: StatType.strength, requiredScore: 50),
          successOutcome: EventOutcome(
            description: 'Destrozas sus núcleos mágicos y cobras una espléndida bolsa de plata.',
            statDelta: StatDelta(strength: 6, combatSkill: 4, mood: 6),
            copperDelta: 550,
          ),
          failureOutcome: EventOutcome(
            description: 'Las garras pétreas hieren tu hombro antes de que la escolta las abata.',
            statDelta: StatDelta(health: -15, mood: -6),
            copperDelta: 100,
          ),
        ),
        EventChoice(
          id: 'lure_into_ravine',
          label: 'Atraerlas hacia un desfiladero estrecho con espejos y fuego',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 50),
          successOutcome: EventOutcome(
            description:
                'Quedan atascadas entre las rocas y salvas toda la carga.',
            statDelta: StatDelta(intellect: 6, mood: 6),
            copperDelta: 480,
          ),
          failureOutcome: EventOutcome(
            description:
                'El plan falla parcialmente y se pierde parte de los víveres.',
            statDelta: StatDelta(mood: -5),
            copperDelta: 90,
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'youth_unstable_mana_crystal',
      stage: LifeStage.youth,
      title: 'Cristal de Maná Inestable',
      requiresManaAwakened: true,
      narrativeBuilder: (_, _) => 'En un cruce de caminos vibra un obelisco de cristal agrietado que amenaza con estallar en una onda arcana.',
      choices: const [
        EventChoice(
          id: 'stabilize_crystal_mana',
          label: 'Canalizar tu propio maná para equilibrar el flujo',
          statCheck: StatCheck(stat: StatType.mana, requiredScore: 48),
          successOutcome: EventOutcome(
            description: 'Domina la corriente arcana; tu reserva de maná crece enormemente.',
            statDelta: StatDelta(mana: 10, intellect: 4, mood: 7),
            copperDelta: 420,
          ),
          failureOutcome: EventOutcome(
            description: 'Una descarga violenta te lanza hacia atrás quemando tus ropas.',
            statDelta: StatDelta(health: -14, mana: 2, mood: -6),
          ),
        ),
        EventChoice(
          id: 'evacuate_travelers',
          label: 'Evacuar la zona y avisar a la orden arcana',
          successOutcome: EventOutcome(
            description:
                'Nadie sale herido y los magos agradecen tu prudencia.',
            statDelta: StatDelta(emotionalIntelligence: 5, mood: 4),
            copperDelta: 180,
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'youth_hero_candidate_encounter',
      stage: LifeStage.youth,
      title: 'Encuentro con un Aspirante a Héroe',
      narrativeBuilder: (_, npc) =>
          'En una posada conoces a $npc, un joven espadachín elegido por su ducado para las pruebas del Grupo de Héroes.',
      choices: const [
        EventChoice(
          id: 'friendly_match_hero',
          label: 'Proponer un combate amistoso de práctica',
          statCheck: StatCheck(stat: StatType.combatSkill, requiredScore: 50),
          successOutcome: EventOutcome(
            description: 'Tu nivel sorprende al aspirante; intercambian técnicas y respeto.',
            statDelta: StatDelta(combatSkill: 7, mood: 7),
          ),
          failureOutcome: EventOutcome(
            description: 'Te supera por velocidad, pero comprendes el estándar de los héroes.',
            statDelta: StatDelta(combatSkill: 4, health: -5),
          ),
        ),
        EventChoice(
          id: 'share_world_perspective',
          label: 'Conversar sobre el peso de la profecía del Rey Demonio',
          successOutcome: EventOutcome(
            description: 'Tu madurez serena le da fuerzas y forjan una amistad duradera.',
            statDelta: StatDelta(emotionalIntelligence: 6, mood: 5),
          ),
        ),
      ],
    ),

    // --- Adultez (+3 -> total 13) ---
    GameEventDefinition(
      id: 'adult_demonic_miasma_fissure',
      stage: LifeStage.adulthood,
      title: 'Fisura de Miasma Demoníaco',
      narrativeBuilder: (_, _) => 'Una grieta humeante se abre en el suelo del páramo emitiendo niebla corrupta y espectros menores.',
      choices: const [
        EventChoice(
          id: 'seal_with_mana',
          label: 'Cerrar la fisura proyectando un sello de maná',
          statCheck: StatCheck(stat: StatType.mana, requiredScore: 58),
          successOutcome: EventOutcome(
            description: 'Tu conjuro purifica la brecha; los reinos premian la hazaña en oro.',
            statDelta: StatDelta(mana: 7, mood: 8),
            copperDelta: 11000,
          ),
          failureOutcome: EventOutcome(
            description:
                'El miasma quema tus pulmones antes de que logres contenerla.',
            statDelta: StatDelta(health: -16, mood: -7),
          ),
        ),
        EventChoice(
          id: 'collapse_with_boulders',
          label: 'Derrumbar el talud rocoso sobre la grieta',
          statCheck: StatCheck(stat: StatType.strength, requiredScore: 58),
          successOutcome: EventOutcome(
            description: 'Sepultas la brecha bajo toneladas de piedra salvando la comarca.',
            statDelta: StatDelta(strength: 5, mood: 7),
            copperDelta: 8500,
          ),
          failureOutcome: EventOutcome(
            description: 'Un espectro te hiere antes de completar el derrumbe.',
            statDelta: StatDelta(health: -14, mood: -5),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'adult_arcane_relic_auction',
      stage: LifeStage.adulthood,
      title: 'Subasta de Reliquia Arcana',
      narrativeBuilder: (_, npc) =>
          'El coleccionista $npc organiza una puja discreta por un báculo rúnico recuperado de una ruina élfica.',
      choices: const [
        EventChoice(
          id: 'appraise_fake_relic',
          label: 'Examinar la autenticidad de las runas antes de pujar',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 60),
          successOutcome: EventOutcome(
            description: 'Detectas una pieza genuina subestimada y la revendes con enorme ganancia.',
            statDelta: StatDelta(intellect: 6, mood: 8),
            copperDelta: 13000,
          ),
          failureOutcome: EventOutcome(
            description: 'Cometes un error de cálculo y pierdes la fianza de la subasta.',
            statDelta: StatDelta(mood: -6),
            copperDelta: -500,
          ),
        ),
        EventChoice(
          id: 'bid_five_silver',
          label: 'Pujar 5 Platas por tomos de estudio complementarios',
          minCopperRequired: 500,
          successOutcome: EventOutcome(
            description: 'Adquieres tratados valiosos que elevan tu saber y reserva mágica.',
            statDelta: StatDelta(intellect: 6, mana: 5),
            copperDelta: -500,
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'adult_abyss_deserters',
      stage: LifeStage.adulthood,
      title: 'Desertores del Frente del Abismo',
      narrativeBuilder: (_, npc) =>
          'Tres soldados agotados liderados por $npc huyen de las batallas contra las huestes demoníacas buscando refugio.',
      choices: const [
        EventChoice(
          id: 'counsel_deserters',
          label: 'Escuchar su trauma y guiarlos a una labor segura',
          statCheck: StatCheck(
            stat: StatType.emotionalIntelligence,
            requiredScore: 60,
          ),
          successOutcome: EventOutcome(
            description: 'Evitas un conflicto y los integras protegiendo los caminos locales.',
            statDelta: StatDelta(emotionalIntelligence: 7, mood: 6),
            copperDelta: 450,
          ),
          failureOutcome: EventOutcome(
            description: 'Desconfían de ti y huyen durante la noche robando provisiones.',
            statDelta: StatDelta(mood: -6),
            copperDelta: -250,
          ),
        ),
        EventChoice(
          id: 'disarm_renegades',
          label: 'Reducirlos si intentan saquear la posada',
          statCheck: StatCheck(stat: StatType.combatSkill, requiredScore: 60),
          successOutcome: EventOutcome(
            description: 'Impones orden sin matar a nadie y recibes recompensa del alguacil.',
            statDelta: StatDelta(combatSkill: 5, mood: 4),
            copperDelta: 900,
          ),
          failureOutcome: EventOutcome(
            description: 'En la desesperación logran herirte antes de escapar.',
            statDelta: StatDelta(health: -14, mood: -5),
          ),
        ),
      ],
    ),

    // --- Vejez (+3 -> total 13) ---
    GameEventDefinition(
      id: 'old_young_mage_pupil',
      stage: LifeStage.oldAge,
      title: 'Joven Mago en Busca de Guía',
      requiresManaAwakened: true,
      narrativeBuilder: (_, npc) =>
          'Un joven hechicero llamado $npc acude a ti tras oír historias sobre la singular pureza de tu maná.',
      choices: const [
        EventChoice(
          id: 'teach_mana_control',
          label: 'Instruirle en el control fino del maná',
          statCheck: StatCheck(stat: StatType.mana, requiredScore: 55),
          successOutcome: EventOutcome(
            description: 'Tu enseñanza inspira a una nueva generación y te colma de dicha.',
            statDelta: StatDelta(mana: 4, mood: 10, emotionalIntelligence: 4),
            copperDelta: 1200,
          ),
          failureOutcome: EventOutcome(
            description: 'El esfuerzo mágico fatiga tu cuerpo cansado aunque él aprende.',
            statDelta: StatDelta(health: -7, mood: 2),
          ),
        ),
        EventChoice(
          id: 'gift_old_notes',
          label: 'Entregarle tus anotaciones y desearle buen viaje',
          successOutcome: EventOutcome(
            description: 'Parte agradecido dejándote unas monedas de plata.',
            statDelta: StatDelta(mood: 6, emotionalIntelligence: 4),
            copperDelta: 600,
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'old_demon_king_relic',
      stage: LifeStage.oldAge,
      title: 'Reliquia del Rey Demonio',
      narrativeBuilder: (_, npc) =>
          'Un anticuario llamado $npc trae un fragmento sellado de armadura abisal hallado tras la gran guerra, pidiendo tu consejo.',
      choices: const [
        EventChoice(
          id: 'seal_at_temple',
          label: 'Exigir que sea sellado bajo custodia del templo',
          successOutcome: EventOutcome(
            description: 'Tu prudencia evita futuras tragedias; el templo te honra en oro.',
            statDelta: StatDelta(emotionalIntelligence: 5, mood: 7),
            copperDelta: 10000,
          ),
        ),
        EventChoice(
          id: 'study_abyss_metal',
          label: 'Analizar el metal oscuro con cuidado extremo',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 60),
          successOutcome: EventOutcome(
            description: 'Descubres cómo neutralizar su miasma y vendes la fórmula a la Torre.',
            statDelta: StatDelta(intellect: 5, mood: 7),
            copperDelta: 12000,
          ),
          failureOutcome: EventOutcome(
            description:
                'Un resto de miasma debilita tu respiración durante días.',
            statDelta: StatDelta(health: -12, mood: -5),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'old_forest_spirit_blessing',
      stage: LifeStage.oldAge,
      title: 'Bendición del Espíritu del Bosque',
      narrativeBuilder: (hero, _) =>
          'Mientras paseas por los linderos tranquilos, un antiguo espíritu silvestre reconoce la larga vida que has recorrido desde ${hero.villageName}.',
      choices: const [
        EventChoice(
          id: 'accept_nature_vitality',
          label: 'Recibir el aliento sereno del bosque',
          successOutcome: EventOutcome(
            description:
                'Una calidez verde renueva tu vitalidad y calma tus dolencias.',
            statDelta: StatDelta(health: 9, mood: 9),
          ),
        ),
        EventChoice(
          id: 'share_memories_of_world',
          label: 'Contarle tus recuerdos de los dos mundos',
          successOutcome: EventOutcome(
            description: 'El espíritu escucha con reverencia dejando en ti una paz luminosa.',
            statDelta: StatDelta(emotionalIntelligence: 6, mood: 10),
          ),
        ),
      ],
    ),

    // =========================================================================
    // EVENTOS ESCOLARES (+6 -> 84 eventos en total)
    // =========================================================================
    GameEventDefinition(
      id: 'school_arithmetic_exam',
      stage: LifeStage.childhood,
      title: 'Examen de Aritmética y Letras',
      requiresEnrolledInSchool: true,
      narrativeBuilder: (_, npc) =>
          'El maestro $npc reparte tablillas de cera con problemas de cálculo comercial y dictado para evaluar a la clase.',
      choices: const [
        EventChoice(
          id: 'solve_with_modern_math',
          label: 'Aplicar métodos rápidos de cálculo de tu otra vida',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 34),
          successOutcome: EventOutcome(
            description:
                'Terminas primero con la nota más alta y recibes un premio del maestro.',
            statDelta: StatDelta(intellect: 7, knowledge: 10, mood: 6),
            copperDelta: 45,
          ),
          failureOutcome: EventOutcome(
            description:
                'Te confundes al convertir monedas antiguas y sacas nota justa.',
            statDelta: StatDelta(intellect: 3, mood: -4),
          ),
        ),
        EventChoice(
          id: 'help_classmate_study',
          label: 'Repasar tranquilamente y ayudar a tu compañero de banco',
          successOutcome: EventOutcome(
            description:
                'Ambos aprueban con soltura y ganas respeto en el aula.',
            statDelta: StatDelta(
              intellect: 4,
              knowledge: 6,
              emotionalIntelligence: 4,
            ),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'school_classroom_rivalry',
      stage: LifeStage.childhood,
      title: 'Rivalidad en el Aula',
      requiresEnrolledInSchool: true,
      narrativeBuilder: (_, npc) =>
          '$npc, hijo de un mercader acomodado, presume de sus libros caros y se burla de tus ropas humildes en el patio escolar.',
      choices: const [
        EventChoice(
          id: 'outshine_in_recitation',
          label: 'Superarlo recitando los mapas e historia de memoria',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 36),
          successOutcome: EventOutcome(
            description:
                'Toda la clase aplaude tu elocuencia y el rival guarda silencio.',
            statDelta: StatDelta(intellect: 5, knowledge: 8, mood: 6),
          ),
          failureOutcome: EventOutcome(
            description:
                'Te trabas ante las risas, aunque prometes estudiar más duro.',
            statDelta: StatDelta(mood: -5, intellect: 2),
          ),
        ),
        EventChoice(
          id: 'respond_with_dignity',
          label: 'Responder con serenidad sin caer en provocaciones',
          statCheck: StatCheck(
            stat: StatType.emotionalIntelligence,
            requiredScore: 32,
          ),
          successOutcome: EventOutcome(
            description:
                'Tu madurez deja en ridículo su arrogancia ante todos.',
            statDelta: StatDelta(emotionalIntelligence: 6, mood: 5),
          ),
          failureOutcome: EventOutcome(
            description:
                'El cruce de palabras te amarga la jornada escolar.',
            statDelta: StatDelta(mood: -6),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'school_mana_theory_class',
      stage: LifeStage.childhood,
      title: 'Clase de Teoría del Maná',
      requiresEnrolledInSchool: true,
      requiresManaAwakened: true,
      narrativeBuilder: (_, _) =>
          'Un clérigo invitado enseña en la escuela los fundamentos elementales sobre los círculos mágicos y el flujo del maná.',
      choices: const [
        EventChoice(
          id: 'practice_light_spark',
          label: 'Intentar encender una chispa azul sobre tu dedo',
          statCheck: StatCheck(stat: StatType.mana, requiredScore: 30),
          successOutcome: EventOutcome(
            description:
                'Una llama azul clara baila sobre tu mano causando admiración.',
            statDelta: StatDelta(mana: 7, magicPower: 10, knowledge: 8, mood: 7),
          ),
          failureOutcome: EventOutcome(
            description:
                'Solo logras un leve chispazo, pero comprendes mejor el principio.',
            statDelta: StatDelta(mana: 3, intellect: 3),
          ),
        ),
        EventChoice(
          id: 'take_detailed_notes',
          label: 'Tomar apuntes minuciosos sobre los diagramas rúnicos',
          successOutcome: EventOutcome(
            description:
                'Guardas valiosos esquemas que serán útiles al crecer.',
            statDelta: StatDelta(intellect: 5, knowledge: 10),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'school_county_debate',
      stage: LifeStage.adolescence,
      title: 'Debate Escolar de la Comarca',
      requiresEnrolledInSchool: true,
      narrativeBuilder: (_, npc) =>
          'Tu escuela compite contra la villa vecina en un certamen de retórica, leyes y estrategia moderado por el juez $npc.',
      choices: const [
        EventChoice(
          id: 'present_civic_argument',
          label: 'Defender una reforma práctica basada en tu saber',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 44),
          successOutcome: EventOutcome(
            description:
                'El jurado otorga el primer premio a tu escuela con bolsa de plata.',
            statDelta: StatDelta(intellect: 6, knowledge: 25, mood: 7),
            copperDelta: 160,
          ),
          failureOutcome: EventOutcome(
            description:
                'Los jueces conservadores no comprenden tus ideas novedosas.',
            statDelta: StatDelta(knowledge: 10, mood: -4),
          ),
        ),
        EventChoice(
          id: 'sway_audience_empathy',
          label: 'Apelar a las necesidades reales de los aldeanos',
          statCheck: StatCheck(
            stat: StatType.emotionalIntelligence,
            requiredScore: 42,
          ),
          successOutcome: EventOutcome(
            description:
                'Conmueves al público y recibes una mención de honor.',
            statDelta: StatDelta(emotionalIntelligence: 6, knowledge: 18, mood: 6),
            copperDelta: 110,
          ),
          failureOutcome: EventOutcome(
            description:
                'Tu discurso queda corto frente a los oradores rivales.',
            statDelta: StatDelta(mood: -4, emotionalIntelligence: 2),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'school_masters_books',
      stage: LifeStage.adolescence,
      title: 'Los Libros del Maestro',
      requiresEnrolledInSchool: true,
      narrativeBuilder: (_, npc) =>
          'El maestro $npc te confía la llave de su biblioteca privada para catalogar viejos volúmenes de geografía, historia y magia.',
      choices: const [
        EventChoice(
          id: 'study_night_volumes',
          label: 'Leer a fondo los tomos de historia y estrategia',
          successOutcome: EventOutcome(
            description:
                'Absorbes décadas de saber acumulado en los estantes.',
            statDelta: StatDelta(intellect: 5, knowledge: 35, mood: 4),
          ),
        ),
        EventChoice(
          id: 'copy_arcane_treatise',
          label: 'Transcribir y estudiar un tratado antiguo de energía mágica',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 42),
          successOutcome: EventOutcome(
            description:
                'Entiendes fórmulas avanzadas que potencian tu maná y poder mágico.',
            statDelta: StatDelta(magicPower: 30, mana: 12, knowledge: 20),
          ),
          failureOutcome: EventOutcome(
            description:
                'La caligrafía arcaica te da jaqueca y apenas descifras unas páginas.',
            statDelta: StatDelta(knowledge: 10, mood: -3),
          ),
        ),
      ],
    ),
    GameEventDefinition(
      id: 'school_council_scholarship',
      stage: LifeStage.adolescence,
      title: 'Beca del Concejo Escolar',
      requiresEnrolledInSchool: true,
      narrativeBuilder: (hero, _) =>
          'El concejo de ${hero.villageName} ofrece una ayuda en plata al alumno más aplicado para costear materiales y estudio.',
      choices: const [
        EventChoice(
          id: 'apply_merit_scholarship',
          label: 'Presentar tus calificaciones y examen práctico',
          statCheck: StatCheck(stat: StatType.intellect, requiredScore: 45),
          successOutcome: EventOutcome(
            description:
                'Obtienes la beca completa y un lote de pergaminos selectos.',
            statDelta: StatDelta(intellect: 5, knowledge: 25, mood: 8),
            copperDelta: 300,
          ),
          failureOutcome: EventOutcome(
            description:
                'Quedas segundo tras el hijo del escribano, aunque te dan un accésit.',
            statDelta: StatDelta(knowledge: 10, mood: -3),
            copperDelta: 60,
          ),
        ),
        EventChoice(
          id: 'tutor_younger_pupils',
          label: 'Dar tutorías a los niños menores por una paga fija',
          successOutcome: EventOutcome(
            description:
                'Enseñar consolida tus propios conocimientos y ganas plata.',
            statDelta: StatDelta(
              knowledge: 18,
              emotionalIntelligence: 4,
              mood: 4,
            ),
            copperDelta: 150,
          ),
        ),
      ],
    ),
  ];

  /// Devuelve los eventos pertenecientes a una etapa concreta.
  static List<GameEventDefinition> eventsForStage(LifeStage stage) {
    return all.where((e) => e.stage == stage).toList();
  }

  /// Elige un evento de la etapa actual, priorizando los aún no vistos.
  static ActiveGameEvent? pickEventForStage(
    LifeStage stage,
    Protagonist hero,
    Set<String> seenEventIds,
    Random rng, {
    bool isEnrolledInSchool = false,
  }) {
    final stageEvents = eventsForStage(stage)
        .where(
          (e) =>
              (!e.requiresManaAwakened || hero.manaAwakened) &&
              (!e.requiresEnrolledInSchool || isEnrolledInSchool),
        )
        .toList();
    if (stageEvents.isEmpty) return null;

    final unseen = stageEvents
        .where((e) => !seenEventIds.contains(e.id))
        .toList();
    final pool = unseen.isNotEmpty ? unseen : stageEvents;
    final picked = pool[rng.nextInt(pool.length)];
    final npcName = pickRandomNpcName(rng);

    return ActiveGameEvent(
      eventId: picked.id,
      stage: picked.stage,
      title: picked.title,
      narrative: picked.narrativeBuilder(hero, npcName),
      npcName: npcName,
      choices: picked.choices,
    );
  }
}
