// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appTitle => 'ממלכת השחמט';

  @override
  String get mapTitle => 'הממלכה';

  @override
  String get comingSoon => 'בקרוב';

  @override
  String get locked => 'נעול';

  @override
  String get start => 'משחקים!';

  @override
  String get again => 'שוב';

  @override
  String get next => 'הבא';

  @override
  String get back => 'חזרה';

  @override
  String get yes => 'כן';

  @override
  String get no => 'לא';

  @override
  String get wellDone => 'כל הכבוד!';

  @override
  String get lessonDone => 'השיעור הושלם!';

  @override
  String get taskWon => 'הידד!';

  @override
  String get tryAgain => 'ננסה שוב!';

  @override
  String get botWon => 'הרובוט ניצח. משחקים שוב!';

  @override
  String get promoted => 'היא הפכה למלכה!';

  @override
  String get lavaWarning => 'אוי, לבה!';

  @override
  String tapTarget(String target) {
    return 'הקישו על: $target';
  }

  @override
  String street(String name) {
    return 'רחוב $name';
  }

  @override
  String house(String name) {
    return 'שורת $name';
  }

  @override
  String room(String name) {
    return 'חדר $name';
  }

  @override
  String get dragHint => 'גררו כלי אל הלוח';

  @override
  String get armies => 'צבאות';

  @override
  String get myArmy => 'הצבא שלי';

  @override
  String get rivalArmy => 'יריב';

  @override
  String get battleDemo => 'קרב ניסיון';

  @override
  String taskOf(int n, int total) {
    return 'משימה $n מתוך $total';
  }

  @override
  String get opponentThinking => 'הרובוט חושב…';

  @override
  String get hallTitle => 'היכל התהילה';

  @override
  String get hallGolden => 'הלוח המוזהב';

  @override
  String get hallGoldenHint => '64 המשחקים המפורסמים ביותר';

  @override
  String get hallMatches => 'קרבות על הכתר';

  @override
  String get hallMatchesHint => 'כל הקרבות על אליפות העולם';

  @override
  String get hallWomen => 'אלופות';

  @override
  String get hallWomenHint => 'אלופות העולם והמשחקים שלהן';

  @override
  String get hallChallenge => 'האלוף והמתמודד';

  @override
  String hallChallengeHint(String year) {
    return 'הניצחונות היפים ביותר של שני השחקנים בקרב על התואר $year';
  }

  @override
  String hallStickers(int n, int total) {
    return '$n מתוך $total';
  }

  @override
  String get hallFideLine => 'תואר פיד״ה 1993–2006';

  @override
  String get hallTiebreak => 'משחק מהיר';

  @override
  String get replayCheck => 'שח!';

  @override
  String get replayMate => 'מט!';

  @override
  String get replayCastle => 'המלך מתחבא בטירה!';

  @override
  String get replaySacrifice => 'הקרבה אמיצה!';

  @override
  String get replayEndMate => 'מט! ניצחנו בקרב.';

  @override
  String get replayEndResign => 'המלך משתחווה ומוסר את כתרו. הקרב נגמר!';

  @override
  String get replayEndDraw => 'תיקו! שני המלכים לוחצים ידיים.';

  @override
  String get replayEndUnfinished => 'הקרב הזה עדיין נמשך.';

  @override
  String get replayPlay => 'נגן';

  @override
  String get replayPause => 'השהיה';

  @override
  String get replayNextBattle => 'הקרב הבא';

  @override
  String get replayChronicle => 'יומן הקרב';

  @override
  String get replayStepBack => 'מהלך אחורה';

  @override
  String get replayStepForward => 'מהלך קדימה';

  @override
  String replayMoveOf(int n, int total) {
    return 'מהלך $n מתוך $total';
  }

  @override
  String get liveTitle => 'משחקים עכשיו';

  @override
  String get liveSwitch => 'משחקים מהאינטרנט';

  @override
  String get liveSwitchHint => 'טורנירים חיים יורדים רק כשהמתג הזה דלוק.';

  @override
  String get liveNothing => 'כרגע לא משחקים כלום.';

  @override
  String get liveError => 'לא הצלחנו לטעון. נסו שוב מאוחר יותר.';

  @override
  String get liveOffline => 'אין אינטרנט: מוצג מה שכבר הורד.';

  @override
  String liveGame(int n) {
    return 'משחק $n';
  }

  @override
  String get settingsTitle => 'הגדרות';

  @override
  String get settingsBattles => 'קרבות בזמן הכאה';

  @override
  String get settingsBattlesHint => 'כבוי: הכלי שהוכה פשוט נעלם בענן.';

  @override
  String get settingsClassic => 'כלי שחמט קלאסיים';

  @override
  String get settingsClassicHint => 'במשחקים במקום דמויות הצבאות.';

  @override
  String get liveBadge => 'שידור חי';

  @override
  String get liveSkip => 'דלג';

  @override
  String get liveTryOwn => 'אנסה בעצמי';

  @override
  String get liveAdviser => 'יועץ';

  @override
  String get liveBackToGame => 'חזרה למשחק';

  @override
  String get liveNewMove => 'מסע חדש!';

  @override
  String liveNewMoves(int n) {
    return 'מסעים חדשים: $n';
  }

  @override
  String get liveTimeTrouble => 'הזמן אוזל!';

  @override
  String get liveAdviserThinking => 'היועץ עדיין חושב.';

  @override
  String get liveAdviserContinue => 'אמשיך בעצמי';

  @override
  String get liveAhead => 'מי מוביל';

  @override
  String get liveClockApprox => 'הזמן משוער';

  @override
  String get liveReset => 'מההתחלה';

  @override
  String liveStartsAt(String time) {
    return 'מתחיל ב־$time';
  }

  @override
  String liveDepth(int n) {
    return 'עומק $n';
  }
}
