import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/social_relation.dart';
import '../providers/life_provider.dart';
import '../theme/medieval_theme.dart';

/// Apartado Social con el registro de personas conocidas y su nivel de afinidad.
class SocialView extends ConsumerStatefulWidget {
  const SocialView({super.key});

  @override
  ConsumerState<SocialView> createState() => _SocialViewState();
}

class _SocialViewState extends ConsumerState<SocialView> {
  RelationshipGroup? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lifeProvider);
    final notifier = ref.read(lifeProvider.notifier);

    final allContacts = List<SocialContact>.from(state.contacts)
      ..sort((a, b) {
        final aFam = a.group == RelationshipGroup.family ? 0 : 1;
        final bFam = b.group == RelationshipGroup.family ? 0 : 1;
        if (aFam != bFam) return aFam.compareTo(bFam);
        return b.affinity.compareTo(a.affinity);
      });

    final filtered = _selectedFilter == null
        ? allContacts
        : allContacts.where((c) => c.group == _selectedFilter).toList();

    final closeCount = allContacts.where((c) => c.affinity >= 60).length;

    return Container(
      color: MedievalColors.parchmentBg,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: MedievalColors.plumEmpathyBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.people_alt_outlined,
                      color: MedievalColors.plumEmpathy,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Círculo Social y Afinidades',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: MedievalColors.inkDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${allContacts.length} personas conocidas · $closeCount vínculos cercanos (60+)',
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: MedievalColors.inkMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterPill(
                  label: 'Todos (${allContacts.length})',
                  selected: _selectedFilter == null,
                  onTap: () => setState(() => _selectedFilter = null),
                ),
                ...RelationshipGroup.values.map((group) {
                  final count =
                      allContacts.where((c) => c.group == group).length;
                  return Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: _FilterPill(
                      label: '${group.label} ($count)',
                      selected: _selectedFilter == group,
                      onTap: () => setState(() => _selectedFilter = group),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (filtered.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Text(
                  'Aún no has tratado con personas en este ámbito.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: MedievalColors.inkMuted,
                  ),
                ),
              ),
            )
          else
            ...filtered.map((contact) {
              final level = contact.affinityLevel;
              final canInteract = !state.isGameOver &&
                  state.activeEvent == null &&
                  contact.canInteractIn(state.currentSemesterKey);
              final canGift =
                  canInteract && state.currency.totalCopper >= 20;

              return Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 19,
                              backgroundColor:
                                  contact.group.color.withValues(alpha: 0.16),
                              child: Text(
                                contact.name.isNotEmpty
                                    ? contact.name[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: contact.group.color,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    contact.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: MedievalColors.inkDark,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        contact.group.icon,
                                        size: 12.5,
                                        color: contact.group.color,
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          '${contact.role} · desde ${contact.firstMetAge}a',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: MedievalColors.inkMuted,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: level.bgColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: level.color.withValues(alpha: 0.55),
                                ),
                              ),
                              child: Text(
                                '${level.label} · ${contact.affinity}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: level.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: LinearProgressIndicator(
                            value: (contact.affinity / 100).clamp(0.0, 1.0),
                            minHeight: 7,
                            backgroundColor: MedievalColors.borderWood
                                .withValues(alpha: 0.3),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(level.color),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: MedievalColors.parchmentBg
                                .withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: MedievalColors.borderWood
                                  .withValues(alpha: 0.35),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Edad: ${contact.knowsAge ? '${contact.age} años' : '???'}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: contact.knowsAge
                                          ? MedievalColors.inkDark
                                          : MedievalColors.inkMuted,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Conocido: ${contact.knownFactsCount}/4',
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      color: MedievalColors.inkMuted,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              _IdentityRow(
                                label: 'Oficio',
                                value: contact.knowsOccupation
                                    ? contact.occupation
                                    : 'Desconocido (charla para conocerle)',
                                known: contact.knowsOccupation,
                              ),
                              const SizedBox(height: 3),
                              _IdentityRow(
                                label: 'Quién es',
                                value: contact.knowsBio
                                    ? contact.bio
                                    : 'Desconocido (charla para conocerle)',
                                known: contact.knowsBio,
                              ),
                              const SizedBox(height: 3),
                              _IdentityRow(
                                label: 'Familia',
                                value: contact.knowsFamily
                                    ? contact.familyInfo
                                    : 'Desconocido (charla para conocerle)',
                                known: contact.knowsFamily,
                              ),
                            ],
                          ),
                        ),
                        if (contact.lastInteractionNote.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            contact.lastInteractionNote,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: MedievalColors.inkMuted,
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                              onPressed: canInteract
                                  ? () {
                                      showDialog<void>(
                                        context: context,
                                        builder: (_) => _NpcChatDialog(
                                          contact: contact,
                                          onSelectTopic: (topic) =>
                                              notifier.chatWithContact(
                                            contact.id,
                                            topic,
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                              icon: const Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 14,
                              ),
                              label: Text(
                                canInteract ? 'Charlar' : 'Visitado',
                                style: const TextStyle(fontSize: 11.5),
                              ),
                            ),
                            const SizedBox(width: 8),
                            FilledButton.icon(
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                              onPressed: canGift
                                  ? () {
                                      final ok = notifier.interactWithContact(
                                        contact.id,
                                        giveGift: true,
                                      );
                                      if (ok && context.mounted) {
                                        ScaffoldMessenger.of(context)
                                          ..hideCurrentSnackBar()
                                          ..showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Entregaste un obsequio a ${contact.name} (-20C).',
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                          );
                                      }
                                    }
                                  : null,
                              icon: const Icon(
                                Icons.card_giftcard_outlined,
                                size: 14,
                              ),
                              label: const Text(
                                'Regalar (20C)',
                                style: TextStyle(fontSize: 11.5),
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
}

class _IdentityRow extends StatelessWidget {
  const _IdentityRow({
    required this.label,
    required this.value,
    required this.known,
  });

  final String label;
  final String value;
  final bool known;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 11,
          height: 1.3,
          color: known ? MedievalColors.inkDark : MedievalColors.inkMuted,
        ),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontStyle: known ? FontStyle.normal : FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _NpcChatDialog extends StatefulWidget {
  const _NpcChatDialog({
    required this.contact,
    required this.onSelectTopic,
  });

  final SocialContact contact;
  final ChatOutcomeResult? Function(ChatTopic topic) onSelectTopic;

  @override
  State<_NpcChatDialog> createState() => _NpcChatDialogState();
}

class _NpcChatDialogState extends State<_NpcChatDialog> {
  ChatOutcomeResult? _result;

  @override
  Widget build(BuildContext context) {
    final result = _result;
    return AlertDialog(
      backgroundColor: MedievalColors.parchmentCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: MedievalColors.borderWood),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Charlar con ${widget.contact.name}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: MedievalColors.inkDark,
            ),
          ),
          Text(
            widget.contact.role,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: MedievalColors.inkMuted,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: result == null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Elige qué preguntarle o comentar. Su reacción es incierta y dependerá de su carácter.',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: MedievalColors.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...ChatTopic.values.map(
                    (topic) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          backgroundColor: MedievalColors.parchmentBg,
                          side: const BorderSide(
                            color: MedievalColors.borderWood,
                          ),
                        ),
                        onPressed: () {
                          final outcome = widget.onSelectTopic(topic);
                          if (outcome != null) {
                            setState(() => _result = outcome);
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          topic.label,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: MedievalColors.inkDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: result.liked
                          ? MedievalColors.forestGreenBg
                          : MedievalColors.crimsonSealBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${result.liked ? 'Le agradó la charla' : 'Le incomodó tu pregunta'} · ${result.affinityDelta >= 0 ? '+${result.affinityDelta}' : '${result.affinityDelta}'} afinidad (Total: ${result.newAffinity})',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: result.liked
                            ? MedievalColors.forestGreen
                            : MedievalColors.crimsonSeal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    result.npcReply,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      fontStyle: FontStyle.italic,
                      color: MedievalColors.inkDark,
                    ),
                  ),
                  if (result.discoveredFacts.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: MedievalColors.forestGreenBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: MedievalColors.forestGreen
                              .withValues(alpha: 0.4),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Información descubierta:',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: MedievalColors.forestGreen,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ...result.discoveredFacts.map(
                            (fact) => Text(
                              '• $fact',
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: MedievalColors.inkDark,
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
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(result == null ? 'Cancelar' : 'Cerrar'),
        ),
      ],
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
        ),
      ),
      selected: selected,
      selectedColor: MedievalColors.forestGreenBg,
      backgroundColor: MedievalColors.parchmentCard,
      onSelected: (_) => onTap(),
    );
  }
}

