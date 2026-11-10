// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appTitle => 'ממלכת השחמט';

  @override
  String get mapTitle => 'הממלכה';

  @override
  String get comingSoon => 'בקרוב';

  @override
  String get locked => 'נעול';

  @override
  String get start => 'משחקים!';

  @override
  String get again => 'שוב';

  @override
  String get next => 'הבא';

  @override
  String get back => 'חזרה';

  @override
  String get yes => 'כן';

  @override
  String get no => 'לא';

  @override
  String get wellDone => 'כל הכבוד!';

  @override
  String get lessonDone => 'השיעור הושלם!';

  @override
  String get taskWon => 'הידד!';

  @override
  String get tryAgain => 'ננסה שוב!';

  @override
  String get botWon => 'הרובוט ניצח. משחקים שוב!';

  @override
  String get promoted => 'היא הפכה לנסיכה!';

  @override
  String get lavaWarning => 'אוי, לבה!';

  @override
  String tapTarget(String target) {
    return 'הקישו על: $target';
  }

  @override
  String street(String name) {
    return 'רחוב $name';
  }

  @override
  String house(String name) {
    return 'שורת $name';
  }

  @override
  String room(String name) {
    return 'חדר $name';
  }

  @override
  String get dragHint => 'גררו כלי אל הלוח';

  @override
  String get armies => 'צבאות';

  @override
  String get myArmy => 'הצבא שלי';

  @override
  String get rivalArmy => 'יריב';

  @override
  String get battleDemo => 'קרב ניסיון';

  @override
  String taskOf(int n, int total) {
    return 'משימה $n מתוך $total';
  }

  @override
  String get opponentThinking => 'הרובוט חושב…';
}
