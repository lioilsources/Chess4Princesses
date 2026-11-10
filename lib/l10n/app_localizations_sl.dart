// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovenian (`sl`).
class AppLocalizationsSl extends AppLocalizations {
  AppLocalizationsSl([String locale = 'sl']) : super(locale);

  @override
  String get appTitle => 'Šahovsko kraljestvo';

  @override
  String get mapTitle => 'Kraljestvo';

  @override
  String get comingSoon => 'Kmalu';

  @override
  String get locked => 'Zaklenjeno';

  @override
  String get start => 'Igrajmo!';

  @override
  String get again => 'Še enkrat';

  @override
  String get next => 'Naprej';

  @override
  String get back => 'Nazaj';

  @override
  String get yes => 'Da';

  @override
  String get no => 'Ne';

  @override
  String get wellDone => 'Odlično!';

  @override
  String get lessonDone => 'Lekcija končana!';

  @override
  String get taskWon => 'Hura!';

  @override
  String get tryAgain => 'Poskusimo še enkrat!';

  @override
  String get botWon => 'Robotek je zmagal. Igrajmo še enkrat!';

  @override
  String get promoted => 'Postane princesa!';

  @override
  String get lavaWarning => 'Av, lava!';

  @override
  String tapTarget(String target) {
    return 'Tapni: $target';
  }

  @override
  String street(String name) {
    return 'ulico $name';
  }

  @override
  String house(String name) {
    return 'vrsto $name';
  }

  @override
  String room(String name) {
    return 'sobo $name';
  }

  @override
  String get dragHint => 'Povleci figurico na šahovnico';

  @override
  String get armies => 'Vojske';

  @override
  String get myArmy => 'Moja vojska';

  @override
  String get rivalArmy => 'Nasprotnik';

  @override
  String get battleDemo => 'Poskusna bitka';

  @override
  String taskOf(int n, int total) {
    return 'Naloga $n od $total';
  }

  @override
  String get opponentThinking => 'Robotek razmišlja…';
}
