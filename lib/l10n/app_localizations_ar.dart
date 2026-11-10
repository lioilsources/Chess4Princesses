// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'مملكة الشطرنج';

  @override
  String get mapTitle => 'المملكة';

  @override
  String get comingSoon => 'قريبًا';

  @override
  String get locked => 'مقفل';

  @override
  String get start => 'هيا نلعب!';

  @override
  String get again => 'مرة أخرى';

  @override
  String get next => 'التالي';

  @override
  String get back => 'رجوع';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get wellDone => 'أحسنت!';

  @override
  String get lessonDone => 'اكتمل الدرس!';

  @override
  String get taskWon => 'يا للفرحة!';

  @override
  String get tryAgain => 'لنحاول مرة أخرى!';

  @override
  String get botWon => 'فاز الروبوت. لنلعب مرة أخرى!';

  @override
  String get promoted => 'لقد أصبحت أميرة!';

  @override
  String get lavaWarning => 'آخ، حمم!';

  @override
  String tapTarget(String target) {
    return 'المس: $target';
  }

  @override
  String street(String name) {
    return 'الشارع $name';
  }

  @override
  String house(String name) {
    return 'الصف $name';
  }

  @override
  String room(String name) {
    return 'الغرفة $name';
  }

  @override
  String get dragHint => 'اسحب القطعة إلى رقعة الشطرنج';

  @override
  String get armies => 'الجيوش';

  @override
  String get myArmy => 'جيشي';

  @override
  String get rivalArmy => 'الخصم';

  @override
  String get battleDemo => 'معركة تجريبية';

  @override
  String taskOf(int n, int total) {
    return 'المهمة $n من $total';
  }

  @override
  String get opponentThinking => 'الروبوت يفكر…';
}
