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
  String get promoted => 'Diventa una regina!';

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

  @override
  String get hallTitle => 'Sala della fama';

  @override
  String get hallGolden => 'La scacchiera d\'oro';

  @override
  String get hallGoldenHint => 'Le 64 partite più famose';

  @override
  String get hallMatches => 'Sfide per la corona';

  @override
  String get hallMatchesHint => 'Tutti i match per il campionato del mondo';

  @override
  String get hallWomen => 'Campionesse';

  @override
  String get hallWomenHint => 'Le campionesse del mondo e le loro partite';

  @override
  String get hallChallenge => 'Campione e sfidante';

  @override
  String hallChallengeHint(String year) {
    return 'Le vittorie più belle dei due giocatori del match per il titolo $year';
  }

  @override
  String hallStickers(int n, int total) {
    return '$n su $total';
  }

  @override
  String get hallFideLine => 'Titolo FIDE 1993–2006';

  @override
  String get hallTiebreak => 'Partita rapida';

  @override
  String get replayCheck => 'Scacco!';

  @override
  String get replayMate => 'Scacco matto!';

  @override
  String get replayCastle => 'Il re si nasconde nel castello!';

  @override
  String get replaySacrifice => 'Un coraggioso sacrificio!';

  @override
  String get replayEndMate => 'Scacco matto! La battaglia è vinta.';

  @override
  String get replayEndResign =>
      'Il re si inchina e consegna la sua corona. La battaglia è finita!';

  @override
  String get replayEndDraw => 'Patta! I due re si stringono la mano.';

  @override
  String get replayEndUnfinished => 'Questa battaglia è ancora in corso.';

  @override
  String get replayPlay => 'Riproduci';

  @override
  String get replayPause => 'Pausa';

  @override
  String get replayNextBattle => 'Battaglia successiva';

  @override
  String get replayChronicle => 'Cronaca';

  @override
  String get replayStepBack => 'Mossa indietro';

  @override
  String get replayStepForward => 'Mossa avanti';

  @override
  String replayMoveOf(int n, int total) {
    return 'Mossa $n di $total';
  }

  @override
  String get liveTitle => 'Si gioca adesso';

  @override
  String get liveSwitch => 'Partite da internet';

  @override
  String get liveSwitchHint =>
      'I tornei in diretta vengono scaricati solo quando questo è attivo.';

  @override
  String get liveNothing => 'Al momento non si sta giocando niente.';

  @override
  String get liveError => 'Impossibile caricare. Riprova più tardi.';

  @override
  String get liveOffline =>
      'Niente internet: mostro quello che è già scaricato.';

  @override
  String liveGame(int n) {
    return 'Partita $n';
  }

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsBattles => 'Battaglie nelle catture';

  @override
  String get settingsBattlesHint =>
      'Disattivato: il pezzo catturato sparisce solo in una nuvoletta.';

  @override
  String get settingsClassic => 'Pezzi degli scacchi classici';

  @override
  String get settingsClassicHint =>
      'Nelle partite, al posto dei personaggi degli eserciti. Le battaglie allora non si vedono.';

  @override
  String get liveBadge => 'In diretta';

  @override
  String get liveSkip => 'Salta';

  @override
  String get liveTryOwn => 'Provo da solo';

  @override
  String get liveAdviser => 'Consigliere';

  @override
  String get liveBackToGame => 'Torna alla partita';

  @override
  String get liveNewMove => 'Mossa nuova!';

  @override
  String liveNewMoves(int n) {
    return 'Mosse nuove: $n';
  }

  @override
  String get liveTimeTrouble => 'Il tempo sta finendo!';

  @override
  String get liveAdviserThinking => 'Il consigliere sta ancora pensando.';

  @override
  String get liveAdviserContinue => 'Continuo da solo';

  @override
  String get liveAhead => 'Chi è in vantaggio';

  @override
  String get liveClockApprox => 'Il tempo è approssimativo';

  @override
  String get liveReset => 'Dall\'inizio';

  @override
  String liveStartsAt(String time) {
    return 'Inizia alle $time';
  }

  @override
  String liveDepth(int n) {
    return 'profondità $n';
  }
}
