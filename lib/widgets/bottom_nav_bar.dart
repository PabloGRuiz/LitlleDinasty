import 'package:flutter/material.dart';

import '../theme/medieval_theme.dart';

/// Pestañas principales de la interfaz medieval RPG.
enum LifeTab { hero, semester, profession, chronicles }

/// Barra inferior con acceso a la ficha de vida, objetivos semestrales, oficios y crónicas.
class MedievalBottomNavBar extends StatelessWidget {
  const MedievalBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onSelectTab,
    this.showSemesterBadge = false,
    this.showProfessionBadge = false,
  });

  final LifeTab currentTab;
  final ValueChanged<LifeTab> onSelectTab;
  final bool showSemesterBadge;
  final bool showProfessionBadge;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MedievalColors.parchmentCard,
        border: Border(
          top: BorderSide(
            color: MedievalColors.borderWood.withValues(alpha: 0.9),
            width: 1.5,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Row(
        children: [
          _NavItem(
            icon: Icons.person_outline_rounded,
            label: 'Mi Vida',
            selected: currentTab == LifeTab.hero,
            onTap: () => onSelectTab(LifeTab.hero),
          ),
          _NavItem(
            icon: Icons.event_note_outlined,
            label: 'Semestre',
            selected: currentTab == LifeTab.semester,
            showBadge: showSemesterBadge,
            onTap: () => onSelectTab(LifeTab.semester),
          ),
          _NavItem(
            icon: Icons.explore_outlined,
            label: 'Oficios',
            selected: currentTab == LifeTab.profession,
            showBadge: showProfessionBadge,
            onTap: () => onSelectTab(LifeTab.profession),
          ),
          _NavItem(
            icon: Icons.history_edu_outlined,
            label: 'Crónicas',
            selected: currentTab == LifeTab.chronicles,
            onTap: () => onSelectTab(LifeTab.chronicles),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.showBadge = false,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    final fgColor =
        selected ? MedievalColors.forestGreen : MedievalColors.inkMuted;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          decoration: BoxDecoration(
            color: selected
                ? MedievalColors.forestGreenBg
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, size: 20, color: fgColor),
                  if (showBadge)
                    Positioned(
                      right: -4,
                      top: -2,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: MedievalColors.crimsonSeal,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: fgColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
