import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/currency.dart';
import '../models/game_event.dart';
import '../models/profession.dart';
import '../models/stats.dart';
import '../providers/life_provider.dart';
import '../theme/medieval_theme.dart';

/// Vista de profesiones: postulación y Gremio de Aventureros (desde los 15 años).
class ProfessionView extends ConsumerWidget {
  const ProfessionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lifeProvider);
    final notifier = ref.read(lifeProvider.notifier);
    final hero = state.hero;

    if (state.profession == ProfessionId.none) {
      final yearsLeft = (15 - hero.age).clamp(0, 15);
      final canApply = state.canApplyAsAdventurer;

      return Container(
        color: MedievalColors.parchmentBg,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: MedievalColors.crimsonSealBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: MedievalColors.crimsonSeal
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                          child: const Icon(
                            Icons.explore_outlined,
                            size: 26,
                            color: MedievalColors.crimsonSeal,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gremio de Aventureros',
                                style: TextStyle(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'Requisito: 15 años o más',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: MedievalColors.inkMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Forja tu leyenda aceptando encargos de exploración, escolta y caza en este mundo medieval. Al ingresar obtendrás tu placa de Bronce (Rango E), un estipendio mensual y misiones semestrales para ascender hasta Rango A.',
                      style: TextStyle(fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: MedievalColors.parchmentBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: MedievalColors.borderWood),
                      ),
                      child: const Text(
                        '• Estipendio mensual desde 15C (Rango E) hasta 3P 20C (Rango A)\n'
                        '• 1 Encargo del Gremio por semestre con pruebas 0–100%\n'
                        '• Progresión de experiencia y ascensos de rango',
                        style: TextStyle(
                          fontSize: 12,
                          color: MedievalColors.inkDark,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        key: const Key('apply_adventurer_button'),
                        onPressed: canApply
                            ? () {
                                final ok = notifier.applyForAdventurer();
                                if (ok && context.mounted) {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          '¡Te has unido al Gremio de Aventureros (Rango E)!',
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                }
                              }
                            : null,
                        icon: const Icon(Icons.shield_outlined),
                        label: Text(
                          canApply
                              ? 'Postularse como Aventurero'
                              : (state.isGameOver
                                  ? 'Vida finalizada'
                                  : 'Disponible a los 15 años (faltan $yearsLeft)'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Jugador ya pertenece al Gremio de Aventureros.
    final rank = state.adventurerRank;
    final nextRank = rank.nextRank;
    final xpInTier = state.adventurerXp - rank.minXp;
    final tierSpan =
        nextRank != null ? (nextRank.minXp - rank.minXp) : 1;
    final progress = nextRank != null
        ? (xpInTier / tierSpan).clamp(0.0, 1.0)
        : 1.0;

    final rawStipend = rank.monthlyStipendCopper;
    final currentStipend = hero.age >= 60 ? (rawStipend ~/ 2) : rawStipend;
    final availableQuests = GuildQuestCatalog.availableFor(rank);
    final questAvailable = state.hasGuildQuestAvailable;

    return Container(
      color: MedievalColors.parchmentBg,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: MedievalColors.amberOchreBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: MedievalColors.amberOchre),
                        ),
                        child: const Icon(
                          Icons.military_tech_rounded,
                          size: 24,
                          color: MedievalColors.amberOchre,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Aventurero · ${rank.label}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Estipendio: ${RpgCurrency.formatDelta(currentStipend)}/mes · ${state.completedQuests} encargos completados',
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: MedievalColors.inkMuted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!state.isGameOver)
                        TextButton(
                          onPressed: notifier.retireFromProfession,
                          child: const Text(
                            'Retirarse',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: MedievalColors.crimsonSeal,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Experiencia: ${state.adventurerXp} XP',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        nextRank != null
                            ? 'Siguiente: ${nextRank.label} (${nextRank.minXp} XP)'
                            : 'Rango máximo alcanzado',
                        style: const TextStyle(
                          fontSize: 11,
                          color: MedievalColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor:
                          MedievalColors.borderWood.withValues(alpha: 0.35),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        MedievalColors.amberOchre,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tablón de Encargos (1 / semestre)',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: MedievalColors.inkDark,
                ),
              ),
              Text(
                questAvailable ? 'Disponible' : 'Ya realizado',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: questAvailable
                      ? MedievalColors.forestGreen
                      : MedievalColors.inkMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...availableQuests.map((quest) {
            final chance = quest.statCheck.successChanceFor(hero.stats);
            final chanceColor = chance >= 70
                ? MedievalColors.forestGreen
                : (chance >= 40
                    ? MedievalColors.amberOchre
                    : MedievalColors.crimsonSeal);

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              quest.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: chanceColor.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Éxito: $chance%',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: chanceColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        quest.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: MedievalColors.inkMuted,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${quest.statCheck.stat.label}: ${hero.stats[quest.statCheck.stat]} / req. ${quest.statCheck.requiredScore}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: quest.statCheck.stat.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Éxito: ${quest.successOutcome.formatPreview()} · +${quest.xpRewardSuccess} XP',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: MedievalColors.forestGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Fallo: ${quest.failureOutcome.formatPreview()} · +${quest.xpRewardFailure} XP',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: MedievalColors.crimsonSeal,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            onPressed: questAvailable
                                ? () {
                                    final res = notifier.takeGuildQuest(quest);
                                    if (res != null && context.mounted) {
                                      _showQuestSnackBar(context, res);
                                    }
                                  }
                                : null,
                            child: const Text(
                              'Aceptar',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showQuestSnackBar(
    BuildContext context,
    EventResolutionResult res,
  ) {
    final prefix = res.succeeded
        ? '¡Encargo exitoso! (${res.roll} ≤ ${res.chance}%)'
        : 'Encargo fallido (${res.roll} > ${res.chance}%)';

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$prefix · ${res.description}'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
  }
}

