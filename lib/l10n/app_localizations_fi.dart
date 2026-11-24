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
  String get promoted => 'Hänestä tulee kuningatar!';

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
  String get hallGolden => 'Kultainen lauta';

  @override
  String get hallGoldenHint => '64 kuuluisinta peliä';

  @override
  String get hallMatches => 'Kamppailut kruunusta';

  @override
  String get hallMatchesHint => 'Kaikki maailmanmestaruusottelut';

  @override
  String get hallWomen => 'Mestarinaiset';

  @override
  String get hallWomenHint => 'Naisten maailmanmestarit ja heidän pelinsä';

  @override
  String get hallChallenge => 'Mestari ja haastaja';

  @override
  String hallChallengeHint(String year) {
    return 'Kummankin pelaajan kauneimmat voitot, MM-ottelu $year';
  }

  @override
  String hallStickers(int n, int total) {
    return '$n/$total';
  }

  @override
  String get hallFideLine => 'FIDE-titteli 1993–2006';

  @override
  String get hallTiebreak => 'Pikapeli';

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

  @override
  String get settingsTitle => 'Asetukset';

  @override
  String get settingsBattles => 'Taistelut syödessä';

  @override
  String get settingsBattlesHint => 'Pois: syöty nappula vain katoaa pilveen.';

  @override
  String get settingsClassic => 'Klassiset shakkinappulat';

  @override
  String get settingsClassicHint =>
      'Peleissä armeijoiden hahmojen sijaan. Taisteluita ei silloin näytetä.';

  @override
  String get liveBadge => 'Suorana';

  @override
  String get liveSkip => 'Ohita';

  @override
  String get liveTryOwn => 'Kokeilen itse';

  @override
  String get liveAdviser => 'Neuvonantaja';

  @override
  String get liveBackToGame => 'Takaisin peliin';

  @override
  String get liveNewMove => 'Uusi siirto!';

  @override
  String liveNewMoves(int n) {
    return 'Uusia siirtoja: $n';
  }

  @override
  String get liveTimeTrouble => 'Aika loppuu!';

  @override
  String get liveAdviserThinking => 'Neuvonantaja miettii vielä.';

  @override
  String get liveAdviserContinue => 'Jatkan itse';

  @override
  String get liveAhead => 'Kuka johtaa';

  @override
  String get liveClockApprox => 'Aika on likimääräinen';

  @override
  String get liveReset => 'Alusta';

  @override
  String liveStartsAt(String time) {
    return 'Alkaa klo $time';
  }

  @override
  String liveDepth(int n) {
    return 'syvyys $n';
  }
}
