// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get appTitle => 'Šahovsko kraljevstvo';

  @override
  String get mapTitle => 'Kraljevstvo';

  @override
  String get comingSoon => 'Uskoro';

  @override
  String get locked => 'Zaključano';

  @override
  String get start => 'Igrajmo!';

  @override
  String get again => 'Opet';

  @override
  String get next => 'Dalje';

  @override
  String get back => 'Natrag';

  @override
  String get yes => 'Da';

  @override
  String get no => 'Ne';

  @override
  String get wellDone => 'Odlično!';

  @override
  String get lessonDone => 'Lekcija završena!';

  @override
  String get taskWon => 'Hura!';

  @override
  String get tryAgain => 'Pokušajmo opet!';

  @override
  String get botWon => 'Robotić je pobijedio. Igrajmo opet!';

  @override
  String get promoted => 'Postaje princeza!';

  @override
  String get lavaWarning => 'Au, lava!';

  @override
  String tapTarget(String target) {
    return 'Dodirni: $target';
  }

  @override
  String street(String name) {
    return 'ulicu $name';
  }

  @override
  String house(String name) {
    return 'red $name';
  }

  @override
  String room(String name) {
    return 'sobu $name';
  }

  @override
  String get dragHint => 'Povuci figuru na ploču';

  @override
  String get armies => 'Vojske';

  @override
  String get myArmy => 'Moja vojska';

  @override
  String get rivalArmy => 'Protivnik';

  @override
  String get battleDemo => 'Probna bitka';

  @override
  String taskOf(int n, int total) {
    return 'Zadatak $n od $total';
  }

  @override
  String get opponentThinking => 'Robotić razmišlja…';
}
