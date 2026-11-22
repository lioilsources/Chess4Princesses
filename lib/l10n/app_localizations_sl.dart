// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovenian (`sl`).
class AppLocalizationsSl extends AppLocalizations {
  AppLocalizationsSl([String locale = 'sl']) : super(locale);

  @override
  String get appTitle => 'Šahovsko kraljestvo';

  @override
  String get mapTitle => 'Kraljestvo';

  @override
  String get comingSoon => 'Kmalu';

  @override
  String get locked => 'Zaklenjeno';

  @override
  String get start => 'Igrajmo!';

  @override
  String get again => 'Še enkrat';

  @override
  String get next => 'Naprej';

  @override
  String get back => 'Nazaj';

  @override
  String get yes => 'Da';

  @override
  String get no => 'Ne';

  @override
  String get wellDone => 'Odlično!';

  @override
  String get lessonDone => 'Lekcija končana!';

  @override
  String get taskWon => 'Hura!';

  @override
  String get tryAgain => 'Poskusimo še enkrat!';

  @override
  String get botWon => 'Robotek je zmagal. Igrajmo še enkrat!';

  @override
  String get promoted => 'Postane kraljica!';

  @override
  String get lavaWarning => 'Av, lava!';

  @override
  String tapTarget(String target) {
    return 'Tapni: $target';
  }

  @override
  String street(String name) {
    return 'ulico $name';
  }

  @override
  String house(String name) {
    return 'vrsto $name';
  }

  @override
  String room(String name) {
    return 'sobo $name';
  }

  @override
  String get dragHint => 'Povleci figurico na šahovnico';

  @override
  String get armies => 'Vojske';

  @override
  String get myArmy => 'Moja vojska';

  @override
  String get rivalArmy => 'Nasprotnik';

  @override
  String get battleDemo => 'Poskusna bitka';

  @override
  String taskOf(int n, int total) {
    return 'Naloga $n od $total';
  }

  @override
  String get opponentThinking => 'Robotek razmišlja…';

  @override
  String get hallTitle => 'Dvorana slavnih';

  @override
  String get hallGolden => 'Zlata šahovnica';

  @override
  String get hallGoldenHint => '64 najslavnejših partij';

  @override
  String get hallMatches => 'Dvoboji za krono';

  @override
  String get hallMatchesHint => 'Vsi dvoboji za naslov svetovnega prvaka';

  @override
  String get hallWomen => 'Prvakinje';

  @override
  String get hallWomenHint => 'Svetovne prvakinje in njihove partije';

  @override
  String hallStickers(int n, int total) {
    return '$n od $total';
  }

  @override
  String get hallFideLine => 'Naslov FIDE 1993–2006';

  @override
  String get hallTiebreak => 'Hitropotezna partija';

  @override
  String get replayCheck => 'Šah!';

  @override
  String get replayMate => 'Mat!';

  @override
  String get replayCastle => 'Kralj se je skril v grad!';

  @override
  String get replaySacrifice => 'Pogumna žrtev!';

  @override
  String get replayEndMate => 'Mat! Bitka je dobljena.';

  @override
  String get replayEndResign =>
      'Kralj se je priklonil in izročil krono. Bitke je konec!';

  @override
  String get replayEndDraw => 'Remi! Oba kralja si segata v roke.';

  @override
  String get replayEndUnfinished => 'Ta bitka še traja.';

  @override
  String get replayPlay => 'Predvajaj';

  @override
  String get replayPause => 'Premor';

  @override
  String get replayNextBattle => 'Naslednja bitka';

  @override
  String get replayChronicle => 'Kronika';

  @override
  String get replayStepBack => 'Poteza nazaj';

  @override
  String get replayStepForward => 'Poteza naprej';

  @override
  String replayMoveOf(int n, int total) {
    return 'Poteza $n od $total';
  }

  @override
  String get liveTitle => 'Igra se zdaj';

  @override
  String get liveSwitch => 'Partije z interneta';

  @override
  String get liveSwitchHint =>
      'Turnirji v živo se prenesejo le, ko je to vklopljeno.';

  @override
  String get liveNothing => 'Trenutno se nič ne igra.';

  @override
  String get liveError => 'Nalaganje ni uspelo. Poskusi znova pozneje.';

  @override
  String get liveOffline => 'Ni interneta: prikazujem, kar je že preneseno.';

  @override
  String liveGame(int n) {
    return 'Partija $n';
  }
}
