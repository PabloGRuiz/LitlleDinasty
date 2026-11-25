import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/life_stage.dart';
import '../providers/life_provider.dart';
import '../theme/medieval_theme.dart';

/// Diario cronológico con todos los sucesos de la vida del protagonista.
class ChroniclesView extends ConsumerWidget {
  const ChroniclesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chronicles = ref.watch(lifeProvider).chronicles;

    return Container(
      color: MedievalColors.parchmentBg,
      child: chronicles.isEmpty
          ? const Center(
              child: Text(
                'Tu diario aún está en blanco.',
                style: TextStyle(color: MedievalColors.inkMuted),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
              itemCount: chronicles.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final entry = chronicles[index];
                final badgeColor = entry.wasSuccess == null
                    ? MedievalColors.amberOchre
                    : (entry.wasSuccess!
                        ? MedievalColors.forestGreen
                        : MedievalColors.crimsonSeal);
                final badgeBg = entry.wasSuccess == null
                    ? MedievalColors.amberOchreBg
                    : (entry.wasSuccess!
                        ? MedievalColors.forestGreenBg
                        : MedievalColors.crimsonSealBg);

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: badgeBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            entry.stage.icon,
                            size: 18,
                            color: badgeColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      entry.title,
                                      style: const TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w800,
                                        color: MedievalColors.inkDark,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    entry.dateLabel,
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      color: MedievalColors.inkMuted,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                entry.description,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: MedievalColors.inkDark,
                                  height: 1.35,
                                ),
                              ),
                              if (entry.rollSummary != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  '${entry.wasSuccess == true ? 'Éxito' : 'Fallo'} · ${entry.rollSummary}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: badgeColor,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
