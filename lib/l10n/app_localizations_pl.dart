// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Szachowe Królestwo';

  @override
  String get mapTitle => 'Królestwo';

  @override
  String get comingSoon => 'Wkrótce';

  @override
  String get locked => 'Zablokowane';

  @override
  String get start => 'Gramy!';

  @override
  String get again => 'Jeszcze raz';

  @override
  String get next => 'Dalej';

  @override
  String get back => 'Wstecz';

  @override
  String get yes => 'Tak';

  @override
  String get no => 'Nie';

  @override
  String get wellDone => 'Świetnie!';

  @override
  String get lessonDone => 'Lekcja ukończona!';

  @override
  String get taskWon => 'Hura!';

  @override
  String get tryAgain => 'Spróbujmy jeszcze raz!';

  @override
  String get botWon => 'Robocik wygrał. Gramy jeszcze raz!';

  @override
  String get promoted => 'Zmienia się w księżniczkę!';

  @override
  String get lavaWarning => 'Au, lawa!';

  @override
  String tapTarget(String target) {
    return 'Stuknij w: $target';
  }

  @override
  String street(String name) {
    return 'ulicę $name';
  }

  @override
  String house(String name) {
    return 'rząd $name';
  }

  @override
  String room(String name) {
    return 'komnatę $name';
  }

  @override
  String get dragHint => 'Przeciągnij figurkę na szachownicę';

  @override
  String get armies => 'Armie';

  @override
  String get myArmy => 'Moja armia';

  @override
  String get rivalArmy => 'Przeciwnik';

  @override
  String get battleDemo => 'Bitwa próbna';

  @override
  String taskOf(int n, int total) {
    return 'Zadanie $n z $total';
  }

  @override
  String get opponentThinking => 'Robocik myśli…';
}
