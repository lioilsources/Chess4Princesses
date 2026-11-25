// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Schackriket';

  @override
  String get mapTitle => 'Riket';

  @override
  String get comingSoon => 'Snart';

  @override
  String get locked => 'Låst';

  @override
  String get start => 'Spela!';

  @override
  String get again => 'Igen';

  @override
  String get next => 'Nästa';

  @override
  String get back => 'Tillbaka';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nej';

  @override
  String get wellDone => 'Bra gjort!';

  @override
  String get lessonDone => 'Lektionen är klar!';

  @override
  String get taskWon => 'Hurra!';

  @override
  String get tryAgain => 'Vi försöker igen!';

  @override
  String get botWon => 'Den lilla roboten vann. Vi spelar igen!';

  @override
  String get promoted => 'Hon blir en drottning!';

  @override
  String get lavaWarning => 'Aj, lava!';

  @override
  String tapTarget(String target) {
    return 'Tryck på: $target';
  }

  @override
  String street(String name) {
    return 'gata $name';
  }

  @override
  String house(String name) {
    return 'rad $name';
  }

  @override
  String room(String name) {
    return 'rum $name';
  }

  @override
  String get dragHint => 'Dra en pjäs till brädet';

  @override
  String get armies => 'Arméer';

  @override
  String get myArmy => 'Min armé';

  @override
  String get rivalArmy => 'Motståndare';

  @override
  String get battleDemo => 'Provstrid';

  @override
  String taskOf(int n, int total) {
    return 'Uppgift $n av $total';
  }

  @override
  String get opponentThinking => 'Den lilla roboten tänker…';

  @override
  String get hallTitle => 'Ärans hall';

  @override
  String get hallGolden => 'Det gyllene brädet';

  @override
  String get hallGoldenHint => 'De 64 mest berömda partierna';

  @override
  String get hallMatches => 'Matcher om kronan';

  @override
  String get hallMatchesHint => 'Alla VM-matcher';

  @override
  String get hallWomen => 'Mästarinnor';

  @override
  String get hallWomenHint => 'Världsmästarinnorna och deras partier';

  @override
  String get hallChallenge => 'Mästare och utmanare';

  @override
  String hallChallengeHint(String year) {
    return 'De vackraste segrarna för båda spelarna i titelmatchen $year';
  }

  @override
  String hallStickers(int n, int total) {
    return '$n av $total';
  }

  @override
  String get hallFideLine => 'FIDE-titeln 1993–2006';

  @override
  String get hallTiebreak => 'Snabbparti';

  @override
  String get replayCheck => 'Schack!';

  @override
  String get replayMate => 'Schackmatt!';

  @override
  String get replayCastle => 'Kungen gömmer sig i slottet!';

  @override
  String get replaySacrifice => 'Ett modigt offer!';

  @override
  String get replayEndMate => 'Schackmatt! Striden är vunnen.';

  @override
  String get replayEndResign =>
      'Kungen bugar och lämnar över sin krona. Striden är slut!';

  @override
  String get replayEndDraw => 'Remi! De två kungarna skakar hand.';

  @override
  String get replayEndUnfinished => 'Den här striden pågår fortfarande.';

  @override
  String get replayPlay => 'Spela upp';

  @override
  String get replayPause => 'Paus';

  @override
  String get replayNextBattle => 'Nästa strid';

  @override
  String get replayChronicle => 'Krönika';

  @override
  String get replayStepBack => 'Drag tillbaka';

  @override
  String get replayStepForward => 'Drag framåt';

  @override
  String replayMoveOf(int n, int total) {
    return 'Drag $n av $total';
  }

  @override
  String get liveTitle => 'Spelas nu';

  @override
  String get liveSwitch => 'Partier från internet';

  @override
  String get liveSwitchHint =>
      'Direktsända turneringar laddas bara ned när den här är på.';

  @override
  String get liveNothing => 'Ingenting spelas just nu.';

  @override
  String get liveError => 'Det gick inte att ladda. Försök igen senare.';

  @override
  String get liveOffline => 'Inget internet: visar det som redan är nedladdat.';

  @override
  String liveGame(int n) {
    return 'Parti $n';
  }

  @override
  String get settingsTitle => 'Inställningar';

  @override
  String get settingsBattles => 'Strider vid slag';

  @override
  String get settingsBattlesHint =>
      'Av: en slagen pjäs försvinner bara i ett moln.';

  @override
  String get settingsClassic => 'Klassiska schackpjäser';

  @override
  String get settingsClassicHint =>
      'I partier i stället för arméernas figurer.';

  @override
  String get liveBadge => 'Live';

  @override
  String get liveSkip => 'Hoppa över';

  @override
  String get liveTryOwn => 'Jag provar själv';

  @override
  String get liveAdviser => 'Rådgivare';

  @override
  String get liveBackToGame => 'Tillbaka till partiet';

  @override
  String get liveNewMove => 'Nytt drag!';

  @override
  String liveNewMoves(int n) {
    return 'Nya drag: $n';
  }

  @override
  String get liveTimeTrouble => 'Tiden håller på att ta slut!';

  @override
  String get liveAdviserThinking => 'Rådgivaren tänker fortfarande.';

  @override
  String get liveAdviserContinue => 'Jag fortsätter själv';

  @override
  String get liveAhead => 'Vem leder';

  @override
  String get liveClockApprox => 'Tiden är ungefärlig';

  @override
  String get liveReset => 'Från början';

  @override
  String liveStartsAt(String time) {
    return 'Börjar kl. $time';
  }

  @override
  String liveDepth(int n) {
    return 'djup $n';
  }
}
