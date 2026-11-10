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
  String get promoted => '공주님으로 변신!';

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
}
