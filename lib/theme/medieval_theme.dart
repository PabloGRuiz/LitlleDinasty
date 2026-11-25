import 'package:flutter/material.dart';

/// Paleta de colores medieval RPG inspirada en pergamino, madera y heráldica suave.
class MedievalColors {
  MedievalColors._();

  static const Color parchmentBg = Color(0xFFF3ECD8);
  static const Color parchmentCard = Color(0xFFFBF7EC);
  static const Color meadowMist = Color(0xFFDCE5D5);
  static const Color outerBackdrop = Color(0xFFD3CCB9);

  static const Color inkDark = Color(0xFF2A221B);
  static const Color inkMuted = Color(0xFF6A5D4D);
  static const Color borderWood = Color(0xFFB8A88A);

  static const Color forestGreen = Color(0xFF2F6F4E);
  static const Color forestGreenBg = Color(0xFFE3F0E8);

  static const Color crimsonSeal = Color(0xFFA63434);
  static const Color crimsonSealBg = Color(0xFFF7E6E6);

  static const Color royalBlue = Color(0xFF3C668C);
  static const Color royalBlueBg = Color(0xFFE6EFF6);

  static const Color amberOchre = Color(0xFFB87A24);
  static const Color amberOchreBg = Color(0xFFF8EFE0);

  static const Color plumEmpathy = Color(0xFF7A4E7A);
  static const Color plumEmpathyBg = Color(0xFFF2E8F2);

  static const Color copperCoin = Color(0xFFB86B35);
  static const Color silverCoin = Color(0xFF7B8894);
  static const Color goldCoin = Color(0xFFC99728);
}

/// Construye el tema Material 3 para el simulador de vida medieval RPG.
ThemeData buildMedievalTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: MedievalColors.forestGreen,
    brightness: Brightness.light,
    surface: MedievalColors.parchmentBg,
  ).copyWith(
    primary: MedievalColors.forestGreen,
    secondary: MedievalColors.amberOchre,
    error: MedievalColors.crimsonSeal,
    surface: MedievalColors.parchmentBg,
    onSurface: MedievalColors.inkDark,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: MedievalColors.parchmentBg,
    fontFamilyFallback: const [
      'Georgia',
      'Noto Serif',
      'Roboto',
      'sans-serif',
    ],
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        color: MedievalColors.inkDark,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2,
      ),
      titleMedium: TextStyle(
        color: MedievalColors.inkDark,
        fontWeight: FontWeight.w700,
      ),
      bodyMedium: TextStyle(
        color: MedievalColors.inkDark,
        height: 1.38,
      ),
      bodySmall: TextStyle(
        color: MedievalColors.inkMuted,
        height: 1.3,
      ),
    ),
    cardTheme: CardThemeData(
      color: MedievalColors.parchmentCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: MedievalColors.borderWood, width: 1.3),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: MedievalColors.parchmentCard,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: MedievalColors.borderWood, width: 1.6),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: MedievalColors.forestGreen,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: MedievalColors.inkDark,
        side: const BorderSide(color: MedievalColors.borderWood, width: 1.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: MedievalColors.borderWood.withValues(alpha: 0.6),
      thickness: 1,
    ),
  );
}

