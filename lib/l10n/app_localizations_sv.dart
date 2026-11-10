// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Schackriket';

  @override
  String get mapTitle => 'Riket';

  @override
  String get comingSoon => 'Snart';

  @override
  String get locked => 'Låst';

  @override
  String get start => 'Spela!';

  @override
  String get again => 'Igen';

  @override
  String get next => 'Nästa';

  @override
  String get back => 'Tillbaka';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nej';

  @override
  String get wellDone => 'Bra gjort!';

  @override
  String get lessonDone => 'Lektionen är klar!';

  @override
  String get taskWon => 'Hurra!';

  @override
  String get tryAgain => 'Vi försöker igen!';

  @override
  String get botWon => 'Den lilla roboten vann. Vi spelar igen!';

  @override
  String get promoted => 'Hon blir en prinsessa!';

  @override
  String get lavaWarning => 'Aj, lava!';

  @override
  String tapTarget(String target) {
    return 'Tryck på: $target';
  }

  @override
  String street(String name) {
    return 'gata $name';
  }

  @override
  String house(String name) {
    return 'rad $name';
  }

  @override
  String room(String name) {
    return 'rum $name';
  }

  @override
  String get dragHint => 'Dra en pjäs till brädet';

  @override
  String get armies => 'Arméer';

  @override
  String get myArmy => 'Min armé';

  @override
  String get rivalArmy => 'Motståndare';

  @override
  String get battleDemo => 'Provstrid';

  @override
  String taskOf(int n, int total) {
    return 'Uppgift $n av $total';
  }

  @override
  String get opponentThinking => 'Den lilla roboten tänker…';
}
