// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'Sakkbirodalom';

  @override
  String get mapTitle => 'Birodalom';

  @override
  String get comingSoon => 'Hamarosan';

  @override
  String get locked => 'Zárva';

  @override
  String get start => 'Játsszunk!';

  @override
  String get again => 'Újra';

  @override
  String get next => 'Tovább';

  @override
  String get back => 'Vissza';

  @override
  String get yes => 'Igen';

  @override
  String get no => 'Nem';

  @override
  String get wellDone => 'Ügyes vagy!';

  @override
  String get lessonDone => 'A lecke kész!';

  @override
  String get taskWon => 'Hurrá!';

  @override
  String get tryAgain => 'Próbáljuk újra!';

  @override
  String get botWon => 'A kis robot nyert. Játsszunk újra!';

  @override
  String get promoted => 'Hercegnővé változik!';

  @override
  String get lavaWarning => 'Jaj, láva!';

  @override
  String tapTarget(String target) {
    return 'Koppints: $target';
  }

  @override
  String street(String name) {
    return '$name utca';
  }

  @override
  String house(String name) {
    return '$name. sor';
  }

  @override
  String room(String name) {
    return '$name szoba';
  }

  @override
  String get dragHint => 'Húzz egy bábut a táblára';

  @override
  String get armies => 'Seregek';

  @override
  String get myArmy => 'Az én seregem';

  @override
  String get rivalArmy => 'Ellenfél';

  @override
  String get battleDemo => 'Próbacsata';

  @override
  String taskOf(int n, int total) {
    return '$n. feladat / $total';
  }

  @override
  String get opponentThinking => 'A kis robot gondolkodik…';
}
