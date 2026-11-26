import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/events_catalog.dart';
import '../models/character.dart';
import '../models/currency.dart';
import '../models/life_stage.dart';
import '../models/profession.dart';
import '../models/stats.dart';
import '../models/world_state.dart';
import '../providers/life_provider.dart';
import '../theme/medieval_theme.dart';
import 'world_dialog.dart';

/// Vista principal de la ficha del protagonista, su etapa actual y sus 6 atributos.
class HeroLifeView extends ConsumerWidget {
  const HeroLifeView({super.key, this.onOpenSemesterTab});

  final VoidCallback? onOpenSemesterTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lifeProvider);
    final notifier = ref.read(lifeProvider.notifier);
    final hero = state.hero;
    final stage = hero.lifeStage;

    final stageEvents = EventsCatalog.eventsForStage(stage);
    final livedInStage =
        stageEvents.where((e) => state.seenEventIds.contains(e.id)).length;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            MedievalColors.meadowMist,
            MedievalColors.parchmentBg,
          ],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
        children: [
          if (state.isGameOver) ...[
            Card(
              color: MedievalColors.crimsonSealBg,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    const Icon(
                      Icons.hourglass_disabled_rounded,
                      size: 32,
                      color: MedievalColors.crimsonSeal,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Fin de tu Vida Medieval',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: MedievalColors.crimsonSeal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.causeOfDeath ??
                          'Has concluido tu viaje en este mundo.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12.5),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Viviste ${hero.age} años (${hero.birthYear}–${hero.deathYear ?? state.year}) · Fortuna final: ${state.currency.formatCompact()}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: MedievalColors.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: notifier.requestNewLife,
                      icon: const Icon(Icons.replay_rounded),
                      label: const Text('Renacer de Nuevo'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Tarjeta de retrato y etapa vital
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: MedievalColors.meadowMist,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: MedievalColors.borderWood,
                        width: 1.5,
                      ),
                    ),
                    child: CustomPaint(
                      painter: MedievalAvatarPainter(hero: hero),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              stage.icon,
                              size: 16,
                              color: MedievalColors.forestGreen,
                            ),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                '${stage.label} (${stage.ageRangeLabel})',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: MedievalColors.forestGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Padre: ${hero.fatherName}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: MedievalColors.inkDark,
                          ),
                        ),
                        Text(
                          'Madre: ${hero.motherName}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: MedievalColors.inkDark,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: MedievalColors.amberOchreBg,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: MedievalColors.amberOchre
                                      .withValues(alpha: 0.4),
                                ),
                              ),
                              child: Text(
                                'Eventos: $livedInStage/${stageEvents.length}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: MedievalColors.amberOchre,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: state.profession == ProfessionId.none
                                    ? MedievalColors.parchmentBg
                                    : MedievalColors.royalBlueBg,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: state.profession == ProfessionId.none
                                      ? MedievalColors.borderWood
                                      : MedievalColors.royalBlue
                                          .withValues(alpha: 0.5),
                                ),
                              ),
                              child: Text(
                                state.profession == ProfessionId.adventurer
                                    ? 'Aventurero (${state.adventurerRank.label.split(' · ').first})'
                                    : 'Sin oficio',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: state.profession == ProfessionId.none
                                      ? MedievalColors.inkMuted
                                      : MedievalColors.royalBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          if (state.hasSemesterActionAvailable && onOpenSemesterTab != null) ...[
            Card(
              color: MedievalColors.forestGreenBg,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: onOpenSemesterTab,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.event_available_rounded,
                        size: 20,
                        color: MedievalColors.forestGreen,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Tienes disponible tu objetivo de este semestre. Toca para elegir qué entrenar o estudiar.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: MedievalColors.inkDark,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: MedievalColors.forestGreen,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Tarjeta de Mundo Vivo, Ruta y Viajes
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        state.worldState.route.icon,
                        size: 18,
                        color: MedievalColors.arcaneViolet,
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          '${state.worldState.era.label} · ${state.worldState.route.label}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: MedievalColors.inkDark,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      OutlinedButton.icon(
                        key: const Key('open_world_button'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: () => showWorldDialog(context),
                        icon: const Icon(Icons.public_rounded, size: 15),
                        label: const Text(
                          'Mundo y Viajes',
                          style: TextStyle(fontSize: 11.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Text(
                        'Amenaza del Rey Demonio',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: MedievalColors.inkMuted,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: LinearProgressIndicator(
                            value:
                                (state.worldState.demonKingThreat / 100)
                                    .clamp(0.0, 1.0),
                            minHeight: 6,
                            backgroundColor: MedievalColors.borderWood
                                .withValues(alpha: 0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              MedievalColors.crimsonSeal,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${state.worldState.demonKingThreat}%',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: MedievalColors.crimsonSeal,
                        ),
                      ),
                    ],
                  ),
                  if (state.worldState.worldNews.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Noticia: ${state.worldState.worldNews.first.headline}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: MedievalColors.inkMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Tarjeta de Economía Familiar (hasta los 15 años)
          if (!state.familyState.isFinanciallyIndependent) ...[
            _FamilyEconomyCard(
              age: hero.age,
              savingsText: state.familyState.savingsCurrency.formatCompact(),
              monthlyNetCopper: state.familyState.monthlyNetCopper,
              isEnrolledInSchool: state.familyState.isEnrolledInSchool,
              isChildWorker: state.familyState.isChildWorker,
              siblingsCount: state.familyState.dependentSiblingsCount,
              siblingNames:
                  state.familyState.siblings.map((s) => '${s.name} (${s.age}a)').toList(),
              canAct: !state.isGameOver && state.activeEvent == null,
              onToggleSchool: notifier.toggleSchoolEnrollment,
              onToggleWork: notifier.toggleChildWork,
            ),
            const SizedBox(height: 12),
          ],

          // Panel con estadísticas (6 base -> +Maná a los 6 -> +Fortaleza, Poder Mágico, Conocimientos a los 10)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Atributos del Alma y Cuerpo',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: MedievalColors.inkDark,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        hero.primaryDevelopmentCompleted
                            ? 'Límites exponenciales'
                            : '0 – 100',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: MedievalColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...CharacterStats.visibleStats(
                    manaAwakened: hero.manaAwakened,
                    primaryDevelopmentCompleted:
                        hero.primaryDevelopmentCompleted,
                  ).map((statType) {
                    final value = hero.stats[statType];
                    final cap = hero.statCaps[statType];
                    final ratio = cap > 0 ? (value / cap).clamp(0.0, 1.0) : 0.0;
                    final valueText = hero.primaryDevelopmentCompleted
                        ? '${formatStatNumber(value)} / ${formatStatNumber(cap)}'
                        : '$value';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                statType.icon,
                                size: 16,
                                color: statType.color,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  statType.label,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Text(
                                valueText,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: statType.color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: ratio,
                              minHeight: 8,
                              backgroundColor: MedievalColors.borderWood
                                  .withValues(alpha: 0.3),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(statType.color),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  if (!hero.manaAwakened)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: MedievalColors.arcaneVioletBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.auto_fix_high_rounded,
                            size: 15,
                            color: MedievalColors.arcaneViolet,
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Afinidad mágica (Maná): será examinada por el sacerdote al cumplir 6 años.',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: MedievalColors.arcaneViolet,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (!hero.primaryDevelopmentCompleted) ...[
                    if (!hero.manaAwakened) const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: MedievalColors.amberOchreBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.bolt_rounded,
                            size: 15,
                            color: MedievalColors.amberOchre,
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Desarrollo primario: a los 10 años se fijarán tus límites exponenciales y nacerán Fortaleza, Poder Mágico y Conocimientos.',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: MedievalColors.amberOchre,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 6),
          const Center(
            child: Text(
              'Los acontecimientos de tu vida ocurren de forma natural con el paso de los meses (10% mensual).',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                fontStyle: FontStyle.italic,
                color: MedievalColors.inkMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Retrato procedural medieval que evoluciona visualmente con las 6 etapas de vida.
class MedievalAvatarPainter extends CustomPainter {
  MedievalAvatarPainter({required this.hero});

  final Protagonist hero;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final stage = hero.lifeStage;
    final isMale = hero.gender == Gender.male;

    final tunicColor = stage == LifeStage.earlyChildhood
        ? const Color(0xFFD8C6A8)
        : (isMale ? const Color(0xFF4B6C8B) : const Color(0xFF9F5364));
    final hairColor = stage == LifeStage.oldAge
        ? const Color(0xFFD9D5CC)
        : const Color(0xFF3A2B20);
    final skinColor = const Color(0xFFF3DBC3);

    // 1. Túnica o manta de bebé
    final bodyPath = Path()
      ..moveTo(w * 0.16, h * 0.98)
      ..quadraticBezierTo(w * 0.24, h * 0.64, cx, h * 0.64)
      ..quadraticBezierTo(w * 0.76, h * 0.64, w * 0.84, h * 0.98)
      ..close();
    canvas.drawPath(bodyPath, Paint()..color = tunicColor);

    // Cuello de lino medieval
    canvas.drawLine(
      Offset(w * 0.39, h * 0.68),
      Offset(cx, h * 0.82),
      Paint()
        ..color = MedievalColors.parchmentCard
        ..strokeWidth = 2.6,
    );
    canvas.drawLine(
      Offset(w * 0.61, h * 0.68),
      Offset(cx, h * 0.82),
      Paint()
        ..color = MedievalColors.parchmentCard
        ..strokeWidth = 2.6,
    );

    // 2. Melena trasera en mujer o cabello largo
    final hairPaint = Paint()..color = hairColor;
    if (!isMale && stage != LifeStage.earlyChildhood) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(cx, h * 0.46),
            width: w * 0.50,
            height: h * 0.42,
          ),
          Radius.circular(w * 0.22),
        ),
        hairPaint,
      );
    }

    // 3. Cabeza
    final headRadius =
        stage == LifeStage.earlyChildhood ? w * 0.22 : w * 0.21;
    final headCenter = Offset(cx, h * 0.42);
    canvas.drawCircle(headCenter, headRadius, Paint()..color = skinColor);
    canvas.drawCircle(
      headCenter,
      headRadius,
      Paint()
        ..color = MedievalColors.inkDark.withValues(alpha: 0.28)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1,
    );

    // 4. Cabello superior o capucha de bebé
    if (stage == LifeStage.earlyChildhood) {
      canvas.drawArc(
        Rect.fromCircle(center: headCenter, radius: headRadius * 1.05),
        2.9,
        3.6,
        false,
        Paint()
          ..color = const Color(0xFF9F8466)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.2,
      );
    } else {
      canvas.drawArc(
        Rect.fromCircle(center: headCenter, radius: headRadius),
        3.15,
        3.1,
        false,
        hairPaint,
      );
    }

    // 5. Ojos y expresión
    final eyePaint = Paint()..color = MedievalColors.inkDark;
    canvas.drawCircle(Offset(w * 0.42, h * 0.42), w * 0.025, eyePaint);
    canvas.drawCircle(Offset(w * 0.58, h * 0.42), w * 0.025, eyePaint);

    // Sonrisa o expresión serena
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(cx, h * 0.48),
        width: w * 0.13,
        height: h * 0.06,
      ),
      0.2,
      2.7,
      false,
      Paint()
        ..color = MedievalColors.inkDark.withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3,
    );

    // 6. Barba en adultez/vejez masculina
    if (isMale &&
        (stage == LifeStage.adulthood || stage == LifeStage.oldAge)) {
      final beard = Path()
        ..moveTo(w * 0.39, h * 0.54)
        ..lineTo(cx, h * (stage == LifeStage.oldAge ? 0.74 : 0.66))
        ..lineTo(w * 0.61, h * 0.54)
        ..close();
      canvas.drawPath(beard, hairPaint);
    }
  }

  @override
  bool shouldRepaint(covariant MedievalAvatarPainter oldDelegate) {
    return oldDelegate.hero.age != hero.age ||
        oldDelegate.hero.gender != hero.gender ||
        oldDelegate.hero.avatarSeed != hero.avatarSeed;
  }
}

class _FamilyEconomyCard extends StatelessWidget {
  const _FamilyEconomyCard({
    required this.age,
    required this.savingsText,
    required this.monthlyNetCopper,
    required this.isEnrolledInSchool,
    required this.isChildWorker,
    required this.siblingsCount,
    required this.siblingNames,
    required this.canAct,
    required this.onToggleSchool,
    required this.onToggleWork,
  });

  final int age;
  final String savingsText;
  final int monthlyNetCopper;
  final bool isEnrolledInSchool;
  final bool isChildWorker;
  final int siblingsCount;
  final List<String> siblingNames;
  final bool canAct;
  final VoidCallback onToggleSchool;
  final VoidCallback onToggleWork;

  @override
  Widget build(BuildContext context) {
    final isPositive = monthlyNetCopper >= 0;
    final netColor = isPositive
        ? MedievalColors.forestGreen
        : MedievalColors.crimsonSeal;

    return Card(
      key: const Key('family_economy_card'),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.cottage_outlined,
                  size: 18,
                  color: MedievalColors.amberOchre,
                ),
                const SizedBox(width: 7),
                const Expanded(
                  child: Text(
                    'Economía Familiar',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: MedievalColors.inkDark,
                    ),
                  ),
                ),
                Text(
                  'Ahorros: $savingsText',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: MedievalColors.goldCoin,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Padres +20P · Mantención -5P'
                    '${isEnrolledInSchool ? ' · Escuela -15P' : ''}'
                    '${siblingsCount > 0 ? ' · Hermanos -${siblingsCount * 5}P' : ''}'
                    '${isChildWorker ? ' · Trabajo +8P' : ''}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: MedievalColors.inkMuted,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? MedievalColors.forestGreenBg
                        : MedievalColors.crimsonSealBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${RpgCurrency.formatDelta(monthlyNetCopper)}/mes',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: netColor,
                    ),
                  ),
                ),
              ],
            ),
            if (siblingNames.isNotEmpty) ...[
              const SizedBox(height: 5),
              Text(
                'Hermanos: ${siblingNames.join(', ')}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: MedievalColors.inkDark,
                ),
              ),
            ],
            if (age >= 7) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  OutlinedButton.icon(
                    key: const Key('toggle_school_button'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: canAct ? onToggleSchool : null,
                    icon: const Icon(Icons.school_outlined, size: 15),
                    label: Text(
                      isEnrolledInSchool
                          ? 'Dejar Escuela'
                          : 'Ir a Escuela (15P/m)',
                      style: const TextStyle(fontSize: 11.5),
                    ),
                  ),
                  if (age >= 8)
                    OutlinedButton.icon(
                      key: const Key('toggle_child_work_button'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: canAct ? onToggleWork : null,
                      icon: const Icon(Icons.handyman_outlined, size: 15),
                      label: Text(
                        isChildWorker
                            ? 'Dejar Trabajo'
                            : 'Trabajar (+8P/m)',
                        style: const TextStyle(fontSize: 11.5),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
