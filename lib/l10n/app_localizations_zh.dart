// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '棋盘王国';

  @override
  String get mapTitle => '王国';

  @override
  String get comingSoon => '敬请期待';

  @override
  String get locked => '未解锁';

  @override
  String get start => '开始玩！';

  @override
  String get again => '再来一次';

  @override
  String get next => '继续';

  @override
  String get back => '返回';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get wellDone => '太棒了！';

  @override
  String get lessonDone => '课程完成！';

  @override
  String get taskWon => '太好啦！';

  @override
  String get tryAgain => '我们再试一次！';

  @override
  String get botWon => '机器人赢了。我们再玩一次！';

  @override
  String get promoted => '她变成了公主！';

  @override
  String get lavaWarning => '哎呀，岩浆！';

  @override
  String tapTarget(String target) {
    return '点一下：$target';
  }

  @override
  String street(String name) {
    return '街道 $name';
  }

  @override
  String house(String name) {
    return '第 $name 排';
  }

  @override
  String room(String name) {
    return '房间 $name';
  }

  @override
  String get dragHint => '把棋子拖到棋盘上';

  @override
  String get armies => '军队';

  @override
  String get myArmy => '我的军队';

  @override
  String get rivalArmy => '对手';

  @override
  String get battleDemo => '试玩战斗';

  @override
  String taskOf(int n, int total) {
    return '任务 $n/$total';
  }

  @override
  String get opponentThinking => '机器人在思考…';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appTitle => '棋盤王國';

  @override
  String get mapTitle => '王國';

  @override
  String get comingSoon => '敬請期待';

  @override
  String get locked => '未解鎖';

  @override
  String get start => '開始玩！';

  @override
  String get again => '再來一次';

  @override
  String get next => '繼續';

  @override
  String get back => '返回';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get wellDone => '太棒了！';

  @override
  String get lessonDone => '課程完成！';

  @override
  String get taskWon => '太好啦！';

  @override
  String get tryAgain => '我們再試一次！';

  @override
  String get botWon => '機器人贏了。我們再玩一次！';

  @override
  String get promoted => '她變成了公主！';

  @override
  String get lavaWarning => '哎呀，岩漿！';

  @override
  String tapTarget(String target) {
    return '點一下：$target';
  }

  @override
  String street(String name) {
    return '街道 $name';
  }

  @override
  String house(String name) {
    return '第 $name 排';
  }

  @override
  String room(String name) {
    return '房間 $name';
  }

  @override
  String get dragHint => '把棋子拖到棋盤上';

  @override
  String get armies => '軍隊';

  @override
  String get myArmy => '我的軍隊';

  @override
  String get rivalArmy => '對手';

  @override
  String get battleDemo => '試玩戰鬥';

  @override
  String taskOf(int n, int total) {
    return '任務 $n/$total';
  }

  @override
  String get opponentThinking => '機器人在思考…';
}
