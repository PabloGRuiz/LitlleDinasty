/// Moneda RPG medieval basada en cobre, plata y oro.
/// 100 Cobre = 1 Plata; 100 Plata = 1 Oro (10.000 Cobre = 1 Oro).
class RpgCurrency {
  const RpgCurrency(int totalCopper) : totalCopper = totalCopper < 0 ? 0 : totalCopper;

  factory RpgCurrency.fromCoins({
    int gold = 0,
    int silver = 0,
    int copper = 0,
  }) {
    return RpgCurrency(gold * 10000 + silver * 100 + copper);
  }

  final int totalCopper;

  int get gold => totalCopper ~/ 10000;
  int get silver => (totalCopper % 10000) ~/ 100;
  int get copper => totalCopper % 100;

  RpgCurrency addCopper(int delta) => RpgCurrency(totalCopper + delta);

  String formatCompact() {
    final parts = <String>[];
    if (gold > 0) parts.add('${gold}O');
    if (silver > 0 || gold > 0) parts.add('${silver}P');
    parts.add('${copper}C');
    return parts.join(' ');
  }

  /// Formatea un cambio en cobre (positivo o negativo) en Oro/Plata/Cobre.
  static String formatDelta(int copperDelta) {
    if (copperDelta == 0) return '0C';
    final sign = copperDelta > 0 ? '+' : '-';
    final abs = copperDelta.abs();
    final g = abs ~/ 10000;
    final s = (abs % 10000) ~/ 100;
    final c = abs % 100;

    final parts = <String>[];
    if (g > 0) parts.add('${g}O');
    if (s > 0) parts.add('${s}P');
    if (c > 0 || parts.isEmpty) parts.add('${c}C');
    return '$sign${parts.join(' ')}';
  }
}

