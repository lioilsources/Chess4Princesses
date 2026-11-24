// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Reino del Ajedrez';

  @override
  String get mapTitle => 'Reino';

  @override
  String get comingSoon => 'Pronto';

  @override
  String get locked => 'Bloqueado';

  @override
  String get start => '¡A jugar!';

  @override
  String get again => 'Otra vez';

  @override
  String get next => 'Siguiente';

  @override
  String get back => 'Atrás';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get wellDone => '¡Muy bien!';

  @override
  String get lessonDone => '¡Lección terminada!';

  @override
  String get taskWon => '¡Hurra!';

  @override
  String get tryAgain => '¡Probamos otra vez!';

  @override
  String get botWon => 'Ha ganado el robotito. ¡Jugamos otra vez!';

  @override
  String get promoted => '¡Se convierte en reina!';

  @override
  String get lavaWarning => '¡Ay, lava!';

  @override
  String tapTarget(String target) {
    return 'Toca: $target';
  }

  @override
  String street(String name) {
    return 'la calle $name';
  }

  @override
  String house(String name) {
    return 'la fila $name';
  }

  @override
  String room(String name) {
    return 'la habitación $name';
  }

  @override
  String get dragHint => 'Arrastra una pieza al tablero';

  @override
  String get armies => 'Ejércitos';

  @override
  String get myArmy => 'Mi ejército';

  @override
  String get rivalArmy => 'Rival';

  @override
  String get battleDemo => 'Batalla de prueba';

  @override
  String taskOf(int n, int total) {
    return 'Tarea $n de $total';
  }

  @override
  String get opponentThinking => 'El robotito está pensando…';

  @override
  String get hallTitle => 'Salón de la Fama';

  @override
  String get hallGolden => 'El tablero de oro';

  @override
  String get hallGoldenHint => 'Las 64 partidas más famosas';

  @override
  String get hallMatches => 'Duelos por la corona';

  @override
  String get hallMatchesHint => 'Todos los matches por el campeonato mundial';

  @override
  String get hallWomen => 'Campeonas';

  @override
  String get hallWomenHint => 'Las campeonas del mundo y sus partidas';

  @override
  String get hallChallenge => 'Campeón y aspirante';

  @override
  String hallChallengeHint(String year) {
    return 'Las victorias más bonitas de los dos jugadores del match por el título $year';
  }

  @override
  String hallStickers(int n, int total) {
    return '$n de $total';
  }

  @override
  String get hallFideLine => 'Título FIDE 1993–2006';

  @override
  String get hallTiebreak => 'Partida rápida';

  @override
  String get replayCheck => '¡Jaque!';

  @override
  String get replayMate => '¡Jaque mate!';

  @override
  String get replayCastle => '¡El rey se esconde en el castillo!';

  @override
  String get replaySacrifice => '¡Un sacrificio valiente!';

  @override
  String get replayEndMate => '¡Jaque mate! La batalla está ganada.';

  @override
  String get replayEndResign =>
      'El rey hace una reverencia y entrega su corona. ¡Fin de la batalla!';

  @override
  String get replayEndDraw => '¡Tablas! Los dos reyes se dan la mano.';

  @override
  String get replayEndUnfinished => 'Esta batalla todavía continúa.';

  @override
  String get replayPlay => 'Reproducir';

  @override
  String get replayPause => 'Pausa';

  @override
  String get replayNextBattle => 'Siguiente batalla';

  @override
  String get replayChronicle => 'Crónica';

  @override
  String get replayStepBack => 'Jugada atrás';

  @override
  String get replayStepForward => 'Jugada adelante';

  @override
  String replayMoveOf(int n, int total) {
    return 'Jugada $n de $total';
  }

  @override
  String get liveTitle => 'Jugándose ahora';

  @override
  String get liveSwitch => 'Partidas de internet';

  @override
  String get liveSwitchHint =>
      'Los torneos en directo solo se descargan mientras esto está activado.';

  @override
  String get liveNothing => 'Ahora mismo no se está jugando nada.';

  @override
  String get liveError => 'No se pudo cargar. Inténtalo más tarde.';

  @override
  String get liveOffline => 'Sin internet: muestro lo que ya está descargado.';

  @override
  String liveGame(int n) {
    return 'Partida $n';
  }
}
