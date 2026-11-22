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

  @override
  String get hallTitle => 'Sieň slávy';

  @override
  String get hallFamous => 'Slávne partie';

  @override
  String get replayCheck => 'Šach!';

  @override
  String get replayMate => 'Mat!';

  @override
  String get replayCastle => 'Kráľ sa schoval do hradu!';

  @override
  String get replaySacrifice => 'Odvážna obeta!';

  @override
  String get replayEndMate => 'Mat! Bitka je vyhraná.';

  @override
  String get replayEndResign =>
      'Kráľ sa uklonil a odovzdal korunu. Koniec bitky!';

  @override
  String get replayEndDraw => 'Remíza! Obaja králi si podali ruky.';

  @override
  String get replayEndUnfinished => 'Táto bitka ešte trvá.';

  @override
  String get replayPlay => 'Prehrať';

  @override
  String get replayPause => 'Pauza';

  @override
  String get replayNextBattle => 'Ďalšia bitka';

  @override
  String get replayChronicle => 'Kronika';

  @override
  String get replayStepBack => 'Ťah späť';

  @override
  String get replayStepForward => 'Ťah vpred';

  @override
  String replayMoveOf(int n, int total) {
    return 'Ťah $n z $total';
  }

  @override
  String get liveTitle => 'Práve sa hrá';

  @override
  String get liveSwitch => 'Partie z internetu';

  @override
  String get liveSwitchHint =>
      'Živé turnaje sa sťahujú len so zapnutým prepínačom.';

  @override
  String get liveNothing => 'Teraz sa nič nehrá.';

  @override
  String get liveError => 'Nepodarilo sa načítať. Skús to neskôr.';

  @override
  String get liveOffline => 'Bez internetu: ukazujem, čo je už stiahnuté.';

  @override
  String liveGame(int n) {
    return 'Partia $n';
  }
}
