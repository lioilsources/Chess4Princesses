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
  String get hallFamous => 'Berühmte Partien';

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
}
