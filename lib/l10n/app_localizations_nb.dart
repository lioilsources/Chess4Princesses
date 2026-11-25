// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get appTitle => 'Sjakkriket';

  @override
  String get mapTitle => 'Riket';

  @override
  String get comingSoon => 'Snart';

  @override
  String get locked => 'Låst';

  @override
  String get start => 'Spill!';

  @override
  String get again => 'Igjen';

  @override
  String get next => 'Neste';

  @override
  String get back => 'Tilbake';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nei';

  @override
  String get wellDone => 'Bra jobba!';

  @override
  String get lessonDone => 'Leksjonen er ferdig!';

  @override
  String get taskWon => 'Hurra!';

  @override
  String get tryAgain => 'Vi prøver igjen!';

  @override
  String get botWon => 'Den lille roboten vant. Vi spiller igjen!';

  @override
  String get promoted => 'Hun blir en dronning!';

  @override
  String get lavaWarning => 'Au, lava!';

  @override
  String tapTarget(String target) {
    return 'Trykk på: $target';
  }

  @override
  String street(String name) {
    return 'gate $name';
  }

  @override
  String house(String name) {
    return 'rad $name';
  }

  @override
  String room(String name) {
    return 'rom $name';
  }

  @override
  String get dragHint => 'Dra en brikke til brettet';

  @override
  String get armies => 'Hærer';

  @override
  String get myArmy => 'Min hær';

  @override
  String get rivalArmy => 'Motstander';

  @override
  String get battleDemo => 'Prøvekamp';

  @override
  String taskOf(int n, int total) {
    return 'Oppgave $n av $total';
  }

  @override
  String get opponentThinking => 'Den lille roboten tenker…';

  @override
  String get hallTitle => 'Berømmelsens hall';

  @override
  String get hallGolden => 'Det gylne brettet';

  @override
  String get hallGoldenHint => 'De 64 mest berømte partiene';

  @override
  String get hallMatches => 'Kamper om kronen';

  @override
  String get hallMatchesHint => 'Alle VM-matcher';

  @override
  String get hallWomen => 'Mesterinner';

  @override
  String get hallWomenHint => 'Verdensmesterinnene og partiene deres';

  @override
  String get hallChallenge => 'Mester og utfordrer';

  @override
  String hallChallengeHint(String year) {
    return 'De vakreste seirene til begge spillerne i tittelkampen $year';
  }

  @override
  String hallStickers(int n, int total) {
    return '$n av $total';
  }

  @override
  String get hallFideLine => 'FIDE-tittelen 1993–2006';

  @override
  String get hallTiebreak => 'Hurtigparti';

  @override
  String get replayCheck => 'Sjakk!';

  @override
  String get replayMate => 'Sjakkmatt!';

  @override
  String get replayCastle => 'Kongen gjemmer seg i slottet!';

  @override
  String get replaySacrifice => 'Et modig offer!';

  @override
  String get replayEndMate => 'Sjakkmatt! Kampen er vunnet.';

  @override
  String get replayEndResign =>
      'Kongen bukker og gir fra seg kronen. Kampen er over!';

  @override
  String get replayEndDraw => 'Remis! De to kongene tar hverandre i hånden.';

  @override
  String get replayEndUnfinished => 'Denne kampen pågår fortsatt.';

  @override
  String get replayPlay => 'Spill av';

  @override
  String get replayPause => 'Pause';

  @override
  String get replayNextBattle => 'Neste kamp';

  @override
  String get replayChronicle => 'Krøniken';

  @override
  String get replayStepBack => 'Trekk tilbake';

  @override
  String get replayStepForward => 'Trekk frem';

  @override
  String replayMoveOf(int n, int total) {
    return 'Trekk $n av $total';
  }

  @override
  String get liveTitle => 'Spilles nå';

  @override
  String get liveSwitch => 'Partier fra internett';

  @override
  String get liveSwitchHint =>
      'Direkteturneringer lastes ned bare mens denne er slått på.';

  @override
  String get liveNothing => 'Det spilles ingenting akkurat nå.';

  @override
  String get liveError => 'Kunne ikke laste inn. Prøv igjen senere.';

  @override
  String get liveOffline =>
      'Ikke internett: viser det som allerede er lastet ned.';

  @override
  String liveGame(int n) {
    return 'Parti $n';
  }

  @override
  String get settingsTitle => 'Innstillinger';

  @override
  String get settingsBattles => 'Kamper ved slag';

  @override
  String get settingsBattlesHint =>
      'Av: en slått brikke forsvinner bare i en sky.';

  @override
  String get settingsClassic => 'Klassiske sjakkbrikker';

  @override
  String get settingsClassicHint => 'I partier i stedet for hærenes figurer.';

  @override
  String get liveBadge => 'Direkte';

  @override
  String get liveSkip => 'Hopp over';

  @override
  String get liveTryOwn => 'Jeg prøver selv';

  @override
  String get liveAdviser => 'Rådgiver';

  @override
  String get liveBackToGame => 'Tilbake til partiet';

  @override
  String get liveNewMove => 'Nytt trekk!';

  @override
  String liveNewMoves(int n) {
    return 'Nye trekk: $n';
  }

  @override
  String get liveTimeTrouble => 'Tiden er i ferd med å renne ut!';

  @override
  String get liveAdviserThinking => 'Rådgiveren tenker fortsatt.';

  @override
  String get liveAdviserContinue => 'Jeg fortsetter selv';

  @override
  String get liveAhead => 'Hvem leder';

  @override
  String get liveClockApprox => 'Tiden er omtrentlig';

  @override
  String get liveReset => 'Fra starten';

  @override
  String liveStartsAt(String time) {
    return 'Starter kl. $time';
  }

  @override
  String liveDepth(int n) {
    return 'dybde $n';
  }
}
