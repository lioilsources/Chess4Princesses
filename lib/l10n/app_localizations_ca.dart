// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get appTitle => 'Regne dels Escacs';

  @override
  String get mapTitle => 'Regne';

  @override
  String get comingSoon => 'Aviat';

  @override
  String get locked => 'Bloquejat';

  @override
  String get start => 'A jugar!';

  @override
  String get again => 'Una altra vegada';

  @override
  String get next => 'Següent';

  @override
  String get back => 'Enrere';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get wellDone => 'Molt bé!';

  @override
  String get lessonDone => 'Lliçó acabada!';

  @override
  String get taskWon => 'Visca!';

  @override
  String get tryAgain => 'Ho tornem a provar!';

  @override
  String get botWon => 'Ha guanyat el robotet. Tornem a jugar!';

  @override
  String get promoted => 'Es converteix en reina!';

  @override
  String get lavaWarning => 'Ai, lava!';

  @override
  String tapTarget(String target) {
    return 'Toca: $target';
  }

  @override
  String street(String name) {
    return 'el carrer $name';
  }

  @override
  String house(String name) {
    return 'la fila $name';
  }

  @override
  String room(String name) {
    return 'l\'habitació $name';
  }

  @override
  String get dragHint => 'Arrossega una peça al tauler';

  @override
  String get armies => 'Exèrcits';

  @override
  String get myArmy => 'El meu exèrcit';

  @override
  String get rivalArmy => 'Rival';

  @override
  String get battleDemo => 'Batalla de prova';

  @override
  String taskOf(int n, int total) {
    return 'Tasca $n de $total';
  }

  @override
  String get opponentThinking => 'El robotet està pensant…';

  @override
  String get hallTitle => 'Sala de la Fama';

  @override
  String get hallGolden => 'El tauler d\'or';

  @override
  String get hallGoldenHint => 'Les 64 partides més famoses';

  @override
  String get hallMatches => 'Duels per la corona';

  @override
  String get hallMatchesHint => 'Tots els matxs pel campionat del món';

  @override
  String get hallWomen => 'Campiones';

  @override
  String get hallWomenHint => 'Les campiones del món i les seves partides';

  @override
  String get hallChallenge => 'Campió i aspirant';

  @override
  String hallChallengeHint(String year) {
    return 'Les victòries més boniques dels dos jugadors del matx pel títol $year';
  }

  @override
  String hallStickers(int n, int total) {
    return '$n de $total';
  }

  @override
  String get hallFideLine => 'Títol FIDE 1993–2006';

  @override
  String get hallTiebreak => 'Partida ràpida';

  @override
  String get replayCheck => 'Escac!';

  @override
  String get replayMate => 'Escac i mat!';

  @override
  String get replayCastle => 'El rei s’amaga al castell!';

  @override
  String get replaySacrifice => 'Un sacrifici valent!';

  @override
  String get replayEndMate => 'Escac i mat! Hem guanyat la batalla.';

  @override
  String get replayEndResign =>
      'El rei fa una reverència i lliura la corona. Fi de la batalla!';

  @override
  String get replayEndDraw => 'Taules! Els dos reis es donen la mà.';

  @override
  String get replayEndUnfinished => 'Aquesta batalla encara continua.';

  @override
  String get replayPlay => 'Reprodueix';

  @override
  String get replayPause => 'Pausa';

  @override
  String get replayNextBattle => 'Següent batalla';

  @override
  String get replayChronicle => 'Crònica';

  @override
  String get replayStepBack => 'Jugada enrere';

  @override
  String get replayStepForward => 'Jugada endavant';

  @override
  String replayMoveOf(int n, int total) {
    return 'Jugada $n de $total';
  }

  @override
  String get liveTitle => 'Es juga ara';

  @override
  String get liveSwitch => 'Partides d’internet';

  @override
  String get liveSwitchHint =>
      'Els torneigs en directe només es baixen mentre això està activat.';

  @override
  String get liveNothing => 'Ara no s’està jugant res.';

  @override
  String get liveError => 'No s’ha pogut carregar. Torna-ho a provar més tard.';

  @override
  String get liveOffline => 'Sense internet: mostro el que ja està baixat.';

  @override
  String liveGame(int n) {
    return 'Partida $n';
  }

  @override
  String get settingsTitle => 'Configuració';

  @override
  String get settingsBattles => 'Batalles en capturar';

  @override
  String get settingsBattlesHint =>
      'Desactivat: la peça capturada només desapareix en un núvol.';

  @override
  String get settingsClassic => 'Peces d\'escacs clàssiques';

  @override
  String get settingsClassicHint =>
      'A les partides, en lloc dels personatges dels exèrcits.';

  @override
  String get liveBadge => 'En directe';

  @override
  String get liveSkip => 'Salta';

  @override
  String get liveTryOwn => 'Ho provaré jo';

  @override
  String get liveAdviser => 'Conseller';

  @override
  String get liveBackToGame => 'Torna a la partida';

  @override
  String get liveNewMove => 'Jugada nova!';

  @override
  String liveNewMoves(int n) {
    return 'Jugades noves: $n';
  }

  @override
  String get liveTimeTrouble => 'S\'acaba el temps!';

  @override
  String get liveAdviserThinking => 'El conseller encara pensa.';

  @override
  String get liveAdviserContinue => 'Continuaré jo';

  @override
  String get liveAhead => 'Qui va guanyant';

  @override
  String get liveClockApprox => 'El temps és aproximat';

  @override
  String get liveReset => 'Des del principi';

  @override
  String liveStartsAt(String time) {
    return 'Comença a les $time';
  }

  @override
  String liveDepth(int n) {
    return 'profunditat $n';
  }
}
