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

  @override
  String get hallTitle => 'Síň slávy';

  @override
  String get hallFamous => 'Slavné partie';

  @override
  String get replayCheck => 'Šach!';

  @override
  String get replayMate => 'Mat!';

  @override
  String get replayCastle => 'Král se schoval do hradu!';

  @override
  String get replaySacrifice => 'Odvážná oběť!';

  @override
  String get replayEndMate => 'Mat! Bitva je vyhraná.';

  @override
  String get replayEndResign => 'Král se uklonil a podal korunu. Konec bitvy!';

  @override
  String get replayEndDraw => 'Remíza! Oba králové si podali ruce.';

  @override
  String get replayEndUnfinished => 'Tahle bitva se ještě hraje.';

  @override
  String get replayPlay => 'Přehrát';

  @override
  String get replayPause => 'Pauza';

  @override
  String get replayNextBattle => 'Další bitva';

  @override
  String get replayChronicle => 'Kronika';

  @override
  String get replayStepBack => 'Tah zpět';

  @override
  String get replayStepForward => 'Tah vpřed';

  @override
  String replayMoveOf(int n, int total) {
    return 'Tah $n z $total';
  }
}
