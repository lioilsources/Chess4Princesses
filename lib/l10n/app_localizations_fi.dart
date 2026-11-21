// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'Shakkivaltakunta';

  @override
  String get mapTitle => 'Valtakunta';

  @override
  String get comingSoon => 'Pian';

  @override
  String get locked => 'Lukittu';

  @override
  String get start => 'Pelataan!';

  @override
  String get again => 'Uudestaan';

  @override
  String get next => 'Seuraava';

  @override
  String get back => 'Takaisin';

  @override
  String get yes => 'Kyllä';

  @override
  String get no => 'Ei';

  @override
  String get wellDone => 'Hienoa!';

  @override
  String get lessonDone => 'Oppitunti valmis!';

  @override
  String get taskWon => 'Hurraa!';

  @override
  String get tryAgain => 'Yritetään uudestaan!';

  @override
  String get botWon => 'Pikkurobotti voitti. Pelataan uudestaan!';

  @override
  String get promoted => 'Hänestä tulee prinsessa!';

  @override
  String get lavaWarning => 'Auts, laavaa!';

  @override
  String tapTarget(String target) {
    return 'Napauta: $target';
  }

  @override
  String street(String name) {
    return 'katu $name';
  }

  @override
  String house(String name) {
    return 'rivi $name';
  }

  @override
  String room(String name) {
    return 'huone $name';
  }

  @override
  String get dragHint => 'Vedä nappula laudalle';

  @override
  String get armies => 'Armeijat';

  @override
  String get myArmy => 'Minun armeijani';

  @override
  String get rivalArmy => 'Vastustaja';

  @override
  String get battleDemo => 'Harjoitustaistelu';

  @override
  String taskOf(int n, int total) {
    return 'Tehtävä $n/$total';
  }

  @override
  String get opponentThinking => 'Pikkurobotti miettii…';

  @override
  String get hallTitle => 'Kunniahalli';

  @override
  String get hallFamous => 'Kuuluisia pelejä';

  @override
  String get replayCheck => 'Shakki!';

  @override
  String get replayMate => 'Matti!';

  @override
  String get replayCastle => 'Kuningas piiloutuu linnaan!';

  @override
  String get replaySacrifice => 'Rohkea uhraus!';

  @override
  String get replayEndMate => 'Matti! Taistelu on voitettu.';

  @override
  String get replayEndResign =>
      'Kuningas kumartaa ja ojentaa kruununsa. Taistelu on ohi!';

  @override
  String get replayEndDraw => 'Tasapeli! Molemmat kuninkaat kättelevät.';

  @override
  String get replayEndUnfinished => 'Tämä taistelu on vielä kesken.';

  @override
  String get replayPlay => 'Toista';

  @override
  String get replayPause => 'Tauko';

  @override
  String get replayNextBattle => 'Seuraava taistelu';

  @override
  String get replayChronicle => 'Kronikka';

  @override
  String get replayStepBack => 'Siirto taakse';

  @override
  String get replayStepForward => 'Siirto eteen';

  @override
  String replayMoveOf(int n, int total) {
    return 'Siirto $n/$total';
  }

  @override
  String get liveTitle => 'Pelataan nyt';

  @override
  String get liveSwitch => 'Pelejä netistä';

  @override
  String get liveSwitchHint =>
      'Suorat turnaukset ladataan vain, kun tämä on päällä.';

  @override
  String get liveNothing => 'Juuri nyt ei pelata mitään.';

  @override
  String get liveError => 'Lataus ei onnistunut. Yritä myöhemmin uudelleen.';

  @override
  String get liveOffline => 'Ei nettiä: näytän jo ladatut.';

  @override
  String liveGame(int n) {
    return 'Peli $n';
  }
}
