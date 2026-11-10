// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'Skakkongeriget';

  @override
  String get mapTitle => 'Kongeriget';

  @override
  String get comingSoon => 'Snart';

  @override
  String get locked => 'Låst';

  @override
  String get start => 'Spil!';

  @override
  String get again => 'Igen';

  @override
  String get next => 'Videre';

  @override
  String get back => 'Tilbage';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nej';

  @override
  String get wellDone => 'Godt klaret!';

  @override
  String get lessonDone => 'Lektionen er klaret!';

  @override
  String get taskWon => 'Hurra!';

  @override
  String get tryAgain => 'Vi prøver igen!';

  @override
  String get botWon => 'Den lille robot vandt. Vi spiller igen!';

  @override
  String get promoted => 'Hun bliver til en prinsesse!';

  @override
  String get lavaWarning => 'Av, lava!';

  @override
  String tapTarget(String target) {
    return 'Tryk på: $target';
  }

  @override
  String street(String name) {
    return 'gade $name';
  }

  @override
  String house(String name) {
    return 'række $name';
  }

  @override
  String room(String name) {
    return 'værelse $name';
  }

  @override
  String get dragHint => 'Træk en brik ind på brættet';

  @override
  String get armies => 'Hære';

  @override
  String get myArmy => 'Min hær';

  @override
  String get rivalArmy => 'Modstander';

  @override
  String get battleDemo => 'Prøvekamp';

  @override
  String taskOf(int n, int total) {
    return 'Opgave $n af $total';
  }

  @override
  String get opponentThinking => 'Den lille robot tænker…';
}
