// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appTitle => 'చదరంగ రాజ్యం';

  @override
  String get mapTitle => 'రాజ్యం';

  @override
  String get comingSoon => 'త్వరలో';

  @override
  String get locked => 'లాక్ అయింది';

  @override
  String get start => 'ఆడదాం!';

  @override
  String get again => 'మళ్ళీ';

  @override
  String get next => 'తర్వాత';

  @override
  String get back => 'వెనక్కి';

  @override
  String get yes => 'అవును';

  @override
  String get no => 'కాదు';

  @override
  String get wellDone => 'భలే!';

  @override
  String get lessonDone => 'పాఠం పూర్తయింది!';

  @override
  String get taskWon => 'హుర్రే!';

  @override
  String get tryAgain => 'మళ్ళీ ప్రయత్నిద్దాం!';

  @override
  String get botWon => 'రోబోట్ గెలిచింది. మళ్ళీ ఆడదాం!';

  @override
  String get promoted => 'ఆమె రాణి అయింది!';

  @override
  String get lavaWarning => 'అయ్యో, లావా!';

  @override
  String tapTarget(String target) {
    return 'ఇక్కడ తాకండి: $target';
  }

  @override
  String street(String name) {
    return 'వీధి $name';
  }

  @override
  String house(String name) {
    return 'వరుస $name';
  }

  @override
  String room(String name) {
    return 'గది $name';
  }

  @override
  String get dragHint => 'పావును బోర్డ్ మీదకు లాగండి';

  @override
  String get armies => 'సైన్యాలు';

  @override
  String get myArmy => 'నా సైన్యం';

  @override
  String get rivalArmy => 'ప్రత్యర్థి';

  @override
  String get battleDemo => 'పరీక్షా యుద్ధం';

  @override
  String taskOf(int n, int total) {
    return 'పని $n/$total';
  }

  @override
  String get opponentThinking => 'రోబోట్ ఆలోచిస్తోంది…';

  @override
  String get hallTitle => 'కీర్తి మందిరం';

  @override
  String get hallGolden => 'బంగారు బోర్డు';

  @override
  String get hallGoldenHint => 'అత్యంత ప్రసిద్ధమైన 64 ఆటలు';

  @override
  String get hallMatches => 'కిరీటం కోసం పోటీలు';

  @override
  String get hallMatchesHint => 'ప్రపంచ ఛాంపియన్‌షిప్ పోటీలన్నీ';

  @override
  String get hallWomen => 'ఛాంపియన్ మహిళలు';

  @override
  String get hallWomenHint => 'మహిళా ప్రపంచ ఛాంపియన్లు, వారి ఆటలు';

  @override
  String get hallChallenge => 'ఛాంపియన్ మరియు ఛాలెంజర్';

  @override
  String hallChallengeHint(String year) {
    return '$year టైటిల్ మ్యాచ్‌లో ఇద్దరు ఆటగాళ్ల అత్యంత అందమైన విజయాలు';
  }

  @override
  String hallStickers(int n, int total) {
    return '$totalలో $n';
  }

  @override
  String get hallFideLine => 'ఫిడే టైటిల్ 1993–2006';

  @override
  String get hallTiebreak => 'వేగవంతమైన ఆట';

  @override
  String get replayCheck => 'చెక్!';

  @override
  String get replayMate => 'చెక్‌మేట్!';

  @override
  String get replayCastle => 'రాజు కోటలో దాక్కున్నాడు!';

  @override
  String get replaySacrifice => 'ధైర్యమైన త్యాగం!';

  @override
  String get replayEndMate => 'చెక్‌మేట్! యుద్ధం గెలిచాం.';

  @override
  String get replayEndResign =>
      'రాజు వంగి నమస్కరించి తన కిరీటాన్ని ఇచ్చాడు. యుద్ధం ముగిసింది!';

  @override
  String get replayEndDraw => 'డ్రా! ఇద్దరు రాజులు కరచాలనం చేశారు.';

  @override
  String get replayEndUnfinished => 'ఈ యుద్ధం ఇంకా జరుగుతోంది.';

  @override
  String get replayPlay => 'ఆడించు';

  @override
  String get replayPause => 'ఆపు';

  @override
  String get replayNextBattle => 'తర్వాతి యుద్ధం';

  @override
  String get replayChronicle => 'చరిత్ర';

  @override
  String get replayStepBack => 'ఒక ఎత్తు వెనక్కి';

  @override
  String get replayStepForward => 'ఒక ఎత్తు ముందుకి';

  @override
  String replayMoveOf(int n, int total) {
    return '$totalలో $nవ ఎత్తు';
  }

  @override
  String get liveTitle => 'ఇప్పుడు ఆడుతున్నారు';

  @override
  String get liveSwitch => 'ఇంటర్నెట్ నుండి ఆటలు';

  @override
  String get liveSwitchHint =>
      'ఇది ఆన్‌లో ఉన్నప్పుడు మాత్రమే లైవ్ టోర్నమెంట్‌లు డౌన్‌లోడ్ అవుతాయి.';

  @override
  String get liveNothing => 'ఇప్పుడు ఏదీ ఆడటం లేదు.';

  @override
  String get liveError => 'లోడ్ కాలేదు. తర్వాత మళ్లీ ప్రయత్నించండి.';

  @override
  String get liveOffline =>
      'ఇంటర్నెట్ లేదు: ఇప్పటికే డౌన్‌లోడ్ అయినవి చూపిస్తున్నాం.';

  @override
  String liveGame(int n) {
    return 'ఆట $n';
  }

  @override
  String get settingsTitle => 'సెట్టింగ్‌లు';

  @override
  String get settingsBattles => 'పావు చంపినప్పుడు యుద్ధం';

  @override
  String get settingsBattlesHint => 'ఆఫ్: చంపిన పావు మేఘంలో మాయమవుతుంది అంతే.';

  @override
  String get settingsClassic => 'క్లాసిక్ చదరంగం పావులు';

  @override
  String get settingsClassicHint =>
      'ఆటల్లో సైన్యాల పాత్రలకు బదులుగా. అప్పుడు యుద్ధాలు కనిపించవు.';

  @override
  String get liveBadge => 'ప్రత్యక్షం';

  @override
  String get liveSkip => 'దాటవేయి';

  @override
  String get liveTryOwn => 'నేనే ప్రయత్నిస్తాను';

  @override
  String get liveAdviser => 'సలహాదారు';

  @override
  String get liveBackToGame => 'ఆటకు తిరిగి';

  @override
  String get liveNewMove => 'కొత్త ఎత్తు!';

  @override
  String liveNewMoves(int n) {
    return 'కొత్త ఎత్తులు: $n';
  }

  @override
  String get liveTimeTrouble => 'సమయం అయిపోతోంది!';

  @override
  String get liveAdviserThinking => 'సలహాదారు ఇంకా ఆలోచిస్తున్నారు.';

  @override
  String get liveAdviserContinue => 'నేనే కొనసాగిస్తాను';

  @override
  String get liveAhead => 'ఎవరు ముందున్నారు';

  @override
  String get liveClockApprox => 'సమయం సుమారుగా ఉంది';

  @override
  String get liveReset => 'మొదటి నుండి';

  @override
  String liveStartsAt(String time) {
    return '$timeకి ప్రారంభం';
  }

  @override
  String liveDepth(int n) {
    return 'లోతు $n';
  }
}
