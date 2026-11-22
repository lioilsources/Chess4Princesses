// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'Sakkbirodalom';

  @override
  String get mapTitle => 'Birodalom';

  @override
  String get comingSoon => 'Hamarosan';

  @override
  String get locked => 'Zárva';

  @override
  String get start => 'Játsszunk!';

  @override
  String get again => 'Újra';

  @override
  String get next => 'Tovább';

  @override
  String get back => 'Vissza';

  @override
  String get yes => 'Igen';

  @override
  String get no => 'Nem';

  @override
  String get wellDone => 'Ügyes vagy!';

  @override
  String get lessonDone => 'A lecke kész!';

  @override
  String get taskWon => 'Hurrá!';

  @override
  String get tryAgain => 'Próbáljuk újra!';

  @override
  String get botWon => 'A kis robot nyert. Játsszunk újra!';

  @override
  String get promoted => 'Királynővé változik!';

  @override
  String get lavaWarning => 'Jaj, láva!';

  @override
  String tapTarget(String target) {
    return 'Koppints: $target';
  }

  @override
  String street(String name) {
    return '$name utca';
  }

  @override
  String house(String name) {
    return '$name. sor';
  }

  @override
  String room(String name) {
    return '$name szoba';
  }

  @override
  String get dragHint => 'Húzz egy bábut a táblára';

  @override
  String get armies => 'Seregek';

  @override
  String get myArmy => 'Az én seregem';

  @override
  String get rivalArmy => 'Ellenfél';

  @override
  String get battleDemo => 'Próbacsata';

  @override
  String taskOf(int n, int total) {
    return '$n. feladat / $total';
  }

  @override
  String get opponentThinking => 'A kis robot gondolkodik…';

  @override
  String get hallTitle => 'Hírességek csarnoka';

  @override
  String get hallGolden => 'Az aranytábla';

  @override
  String get hallGoldenHint => 'A 64 leghíresebb játszma';

  @override
  String get hallMatches => 'Párosmérkőzések a koronáért';

  @override
  String get hallMatchesHint => 'Minden világbajnoki párosmérkőzés';

  @override
  String get hallWomen => 'Bajnoknők';

  @override
  String get hallWomenHint => 'A női világbajnokok és játszmáik';

  @override
  String hallStickers(int n, int total) {
    return '$n/$total';
  }

  @override
  String get hallFideLine => 'FIDE-cím 1993–2006';

  @override
  String get hallTiebreak => 'Rapidjátszma';

  @override
  String get replayCheck => 'Sakk!';

  @override
  String get replayMate => 'Matt!';

  @override
  String get replayCastle => 'A király elbújt a várban!';

  @override
  String get replaySacrifice => 'Bátor áldozat!';

  @override
  String get replayEndMate => 'Matt! Megnyertük a csatát.';

  @override
  String get replayEndResign =>
      'A király meghajol és átadja a koronáját. Vége a csatának!';

  @override
  String get replayEndDraw => 'Döntetlen! A két király kezet fog.';

  @override
  String get replayEndUnfinished => 'Ez a csata még tart.';

  @override
  String get replayPlay => 'Lejátszás';

  @override
  String get replayPause => 'Szünet';

  @override
  String get replayNextBattle => 'Következő csata';

  @override
  String get replayChronicle => 'Krónika';

  @override
  String get replayStepBack => 'Lépés vissza';

  @override
  String get replayStepForward => 'Lépés előre';

  @override
  String replayMoveOf(int n, int total) {
    return 'Lépés: $n / $total';
  }

  @override
  String get liveTitle => 'Most játszanak';

  @override
  String get liveSwitch => 'Játszmák az internetről';

  @override
  String get liveSwitchHint =>
      'Az élő versenyek csak akkor töltődnek le, ha ez be van kapcsolva.';

  @override
  String get liveNothing => 'Most éppen semmi sem folyik.';

  @override
  String get liveError => 'Nem sikerült betölteni. Próbáld újra később.';

  @override
  String get liveOffline =>
      'Nincs internet: azt mutatom, ami már le van töltve.';

  @override
  String liveGame(int n) {
    return '$n. játszma';
  }
}
