// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'Šachové království';

  @override
  String get mapTitle => 'Království';

  @override
  String get comingSoon => 'Brzy';

  @override
  String get locked => 'Zamčeno';

  @override
  String get start => 'Hrát!';

  @override
  String get again => 'Znovu';

  @override
  String get next => 'Dál';

  @override
  String get back => 'Zpět';

  @override
  String get yes => 'Ano';

  @override
  String get no => 'Ne';

  @override
  String get wellDone => 'Výborně!';

  @override
  String get lessonDone => 'Lekce hotová!';

  @override
  String get taskWon => 'Hurá!';

  @override
  String get tryAgain => 'Zkusíme to znovu!';

  @override
  String get botWon => 'Robůtek vyhrál. Hrajeme znovu!';

  @override
  String get promoted => 'Proměna v princeznu!';

  @override
  String get lavaWarning => 'Au, láva!';

  @override
  String tapTarget(String target) {
    return 'Klepni na: $target';
  }

  @override
  String street(String name) {
    return 'ulici $name';
  }

  @override
  String house(String name) {
    return 'řadu $name';
  }

  @override
  String room(String name) {
    return 'komnatu $name';
  }

  @override
  String get dragHint => 'Přetáhni figurku na šachovnici';

  @override
  String get armies => 'Armády';

  @override
  String get myArmy => 'Moje armáda';

  @override
  String get rivalArmy => 'Soupeř';

  @override
  String get battleDemo => 'Zkušební bitva';

  @override
  String taskOf(int n, int total) {
    return 'Úkol $n z $total';
  }

  @override
  String get opponentThinking => 'Robůtek přemýšlí…';
}
