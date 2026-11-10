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
  String get promoted => 'ಅವಳು ರಾಜಕುಮಾರಿಯಾದಳು!';

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
}
