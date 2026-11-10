// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'शतरंज का राज्य';

  @override
  String get mapTitle => 'राज्य';

  @override
  String get comingSoon => 'जल्द आ रहा है';

  @override
  String get locked => 'बंद है';

  @override
  String get start => 'खेलो!';

  @override
  String get again => 'फिर से';

  @override
  String get next => 'आगे';

  @override
  String get back => 'पीछे';

  @override
  String get yes => 'हाँ';

  @override
  String get no => 'नहीं';

  @override
  String get wellDone => 'शाबाश!';

  @override
  String get lessonDone => 'पाठ पूरा हुआ!';

  @override
  String get taskWon => 'हुर्रे!';

  @override
  String get tryAgain => 'चलो फिर कोशिश करते हैं!';

  @override
  String get botWon => 'रोबोट जीत गया। चलो फिर खेलते हैं!';

  @override
  String get promoted => 'वह राजकुमारी बन गई!';

  @override
  String get lavaWarning => 'अरे, लावा!';

  @override
  String tapTarget(String target) {
    return 'यहाँ दबाओ: $target';
  }

  @override
  String street(String name) {
    return 'गली $name';
  }

  @override
  String house(String name) {
    return 'कतार $name';
  }

  @override
  String room(String name) {
    return 'कमरा $name';
  }

  @override
  String get dragHint => 'मोहरे को बिसात पर खींचो';

  @override
  String get armies => 'सेनाएँ';

  @override
  String get myArmy => 'मेरी सेना';

  @override
  String get rivalArmy => 'विरोधी';

  @override
  String get battleDemo => 'आज़माइशी लड़ाई';

  @override
  String taskOf(int n, int total) {
    return 'काम $n/$total';
  }

  @override
  String get opponentThinking => 'रोबोट सोच रहा है…';
}
