// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appTitle => 'ચેસનું રાજ્ય';

  @override
  String get mapTitle => 'રાજ્ય';

  @override
  String get comingSoon => 'જલ્દી આવે છે';

  @override
  String get locked => 'બંધ છે';

  @override
  String get start => 'રમો!';

  @override
  String get again => 'ફરીથી';

  @override
  String get next => 'આગળ';

  @override
  String get back => 'પાછળ';

  @override
  String get yes => 'હા';

  @override
  String get no => 'ના';

  @override
  String get wellDone => 'શાબાશ!';

  @override
  String get lessonDone => 'પાઠ પૂરો!';

  @override
  String get taskWon => 'હુર્રે!';

  @override
  String get tryAgain => 'ચાલો ફરી પ્રયત્ન કરીએ!';

  @override
  String get botWon => 'રોબોટ જીતી ગયો. ચાલો ફરી રમીએ!';

  @override
  String get promoted => 'તે રાજકુમારી બની ગઈ!';

  @override
  String get lavaWarning => 'અરે, લાવા!';

  @override
  String tapTarget(String target) {
    return 'અહીં દબાવો: $target';
  }

  @override
  String street(String name) {
    return 'શેરી $name';
  }

  @override
  String house(String name) {
    return 'હરોળ $name';
  }

  @override
  String room(String name) {
    return 'ઓરડો $name';
  }

  @override
  String get dragHint => 'મોહરાને પટ પર ખેંચો';

  @override
  String get armies => 'સેનાઓ';

  @override
  String get myArmy => 'મારી સેના';

  @override
  String get rivalArmy => 'પ્રતિસ્પર્ધી';

  @override
  String get battleDemo => 'અજમાયશી લડાઈ';

  @override
  String taskOf(int n, int total) {
    return 'કામ $n/$total';
  }

  @override
  String get opponentThinking => 'રોબોટ વિચારે છે…';
}
