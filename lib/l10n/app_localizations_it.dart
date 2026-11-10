// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Regno degli Scacchi';

  @override
  String get mapTitle => 'Regno';

  @override
  String get comingSoon => 'Presto';

  @override
  String get locked => 'Bloccato';

  @override
  String get start => 'Giochiamo!';

  @override
  String get again => 'Ancora';

  @override
  String get next => 'Avanti';

  @override
  String get back => 'Indietro';

  @override
  String get yes => 'Sì';

  @override
  String get no => 'No';

  @override
  String get wellDone => 'Bravissimo!';

  @override
  String get lessonDone => 'Lezione finita!';

  @override
  String get taskWon => 'Evviva!';

  @override
  String get tryAgain => 'Riproviamo!';

  @override
  String get botWon => 'Ha vinto il robottino. Giochiamo ancora!';

  @override
  String get promoted => 'Diventa una principessa!';

  @override
  String get lavaWarning => 'Ahi, la lava!';

  @override
  String tapTarget(String target) {
    return 'Tocca: $target';
  }

  @override
  String street(String name) {
    return 'la via $name';
  }

  @override
  String house(String name) {
    return 'la fila $name';
  }

  @override
  String room(String name) {
    return 'la stanza $name';
  }

  @override
  String get dragHint => 'Trascina un pezzo sulla scacchiera';

  @override
  String get armies => 'Eserciti';

  @override
  String get myArmy => 'Il mio esercito';

  @override
  String get rivalArmy => 'Avversario';

  @override
  String get battleDemo => 'Battaglia di prova';

  @override
  String taskOf(int n, int total) {
    return 'Compito $n di $total';
  }

  @override
  String get opponentThinking => 'Il robottino sta pensando…';
}
