// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Panjabi Punjabi (`pa`).
class AppLocalizationsPa extends AppLocalizations {
  AppLocalizationsPa([String locale = 'pa']) : super(locale);

  @override
  String get appTitle => 'ਸ਼ਤਰੰਜ ਦਾ ਰਾਜ';

  @override
  String get mapTitle => 'ਰਾਜ';

  @override
  String get comingSoon => 'ਜਲਦੀ ਆ ਰਿਹਾ ਹੈ';

  @override
  String get locked => 'ਬੰਦ ਹੈ';

  @override
  String get start => 'ਖੇਡੋ!';

  @override
  String get again => 'ਦੁਬਾਰਾ';

  @override
  String get next => 'ਅੱਗੇ';

  @override
  String get back => 'ਪਿੱਛੇ';

  @override
  String get yes => 'ਹਾਂ';

  @override
  String get no => 'ਨਹੀਂ';

  @override
  String get wellDone => 'ਸ਼ਾਬਾਸ਼!';

  @override
  String get lessonDone => 'ਸਬਕ ਪੂਰਾ!';

  @override
  String get taskWon => 'ਹੁਰੇ!';

  @override
  String get tryAgain => 'ਚਲੋ ਫਿਰ ਕੋਸ਼ਿਸ਼ ਕਰੀਏ!';

  @override
  String get botWon => 'ਰੋਬੋਟ ਜਿੱਤ ਗਿਆ। ਚਲੋ ਫਿਰ ਖੇਡੀਏ!';

  @override
  String get promoted => 'ਉਹ ਰਾਣੀ ਬਣ ਗਈ!';

  @override
  String get lavaWarning => 'ਓਹ, ਲਾਵਾ!';

  @override
  String tapTarget(String target) {
    return 'ਇੱਥੇ ਦਬਾਓ: $target';
  }

  @override
  String street(String name) {
    return 'ਗਲੀ $name';
  }

  @override
  String house(String name) {
    return 'ਕਤਾਰ $name';
  }

  @override
  String room(String name) {
    return 'ਕਮਰਾ $name';
  }

  @override
  String get dragHint => 'ਮੋਹਰੇ ਨੂੰ ਬਿਸਾਤ ਉੱਤੇ ਖਿੱਚੋ';

  @override
  String get armies => 'ਫ਼ੌਜਾਂ';

  @override
  String get myArmy => 'ਮੇਰੀ ਫ਼ੌਜ';

  @override
  String get rivalArmy => 'ਵਿਰੋਧੀ';

  @override
  String get battleDemo => 'ਅਜ਼ਮਾਇਸ਼ੀ ਲੜਾਈ';

  @override
  String taskOf(int n, int total) {
    return 'ਕੰਮ $n/$total';
  }

  @override
  String get opponentThinking => 'ਰੋਬੋਟ ਸੋਚ ਰਿਹਾ ਹੈ…';

  @override
  String get hallTitle => 'ਸ਼ੋਹਰਤ ਹਾਲ';

  @override
  String get hallGolden => 'ਸੁਨਹਿਰੀ ਬਿਸਾਤ';

  @override
  String get hallGoldenHint => '64 ਸਭ ਤੋਂ ਮਸ਼ਹੂਰ ਬਾਜ਼ੀਆਂ';

  @override
  String get hallMatches => 'ਤਾਜ ਲਈ ਮੁਕਾਬਲੇ';

  @override
  String get hallMatchesHint => 'ਵਿਸ਼ਵ ਚੈਂਪੀਅਨਸ਼ਿਪ ਦੇ ਸਾਰੇ ਮੁਕਾਬਲੇ';

  @override
  String get hallWomen => 'ਚੈਂਪੀਅਨ ਔਰਤਾਂ';

  @override
  String get hallWomenHint => 'ਔਰਤ ਵਿਸ਼ਵ ਚੈਂਪੀਅਨ ਅਤੇ ਉਨ੍ਹਾਂ ਦੀਆਂ ਬਾਜ਼ੀਆਂ';

  @override
  String get hallChallenge => 'ਚੈਂਪੀਅਨ ਅਤੇ ਚੁਣੌਤੀ ਦੇਣ ਵਾਲਾ';

  @override
  String hallChallengeHint(String year) {
    return '$year ਦੇ ਖ਼ਿਤਾਬੀ ਮੁਕਾਬਲੇ ਦੇ ਦੋਵਾਂ ਖਿਡਾਰੀਆਂ ਦੀਆਂ ਸਭ ਤੋਂ ਸੋਹਣੀਆਂ ਜਿੱਤਾਂ';
  }

  @override
  String hallStickers(int n, int total) {
    return '$total ਵਿੱਚੋਂ $n';
  }

  @override
  String get hallFideLine => 'ਫਿਡੇ ਖ਼ਿਤਾਬ 1993–2006';

  @override
  String get hallTiebreak => 'ਤੇਜ਼ ਬਾਜ਼ੀ';

  @override
  String get replayCheck => 'ਸ਼ਹਿ!';

  @override
  String get replayMate => 'ਮਾਤ!';

  @override
  String get replayCastle => 'ਰਾਜਾ ਕਿਲ੍ਹੇ ਵਿੱਚ ਲੁਕ ਗਿਆ!';

  @override
  String get replaySacrifice => 'ਬਹਾਦਰੀ ਭਰੀ ਕੁਰਬਾਨੀ!';

  @override
  String get replayEndMate => 'ਮਾਤ! ਲੜਾਈ ਜਿੱਤ ਲਈ।';

  @override
  String get replayEndResign =>
      'ਰਾਜੇ ਨੇ ਝੁਕ ਕੇ ਆਪਣਾ ਤਾਜ ਸੌਂਪ ਦਿੱਤਾ। ਲੜਾਈ ਖ਼ਤਮ!';

  @override
  String get replayEndDraw => 'ਬਰਾਬਰੀ! ਦੋਵੇਂ ਰਾਜਿਆਂ ਨੇ ਹੱਥ ਮਿਲਾਇਆ।';

  @override
  String get replayEndUnfinished => 'ਇਹ ਲੜਾਈ ਹਾਲੇ ਚੱਲ ਰਹੀ ਹੈ।';

  @override
  String get replayPlay => 'ਚਲਾਓ';

  @override
  String get replayPause => 'ਰੁਕੋ';

  @override
  String get replayNextBattle => 'ਅਗਲੀ ਲੜਾਈ';

  @override
  String get replayChronicle => 'ਇਤਿਹਾਸ';

  @override
  String get replayStepBack => 'ਇੱਕ ਚਾਲ ਪਿੱਛੇ';

  @override
  String get replayStepForward => 'ਇੱਕ ਚਾਲ ਅੱਗੇ';

  @override
  String replayMoveOf(int n, int total) {
    return '$total ਵਿੱਚੋਂ ਚਾਲ $n';
  }

  @override
  String get liveTitle => 'ਹੁਣ ਖੇਡਿਆ ਜਾ ਰਿਹਾ ਹੈ';

  @override
  String get liveSwitch => 'ਇੰਟਰਨੈੱਟ ਦੀਆਂ ਖੇਡਾਂ';

  @override
  String get liveSwitchHint =>
      'ਇਹ ਚਾਲੂ ਹੋਣ ਵੇਲੇ ਹੀ ਲਾਈਵ ਟੂਰਨਾਮੈਂਟ ਡਾਊਨਲੋਡ ਹੁੰਦੇ ਹਨ।';

  @override
  String get liveNothing => 'ਹੁਣ ਕੁਝ ਨਹੀਂ ਖੇਡਿਆ ਜਾ ਰਿਹਾ।';

  @override
  String get liveError => 'ਲੋਡ ਨਹੀਂ ਹੋ ਸਕਿਆ। ਬਾਅਦ ਵਿੱਚ ਫਿਰ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String get liveOffline =>
      'ਇੰਟਰਨੈੱਟ ਨਹੀਂ ਹੈ: ਜੋ ਪਹਿਲਾਂ ਡਾਊਨਲੋਡ ਹੋਇਆ ਹੈ ਉਹੀ ਦਿਖਾ ਰਹੇ ਹਾਂ।';

  @override
  String liveGame(int n) {
    return 'ਖੇਡ $n';
  }

  @override
  String get settingsTitle => 'ਸੈਟਿੰਗਾਂ';

  @override
  String get settingsBattles => 'ਮੋਹਰਾ ਮਾਰਨ ਵੇਲੇ ਲੜਾਈ';

  @override
  String get settingsBattlesHint =>
      'ਬੰਦ: ਮਾਰਿਆ ਮੋਹਰਾ ਬੱਸ ਬੱਦਲ ਵਿੱਚ ਗਾਇਬ ਹੋ ਜਾਂਦਾ ਹੈ।';

  @override
  String get settingsClassic => 'ਕਲਾਸਿਕ ਸ਼ਤਰੰਜ ਦੇ ਮੋਹਰੇ';

  @override
  String get settingsClassicHint =>
      'ਖੇਡਾਂ ਵਿੱਚ ਫ਼ੌਜ ਦੇ ਕਿਰਦਾਰਾਂ ਦੀ ਥਾਂ। ਫਿਰ ਲੜਾਈਆਂ ਨਹੀਂ ਦਿਸਦੀਆਂ।';

  @override
  String get liveBadge => 'ਲਾਈਵ';

  @override
  String get liveSkip => 'ਛੱਡੋ';

  @override
  String get liveTryOwn => 'ਮੈਂ ਆਪ ਕੋਸ਼ਿਸ਼ ਕਰਾਂਗਾ';

  @override
  String get liveAdviser => 'ਸਲਾਹਕਾਰ';

  @override
  String get liveBackToGame => 'ਖੇਡ ਵੱਲ ਵਾਪਸ';

  @override
  String get liveNewMove => 'ਨਵੀਂ ਚਾਲ!';

  @override
  String liveNewMoves(int n) {
    return 'ਨਵੀਆਂ ਚਾਲਾਂ: $n';
  }

  @override
  String get liveTimeTrouble => 'ਸਮਾਂ ਮੁੱਕ ਰਿਹਾ ਹੈ!';

  @override
  String get liveAdviserThinking => 'ਸਲਾਹਕਾਰ ਅਜੇ ਸੋਚ ਰਿਹਾ ਹੈ।';

  @override
  String get liveAdviserContinue => 'ਮੈਂ ਆਪ ਅੱਗੇ ਖੇਡਾਂਗਾ';

  @override
  String get liveAhead => 'ਕੌਣ ਅੱਗੇ ਹੈ';

  @override
  String get liveClockApprox => 'ਸਮਾਂ ਅੰਦਾਜ਼ਨ ਹੈ';

  @override
  String get liveReset => 'ਸ਼ੁਰੂ ਤੋਂ';

  @override
  String liveStartsAt(String time) {
    return '$time ਵਜੇ ਸ਼ੁਰੂ';
  }

  @override
  String liveDepth(int n) {
    return 'ਡੂੰਘਾਈ $n';
  }
}
