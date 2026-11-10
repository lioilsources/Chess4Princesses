// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get appTitle => 'Šachové kráľovstvo';

  @override
  String get mapTitle => 'Kráľovstvo';

  @override
  String get comingSoon => 'Čoskoro';

  @override
  String get locked => 'Zamknuté';

  @override
  String get start => 'Hráme!';

  @override
  String get again => 'Znova';

  @override
  String get next => 'Ďalej';

  @override
  String get back => 'Späť';

  @override
  String get yes => 'Áno';

  @override
  String get no => 'Nie';

  @override
  String get wellDone => 'Výborne!';

  @override
  String get lessonDone => 'Lekcia hotová!';

  @override
  String get taskWon => 'Hurá!';

  @override
  String get tryAgain => 'Skúsime to znova!';

  @override
  String get botWon => 'Robotík vyhral. Hráme znova!';

  @override
  String get promoted => 'Premena na princeznú!';

  @override
  String get lavaWarning => 'Au, láva!';

  @override
  String tapTarget(String target) {
    return 'Ťukni na: $target';
  }

  @override
  String street(String name) {
    return 'ulicu $name';
  }

  @override
  String house(String name) {
    return 'rad $name';
  }

  @override
  String room(String name) {
    return 'komnatu $name';
  }

  @override
  String get dragHint => 'Potiahni figúrku na šachovnicu';

  @override
  String get armies => 'Armády';

  @override
  String get myArmy => 'Moja armáda';

  @override
  String get rivalArmy => 'Súper';

  @override
  String get battleDemo => 'Skúšobná bitka';

  @override
  String taskOf(int n, int total) {
    return 'Úloha $n z $total';
  }

  @override
  String get opponentThinking => 'Robotík premýšľa…';
}
