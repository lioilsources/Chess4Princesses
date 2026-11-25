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
  String get promoted => '她变成了王后！';

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

  @override
  String get hallTitle => '名人堂';

  @override
  String get hallGolden => '金色棋盘';

  @override
  String get hallGoldenHint => '最著名的64盘棋';

  @override
  String get hallMatches => '王冠之战';

  @override
  String get hallMatchesHint => '所有世界冠军赛';

  @override
  String get hallWomen => '女子冠军';

  @override
  String get hallWomenHint => '女子世界冠军和她们的对局';

  @override
  String get hallChallenge => '冠军与挑战者';

  @override
  String hallChallengeHint(String year) {
    return '$year年冠军赛两位棋手最精彩的胜局';
  }

  @override
  String hallStickers(int n, int total) {
    return '$n/$total';
  }

  @override
  String get hallFideLine => '国际棋联头衔 1993–2006';

  @override
  String get hallTiebreak => '快棋';

  @override
  String get replayCheck => '将军！';

  @override
  String get replayMate => '将死！';

  @override
  String get replayCastle => '国王躲进了城堡！';

  @override
  String get replaySacrifice => '勇敢的牺牲！';

  @override
  String get replayEndMate => '将死！战斗赢啦。';

  @override
  String get replayEndResign => '国王鞠了一躬，交出了王冠。战斗结束！';

  @override
  String get replayEndDraw => '和棋！两位国王握手了。';

  @override
  String get replayEndUnfinished => '这场战斗还在进行中。';

  @override
  String get replayPlay => '播放';

  @override
  String get replayPause => '暂停';

  @override
  String get replayNextBattle => '下一场战斗';

  @override
  String get replayChronicle => '战斗记录';

  @override
  String get replayStepBack => '上一步';

  @override
  String get replayStepForward => '下一步';

  @override
  String replayMoveOf(int n, int total) {
    return '第 $n 步，共 $total 步';
  }

  @override
  String get liveTitle => '正在进行';

  @override
  String get liveSwitch => '来自网络的棋局';

  @override
  String get liveSwitchHint => '只有打开这个开关，才会下载直播的比赛。';

  @override
  String get liveNothing => '现在没有正在进行的棋局。';

  @override
  String get liveError => '加载失败了，请稍后再试。';

  @override
  String get liveOffline => '没有网络：显示已经下载好的内容。';

  @override
  String liveGame(int n) {
    return '第 $n 局';
  }

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsBattles => '吃子时的战斗';

  @override
  String get settingsBattlesHint => '关闭：被吃的棋子只会在一团烟里消失。';

  @override
  String get settingsClassic => '经典国际象棋棋子';

  @override
  String get settingsClassicHint => '在对局中代替军队角色。';

  @override
  String get liveBadge => '直播';

  @override
  String get liveSkip => '跳过';

  @override
  String get liveTryOwn => '我自己试试';

  @override
  String get liveAdviser => '参谋';

  @override
  String get liveBackToGame => '回到对局';

  @override
  String get liveNewMove => '新的一步！';

  @override
  String liveNewMoves(int n) {
    return '新的步数：$n';
  }

  @override
  String get liveTimeTrouble => '时间快到了！';

  @override
  String get liveAdviserThinking => '参谋还在思考。';

  @override
  String get liveAdviserContinue => '我自己接着下';

  @override
  String get liveAhead => '谁领先';

  @override
  String get liveClockApprox => '时间是大概的';

  @override
  String get liveReset => '从头开始';

  @override
  String liveStartsAt(String time) {
    return '$time 开始';
  }

  @override
  String liveDepth(int n) {
    return '深度 $n';
  }
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
  String get promoted => '她變成了王后！';

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

  @override
  String get hallTitle => '名人堂';

  @override
  String get hallGolden => '金色棋盤';

  @override
  String get hallGoldenHint => '最著名的64盤棋';

  @override
  String get hallMatches => '王冠之戰';

  @override
  String get hallMatchesHint => '所有世界冠軍賽';

  @override
  String get hallWomen => '女子冠軍';

  @override
  String get hallWomenHint => '女子世界冠軍和她們的對局';

  @override
  String get hallChallenge => '冠軍與挑戰者';

  @override
  String hallChallengeHint(String year) {
    return '$year年冠軍賽兩位棋手最精彩的勝局';
  }

  @override
  String hallStickers(int n, int total) {
    return '$n/$total';
  }

  @override
  String get hallFideLine => '國際棋聯頭銜 1993–2006';

  @override
  String get hallTiebreak => '快棋';

  @override
  String get replayCheck => '將軍！';

  @override
  String get replayMate => '將死！';

  @override
  String get replayCastle => '國王躲進了城堡！';

  @override
  String get replaySacrifice => '勇敢的犧牲！';

  @override
  String get replayEndMate => '將死！戰鬥贏啦。';

  @override
  String get replayEndResign => '國王鞠了一躬，交出了王冠。戰鬥結束！';

  @override
  String get replayEndDraw => '和棋！兩位國王握手了。';

  @override
  String get replayEndUnfinished => '這場戰鬥還在進行中。';

  @override
  String get replayPlay => '播放';

  @override
  String get replayPause => '暫停';

  @override
  String get replayNextBattle => '下一場戰鬥';

  @override
  String get replayChronicle => '戰鬥紀錄';

  @override
  String get replayStepBack => '上一步';

  @override
  String get replayStepForward => '下一步';

  @override
  String replayMoveOf(int n, int total) {
    return '第 $n 步，共 $total 步';
  }

  @override
  String get liveTitle => '正在進行';

  @override
  String get liveSwitch => '來自網路的棋局';

  @override
  String get liveSwitchHint => '只有開啟這個開關，才會下載直播的比賽。';

  @override
  String get liveNothing => '現在沒有正在進行的棋局。';

  @override
  String get liveError => '載入失敗了，請稍後再試。';

  @override
  String get liveOffline => '沒有網路：顯示已經下載好的內容。';

  @override
  String liveGame(int n) {
    return '第 $n 局';
  }

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsBattles => '吃子時的戰鬥';

  @override
  String get settingsBattlesHint => '關閉：被吃的棋子只會在一團煙裡消失。';

  @override
  String get settingsClassic => '經典西洋棋棋子';

  @override
  String get settingsClassicHint => '在對局中取代軍隊角色。';

  @override
  String get liveBadge => '直播';

  @override
  String get liveSkip => '跳過';

  @override
  String get liveTryOwn => '我自己試試';

  @override
  String get liveAdviser => '參謀';

  @override
  String get liveBackToGame => '回到對局';

  @override
  String get liveNewMove => '新的一步！';

  @override
  String liveNewMoves(int n) {
    return '新的步數：$n';
  }

  @override
  String get liveTimeTrouble => '時間快到了！';

  @override
  String get liveAdviserThinking => '參謀還在思考。';

  @override
  String get liveAdviserContinue => '我自己接著下';

  @override
  String get liveAhead => '誰領先';

  @override
  String get liveClockApprox => '時間是大概的';

  @override
  String get liveReset => '從頭開始';

  @override
  String liveStartsAt(String time) {
    return '$time 開始';
  }

  @override
  String liveDepth(int n) {
    return '深度 $n';
  }
}
