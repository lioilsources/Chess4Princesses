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
  String get promoted => 'じょおうさまにへんしん！';

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

  @override
  String get hallTitle => 'えいゆうのへや';

  @override
  String get hallGolden => 'きんのチェスばん';

  @override
  String get hallGoldenHint => 'いちばん ゆうめいな 64のゲーム';

  @override
  String get hallMatches => 'おうかんを かけた たたかい';

  @override
  String get hallMatchesHint => 'せかいチャンピオンせんの ぜんぶの しあい';

  @override
  String get hallWomen => 'じょせいチャンピオン';

  @override
  String get hallWomenHint => 'じょせいの せかいチャンピオンと その ゲーム';

  @override
  String hallStickers(int n, int total) {
    return '$totalこ中 $nこ';
  }

  @override
  String get hallFideLine => 'FIDEタイトル 1993–2006';

  @override
  String get hallTiebreak => 'はやざしの ゲーム';

  @override
  String get replayCheck => 'おうて！';

  @override
  String get replayMate => 'チェックメイト！';

  @override
  String get replayCastle => 'おうさまがおしろにかくれたよ！';

  @override
  String get replaySacrifice => 'ゆうきあるぎせい！';

  @override
  String get replayEndMate => 'チェックメイト！ たたかいにかったよ。';

  @override
  String get replayEndResign => 'おうさまがおじぎをして、かんむりをわたしたよ。たたかいはおしまい！';

  @override
  String get replayEndDraw => 'ひきわけ！ ふたりのおうさまがあくしゅしたよ。';

  @override
  String get replayEndUnfinished => 'このたたかいは まだつづいているよ。';

  @override
  String get replayPlay => 'さいせい';

  @override
  String get replayPause => 'ひとやすみ';

  @override
  String get replayNextBattle => 'つぎのたたかい';

  @override
  String get replayChronicle => 'きろく';

  @override
  String get replayStepBack => 'ひとつもどる';

  @override
  String get replayStepForward => 'ひとつすすむ';

  @override
  String replayMoveOf(int n, int total) {
    return '$totalてのうち $nてめ';
  }

  @override
  String get liveTitle => 'いま あそんでいるよ';

  @override
  String get liveSwitch => 'ネットのたいきょく';

  @override
  String get liveSwitchHint => 'このスイッチがオンのときだけ、ライブのたいかいをダウンロードするよ。';

  @override
  String get liveNothing => 'いまは だれも あそんでいないよ。';

  @override
  String get liveError => 'よみこめなかったよ。あとで もういちど ためしてね。';

  @override
  String get liveOffline => 'ネットにつながっていないよ。ダウンロードずみのものを みせているよ。';

  @override
  String liveGame(int n) {
    return 'だい$nきょく';
  }
}
