// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Schachkönigreich';

  @override
  String get mapTitle => 'Königreich';

  @override
  String get comingSoon => 'Bald';

  @override
  String get locked => 'Gesperrt';

  @override
  String get start => 'Los geht\'s!';

  @override
  String get again => 'Nochmal';

  @override
  String get next => 'Weiter';

  @override
  String get back => 'Zurück';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get wellDone => 'Super gemacht!';

  @override
  String get lessonDone => 'Lektion geschafft!';

  @override
  String get taskWon => 'Hurra!';

  @override
  String get tryAgain => 'Wir probieren es nochmal!';

  @override
  String get botWon => 'Der kleine Roboter hat gewonnen. Wir spielen nochmal!';

  @override
  String get promoted => 'Sie wird zur Prinzessin!';

  @override
  String get lavaWarning => 'Autsch, Lava!';

  @override
  String tapTarget(String target) {
    return 'Tippe auf: $target';
  }

  @override
  String street(String name) {
    return 'Straße $name';
  }

  @override
  String house(String name) {
    return 'Reihe $name';
  }

  @override
  String room(String name) {
    return 'Zimmer $name';
  }

  @override
  String get dragHint => 'Zieh eine Figur aufs Brett';

  @override
  String get armies => 'Armeen';

  @override
  String get myArmy => 'Meine Armee';

  @override
  String get rivalArmy => 'Gegner';

  @override
  String get battleDemo => 'Probeschlacht';

  @override
  String taskOf(int n, int total) {
    return 'Aufgabe $n von $total';
  }

  @override
  String get opponentThinking => 'Der kleine Roboter denkt nach…';
}
