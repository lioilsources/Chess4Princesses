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
  String get promoted => 'She became a princess!';

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
}
