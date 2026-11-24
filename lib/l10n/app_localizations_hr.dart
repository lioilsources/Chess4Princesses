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
  String get promoted => 'Postaje kraljica!';

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

  @override
  String get hallTitle => 'Dvorana slavnih';

  @override
  String get hallGolden => 'Zlatna ploča';

  @override
  String get hallGoldenHint => '64 najslavnije partije';

  @override
  String get hallMatches => 'Mečevi za krunu';

  @override
  String get hallMatchesHint => 'Svi mečevi za naslov svjetskog prvaka';

  @override
  String get hallWomen => 'Prvakinje';

  @override
  String get hallWomenHint => 'Svjetske prvakinje i njihove partije';

  @override
  String get hallChallenge => 'Prvak i izazivač';

  @override
  String hallChallengeHint(String year) {
    return 'Najljepše pobjede obaju igrača meča za naslov $year';
  }

  @override
  String hallStickers(int n, int total) {
    return '$n od $total';
  }

  @override
  String get hallFideLine => 'Naslov FIDE 1993.–2006.';

  @override
  String get hallTiebreak => 'Brza partija';

  @override
  String get replayCheck => 'Šah!';

  @override
  String get replayMate => 'Mat!';

  @override
  String get replayCastle => 'Kralj se sakrio u dvorac!';

  @override
  String get replaySacrifice => 'Hrabra žrtva!';

  @override
  String get replayEndMate => 'Mat! Bitka je dobivena.';

  @override
  String get replayEndResign =>
      'Kralj se naklonio i predao krunu. Bitka je gotova!';

  @override
  String get replayEndDraw => 'Neriješeno! Oba kralja rukuju se.';

  @override
  String get replayEndUnfinished => 'Ova se bitka još igra.';

  @override
  String get replayPlay => 'Pusti';

  @override
  String get replayPause => 'Stanka';

  @override
  String get replayNextBattle => 'Sljedeća bitka';

  @override
  String get replayChronicle => 'Kronika';

  @override
  String get replayStepBack => 'Potez natrag';

  @override
  String get replayStepForward => 'Potez naprijed';

  @override
  String replayMoveOf(int n, int total) {
    return 'Potez $n od $total';
  }

  @override
  String get liveTitle => 'Igra se sada';

  @override
  String get liveSwitch => 'Partije s interneta';

  @override
  String get liveSwitchHint =>
      'Turniri uživo preuzimaju se samo dok je ovo uključeno.';

  @override
  String get liveNothing => 'Trenutačno se ništa ne igra.';

  @override
  String get liveError => 'Nije uspjelo učitavanje. Pokušaj ponovno kasnije.';

  @override
  String get liveOffline =>
      'Nema interneta: prikazujem ono što je već preuzeto.';

  @override
  String liveGame(int n) {
    return 'Partija $n';
  }
}
