// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appTitle => 'बुद्धिबळाचे राज्य';

  @override
  String get mapTitle => 'राज्य';

  @override
  String get comingSoon => 'लवकरच';

  @override
  String get locked => 'बंद';

  @override
  String get start => 'खेळा!';

  @override
  String get again => 'पुन्हा';

  @override
  String get next => 'पुढे';

  @override
  String get back => 'मागे';

  @override
  String get yes => 'हो';

  @override
  String get no => 'नाही';

  @override
  String get wellDone => 'छान!';

  @override
  String get lessonDone => 'धडा पूर्ण!';

  @override
  String get taskWon => 'हुर्रे!';

  @override
  String get tryAgain => 'चला पुन्हा प्रयत्न करूया!';

  @override
  String get botWon => 'रोबोट जिंकला. चला पुन्हा खेळूया!';

  @override
  String get promoted => 'ती राणी झाली!';

  @override
  String get lavaWarning => 'अरेरे, लाव्हा!';

  @override
  String tapTarget(String target) {
    return 'इथे दाबा: $target';
  }

  @override
  String street(String name) {
    return 'गल्ली $name';
  }

  @override
  String house(String name) {
    return 'रांग $name';
  }

  @override
  String room(String name) {
    return 'खोली $name';
  }

  @override
  String get dragHint => 'मोहरा पटावर ओढा';

  @override
  String get armies => 'सैन्ये';

  @override
  String get myArmy => 'माझे सैन्य';

  @override
  String get rivalArmy => 'प्रतिस्पर्धी';

  @override
  String get battleDemo => 'चाचणी लढाई';

  @override
  String taskOf(int n, int total) {
    return 'काम $n/$total';
  }

  @override
  String get opponentThinking => 'रोबोट विचार करतोय…';

  @override
  String get hallTitle => 'कीर्ती सभागृह';

  @override
  String get hallGolden => 'सोनेरी पट';

  @override
  String get hallGoldenHint => '64 सर्वात प्रसिद्ध डाव';

  @override
  String get hallMatches => 'मुकुटासाठी सामने';

  @override
  String get hallMatchesHint => 'जागतिक अजिंक्यपदाचे सर्व सामने';

  @override
  String get hallWomen => 'विजेत्या महिला';

  @override
  String get hallWomenHint => 'महिला जगज्जेत्या आणि त्यांचे डाव';

  @override
  String get hallChallenge => 'विजेता आणि आव्हानवीर';

  @override
  String hallChallengeHint(String year) {
    return '$year च्या विजेतेपद सामन्यातील दोन्ही खेळाडूंचे सर्वात सुंदर विजय';
  }

  @override
  String hallStickers(int n, int total) {
    return '$total पैकी $n';
  }

  @override
  String get hallFideLine => 'फिडे किताब 1993–2006';

  @override
  String get hallTiebreak => 'जलद डाव';

  @override
  String get replayCheck => 'शह!';

  @override
  String get replayMate => 'मात!';

  @override
  String get replayCastle => 'राजा किल्ल्यात लपला!';

  @override
  String get replaySacrifice => 'धाडसी बलिदान!';

  @override
  String get replayEndMate => 'मात! लढाई जिंकली.';

  @override
  String get replayEndResign => 'राजाने वाकून आपला मुकुट दिला. लढाई संपली!';

  @override
  String get replayEndDraw => 'बरोबरी! दोन्ही राजांनी हात मिळवला.';

  @override
  String get replayEndUnfinished => 'ही लढाई अजून सुरू आहे.';

  @override
  String get replayPlay => 'चालवा';

  @override
  String get replayPause => 'थांबा';

  @override
  String get replayNextBattle => 'पुढची लढाई';

  @override
  String get replayChronicle => 'वृत्तांत';

  @override
  String get replayStepBack => 'एक चाल मागे';

  @override
  String get replayStepForward => 'एक चाल पुढे';

  @override
  String replayMoveOf(int n, int total) {
    return '$total पैकी चाल $n';
  }

  @override
  String get liveTitle => 'आता खेळ चालू आहे';

  @override
  String get liveSwitch => 'इंटरनेटवरचे खेळ';

  @override
  String get liveSwitchHint => 'हे चालू असतानाच थेट स्पर्धा डाउनलोड होतात.';

  @override
  String get liveNothing => 'आत्ता काहीही खेळले जात नाही.';

  @override
  String get liveError => 'लोड करता आले नाही. नंतर पुन्हा प्रयत्न करा.';

  @override
  String get liveOffline => 'इंटरनेट नाही: आधी डाउनलोड केलेले दाखवत आहे.';

  @override
  String liveGame(int n) {
    return 'खेळ $n';
  }
}
