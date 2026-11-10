// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'チェスのおうこく';

  @override
  String get mapTitle => 'おうこく';

  @override
  String get comingSoon => 'もうすぐ';

  @override
  String get locked => 'ロック中';

  @override
  String get start => 'あそぼう！';

  @override
  String get again => 'もういちど';

  @override
  String get next => 'つぎへ';

  @override
  String get back => 'もどる';

  @override
  String get yes => 'はい';

  @override
  String get no => 'いいえ';

  @override
  String get wellDone => 'よくできました！';

  @override
  String get lessonDone => 'レッスンクリア！';

  @override
  String get taskWon => 'やったね！';

  @override
  String get tryAgain => 'もういちどやってみよう！';

  @override
  String get botWon => 'ロボちゃんのかち。もういちどあそぼう！';

  @override
  String get promoted => 'おひめさまにへんしん！';

  @override
  String get lavaWarning => 'あちっ、ようがんだ！';

  @override
  String tapTarget(String target) {
    return 'タップしてね：$target';
  }

  @override
  String street(String name) {
    return '$nameどおり';
  }

  @override
  String house(String name) {
    return '$nameばんのれつ';
  }

  @override
  String room(String name) {
    return '$nameのおへや';
  }

  @override
  String get dragHint => 'コマをばんにドラッグしてね';

  @override
  String get armies => 'ぐんたい';

  @override
  String get myArmy => 'わたしのぐんたい';

  @override
  String get rivalArmy => 'あいて';

  @override
  String get battleDemo => 'ためしのバトル';

  @override
  String taskOf(int n, int total) {
    return '$totalこのうち$nこめ';
  }

  @override
  String get opponentThinking => 'ロボちゃんがかんがえちゅう…';
}
