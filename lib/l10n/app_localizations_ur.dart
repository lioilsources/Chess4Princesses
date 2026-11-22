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
  String get promoted => 'وہ ملکہ بن گئی!';

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

  @override
  String get hallTitle => 'شہرت کا ہال';

  @override
  String get hallGolden => 'سنہری بساط';

  @override
  String get hallGoldenHint => '64 مشہور ترین بازیاں';

  @override
  String get hallMatches => 'تاج کے لیے مقابلے';

  @override
  String get hallMatchesHint => 'عالمی چیمپئن شپ کے تمام مقابلے';

  @override
  String get hallWomen => 'چیمپئن خواتین';

  @override
  String get hallWomenHint => 'خواتین عالمی چیمپئن اور ان کی بازیاں';

  @override
  String hallStickers(int n, int total) {
    return '$total میں سے $n';
  }

  @override
  String get hallFideLine => 'فیڈے ٹائٹل 1993–2006';

  @override
  String get hallTiebreak => 'تیز بازی';

  @override
  String get replayCheck => 'شہ!';

  @override
  String get replayMate => 'مات!';

  @override
  String get replayCastle => 'بادشاہ قلعے میں چھپ گیا!';

  @override
  String get replaySacrifice => 'بہادری کی قربانی!';

  @override
  String get replayEndMate => 'مات! جنگ جیت لی گئی۔';

  @override
  String get replayEndResign => 'بادشاہ جھکا اور اپنا تاج دے دیا۔ جنگ ختم!';

  @override
  String get replayEndDraw => 'برابری! دونوں بادشاہوں نے ہاتھ ملایا۔';

  @override
  String get replayEndUnfinished => 'یہ جنگ ابھی جاری ہے۔';

  @override
  String get replayPlay => 'چلائیں';

  @override
  String get replayPause => 'رکیں';

  @override
  String get replayNextBattle => 'اگلی جنگ';

  @override
  String get replayChronicle => 'روداد';

  @override
  String get replayStepBack => 'ایک چال پیچھے';

  @override
  String get replayStepForward => 'ایک چال آگے';

  @override
  String replayMoveOf(int n, int total) {
    return '$total میں سے چال $n';
  }

  @override
  String get liveTitle => 'ابھی کھیلا جا رہا ہے';

  @override
  String get liveSwitch => 'انٹرنیٹ سے کھیل';

  @override
  String get liveSwitchHint =>
      'لائیو ٹورنامنٹ صرف اسی وقت ڈاؤن لوڈ ہوتے ہیں جب یہ آن ہو۔';

  @override
  String get liveNothing => 'ابھی کچھ نہیں کھیلا جا رہا۔';

  @override
  String get liveError => 'لوڈ نہیں ہو سکا۔ بعد میں دوبارہ کوشش کرو۔';

  @override
  String get liveOffline =>
      'انٹرنیٹ نہیں ہے: جو پہلے سے ڈاؤن لوڈ ہے وہ دکھا رہے ہیں۔';

  @override
  String liveGame(int n) {
    return 'کھیل $n';
  }
}
