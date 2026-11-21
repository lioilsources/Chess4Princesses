// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'شطرنج کی سلطنت';

  @override
  String get mapTitle => 'سلطنت';

  @override
  String get comingSoon => 'جلد';

  @override
  String get locked => 'مقفل';

  @override
  String get start => 'کھیلیں!';

  @override
  String get again => 'دوبارہ';

  @override
  String get next => 'آگے';

  @override
  String get back => 'پیچھے';

  @override
  String get yes => 'ہاں';

  @override
  String get no => 'نہیں';

  @override
  String get wellDone => 'شاباش!';

  @override
  String get lessonDone => 'سبق مکمل!';

  @override
  String get taskWon => 'ہُرّے!';

  @override
  String get tryAgain => 'آؤ دوبارہ کوشش کریں!';

  @override
  String get botWon => 'روبوٹ جیت گیا۔ آؤ پھر کھیلیں!';

  @override
  String get promoted => 'وہ شہزادی بن گئی!';

  @override
  String get lavaWarning => 'اوئی، لاوا!';

  @override
  String tapTarget(String target) {
    return 'دبائیں: $target';
  }

  @override
  String street(String name) {
    return 'گلی $name';
  }

  @override
  String house(String name) {
    return 'قطار $name';
  }

  @override
  String room(String name) {
    return 'کمرہ $name';
  }

  @override
  String get dragHint => 'مہرے کو بساط پر کھینچیں';

  @override
  String get armies => 'فوجیں';

  @override
  String get myArmy => 'میری فوج';

  @override
  String get rivalArmy => 'مقابل';

  @override
  String get battleDemo => 'آزمائشی جنگ';

  @override
  String taskOf(int n, int total) {
    return 'کام $n از $total';
  }

  @override
  String get opponentThinking => 'روبوٹ سوچ رہا ہے…';
}
