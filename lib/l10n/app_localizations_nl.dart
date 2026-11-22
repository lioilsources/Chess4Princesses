// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Schaakkoninkrijk';

  @override
  String get mapTitle => 'Koninkrijk';

  @override
  String get comingSoon => 'Binnenkort';

  @override
  String get locked => 'Op slot';

  @override
  String get start => 'Spelen!';

  @override
  String get again => 'Nog een keer';

  @override
  String get next => 'Verder';

  @override
  String get back => 'Terug';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nee';

  @override
  String get wellDone => 'Goed gedaan!';

  @override
  String get lessonDone => 'Les klaar!';

  @override
  String get taskWon => 'Hoera!';

  @override
  String get tryAgain => 'We proberen het nog een keer!';

  @override
  String get botWon => 'Het robotje heeft gewonnen. We spelen nog een keer!';

  @override
  String get promoted => 'Ze wordt een koningin!';

  @override
  String get lavaWarning => 'Au, lava!';

  @override
  String tapTarget(String target) {
    return 'Tik op: $target';
  }

  @override
  String street(String name) {
    return 'straat $name';
  }

  @override
  String house(String name) {
    return 'rij $name';
  }

  @override
  String room(String name) {
    return 'kamer $name';
  }

  @override
  String get dragHint => 'Sleep een stuk naar het bord';

  @override
  String get armies => 'Legers';

  @override
  String get myArmy => 'Mijn leger';

  @override
  String get rivalArmy => 'Tegenstander';

  @override
  String get battleDemo => 'Proefgevecht';

  @override
  String taskOf(int n, int total) {
    return 'Opdracht $n van $total';
  }

  @override
  String get opponentThinking => 'Het robotje denkt na…';

  @override
  String get hallTitle => 'Roemhal';

  @override
  String get hallGolden => 'Het gouden bord';

  @override
  String get hallGoldenHint => 'De 64 beroemdste partijen';

  @override
  String get hallMatches => 'Strijd om de kroon';

  @override
  String get hallMatchesHint => 'Alle wereldkampioenschapsmatches';

  @override
  String get hallWomen => 'Kampioenes';

  @override
  String get hallWomenHint => 'Wereldkampioenes en hun partijen';

  @override
  String hallStickers(int n, int total) {
    return '$n van $total';
  }

  @override
  String get hallFideLine => 'FIDE-titel 1993–2006';

  @override
  String get hallTiebreak => 'Snelschaakpartij';

  @override
  String get replayCheck => 'Schaak!';

  @override
  String get replayMate => 'Schaakmat!';

  @override
  String get replayCastle => 'De koning verstopt zich in het kasteel!';

  @override
  String get replaySacrifice => 'Een dappere opoffering!';

  @override
  String get replayEndMate => 'Schaakmat! Het gevecht is gewonnen.';

  @override
  String get replayEndResign =>
      'De koning buigt en geeft zijn kroon af. Het gevecht is voorbij!';

  @override
  String get replayEndDraw => 'Remise! Beide koningen geven elkaar een hand.';

  @override
  String get replayEndUnfinished => 'Dit gevecht is nog bezig.';

  @override
  String get replayPlay => 'Afspelen';

  @override
  String get replayPause => 'Pauze';

  @override
  String get replayNextBattle => 'Volgend gevecht';

  @override
  String get replayChronicle => 'Kroniek';

  @override
  String get replayStepBack => 'Zet terug';

  @override
  String get replayStepForward => 'Zet vooruit';

  @override
  String replayMoveOf(int n, int total) {
    return 'Zet $n van $total';
  }

  @override
  String get liveTitle => 'Nu aan het spelen';

  @override
  String get liveSwitch => 'Partijen van internet';

  @override
  String get liveSwitchHint =>
      'Live-toernooien worden alleen gedownload als dit aanstaat.';

  @override
  String get liveNothing => 'Er wordt nu niets gespeeld.';

  @override
  String get liveError => 'Laden is niet gelukt. Probeer het later nog eens.';

  @override
  String get liveOffline => 'Geen internet: ik laat zien wat al is gedownload.';

  @override
  String liveGame(int n) {
    return 'Partij $n';
  }
}
