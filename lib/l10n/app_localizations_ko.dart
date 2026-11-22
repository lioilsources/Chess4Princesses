// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '체스 왕국';

  @override
  String get mapTitle => '왕국';

  @override
  String get comingSoon => '곧 만나요';

  @override
  String get locked => '잠김';

  @override
  String get start => '놀자!';

  @override
  String get again => '다시';

  @override
  String get next => '다음';

  @override
  String get back => '뒤로';

  @override
  String get yes => '네';

  @override
  String get no => '아니요';

  @override
  String get wellDone => '참 잘했어요!';

  @override
  String get lessonDone => '레슨 완료!';

  @override
  String get taskWon => '야호!';

  @override
  String get tryAgain => '다시 해 보자!';

  @override
  String get botWon => '꼬마 로봇이 이겼어. 다시 해 보자!';

  @override
  String get promoted => '여왕님으로 변신!';

  @override
  String get lavaWarning => '앗, 용암이야!';

  @override
  String tapTarget(String target) {
    return '눌러 봐: $target';
  }

  @override
  String street(String name) {
    return '$name 거리';
  }

  @override
  String house(String name) {
    return '$name번 줄';
  }

  @override
  String room(String name) {
    return '$name 방';
  }

  @override
  String get dragHint => '말을 판 위로 끌어 놓아 봐';

  @override
  String get armies => '군대';

  @override
  String get myArmy => '내 군대';

  @override
  String get rivalArmy => '상대';

  @override
  String get battleDemo => '연습 전투';

  @override
  String taskOf(int n, int total) {
    return '$total개 중 $n번째 과제';
  }

  @override
  String get opponentThinking => '꼬마 로봇이 생각 중…';

  @override
  String get hallTitle => '명예의 전당';

  @override
  String get hallFamous => '유명한 경기';

  @override
  String get replayCheck => '체크!';

  @override
  String get replayMate => '체크메이트!';

  @override
  String get replayCastle => '왕이 성으로 쏙 숨었어요!';

  @override
  String get replaySacrifice => '용감한 희생!';

  @override
  String get replayEndMate => '체크메이트! 전투에서 이겼어요.';

  @override
  String get replayEndResign => '왕이 허리를 숙여 왕관을 건넸어요. 전투가 끝났어요!';

  @override
  String get replayEndDraw => '무승부! 두 왕이 악수를 해요.';

  @override
  String get replayEndUnfinished => '이 전투는 아직 계속되고 있어요.';

  @override
  String get replayPlay => '재생';

  @override
  String get replayPause => '일시정지';

  @override
  String get replayNextBattle => '다음 전투';

  @override
  String get replayChronicle => '연대기';

  @override
  String get replayStepBack => '한 수 뒤로';

  @override
  String get replayStepForward => '한 수 앞으로';

  @override
  String replayMoveOf(int n, int total) {
    return '$total수 중 $n수';
  }

  @override
  String get liveTitle => '지금 하는 중';

  @override
  String get liveSwitch => '인터넷에서 온 대국';

  @override
  String get liveSwitchHint => '이 스위치가 켜져 있을 때만 실시간 대회를 내려받아요.';

  @override
  String get liveNothing => '지금은 아무도 두고 있지 않아요.';

  @override
  String get liveError => '불러오지 못했어요. 나중에 다시 해 보세요.';

  @override
  String get liveOffline => '인터넷이 없어요. 이미 내려받은 것만 보여 줄게요.';

  @override
  String liveGame(int n) {
    return '제$n국';
  }
}
