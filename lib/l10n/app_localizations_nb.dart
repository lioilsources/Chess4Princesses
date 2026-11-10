// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get appTitle => 'Sjakkriket';

  @override
  String get mapTitle => 'Riket';

  @override
  String get comingSoon => 'Snart';

  @override
  String get locked => 'Låst';

  @override
  String get start => 'Spill!';

  @override
  String get again => 'Igjen';

  @override
  String get next => 'Neste';

  @override
  String get back => 'Tilbake';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nei';

  @override
  String get wellDone => 'Bra jobba!';

  @override
  String get lessonDone => 'Leksjonen er ferdig!';

  @override
  String get taskWon => 'Hurra!';

  @override
  String get tryAgain => 'Vi prøver igjen!';

  @override
  String get botWon => 'Den lille roboten vant. Vi spiller igjen!';

  @override
  String get promoted => 'Hun blir en prinsesse!';

  @override
  String get lavaWarning => 'Au, lava!';

  @override
  String tapTarget(String target) {
    return 'Trykk på: $target';
  }

  @override
  String street(String name) {
    return 'gate $name';
  }

  @override
  String house(String name) {
    return 'rad $name';
  }

  @override
  String room(String name) {
    return 'rom $name';
  }

  @override
  String get dragHint => 'Dra en brikke til brettet';

  @override
  String get armies => 'Hærer';

  @override
  String get myArmy => 'Min hær';

  @override
  String get rivalArmy => 'Motstander';

  @override
  String get battleDemo => 'Prøvekamp';

  @override
  String taskOf(int n, int total) {
    return 'Oppgave $n av $total';
  }

  @override
  String get opponentThinking => 'Den lille roboten tenker…';
}
