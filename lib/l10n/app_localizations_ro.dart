// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appTitle => 'Regatul Șahului';

  @override
  String get mapTitle => 'Regatul';

  @override
  String get comingSoon => 'În curând';

  @override
  String get locked => 'Blocat';

  @override
  String get start => 'Hai să jucăm!';

  @override
  String get again => 'Din nou';

  @override
  String get next => 'Mai departe';

  @override
  String get back => 'Înapoi';

  @override
  String get yes => 'Da';

  @override
  String get no => 'Nu';

  @override
  String get wellDone => 'Bravo!';

  @override
  String get lessonDone => 'Lecție terminată!';

  @override
  String get taskWon => 'Ura!';

  @override
  String get tryAgain => 'Mai încercăm o dată!';

  @override
  String get botWon => 'Roboțelul a câștigat. Mai jucăm o dată!';

  @override
  String get promoted => 'Devine regină!';

  @override
  String get lavaWarning => 'Au, lavă!';

  @override
  String tapTarget(String target) {
    return 'Atinge: $target';
  }

  @override
  String street(String name) {
    return 'strada $name';
  }

  @override
  String house(String name) {
    return 'rândul $name';
  }

  @override
  String room(String name) {
    return 'camera $name';
  }

  @override
  String get dragHint => 'Trage o piesă pe tablă';

  @override
  String get armies => 'Armate';

  @override
  String get myArmy => 'Armata mea';

  @override
  String get rivalArmy => 'Adversar';

  @override
  String get battleDemo => 'Bătălie de probă';

  @override
  String taskOf(int n, int total) {
    return 'Sarcina $n din $total';
  }

  @override
  String get opponentThinking => 'Roboțelul se gândește…';

  @override
  String get hallTitle => 'Sala faimei';

  @override
  String get hallGolden => 'Tabla de aur';

  @override
  String get hallGoldenHint => 'Cele mai celebre 64 de partide';

  @override
  String get hallMatches => 'Meciuri pentru coroană';

  @override
  String get hallMatchesHint => 'Toate meciurile pentru titlul mondial';

  @override
  String get hallWomen => 'Campioane';

  @override
  String get hallWomenHint => 'Campioanele mondiale și partidele lor';

  @override
  String hallStickers(int n, int total) {
    return '$n din $total';
  }

  @override
  String get hallFideLine => 'Titlul FIDE 1993–2006';

  @override
  String get hallTiebreak => 'Partidă rapidă';

  @override
  String get replayCheck => 'Șah!';

  @override
  String get replayMate => 'Șah mat!';

  @override
  String get replayCastle => 'Regele se ascunde în castel!';

  @override
  String get replaySacrifice => 'Un sacrificiu curajos!';

  @override
  String get replayEndMate => 'Șah mat! Bătălia este câștigată.';

  @override
  String get replayEndResign =>
      'Regele face o plecăciune și își predă coroana. Bătălia s-a terminat!';

  @override
  String get replayEndDraw => 'Remiză! Cei doi regi își strâng mâna.';

  @override
  String get replayEndUnfinished => 'Bătălia aceasta încă nu s-a terminat.';

  @override
  String get replayPlay => 'Redă';

  @override
  String get replayPause => 'Pauză';

  @override
  String get replayNextBattle => 'Următoarea bătălie';

  @override
  String get replayChronicle => 'Cronica';

  @override
  String get replayStepBack => 'Mutare înapoi';

  @override
  String get replayStepForward => 'Mutare înainte';

  @override
  String replayMoveOf(int n, int total) {
    return 'Mutarea $n din $total';
  }

  @override
  String get liveTitle => 'Se joacă acum';

  @override
  String get liveSwitch => 'Partide de pe internet';

  @override
  String get liveSwitchHint =>
      'Turneele în direct se descarcă doar cât timp comutatorul este pornit.';

  @override
  String get liveNothing => 'Acum nu se joacă nimic.';

  @override
  String get liveError => 'Nu s-a putut încărca. Încearcă din nou mai târziu.';

  @override
  String get liveOffline => 'Fără internet: arăt ce a fost deja descărcat.';

  @override
  String liveGame(int n) {
    return 'Partida $n';
  }
}
