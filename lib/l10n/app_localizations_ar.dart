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
  String get promoted => 'لقد أصبحت ملكة!';

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

  @override
  String get hallTitle => 'قاعة المشاهير';

  @override
  String get hallGolden => 'الرقعة الذهبية';

  @override
  String get hallGoldenHint => 'أشهر 64 مباراة';

  @override
  String get hallMatches => 'مباريات على التاج';

  @override
  String get hallMatchesHint => 'كل مباريات بطولة العالم';

  @override
  String get hallWomen => 'البطلات';

  @override
  String get hallWomenHint => 'بطلات العالم ومبارياتهن';

  @override
  String hallStickers(int n, int total) {
    return '$n من $total';
  }

  @override
  String get hallFideLine => 'لقب الفيديه 1993–2006';

  @override
  String get hallTiebreak => 'مباراة سريعة';

  @override
  String get replayCheck => 'كش!';

  @override
  String get replayMate => 'كش مات!';

  @override
  String get replayCastle => 'الملك اختبأ في القلعة!';

  @override
  String get replaySacrifice => 'تضحية شجاعة!';

  @override
  String get replayEndMate => 'كش مات! ربحنا المعركة.';

  @override
  String get replayEndResign => 'انحنى الملك وسلّم تاجه. انتهت المعركة!';

  @override
  String get replayEndDraw => 'تعادل! الملكان تصافحا.';

  @override
  String get replayEndUnfinished => 'هذه المعركة ما زالت مستمرة.';

  @override
  String get replayPlay => 'تشغيل';

  @override
  String get replayPause => 'إيقاف مؤقت';

  @override
  String get replayNextBattle => 'المعركة التالية';

  @override
  String get replayChronicle => 'السجل';

  @override
  String get replayStepBack => 'حركة للخلف';

  @override
  String get replayStepForward => 'حركة للأمام';

  @override
  String replayMoveOf(int n, int total) {
    return 'الحركة $n من $total';
  }

  @override
  String get liveTitle => 'يُلعب الآن';

  @override
  String get liveSwitch => 'مباريات من الإنترنت';

  @override
  String get liveSwitchHint =>
      'تُنزَّل البطولات المباشرة فقط عندما يكون هذا المفتاح مفعّلًا.';

  @override
  String get liveNothing => 'لا توجد مباراة تُلعب الآن.';

  @override
  String get liveError => 'تعذّر التحميل. حاول مرة أخرى لاحقًا.';

  @override
  String get liveOffline => 'لا يوجد إنترنت: نعرض ما تم تنزيله بالفعل.';

  @override
  String liveGame(int n) {
    return 'المباراة $n';
  }
}
