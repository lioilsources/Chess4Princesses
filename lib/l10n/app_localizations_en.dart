// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Chess Kingdom';

  @override
  String get mapTitle => 'Kingdom';

  @override
  String get comingSoon => 'Soon';

  @override
  String get locked => 'Locked';

  @override
  String get start => 'Play!';

  @override
  String get again => 'Again';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get wellDone => 'Well done!';

  @override
  String get lessonDone => 'Lesson complete!';

  @override
  String get taskWon => 'Hooray!';

  @override
  String get tryAgain => 'Let\'s try again!';

  @override
  String get botWon => 'Robot won. Let\'s play again!';

  @override
  String get promoted => 'She became a queen!';

  @override
  String get lavaWarning => 'Ouch, lava!';

  @override
  String tapTarget(String target) {
    return 'Tap: $target';
  }

  @override
  String street(String name) {
    return 'street $name';
  }

  @override
  String house(String name) {
    return 'row $name';
  }

  @override
  String room(String name) {
    return 'room $name';
  }

  @override
  String get dragHint => 'Drag a piece onto the board';

  @override
  String get armies => 'Armies';

  @override
  String get myArmy => 'My army';

  @override
  String get rivalArmy => 'Rival';

  @override
  String get battleDemo => 'Test battle';

  @override
  String taskOf(int n, int total) {
    return 'Task $n of $total';
  }

  @override
  String get opponentThinking => 'Robot is thinking…';

  @override
  String get hallTitle => 'Hall of Fame';

  @override
  String get hallGolden => 'The Golden Board';

  @override
  String get hallGoldenHint => 'The 64 most famous games';

  @override
  String get hallMatches => 'Matches for the Crown';

  @override
  String get hallMatchesHint => 'Every world championship match';

  @override
  String get hallWomen => 'Women Champions';

  @override
  String get hallWomenHint => 'Women\'s world champions and their games';

  @override
  String hallStickers(int n, int total) {
    return '$n of $total';
  }

  @override
  String get hallFideLine => 'FIDE title 1993–2006';

  @override
  String get hallTiebreak => 'Rapid game';

  @override
  String get replayCheck => 'Check!';

  @override
  String get replayMate => 'Checkmate!';

  @override
  String get replayCastle => 'The king hides in his castle!';

  @override
  String get replaySacrifice => 'A brave sacrifice!';

  @override
  String get replayEndMate => 'Checkmate! The battle is won.';

  @override
  String get replayEndResign =>
      'The king bows and hands over his crown. The battle is over!';

  @override
  String get replayEndDraw => 'A draw! Both kings shake hands.';

  @override
  String get replayEndUnfinished => 'This battle is still going on.';

  @override
  String get replayPlay => 'Play';

  @override
  String get replayPause => 'Pause';

  @override
  String get replayNextBattle => 'Next battle';

  @override
  String get replayChronicle => 'Chronicle';

  @override
  String get replayStepBack => 'Move back';

  @override
  String get replayStepForward => 'Move forward';

  @override
  String replayMoveOf(int n, int total) {
    return 'Move $n of $total';
  }

  @override
  String get liveTitle => 'Playing now';

  @override
  String get liveSwitch => 'Games from the internet';

  @override
  String get liveSwitchHint =>
      'Live tournaments are downloaded only while this is on.';

  @override
  String get liveNothing => 'Nothing is being played right now.';

  @override
  String get liveError => 'Could not load. Try again later.';

  @override
  String get liveOffline => 'No internet: showing what is already downloaded.';

  @override
  String liveGame(int n) {
    return 'Game $n';
  }
}
