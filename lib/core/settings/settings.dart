import 'package:shared_preferences/shared_preferences.dart';

/// Parent choices (Prompts/06-ZIVY_PRENOS_PLAN.md §10).
class Settings {
  const Settings({this.battles = true, this.classicPieces = false});

  /// Full-screen battles on captures; off = just a "poof".
  final bool battles;

  /// Classic chess figures in games (replay and live) instead of the armies.
  final bool classicPieces;

  /// Battles really shown: classic figures have no characters to fight.
  bool get battlesShown => battles && !classicPieces;

  Settings copyWith({bool? battles, bool? classicPieces}) =>
      Settings(battles: battles ?? this.battles, classicPieces: classicPieces ?? this.classicPieces);
}

class SettingsStore {
  static const _battles = 'settings.battles';
  static const _classic = 'settings.classicPieces';

  Future<Settings> load() async {
    final p = await SharedPreferences.getInstance();
    return Settings(battles: p.getBool(_battles) ?? true, classicPieces: p.getBool(_classic) ?? false);
  }

  Future<void> save(Settings s) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_battles, s.battles);
    await p.setBool(_classic, s.classicPieces);
  }
}
