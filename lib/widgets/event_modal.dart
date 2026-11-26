import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/currency.dart';
import '../models/game_event.dart';
import '../models/life_stage.dart';
import '../models/stats.dart';
import '../providers/life_provider.dart';
import '../theme/medieval_theme.dart';

/// Muestra el diálogo emergente de evento medieval sin cierre accidental.
Future<void> showEventModal(BuildContext context, ActiveGameEvent event) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => EventModal(event: event),
  );
}

/// Modal estilo pergamino para eventos aleatorios (0..100%) e hitos de destino.
class EventModal extends ConsumerWidget {
  const EventModal({super.key, required this.event});

  final ActiveGameEvent event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lifeProvider);
    final notifier = ref.read(lifeProvider.notifier);
    final stats = state.hero.stats;
    final isStory = event.isStoryEvent;

    final headerBg =
        isStory ? MedievalColors.arcaneVioletBg : MedievalColors.amberOchreBg;
    final headerAccent =
        isStory ? MedievalColors.arcaneViolet : MedievalColors.amberOchre;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cabecera de etapa / hito de destino y título
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              decoration: BoxDecoration(
                color: headerBg,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: MedievalColors.borderWood.withValues(alpha: 0.8),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: MedievalColors.parchmentCard,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: headerAccent,
                        width: 1.4,
                      ),
                    ),
                    child: Icon(
                      isStory ? Icons.auto_awesome_rounded : event.stage.icon,
                      size: 20,
                      color: headerAccent,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isStory
                              ? 'HITO DEL DESTINO · ${state.hero.age} AÑOS'
                              : '${event.stage.label.toUpperCase()} · ${state.hero.age} AÑOS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.7,
                            color: headerAccent,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: MedievalColors.inkDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Narrativa y opciones
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.narrative,
                      style: const TextStyle(
                        fontSize: 13.5,
                        height: 1.45,
                        color: MedievalColors.inkDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...event.choices.map((choice) {
                      final check = choice.statCheck;
                      final chance = check?.successChanceFor(stats);
                      final canAfford = state.currency.totalCopper >=
                          choice.minCopperRequired;

                      final Color badgeColor;
                      final Color badgeBg;
                      final String? badgeLabel;
                      if (chance != null) {
                        badgeLabel = 'Éxito: $chance%';
                        badgeColor = chance >= 70
                            ? MedievalColors.forestGreen
                            : (chance >= 40
                                ? MedievalColors.amberOchre
                                : MedievalColors.crimsonSeal);
                        badgeBg = chance >= 70
                            ? MedievalColors.forestGreenBg
                            : (chance >= 40
                                ? MedievalColors.amberOchreBg
                                : MedievalColors.crimsonSealBg);
                      } else if (choice.isDestinyChoice) {
                        badgeLabel = 'Destino';
                        badgeColor = MedievalColors.arcaneViolet;
                        badgeBg = MedievalColors.arcaneVioletBg;
                      } else {
                        badgeLabel = null;
                        badgeColor = MedievalColors.forestGreen;
                        badgeBg = MedievalColors.forestGreenBg;
                      }

                      final hasStatOrCoinChange =
                          !choice.successOutcome.statDelta.isEmpty ||
                              choice.successOutcome.copperDelta != 0;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: canAfford
                                  ? MedievalColors.parchmentBg
                                  : MedievalColors.parchmentBg
                                      .withValues(alpha: 0.5),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(12),
                              side: BorderSide(
                                color: canAfford
                                    ? MedievalColors.borderWood
                                    : MedievalColors.borderWood
                                        .withValues(alpha: 0.4),
                                width: 1.2,
                              ),
                            ),
                            onPressed: canAfford
                                ? () {
                                    final messenger =
                                        ScaffoldMessenger.maybeOf(context);
                                    final result =
                                        notifier.resolveActiveEvent(choice);
                                    Navigator.of(context).pop();
                                    _showOutcomeSnackBar(messenger, result);
                                  }
                                : null,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        choice.label,
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w800,
                                          color: canAfford
                                              ? MedievalColors.inkDark
                                              : MedievalColors.inkMuted,
                                        ),
                                      ),
                                    ),
                                    if (badgeLabel != null) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 7,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: badgeBg,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: badgeColor
                                                .withValues(alpha: 0.6),
                                          ),
                                        ),
                                        child: Text(
                                          badgeLabel,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                            color: badgeColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                if (check != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Prueba de ${check.stat.label}: tienes ${stats[check.stat]} / req. ${check.requiredScore}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: check.stat.color,
                                    ),
                                  ),
                                ],
                                if (!canAfford) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Requiere ${RpgCurrency(choice.minCopperRequired).formatCompact()}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: MedievalColors.crimsonSeal,
                                    ),
                                  ),
                                ],
                                if (choice.destinyPreview != null) ...[
                                  const SizedBox(height: 5),
                                  Text(
                                    choice.destinyPreview!,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: MedievalColors.arcaneViolet,
                                    ),
                                  ),
                                ],
                                if (hasStatOrCoinChange ||
                                    !choice.isDestinyChoice) ...[
                                  const SizedBox(height: 5),
                                  Text(
                                    check != null
                                        ? 'Éxito: ${choice.successOutcome.formatPreview()}'
                                        : choice.successOutcome.formatPreview(),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: MedievalColors.forestGreen,
                                    ),
                                  ),
                                ],
                                if (choice.failureOutcome != null)
                                  Text(
                                    'Fallo: ${choice.failureOutcome!.formatPreview()}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: MedievalColors.crimsonSeal,
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOutcomeSnackBar(
    ScaffoldMessengerState? messenger,
    EventResolutionResult result,
  ) {
    if (messenger == null || result.description.isEmpty) return;
    final text = result.wasCheck
        ? '${result.succeeded ? '¡Éxito! (${result.roll} ≤ ${result.chance}%)' : 'Fallo (${result.roll} > ${result.chance}%)'} · ${result.description}'
        : result.description;

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
