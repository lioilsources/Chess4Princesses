// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Schachkönigreich';

  @override
  String get mapTitle => 'Königreich';

  @override
  String get comingSoon => 'Bald';

  @override
  String get locked => 'Gesperrt';

  @override
  String get start => 'Los geht\'s!';

  @override
  String get again => 'Nochmal';

  @override
  String get next => 'Weiter';

  @override
  String get back => 'Zurück';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get wellDone => 'Super gemacht!';

  @override
  String get lessonDone => 'Lektion geschafft!';

  @override
  String get taskWon => 'Hurra!';

  @override
  String get tryAgain => 'Wir probieren es nochmal!';

  @override
  String get botWon => 'Der kleine Roboter hat gewonnen. Wir spielen nochmal!';

  @override
  String get promoted => 'Sie wird zur Königin!';

  @override
  String get lavaWarning => 'Autsch, Lava!';

  @override
  String tapTarget(String target) {
    return 'Tippe auf: $target';
  }

  @override
  String street(String name) {
    return 'Straße $name';
  }

  @override
  String house(String name) {
    return 'Reihe $name';
  }

  @override
  String room(String name) {
    return 'Zimmer $name';
  }

  @override
  String get dragHint => 'Zieh eine Figur aufs Brett';

  @override
  String get armies => 'Armeen';

  @override
  String get myArmy => 'Meine Armee';

  @override
  String get rivalArmy => 'Gegner';

  @override
  String get battleDemo => 'Probeschlacht';

  @override
  String taskOf(int n, int total) {
    return 'Aufgabe $n von $total';
  }

  @override
  String get opponentThinking => 'Der kleine Roboter denkt nach…';

  @override
  String get hallTitle => 'Ruhmeshalle';

  @override
  String get hallGolden => 'Das goldene Brett';

  @override
  String get hallGoldenHint => 'Die 64 berühmtesten Partien';

  @override
  String get hallMatches => 'Kämpfe um die Krone';

  @override
  String get hallMatchesHint => 'Alle Weltmeisterschaftskämpfe';

  @override
  String get hallWomen => 'Weltmeisterinnen';

  @override
  String get hallWomenHint => 'Weltmeisterinnen und ihre Partien';

  @override
  String get hallChallenge => 'Weltmeister und Herausforderer';

  @override
  String hallChallengeHint(String year) {
    return 'Die schönsten Siege beider Spieler des WM-Kampfs $year';
  }

  @override
  String hallStickers(int n, int total) {
    return '$n von $total';
  }

  @override
  String get hallFideLine => 'FIDE-Titel 1993–2006';

  @override
  String get hallTiebreak => 'Schnellpartie';

  @override
  String get replayCheck => 'Schach!';

  @override
  String get replayMate => 'Schachmatt!';

  @override
  String get replayCastle => 'Der König versteckt sich in der Burg!';

  @override
  String get replaySacrifice => 'Ein mutiges Opfer!';

  @override
  String get replayEndMate => 'Schachmatt! Die Schlacht ist gewonnen.';

  @override
  String get replayEndResign =>
      'Der König verbeugt sich und gibt seine Krone ab. Die Schlacht ist vorbei!';

  @override
  String get replayEndDraw =>
      'Unentschieden! Beide Könige reichen sich die Hand.';

  @override
  String get replayEndUnfinished => 'Diese Schlacht läuft noch.';

  @override
  String get replayPlay => 'Abspielen';

  @override
  String get replayPause => 'Pause';

  @override
  String get replayNextBattle => 'Nächste Schlacht';

  @override
  String get replayChronicle => 'Chronik';

  @override
  String get replayStepBack => 'Zug zurück';

  @override
  String get replayStepForward => 'Zug vor';

  @override
  String replayMoveOf(int n, int total) {
    return 'Zug $n von $total';
  }

  @override
  String get liveTitle => 'Läuft gerade';

  @override
  String get liveSwitch => 'Partien aus dem Internet';

  @override
  String get liveSwitchHint =>
      'Live-Turniere werden nur geladen, solange der Schalter an ist.';

  @override
  String get liveNothing => 'Gerade wird nichts gespielt.';

  @override
  String get liveError =>
      'Konnte nicht geladen werden. Versuch es später noch einmal.';

  @override
  String get liveOffline => 'Kein Internet: Ich zeige, was schon geladen ist.';

  @override
  String liveGame(int n) {
    return 'Partie $n';
  }

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsBattles => 'Kämpfe beim Schlagen';

  @override
  String get settingsBattlesHint =>
      'Aus: eine geschlagene Figur verschwindet nur in einer Wolke.';

  @override
  String get settingsClassic => 'Klassische Schachfiguren';

  @override
  String get settingsClassicHint =>
      'In Partien statt der Armeefiguren. Kämpfe werden dann nicht gezeigt.';

  @override
  String get liveBadge => 'Live';

  @override
  String get liveSkip => 'Überspringen';

  @override
  String get liveTryOwn => 'Ich probiere es selbst';

  @override
  String get liveAdviser => 'Ratgeber';

  @override
  String get liveBackToGame => 'Zurück zur Partie';

  @override
  String get liveNewMove => 'Neuer Zug!';

  @override
  String liveNewMoves(int n) {
    return 'Neue Züge: $n';
  }

  @override
  String get liveTimeTrouble => 'Die Zeit wird knapp!';

  @override
  String get liveAdviserThinking => 'Der Ratgeber denkt noch nach.';

  @override
  String get liveAdviserContinue => 'Ich spiele selbst weiter';

  @override
  String get liveAhead => 'Wer führt';

  @override
  String get liveClockApprox => 'Die Zeit ist ungefähr';

  @override
  String get liveReset => 'Von vorn';

  @override
  String liveStartsAt(String time) {
    return 'Beginn um $time';
  }

  @override
  String liveDepth(int n) {
    return 'Tiefe $n';
  }
}
