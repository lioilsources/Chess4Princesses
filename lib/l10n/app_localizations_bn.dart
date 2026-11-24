// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'দাবার রাজ্য';

  @override
  String get mapTitle => 'রাজ্য';

  @override
  String get comingSoon => 'শীঘ্রই আসছে';

  @override
  String get locked => 'বন্ধ';

  @override
  String get start => 'খেলো!';

  @override
  String get again => 'আবার';

  @override
  String get next => 'এগিয়ে';

  @override
  String get back => 'পেছনে';

  @override
  String get yes => 'হ্যাঁ';

  @override
  String get no => 'না';

  @override
  String get wellDone => 'দারুণ!';

  @override
  String get lessonDone => 'পাঠ শেষ!';

  @override
  String get taskWon => 'হুররে!';

  @override
  String get tryAgain => 'চলো আবার চেষ্টা করি!';

  @override
  String get botWon => 'রোবট জিতেছে। চলো আবার খেলি!';

  @override
  String get promoted => 'সে রানি হয়ে গেল!';

  @override
  String get lavaWarning => 'উফ, লাভা!';

  @override
  String tapTarget(String target) {
    return 'ছোঁও: $target';
  }

  @override
  String street(String name) {
    return 'রাস্তা $name';
  }

  @override
  String house(String name) {
    return 'সারি $name';
  }

  @override
  String room(String name) {
    return 'ঘর $name';
  }

  @override
  String get dragHint => 'ঘুঁটিটা ছকের ওপর টেনে আনো';

  @override
  String get armies => 'সেনাবাহিনী';

  @override
  String get myArmy => 'আমার বাহিনী';

  @override
  String get rivalArmy => 'প্রতিপক্ষ';

  @override
  String get battleDemo => 'পরীক্ষামূলক যুদ্ধ';

  @override
  String taskOf(int n, int total) {
    return 'কাজ $n/$total';
  }

  @override
  String get opponentThinking => 'রোবট ভাবছে…';

  @override
  String get hallTitle => 'খ্যাতির ঘর';

  @override
  String get hallGolden => 'সোনালি ছক';

  @override
  String get hallGoldenHint => 'সবচেয়ে বিখ্যাত ৬৪টি খেলা';

  @override
  String get hallMatches => 'মুকুটের লড়াই';

  @override
  String get hallMatchesHint => 'বিশ্ব চ্যাম্পিয়নশিপের সব ম্যাচ';

  @override
  String get hallWomen => 'চ্যাম্পিয়ন মেয়েরা';

  @override
  String get hallWomenHint => 'মহিলা বিশ্বচ্যাম্পিয়ন আর তাঁদের খেলা';

  @override
  String get hallChallenge => 'চ্যাম্পিয়ন ও চ্যালেঞ্জার';

  @override
  String hallChallengeHint(String year) {
    return '$year সালের শিরোপা ম্যাচের দুই খেলোয়াড়ের সেরা জয়';
  }

  @override
  String hallStickers(int n, int total) {
    return '$total-এর মধ্যে $n';
  }

  @override
  String get hallFideLine => 'ফিদে খেতাব ১৯৯৩–২০০৬';

  @override
  String get hallTiebreak => 'দ্রুত খেলা';

  @override
  String get replayCheck => 'কিস্তি!';

  @override
  String get replayMate => 'কিস্তিমাত!';

  @override
  String get replayCastle => 'রাজা দুর্গে লুকিয়ে পড়ল!';

  @override
  String get replaySacrifice => 'সাহসী ত্যাগ!';

  @override
  String get replayEndMate => 'কিস্তিমাত! যুদ্ধ জেতা হলো।';

  @override
  String get replayEndResign => 'রাজা মাথা নুইয়ে মুকুট তুলে দিল। যুদ্ধ শেষ!';

  @override
  String get replayEndDraw => 'ড্র! দুই রাজা হাত মেলাল।';

  @override
  String get replayEndUnfinished => 'এই যুদ্ধ এখনও চলছে।';

  @override
  String get replayPlay => 'চালাও';

  @override
  String get replayPause => 'থামাও';

  @override
  String get replayNextBattle => 'পরের যুদ্ধ';

  @override
  String get replayChronicle => 'ইতিবৃত্ত';

  @override
  String get replayStepBack => 'এক চাল পেছনে';

  @override
  String get replayStepForward => 'এক চাল সামনে';

  @override
  String replayMoveOf(int n, int total) {
    return '$totalটির মধ্যে $n নম্বর চাল';
  }

  @override
  String get liveTitle => 'এখন খেলা চলছে';

  @override
  String get liveSwitch => 'ইন্টারনেট থেকে খেলা';

  @override
  String get liveSwitchHint => 'এটি চালু থাকলেই লাইভ টুর্নামেন্ট ডাউনলোড হয়।';

  @override
  String get liveNothing => 'এখন কোনো খেলা চলছে না।';

  @override
  String get liveError => 'লোড করা গেল না। পরে আবার চেষ্টা করো।';

  @override
  String get liveOffline => 'ইন্টারনেট নেই: যা আগে ডাউনলোড হয়েছে তা দেখাচ্ছি।';

  @override
  String liveGame(int n) {
    return 'খেলা $n';
  }
}
