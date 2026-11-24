// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get appTitle => 'ಚೆಸ್ ರಾಜ್ಯ';

  @override
  String get mapTitle => 'ರಾಜ್ಯ';

  @override
  String get comingSoon => 'ಶೀಘ್ರದಲ್ಲಿ';

  @override
  String get locked => 'ಲಾಕ್ ಆಗಿದೆ';

  @override
  String get start => 'ಆಡೋಣ!';

  @override
  String get again => 'ಮತ್ತೆ';

  @override
  String get next => 'ಮುಂದೆ';

  @override
  String get back => 'ಹಿಂದೆ';

  @override
  String get yes => 'ಹೌದು';

  @override
  String get no => 'ಇಲ್ಲ';

  @override
  String get wellDone => 'ಭೇಷ್!';

  @override
  String get lessonDone => 'ಪಾಠ ಮುಗಿಯಿತು!';

  @override
  String get taskWon => 'ಹುರ್ರೇ!';

  @override
  String get tryAgain => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸೋಣ!';

  @override
  String get botWon => 'ರೋಬೋಟ್ ಗೆದ್ದಿತು. ಮತ್ತೆ ಆಡೋಣ!';

  @override
  String get promoted => 'ಅವಳು ರಾಣಿಯಾದಳು!';

  @override
  String get lavaWarning => 'ಅಯ್ಯೋ, ಲಾವಾ!';

  @override
  String tapTarget(String target) {
    return 'ಇಲ್ಲಿ ಒತ್ತಿ: $target';
  }

  @override
  String street(String name) {
    return 'ಬೀದಿ $name';
  }

  @override
  String house(String name) {
    return 'ಸಾಲು $name';
  }

  @override
  String room(String name) {
    return 'ಕೋಣೆ $name';
  }

  @override
  String get dragHint => 'ಕಾಯಿಯನ್ನು ಹಲಗೆಗೆ ಎಳೆಯಿರಿ';

  @override
  String get armies => 'ಸೇನೆಗಳು';

  @override
  String get myArmy => 'ನನ್ನ ಸೇನೆ';

  @override
  String get rivalArmy => 'ಎದುರಾಳಿ';

  @override
  String get battleDemo => 'ಪ್ರಯೋಗ ಯುದ್ಧ';

  @override
  String taskOf(int n, int total) {
    return 'ಕೆಲಸ $n/$total';
  }

  @override
  String get opponentThinking => 'ರೋಬೋಟ್ ಯೋಚಿಸುತ್ತಿದೆ…';

  @override
  String get hallTitle => 'ಖ್ಯಾತಿಯ ಸಭಾಂಗಣ';

  @override
  String get hallGolden => 'ಚಿನ್ನದ ಹಲಗೆ';

  @override
  String get hallGoldenHint => 'ಅತ್ಯಂತ ಪ್ರಸಿದ್ಧ 64 ಆಟಗಳು';

  @override
  String get hallMatches => 'ಕಿರೀಟಕ್ಕಾಗಿ ಪಂದ್ಯಗಳು';

  @override
  String get hallMatchesHint => 'ವಿಶ್ವ ಚಾಂಪಿಯನ್‌ಶಿಪ್‌ನ ಎಲ್ಲ ಪಂದ್ಯಗಳು';

  @override
  String get hallWomen => 'ಚಾಂಪಿಯನ್ ಮಹಿಳೆಯರು';

  @override
  String get hallWomenHint => 'ಮಹಿಳಾ ವಿಶ್ವ ಚಾಂಪಿಯನ್‌ಗಳು ಮತ್ತು ಅವರ ಆಟಗಳು';

  @override
  String get hallChallenge => 'ಚಾಂಪಿಯನ್ ಮತ್ತು ಸವಾಲುಗಾರ';

  @override
  String hallChallengeHint(String year) {
    return '$year ಪ್ರಶಸ್ತಿ ಪಂದ್ಯದ ಇಬ್ಬರೂ ಆಟಗಾರರ ಅತ್ಯಂತ ಸುಂದರ ಗೆಲುವುಗಳು';
  }

  @override
  String hallStickers(int n, int total) {
    return '$totalರಲ್ಲಿ $n';
  }

  @override
  String get hallFideLine => 'ಫಿಡೆ ಪ್ರಶಸ್ತಿ 1993–2006';

  @override
  String get hallTiebreak => 'ವೇಗದ ಆಟ';

  @override
  String get replayCheck => 'ಚೆಕ್!';

  @override
  String get replayMate => 'ಚೆಕ್‌ಮೇಟ್!';

  @override
  String get replayCastle => 'ರಾಜ ಕೋಟೆಯಲ್ಲಿ ಅಡಗಿಕೊಂಡ!';

  @override
  String get replaySacrifice => 'ಧೈರ್ಯದ ತ್ಯಾಗ!';

  @override
  String get replayEndMate => 'ಚೆಕ್‌ಮೇಟ್! ಯುದ್ಧ ಗೆದ್ದಿತು.';

  @override
  String get replayEndResign =>
      'ರಾಜ ತಲೆಬಾಗಿ ತನ್ನ ಕಿರೀಟ ಒಪ್ಪಿಸಿದ. ಯುದ್ಧ ಮುಗಿಯಿತು!';

  @override
  String get replayEndDraw => 'ಡ್ರಾ! ಇಬ್ಬರು ರಾಜರು ಕೈ ಕುಲುಕಿದರು.';

  @override
  String get replayEndUnfinished => 'ಈ ಯುದ್ಧ ಇನ್ನೂ ನಡೆಯುತ್ತಿದೆ.';

  @override
  String get replayPlay => 'ಆಡಿಸು';

  @override
  String get replayPause => 'ತಡೆ';

  @override
  String get replayNextBattle => 'ಮುಂದಿನ ಯುದ್ಧ';

  @override
  String get replayChronicle => 'ವೃತ್ತಾಂತ';

  @override
  String get replayStepBack => 'ಒಂದು ನಡೆ ಹಿಂದೆ';

  @override
  String get replayStepForward => 'ಒಂದು ನಡೆ ಮುಂದೆ';

  @override
  String replayMoveOf(int n, int total) {
    return '$totalರಲ್ಲಿ $nನೇ ನಡೆ';
  }

  @override
  String get liveTitle => 'ಈಗ ಆಡುತ್ತಿದ್ದಾರೆ';

  @override
  String get liveSwitch => 'ಇಂಟರ್ನೆಟ್‌ನ ಆಟಗಳು';

  @override
  String get liveSwitchHint =>
      'ಇದು ಆನ್ ಇರುವಾಗ ಮಾತ್ರ ನೇರ ಪಂದ್ಯಾವಳಿಗಳನ್ನು ಡೌನ್‌ಲೋಡ್ ಮಾಡಲಾಗುತ್ತದೆ.';

  @override
  String get liveNothing => 'ಈಗ ಏನೂ ಆಡುತ್ತಿಲ್ಲ.';

  @override
  String get liveError => 'ಲೋಡ್ ಆಗಲಿಲ್ಲ. ನಂತರ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get liveOffline =>
      'ಇಂಟರ್ನೆಟ್ ಇಲ್ಲ: ಈಗಾಗಲೇ ಡೌನ್‌ಲೋಡ್ ಆದದ್ದನ್ನು ತೋರಿಸುತ್ತಿದ್ದೇವೆ.';

  @override
  String liveGame(int n) {
    return 'ಆಟ $n';
  }
}
