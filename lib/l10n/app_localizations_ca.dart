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
  String get promoted => 'Es converteix en princesa!';

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
  String get hallFamous => 'Partides famoses';

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
}
