// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Panjabi Punjabi (`pa`).
class AppLocalizationsPa extends AppLocalizations {
  AppLocalizationsPa([String locale = 'pa']) : super(locale);

  @override
  String get appTitle => 'ਸ਼ਤਰੰਜ ਦਾ ਰਾਜ';

  @override
  String get mapTitle => 'ਰਾਜ';

  @override
  String get comingSoon => 'ਜਲਦੀ ਆ ਰਿਹਾ ਹੈ';

  @override
  String get locked => 'ਬੰਦ ਹੈ';

  @override
  String get start => 'ਖੇਡੋ!';

  @override
  String get again => 'ਦੁਬਾਰਾ';

  @override
  String get next => 'ਅੱਗੇ';

  @override
  String get back => 'ਪਿੱਛੇ';

  @override
  String get yes => 'ਹਾਂ';

  @override
  String get no => 'ਨਹੀਂ';

  @override
  String get wellDone => 'ਸ਼ਾਬਾਸ਼!';

  @override
  String get lessonDone => 'ਸਬਕ ਪੂਰਾ!';

  @override
  String get taskWon => 'ਹੁਰੇ!';

  @override
  String get tryAgain => 'ਚਲੋ ਫਿਰ ਕੋਸ਼ਿਸ਼ ਕਰੀਏ!';

  @override
  String get botWon => 'ਰੋਬੋਟ ਜਿੱਤ ਗਿਆ। ਚਲੋ ਫਿਰ ਖੇਡੀਏ!';

  @override
  String get promoted => 'ਉਹ ਰਾਜਕੁਮਾਰੀ ਬਣ ਗਈ!';

  @override
  String get lavaWarning => 'ਓਹ, ਲਾਵਾ!';

  @override
  String tapTarget(String target) {
    return 'ਇੱਥੇ ਦਬਾਓ: $target';
  }

  @override
  String street(String name) {
    return 'ਗਲੀ $name';
  }

  @override
  String house(String name) {
    return 'ਕਤਾਰ $name';
  }

  @override
  String room(String name) {
    return 'ਕਮਰਾ $name';
  }

  @override
  String get dragHint => 'ਮੋਹਰੇ ਨੂੰ ਬਿਸਾਤ ਉੱਤੇ ਖਿੱਚੋ';

  @override
  String get armies => 'ਫ਼ੌਜਾਂ';

  @override
  String get myArmy => 'ਮੇਰੀ ਫ਼ੌਜ';

  @override
  String get rivalArmy => 'ਵਿਰੋਧੀ';

  @override
  String get battleDemo => 'ਅਜ਼ਮਾਇਸ਼ੀ ਲੜਾਈ';

  @override
  String taskOf(int n, int total) {
    return 'ਕੰਮ $n/$total';
  }

  @override
  String get opponentThinking => 'ਰੋਬੋਟ ਸੋਚ ਰਿਹਾ ਹੈ…';
}
