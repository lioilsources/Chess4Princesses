// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appTitle => 'Regatul Șahului';

  @override
  String get mapTitle => 'Regatul';

  @override
  String get comingSoon => 'În curând';

  @override
  String get locked => 'Blocat';

  @override
  String get start => 'Hai să jucăm!';

  @override
  String get again => 'Din nou';

  @override
  String get next => 'Mai departe';

  @override
  String get back => 'Înapoi';

  @override
  String get yes => 'Da';

  @override
  String get no => 'Nu';

  @override
  String get wellDone => 'Bravo!';

  @override
  String get lessonDone => 'Lecție terminată!';

  @override
  String get taskWon => 'Ura!';

  @override
  String get tryAgain => 'Mai încercăm o dată!';

  @override
  String get botWon => 'Roboțelul a câștigat. Mai jucăm o dată!';

  @override
  String get promoted => 'Devine prințesă!';

  @override
  String get lavaWarning => 'Au, lavă!';

  @override
  String tapTarget(String target) {
    return 'Atinge: $target';
  }

  @override
  String street(String name) {
    return 'strada $name';
  }

  @override
  String house(String name) {
    return 'rândul $name';
  }

  @override
  String room(String name) {
    return 'camera $name';
  }

  @override
  String get dragHint => 'Trage o piesă pe tablă';

  @override
  String get armies => 'Armate';

  @override
  String get myArmy => 'Armata mea';

  @override
  String get rivalArmy => 'Adversar';

  @override
  String get battleDemo => 'Bătălie de probă';

  @override
  String taskOf(int n, int total) {
    return 'Sarcina $n din $total';
  }

  @override
  String get opponentThinking => 'Roboțelul se gândește…';
}
