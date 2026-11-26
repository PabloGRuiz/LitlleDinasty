import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/world_state.dart';
import '../providers/life_provider.dart';
import '../theme/medieval_theme.dart';

/// Abre el diálogo de estado del mundo vivo, viajes y noticias de los reinos.
Future<void> showWorldDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (_) => const WorldDialog(),
  );
}

/// Diálogo con la Era actual, amenaza del Rey Demonio, rutas, viajes y noticias.
class WorldDialog extends ConsumerWidget {
  const WorldDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lifeProvider);
    final notifier = ref.read(lifeProvider.notifier);
    final world = state.worldState;
    final hero = state.hero;
    final era = world.era;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 430, maxHeight: 640),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 10, 12),
              decoration: BoxDecoration(
                color: MedievalColors.arcaneVioletBg,
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
                  const Icon(
                    Icons.public_rounded,
                    color: MedievalColors.arcaneViolet,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CRÓNICA DEL MUNDO VIVO',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: MedievalColors.arcaneViolet,
                          ),
                        ),
                        Text(
                          era.label,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: MedievalColors.inkDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      era.description,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: MedievalColors.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Amenaza del Rey Demonio',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '${world.demonKingThreat}%',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: MedievalColors.crimsonSeal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: (world.demonKingThreat / 100).clamp(0.0, 1.0),
                        minHeight: 8,
                        backgroundColor:
                            MedievalColors.borderWood.withValues(alpha: 0.35),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          MedievalColors.crimsonSeal,
                        ),
                      ),
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
                      child: Row(
                        children: [
                          Icon(
                            world.route.icon,
                            size: 18,
                            color: MedievalColors.amberOchre,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ruta actual: ${world.route.label}',
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  world.route.description,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: MedievalColors.inkMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Viajar por el Continente',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...WorldLocation.values.map((loc) {
                      final isHere = world.currentLocation == loc;
                      final canAge = hero.age >= loc.minAgeToTravel;
                      final canTravel = !isHere &&
                          canAge &&
                          !state.isGameOver &&
                          state.activeEvent == null;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isHere
                                ? MedievalColors.forestGreenBg
                                : MedievalColors.parchmentBg,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isHere
                                  ? MedievalColors.forestGreen
                                  : MedievalColors.borderWood,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                loc.icon,
                                size: 20,
                                color: isHere
                                    ? MedievalColors.forestGreen
                                    : MedievalColors.inkDark,
                              ),
                              const SizedBox(width: 9),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      loc.labelFor(hero.villageName),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      loc.description,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: MedievalColors.inkMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (isHere)
                                const Text(
                                  'Aquí',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w800,
                                    color: MedievalColors.forestGreen,
                                  ),
                                )
                              else
                                OutlinedButton(
                                  onPressed: canTravel
                                      ? () {
                                          final ok = notifier.travelTo(loc);
                                          if (ok && context.mounted) {
                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Viajaste a ${loc.labelFor(hero.villageName)}.',
                                                  ),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                ),
                                              );
                                          }
                                        }
                                      : null,
                                  child: Text(
                                    canAge
                                        ? 'Viajar'
                                        : '${loc.minAgeToTravel}+ a.',
                                    style: const TextStyle(fontSize: 11.5),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                    const Text(
                      'Noticias de los Reinos',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (world.worldNews.isEmpty)
                      const Text(
                        'Aún no han llegado mensajeros de la capital.',
                        style: TextStyle(
                          fontSize: 12,
                          color: MedievalColors.inkMuted,
                        ),
                      )
                    else
                      ...world.worldNews.take(6).map((news) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 7),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: MedievalColors.parchmentBg,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: MedievalColors.borderWood),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        news.headline,
                                        style: const TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      news.dateLabel,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: MedievalColors.inkMuted,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  news.details,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: MedievalColors.inkMuted,
                                  ),
                                ),
                              ],
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
}

