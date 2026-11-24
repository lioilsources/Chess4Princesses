// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'Skakkongeriget';

  @override
  String get mapTitle => 'Kongeriget';

  @override
  String get comingSoon => 'Snart';

  @override
  String get locked => 'Låst';

  @override
  String get start => 'Spil!';

  @override
  String get again => 'Igen';

  @override
  String get next => 'Videre';

  @override
  String get back => 'Tilbage';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nej';

  @override
  String get wellDone => 'Godt klaret!';

  @override
  String get lessonDone => 'Lektionen er klaret!';

  @override
  String get taskWon => 'Hurra!';

  @override
  String get tryAgain => 'Vi prøver igen!';

  @override
  String get botWon => 'Den lille robot vandt. Vi spiller igen!';

  @override
  String get promoted => 'Hun bliver til en dronning!';

  @override
  String get lavaWarning => 'Av, lava!';

  @override
  String tapTarget(String target) {
    return 'Tryk på: $target';
  }

  @override
  String street(String name) {
    return 'gade $name';
  }

  @override
  String house(String name) {
    return 'række $name';
  }

  @override
  String room(String name) {
    return 'værelse $name';
  }

  @override
  String get dragHint => 'Træk en brik ind på brættet';

  @override
  String get armies => 'Hære';

  @override
  String get myArmy => 'Min hær';

  @override
  String get rivalArmy => 'Modstander';

  @override
  String get battleDemo => 'Prøvekamp';

  @override
  String taskOf(int n, int total) {
    return 'Opgave $n af $total';
  }

  @override
  String get opponentThinking => 'Den lille robot tænker…';

  @override
  String get hallTitle => 'Berømmelsens hal';

  @override
  String get hallGolden => 'Det gyldne bræt';

  @override
  String get hallGoldenHint => 'De 64 mest berømte partier';

  @override
  String get hallMatches => 'Kampe om kronen';

  @override
  String get hallMatchesHint => 'Alle VM-matcher';

  @override
  String get hallWomen => 'Mesterinder';

  @override
  String get hallWomenHint => 'Verdensmesterinderne og deres partier';

  @override
  String get hallChallenge => 'Mester og udfordrer';

  @override
  String hallChallengeHint(String year) {
    return 'De smukkeste sejre for begge spillere i titelmatchen $year';
  }

  @override
  String hallStickers(int n, int total) {
    return '$n af $total';
  }

  @override
  String get hallFideLine => 'FIDE-titlen 1993–2006';

  @override
  String get hallTiebreak => 'Hurtigparti';

  @override
  String get replayCheck => 'Skak!';

  @override
  String get replayMate => 'Skakmat!';

  @override
  String get replayCastle => 'Kongen gemmer sig i slottet!';

  @override
  String get replaySacrifice => 'Et modigt offer!';

  @override
  String get replayEndMate => 'Skakmat! Kampen er vundet.';

  @override
  String get replayEndResign =>
      'Kongen bukker og rækker sin krone frem. Kampen er slut!';

  @override
  String get replayEndDraw => 'Uafgjort! De to konger giver hinanden hånden.';

  @override
  String get replayEndUnfinished => 'Den her kamp er ikke slut endnu.';

  @override
  String get replayPlay => 'Afspil';

  @override
  String get replayPause => 'Pause';

  @override
  String get replayNextBattle => 'Næste kamp';

  @override
  String get replayChronicle => 'Krøniken';

  @override
  String get replayStepBack => 'Træk tilbage';

  @override
  String get replayStepForward => 'Træk frem';

  @override
  String replayMoveOf(int n, int total) {
    return 'Træk $n af $total';
  }

  @override
  String get liveTitle => 'Spilles nu';

  @override
  String get liveSwitch => 'Partier fra internettet';

  @override
  String get liveSwitchHint =>
      'Live-turneringer hentes kun, når den her er slået til.';

  @override
  String get liveNothing => 'Der bliver ikke spillet noget lige nu.';

  @override
  String get liveError => 'Kunne ikke indlæses. Prøv igen senere.';

  @override
  String get liveOffline =>
      'Intet internet: viser det, der allerede er hentet.';

  @override
  String liveGame(int n) {
    return 'Parti $n';
  }

  @override
  String get settingsTitle => 'Indstillinger';

  @override
  String get settingsBattles => 'Kampe ved slag';

  @override
  String get settingsBattlesHint =>
      'Fra: en slået brik forsvinder bare i en sky.';

  @override
  String get settingsClassic => 'Klassiske skakbrikker';

  @override
  String get settingsClassicHint =>
      'I partier i stedet for hærenes figurer. Så vises kampe ikke.';

  @override
  String get liveBadge => 'Live';

  @override
  String get liveSkip => 'Spring over';

  @override
  String get liveTryOwn => 'Jeg prøver selv';

  @override
  String get liveAdviser => 'Rådgiver';

  @override
  String get liveBackToGame => 'Tilbage til partiet';

  @override
  String get liveNewMove => 'Nyt træk!';

  @override
  String liveNewMoves(int n) {
    return 'Nye træk: $n';
  }

  @override
  String get liveTimeTrouble => 'Tiden er ved at løbe ud!';

  @override
  String get liveAdviserThinking => 'Rådgiveren tænker stadig.';

  @override
  String get liveAdviserContinue => 'Jeg fortsætter selv';

  @override
  String get liveAhead => 'Hvem fører';

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
