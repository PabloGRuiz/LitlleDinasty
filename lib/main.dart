import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/game_state.dart';
import 'providers/life_provider.dart';
import 'theme/medieval_theme.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/character_creation_view.dart';
import 'widgets/chronicles_view.dart';
import 'widgets/event_modal.dart';
import 'widgets/hero_life_view.dart';
import 'widgets/profession_view.dart';
import 'widgets/semester_actions_view.dart';
import 'widgets/top_hud.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MedievalLifeApp()));
}

/// Aplicación principal del simulador de vida medieval RPG.
class MedievalLifeApp extends StatelessWidget {
  const MedievalLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crónicas de Otra Vida — Simulador Medieval RPG',
      debugShowCheckedModeBanner: false,
      theme: buildMedievalTheme(),
      home: const MedievalHomeShell(),
    );
  }
}

/// Contenedor principal con marco vertical móvil centrado en escritorio/web.
class MedievalHomeShell extends ConsumerStatefulWidget {
  const MedievalHomeShell({super.key});

  @override
  ConsumerState<MedievalHomeShell> createState() => _MedievalHomeShellState();
}

class _MedievalHomeShellState extends ConsumerState<MedievalHomeShell> {
  LifeTab _currentTab = LifeTab.hero;
  bool _isEventDialogOpen = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lifeProvider);

    ref.listen<GameState>(lifeProvider, (previous, next) {
      final event = next.activeEvent;
      if (event != null &&
          previous?.activeEvent?.eventId != event.eventId &&
          !_isEventDialogOpen) {
        _isEventDialogOpen = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            _isEventDialogOpen = false;
            return;
          }
          showEventModal(context, event).whenComplete(() {
            if (mounted) {
              _isEventDialogOpen = false;
            }
          });
        });
      }
    });

    final Widget screenBody = state.needsCharacterCreation
        ? const Scaffold(body: SafeArea(child: CharacterCreationView()))
        : Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  const TopHud(),
                  Expanded(
                    child: IndexedStack(
                      index: _currentTab.index,
                      children: [
                        HeroLifeView(
                          onOpenSemesterTab: () =>
                              setState(() => _currentTab = LifeTab.semester),
                        ),
                        const SemesterActionsView(),
                        const ProfessionView(),
                        const ChroniclesView(),
                      ],
                    ),
                  ),
                  MedievalBottomNavBar(
                    currentTab: _currentTab,
                    onSelectTab: (tab) => setState(() => _currentTab = tab),
                    showSemesterBadge: state.hasSemesterActionAvailable,
                    showProfessionBadge: state.canApplyAsAdventurer ||
                        state.hasGuildQuestAvailable,
                  ),
                ],
              ),
            ),
          );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 500) {
          return screenBody;
        }

        // En Web/escritorio centramos el marco móvil vertical.
        return ColoredBox(
          color: MedievalColors.outerBackdrop,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 460,
                  maxHeight: 880,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: MedievalColors.borderWood,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: MedievalColors.inkDark.withValues(alpha: 0.16),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: screenBody,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
