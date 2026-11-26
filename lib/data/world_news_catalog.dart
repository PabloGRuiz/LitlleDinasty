import 'dart:math';

import '../models/world_state.dart';

/// Generador de noticias independientes del mundo vivo según la era y amenaza.
class WorldNewsCatalog {
  WorldNewsCatalog._();

  static const List<({String headline, String details})> _quietNews = [
    (
      headline: 'Caravanas arcanas cruzan el reino',
      details:
          'Mercaderes escoltados por magos menores comercian cristales luminosos sin incidentes.',
    ),
    (
      headline: 'Avistamiento de ciervos blancos en el bosque',
      details:
          'Los druidas consideran la aparición de estas bestias mágicas un augurio de buenas cosechas.',
    ),
    (
      headline: 'Torneo anual en la Capital Real',
      details:
          'Espadachines y hechiceros jóvenes compiten por becas en el Gremio Central.',
    ),
  ];

  static const List<({String headline, String details})> _rumorNews = [
    (
      headline: 'Manadas de lobos espectrales inquietas',
      details:
          'Las patrullas fronterizas reportan criaturas desplazándose hacia el sur sin motivo aparente.',
    ),
    (
      headline: 'Templos refuerzan las rondas de detección mágica',
      details:
          'Sacerdotes itinerantes visitan aldeas remotas buscando jóvenes con afinidad de maná.',
    ),
    (
      headline: 'Subida en el precio del hierro encantado',
      details:
          'Los herreros reales acumulan lingotes ante rumores de escaramuzas en los límites.',
    ),
  ];

  static const List<({String headline, String details})> _summonsNews = [
    (
      headline: 'Edicto de los Tres Reinos: Buscan al Grupo de Héroes',
      details:
          'Pregoneros anuncian recompensas y honores para guerreros y magos capaces de enfrentar el sello agrietado.',
    ),
    (
      headline: 'Gárgolas vistas sobre los pasos montañosos',
      details:
          'Los gremios recomiendan viajar en convoy armado entre la Villa Fronteriza y la Capital.',
    ),
    (
      headline: 'La Torre Arcana abre sus cámaras de prueba',
      details:
          'Hechiceros destacados entrenan conjuros de barrera y purificación contra el miasma.',
    ),
  ];

  static const List<({String headline, String details})> _warNews = [
    (
      headline: 'El Grupo de Héroes marcha hacia el Abismo',
      details:
          'Los campeones elegidos por la corona combaten vanguardias demoníacas en la Frontera.',
    ),
    (
      headline: 'Lluvias de ceniza en las provincias del norte',
      details:
          'Las órdenes de caballería y aventureros de rango alto contienen brechas de criaturas oscuras.',
    ),
    (
      headline: 'Escasez de elixires curativos en las ciudades',
      details:
          'Alquimistas y templos trabajan día y noche asistiendo a los heridos del frente.',
    ),
  ];

  static const List<({String headline, String details})> _newDawnNews = [
    (
      headline: 'Reconstrucción de las rutas reales',
      details:
          'Las caravanas vuelven a circular libremente tras el retroceso de las huestes del Abismo.',
    ),
    (
      headline: 'Bardos cantan la gesta del fin del Rey Demonio',
      details:
          'Las tabernas del continente celebran historias de héroes, magos y aldeanos valientes.',
    ),
  ];

  static WorldNewsEntry pickNews({
    required WorldEra era,
    required int year,
    required int month,
    required Random rng,
  }) {
    final List<({String headline, String details})> pool;
    switch (era) {
      case WorldEra.quietEra:
        pool = _quietNews;
      case WorldEra.shadowRumors:
      case WorldEra.crackedSeal:
        pool = _rumorNews;
      case WorldEra.heroesSummons:
        pool = _summonsNews;
      case WorldEra.demonWar:
        pool = _warNews;
      case WorldEra.newDawn:
        pool = _newDawnNews;
    }

    final item = pool[rng.nextInt(pool.length)];
    return WorldNewsEntry(
      id: 'news_${year}_${month}_${rng.nextInt(99999)}',
      year: year,
      month: month,
      headline: item.headline,
      details: item.details,
    );
  }
}

