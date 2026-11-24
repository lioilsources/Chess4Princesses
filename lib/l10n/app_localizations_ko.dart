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
  String get hallGolden => '황금 체스판';

  @override
  String get hallGoldenHint => '가장 유명한 64판';

  @override
  String get hallMatches => '왕관을 건 대결';

  @override
  String get hallMatchesHint => '세계 챔피언전의 모든 경기';

  @override
  String get hallWomen => '여자 챔피언';

  @override
  String get hallWomenHint => '여자 세계 챔피언과 그들의 경기';

  @override
  String get hallChallenge => '챔피언과 도전자';

  @override
  String hallChallengeHint(String year) {
    return '$year 타이틀 매치 두 선수의 가장 멋진 승리';
  }

  @override
  String hallStickers(int n, int total) {
    return '$total판 중 $n판';
  }

  @override
  String get hallFideLine => 'FIDE 타이틀 1993–2006';

  @override
  String get hallTiebreak => '속기 경기';

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

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsBattles => '잡을 때 전투';

  @override
  String get settingsBattlesHint => '끄면: 잡힌 말은 구름 속으로 사라지기만 해요.';

  @override
  String get settingsClassic => '클래식 체스 말';

  @override
  String get settingsClassicHint => '대국에서 군대 캐릭터 대신 보여요. 그러면 전투는 나오지 않아요.';

  @override
  String get liveBadge => '라이브';

  @override
  String get liveSkip => '건너뛰기';

  @override
  String get liveTryOwn => '내가 해 볼래';

  @override
  String get liveAdviser => '조언자';

  @override
  String get liveBackToGame => '대국으로 돌아가기';

  @override
  String get liveNewMove => '새 수!';

  @override
  String liveNewMoves(int n) {
    return '새 수: $n';
  }

  @override
  String get liveTimeTrouble => '시간이 얼마 안 남았어요!';

  @override
  String get liveAdviserThinking => '조언자가 아직 생각 중이에요.';

  @override
  String get liveAdviserContinue => '내가 이어서 둘래';

  @override
  String get liveAhead => '누가 앞서나';

  @override
  String get liveClockApprox => '시간은 대략이에요';

  @override
  String get liveReset => '처음부터';

  @override
  String liveStartsAt(String time) {
    return '$time 시작';
  }

  @override
  String liveDepth(int n) {
    return '깊이 $n';
  }
}
