import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/life_stage.dart';
import '../models/world_state.dart';
import '../providers/life_provider.dart';
import '../theme/medieval_theme.dart';

/// Barra superior (HUD) con identidad, etapa vital, monedas RPG y control del tiempo.
class TopHud extends ConsumerWidget {
  const TopHud({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lifeProvider);
    final notifier = ref.read(lifeProvider.notifier);
    final hero = state.hero;
    final stage = hero.lifeStage;

    return Container(
      decoration: BoxDecoration(
        color: MedievalColors.parchmentCard,
        border: Border(
          bottom: BorderSide(
            color: MedievalColors.borderWood.withValues(alpha: 0.9),
            width: 1.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: MedievalColors.inkDark.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            hero.fullName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: MedievalColors.inkDark,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: MedievalColors.forestGreenBg,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: MedievalColors.forestGreen
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                          child: Text(
                            '${hero.age} años',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: MedievalColors.forestGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${stage.label} · ${state.formattedDate} · Sem. ${state.currentSemester}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: MedievalColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _HudButton(
                    tooltip: state.isPaused ? 'Reanudar' : 'Pausar',
                    icon: state.isPaused
                        ? Icons.play_arrow_rounded
                        : Icons.pause_rounded,
                    isActive: !state.isPaused,
                    onTap: notifier.togglePause,
                  ),
                  const SizedBox(width: 5),
                  _TextPillButton(
                    tooltip: 'Velocidad x1 / x2',
                    label: 'x${state.speedMultiplier}',
                    isHighlighted: state.speedMultiplier >= 2,
                    onTap: notifier.toggleSpeed,
                  ),
                  const SizedBox(width: 5),
                  _TextPillButton(
                    tooltip: 'Avanzar al siguiente semestre',
                    label: '+6M',
                    isHighlighted: false,
                    onTap:
                        state.isGameOver ? null : notifier.advanceToNextSemester,
                  ),
                  const SizedBox(width: 5),
                  _HudButton(
                    tooltip: 'Nueva Vida',
                    icon: Icons.restart_alt_rounded,
                    isActive: false,
                    onTap: () => _confirmNewLife(context, notifier),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Monedero RPG: Oro, Plata y Cobre
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: MedievalColors.parchmentBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: MedievalColors.borderWood.withValues(alpha: 0.8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.place_outlined,
                        size: 14,
                        color: MedievalColors.inkMuted,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          state.worldState.currentLocation
                              .labelFor(hero.villageName),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: MedievalColors.inkMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  flex: 2,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _CoinChip(
                          amount: state.currency.gold,
                          suffix: 'Oro',
                          color: MedievalColors.goldCoin,
                        ),
                        const SizedBox(width: 8),
                        _CoinChip(
                          amount: state.currency.silver,
                          suffix: 'Plata',
                          color: MedievalColors.silverCoin,
                        ),
                        const SizedBox(width: 8),
                        _CoinChip(
                          amount: state.currency.copper,
                          suffix: 'Cobre',
                          color: MedievalColors.copperCoin,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmNewLife(
    BuildContext context,
    LifeNotifier notifier,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Comenzar una Nueva Vida?'),
        content: const Text(
          'Se reiniciará tu progreso actual y volverás a renacer desde los 0 años.',
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: MedievalColors.crimsonSeal,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Nueva Vida'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await notifier.requestNewLife();
    }
  }
}

class _CoinChip extends StatelessWidget {
  const _CoinChip({
    required this.amount,
    required this.suffix,
    required this.color,
  });

  final int amount;
  final String suffix;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 11,
          height: 11,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: MedievalColors.inkDark.withValues(alpha: 0.4),
              width: 0.8,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$amount $suffix',
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            color: MedievalColors.inkDark,
          ),
        ),
      ],
    );
  }
}

class _HudButton extends StatelessWidget {
  const _HudButton({
    required this.tooltip,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final String tooltip;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive
                ? MedievalColors.forestGreenBg
                : MedievalColors.parchmentBg,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: isActive
                  ? MedievalColors.forestGreen
                  : MedievalColors.borderWood,
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: isActive
                ? MedievalColors.forestGreen
                : MedievalColors.inkDark,
          ),
        ),
      ),
    );
  }
}

class _TextPillButton extends StatelessWidget {
  const _TextPillButton({
    required this.tooltip,
    required this.label,
    required this.isHighlighted,
    required this.onTap,
  });

  final String tooltip;
  final String label;
  final bool isHighlighted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isHighlighted
                ? MedievalColors.amberOchreBg
                : MedievalColors.parchmentBg,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: isHighlighted
                  ? MedievalColors.amberOchre
                  : MedievalColors.borderWood,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: isHighlighted
                  ? MedievalColors.amberOchre
                  : MedievalColors.inkDark,
            ),
          ),
        ),
      ),
    );
  }
}
