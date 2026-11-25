import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/currency.dart';
import '../models/life_stage.dart';
import '../models/semester_action.dart';
import '../providers/life_provider.dart';
import '../theme/medieval_theme.dart';

/// Vista de planificación semestral para definir objetivos de desarrollo del personaje.
class SemesterActionsView extends ConsumerWidget {
  const SemesterActionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lifeProvider);
    final notifier = ref.read(lifeProvider.notifier);
    final stage = state.hero.lifeStage;
    final actions = SemesterActionsCatalog.forStage(stage);
    final available = state.hasSemesterActionAvailable;

    return Container(
      color: MedievalColors.parchmentBg,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
        children: [
          Card(
            color: available
                ? MedievalColors.forestGreenBg
                : MedievalColors.amberOchreBg,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    available
                        ? Icons.task_alt_rounded
                        : Icons.hourglass_bottom_rounded,
                    color: available
                        ? MedievalColors.forestGreen
                        : MedievalColors.amberOchre,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Semestre ${state.currentSemester} · Año ${state.year} (${stage.label})',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: MedievalColors.inkDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          state.isGameOver
                              ? 'Tu historia ha terminado.'
                              : (available
                                  ? 'Elige 1 objetivo de entrenamiento, estudio o trabajo para este semestre.'
                                  : 'Ya cumpliste tu objetivo este semestre. Avanza al siguiente semestre para planificar otro.'),
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: MedievalColors.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!available && !state.isGameOver) ...[
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: notifier.advanceToNextSemester,
                      child: const Text(
                        '+6M',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...actions.map((action) {
            final statsSummary = action.statDelta.formatSummary();
            final rewardParts = <String>[
              if (statsSummary.isNotEmpty) statsSummary,
              if (action.copperDelta != 0)
                RpgCurrency.formatDelta(action.copperDelta),
            ];

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: action.accentColor.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          action.icon,
                          size: 20,
                          color: action.accentColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              action.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              action.description,
                              style: const TextStyle(
                                fontSize: 12,
                                color: MedievalColors.inkMuted,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              rewardParts.join(' · '),
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: MedievalColors.forestGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: available
                            ? () {
                                final ok =
                                    notifier.performSemesterAction(action);
                                if (ok && context.mounted) {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Objetivo completado: ${action.title}.',
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                }
                              }
                            : null,
                        child: const Text(
                          'Realizar',
                          style: TextStyle(fontSize: 12),
                        ),
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
}

