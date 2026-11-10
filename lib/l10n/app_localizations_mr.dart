// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appTitle => 'बुद्धिबळाचे राज्य';

  @override
  String get mapTitle => 'राज्य';

  @override
  String get comingSoon => 'लवकरच';

  @override
  String get locked => 'बंद';

  @override
  String get start => 'खेळा!';

  @override
  String get again => 'पुन्हा';

  @override
  String get next => 'पुढे';

  @override
  String get back => 'मागे';

  @override
  String get yes => 'हो';

  @override
  String get no => 'नाही';

  @override
  String get wellDone => 'छान!';

  @override
  String get lessonDone => 'धडा पूर्ण!';

  @override
  String get taskWon => 'हुर्रे!';

  @override
  String get tryAgain => 'चला पुन्हा प्रयत्न करूया!';

  @override
  String get botWon => 'रोबोट जिंकला. चला पुन्हा खेळूया!';

  @override
  String get promoted => 'ती राजकुमारी झाली!';

  @override
  String get lavaWarning => 'अरेरे, लाव्हा!';

  @override
  String tapTarget(String target) {
    return 'इथे दाबा: $target';
  }

  @override
  String street(String name) {
    return 'गल्ली $name';
  }

  @override
  String house(String name) {
    return 'रांग $name';
  }

  @override
  String room(String name) {
    return 'खोली $name';
  }

  @override
  String get dragHint => 'मोहरा पटावर ओढा';

  @override
  String get armies => 'सैन्ये';

  @override
  String get myArmy => 'माझे सैन्य';

  @override
  String get rivalArmy => 'प्रतिस्पर्धी';

  @override
  String get battleDemo => 'चाचणी लढाई';

  @override
  String taskOf(int n, int total) {
    return 'काम $n/$total';
  }

  @override
  String get opponentThinking => 'रोबोट विचार करतोय…';
}
