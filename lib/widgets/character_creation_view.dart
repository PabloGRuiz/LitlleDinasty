import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/character.dart';
import '../providers/life_provider.dart';
import '../theme/medieval_theme.dart';

/// Pantalla inicial de renacimiento donde el jugador elige su propio nombre y género.
class CharacterCreationView extends ConsumerStatefulWidget {
  const CharacterCreationView({super.key});

  @override
  ConsumerState<CharacterCreationView> createState() =>
      _CharacterCreationViewState();
}

class _CharacterCreationViewState
    extends ConsumerState<CharacterCreationView> {
  final TextEditingController _nameController = TextEditingController();
  Gender _gender = Gender.male;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: MedievalColors.amberOchreBg,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: MedievalColors.amberOchre,
                          width: 1.6,
                        ),
                      ),
                      child: const Icon(
                        Icons.auto_stories_rounded,
                        size: 28,
                        color: MedievalColors.amberOchre,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Crónicas de Otra Vida',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: MedievalColors.inkDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Despiertas a los 0 años en una aldea medieval remota, conservando recuerdos de otro mundo. Elige tu nombre; tu apellido, familia y tierra natal serán obra del destino.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: MedievalColors.inkMuted,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    key: const Key('hero_name_field'),
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'Tu Nombre Propio',
                      hintText: 'Ej. Mateo, Lucía, Erik...',
                      filled: true,
                      fillColor: MedievalColors.parchmentBg,
                      prefixIcon: const Icon(Icons.badge_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Género al Renacer',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: MedievalColors.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SegmentedButton<Gender>(
                    segments: const [
                      ButtonSegment(
                        value: Gender.male,
                        icon: Icon(Icons.male_rounded),
                        label: Text('Hombre'),
                      ),
                      ButtonSegment(
                        value: Gender.female,
                        icon: Icon(Icons.female_rounded),
                        label: Text('Mujer'),
                      ),
                    ],
                    selected: {_gender},
                    onSelectionChanged: (sel) {
                      setState(() => _gender = sel.first);
                    },
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: MedievalColors.forestGreenBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:
                            MedievalColors.forestGreen.withValues(alpha: 0.4),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 18,
                          color: MedievalColors.forestGreen,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Comenzarás con 0 años y vivirás 6 etapas: Infancia temprana, Niñez, Adolescencia, Juventud, Adultez y Vejez.',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: MedievalColors.inkDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    key: const Key('start_life_button'),
                    onPressed: () {
                      ref.read(lifeProvider.notifier).startNewLife(
                            name: _nameController.text,
                            gender: _gender,
                          );
                    },
                    icon: const Icon(Icons.wb_twilight_rounded),
                    label: const Text(
                      'Renacer (0 años)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
