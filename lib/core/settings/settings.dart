import 'package:shared_preferences/shared_preferences.dart';

/// Parent choices (Prompts/06-ZIVY_PRENOS_PLAN.md §10).
class Settings {
  const Settings({this.battles = true, this.classicPieces = false});

  /// Full-screen battles on captures; off = just a "poof".
  final bool battles;

  /// Classic chess figures on the board in games (replay and live).
  final bool classicPieces;

  /// Battles follow their own switch; with classic pieces the battle still
  /// shows the army characters (Olin 2026-11-26: "ani když zapnu bitvy").
  bool get battlesShown => battles;

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
