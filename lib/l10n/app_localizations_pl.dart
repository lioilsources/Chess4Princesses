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
  String get promoted => 'Zmienia się w królową!';

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

  @override
  String get hallTitle => 'Sala sław';

  @override
  String get hallFamous => 'Słynne partie';

  @override
  String get replayCheck => 'Szach!';

  @override
  String get replayMate => 'Mat!';

  @override
  String get replayCastle => 'Król schował się w zamku!';

  @override
  String get replaySacrifice => 'Odważna ofiara!';

  @override
  String get replayEndMate => 'Mat! Bitwa wygrana.';

  @override
  String get replayEndResign =>
      'Król ukłonił się i oddał koronę. Koniec bitwy!';

  @override
  String get replayEndDraw => 'Remis! Obaj królowie podali sobie ręce.';

  @override
  String get replayEndUnfinished => 'Ta bitwa jeszcze trwa.';

  @override
  String get replayPlay => 'Odtwórz';

  @override
  String get replayPause => 'Pauza';

  @override
  String get replayNextBattle => 'Następna bitwa';

  @override
  String get replayChronicle => 'Kronika';

  @override
  String get replayStepBack => 'Ruch wstecz';

  @override
  String get replayStepForward => 'Ruch naprzód';

  @override
  String replayMoveOf(int n, int total) {
    return 'Ruch $n z $total';
  }

  @override
  String get liveTitle => 'Gramy teraz';

  @override
  String get liveSwitch => 'Partie z internetu';

  @override
  String get liveSwitchHint =>
      'Turnieje na żywo są pobierane tylko wtedy, gdy ten przełącznik jest włączony.';

  @override
  String get liveNothing => 'Teraz nic się nie rozgrywa.';

  @override
  String get liveError => 'Nie udało się wczytać. Spróbuj później.';

  @override
  String get liveOffline => 'Brak internetu: pokazuję to, co już pobrano.';

  @override
  String liveGame(int n) {
    return 'Partia $n';
  }
}
