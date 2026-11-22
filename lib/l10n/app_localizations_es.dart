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
  String get promoted => '¡Se convierte en princesa!';

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
  String get hallFamous => 'Partidas famosas';

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
}
