// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'शतरंज का राज्य';

  @override
  String get mapTitle => 'राज्य';

  @override
  String get comingSoon => 'जल्द आ रहा है';

  @override
  String get locked => 'बंद है';

  @override
  String get start => 'खेलो!';

  @override
  String get again => 'फिर से';

  @override
  String get next => 'आगे';

  @override
  String get back => 'पीछे';

  @override
  String get yes => 'हाँ';

  @override
  String get no => 'नहीं';

  @override
  String get wellDone => 'शाबाश!';

  @override
  String get lessonDone => 'पाठ पूरा हुआ!';

  @override
  String get taskWon => 'हुर्रे!';

  @override
  String get tryAgain => 'चलो फिर कोशिश करते हैं!';

  @override
  String get botWon => 'रोबोट जीत गया। चलो फिर खेलते हैं!';

  @override
  String get promoted => 'वह रानी बन गई!';

  @override
  String get lavaWarning => 'अरे, लावा!';

  @override
  String tapTarget(String target) {
    return 'यहाँ दबाओ: $target';
  }

  @override
  String street(String name) {
    return 'गली $name';
  }

  @override
  String house(String name) {
    return 'कतार $name';
  }

  @override
  String room(String name) {
    return 'कमरा $name';
  }

  @override
  String get dragHint => 'मोहरे को बिसात पर खींचो';

  @override
  String get armies => 'सेनाएँ';

  @override
  String get myArmy => 'मेरी सेना';

  @override
  String get rivalArmy => 'विरोधी';

  @override
  String get battleDemo => 'आज़माइशी लड़ाई';

  @override
  String taskOf(int n, int total) {
    return 'काम $n/$total';
  }

  @override
  String get opponentThinking => 'रोबोट सोच रहा है…';

  @override
  String get hallTitle => 'यश भवन';

  @override
  String get hallGolden => 'सुनहरी बिसात';

  @override
  String get hallGoldenHint => '64 सबसे मशहूर बाज़ियाँ';

  @override
  String get hallMatches => 'ताज के लिए मुक़ाबले';

  @override
  String get hallMatchesHint => 'विश्व चैंपियनशिप के सारे मुक़ाबले';

  @override
  String get hallWomen => 'चैंपियन महिलाएँ';

  @override
  String get hallWomenHint => 'महिला विश्व चैंपियन और उनकी बाज़ियाँ';

  @override
  String get hallChallenge => 'चैंपियन और चैलेंजर';

  @override
  String hallChallengeHint(String year) {
    return '$year के खिताबी मुकाबले के दोनों खिलाड़ियों की सबसे सुंदर जीतें';
  }

  @override
  String hallStickers(int n, int total) {
    return '$total में से $n';
  }

  @override
  String get hallFideLine => 'फ़िडे ख़िताब 1993–2006';

  @override
  String get hallTiebreak => 'तेज़ बाज़ी';

  @override
  String get replayCheck => 'शह!';

  @override
  String get replayMate => 'मात!';

  @override
  String get replayCastle => 'राजा किले में छिप गया!';

  @override
  String get replaySacrifice => 'बहादुर बलिदान!';

  @override
  String get replayEndMate => 'मात! लड़ाई जीत ली गई।';

  @override
  String get replayEndResign => 'राजा ने झुककर अपना ताज सौंप दिया। लड़ाई खत्म!';

  @override
  String get replayEndDraw => 'बराबरी! दोनों राजाओं ने हाथ मिलाया।';

  @override
  String get replayEndUnfinished => 'यह लड़ाई अभी चल रही है।';

  @override
  String get replayPlay => 'चलाएँ';

  @override
  String get replayPause => 'रुकें';

  @override
  String get replayNextBattle => 'अगली लड़ाई';

  @override
  String get replayChronicle => 'वृत्तांत';

  @override
  String get replayStepBack => 'एक चाल पीछे';

  @override
  String get replayStepForward => 'एक चाल आगे';

  @override
  String replayMoveOf(int n, int total) {
    return '$total में से चाल $n';
  }

  @override
  String get liveTitle => 'अभी खेला जा रहा है';

  @override
  String get liveSwitch => 'इंटरनेट से खेल';

  @override
  String get liveSwitchHint =>
      'लाइव टूर्नामेंट तभी डाउनलोड होते हैं जब यह चालू हो।';

  @override
  String get liveNothing => 'अभी कुछ नहीं खेला जा रहा।';

  @override
  String get liveError => 'लोड नहीं हो सका। बाद में फिर कोशिश करो।';

  @override
  String get liveOffline =>
      'इंटरनेट नहीं है: जो पहले से डाउनलोड है वही दिखा रहे हैं।';

  @override
  String liveGame(int n) {
    return 'खेल $n';
  }

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get settingsBattles => 'मोहरा मारने पर लड़ाई';

  @override
  String get settingsBattlesHint =>
      'बंद: मारा गया मोहरा बस बादल में गायब हो जाता है।';

  @override
  String get settingsClassic => 'क्लासिक शतरंज के मोहरे';

  @override
  String get settingsClassicHint => 'खेलों में सेना के पात्रों की जगह।';

  @override
  String get liveBadge => 'लाइव';

  @override
  String get liveSkip => 'छोड़ें';

  @override
  String get liveTryOwn => 'मैं खुद कोशिश करूँगा';

  @override
  String get liveAdviser => 'सलाहकार';

  @override
  String get liveBackToGame => 'खेल पर वापस';

  @override
  String get liveNewMove => 'नई चाल!';

  @override
  String liveNewMoves(int n) {
    return 'नई चालें: $n';
  }

  @override
  String get liveTimeTrouble => 'समय खत्म हो रहा है!';

  @override
  String get liveAdviserThinking => 'सलाहकार अभी सोच रहा है।';

  @override
  String get liveAdviserContinue => 'मैं खुद आगे खेलूँगा';

  @override
  String get liveAhead => 'कौन आगे है';

  @override
  String get liveClockApprox => 'समय अनुमानित है';

  @override
  String get liveReset => 'शुरू से';

  @override
  String liveStartsAt(String time) {
    return '$time बजे शुरू';
  }

  @override
  String liveDepth(int n) {
    return 'गहराई $n';
  }
}
