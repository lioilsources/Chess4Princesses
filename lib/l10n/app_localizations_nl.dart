// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Schaakkoninkrijk';

  @override
  String get mapTitle => 'Koninkrijk';

  @override
  String get comingSoon => 'Binnenkort';

  @override
  String get locked => 'Op slot';

  @override
  String get start => 'Spelen!';

  @override
  String get again => 'Nog een keer';

  @override
  String get next => 'Verder';

  @override
  String get back => 'Terug';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nee';

  @override
  String get wellDone => 'Goed gedaan!';

  @override
  String get lessonDone => 'Les klaar!';

  @override
  String get taskWon => 'Hoera!';

  @override
  String get tryAgain => 'We proberen het nog een keer!';

  @override
  String get botWon => 'Het robotje heeft gewonnen. We spelen nog een keer!';

  @override
  String get promoted => 'Ze wordt een prinses!';

  @override
  String get lavaWarning => 'Au, lava!';

  @override
  String tapTarget(String target) {
    return 'Tik op: $target';
  }

  @override
  String street(String name) {
    return 'straat $name';
  }

  @override
  String house(String name) {
    return 'rij $name';
  }

  @override
  String room(String name) {
    return 'kamer $name';
  }

  @override
  String get dragHint => 'Sleep een stuk naar het bord';

  @override
  String get armies => 'Legers';

  @override
  String get myArmy => 'Mijn leger';

  @override
  String get rivalArmy => 'Tegenstander';

  @override
  String get battleDemo => 'Proefgevecht';

  @override
  String taskOf(int n, int total) {
    return 'Opdracht $n van $total';
  }

  @override
  String get opponentThinking => 'Het robotje denkt na…';
}
