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
  String get promoted => 'সে রাজকন্যা হয়ে গেল!';

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
}
