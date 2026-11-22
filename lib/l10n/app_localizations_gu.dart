// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appTitle => 'ચેસનું રાજ્ય';

  @override
  String get mapTitle => 'રાજ્ય';

  @override
  String get comingSoon => 'જલ્દી આવે છે';

  @override
  String get locked => 'બંધ છે';

  @override
  String get start => 'રમો!';

  @override
  String get again => 'ફરીથી';

  @override
  String get next => 'આગળ';

  @override
  String get back => 'પાછળ';

  @override
  String get yes => 'હા';

  @override
  String get no => 'ના';

  @override
  String get wellDone => 'શાબાશ!';

  @override
  String get lessonDone => 'પાઠ પૂરો!';

  @override
  String get taskWon => 'હુર્રે!';

  @override
  String get tryAgain => 'ચાલો ફરી પ્રયત્ન કરીએ!';

  @override
  String get botWon => 'રોબોટ જીતી ગયો. ચાલો ફરી રમીએ!';

  @override
  String get promoted => 'તે રાણી બની ગઈ!';

  @override
  String get lavaWarning => 'અરે, લાવા!';

  @override
  String tapTarget(String target) {
    return 'અહીં દબાવો: $target';
  }

  @override
  String street(String name) {
    return 'શેરી $name';
  }

  @override
  String house(String name) {
    return 'હરોળ $name';
  }

  @override
  String room(String name) {
    return 'ઓરડો $name';
  }

  @override
  String get dragHint => 'મોહરાને પટ પર ખેંચો';

  @override
  String get armies => 'સેનાઓ';

  @override
  String get myArmy => 'મારી સેના';

  @override
  String get rivalArmy => 'પ્રતિસ્પર્ધી';

  @override
  String get battleDemo => 'અજમાયશી લડાઈ';

  @override
  String taskOf(int n, int total) {
    return 'કામ $n/$total';
  }

  @override
  String get opponentThinking => 'રોબોટ વિચારે છે…';

  @override
  String get hallTitle => 'કીર્તિ ખંડ';

  @override
  String get hallFamous => 'પ્રખ્યાત રમતો';

  @override
  String get replayCheck => 'શાહ!';

  @override
  String get replayMate => 'માત!';

  @override
  String get replayCastle => 'રાજા કિલ્લામાં સંતાઈ ગયો!';

  @override
  String get replaySacrifice => 'બહાદુર બલિદાન!';

  @override
  String get replayEndMate => 'માત! લડાઈ જીતાઈ ગઈ.';

  @override
  String get replayEndResign =>
      'રાજાએ નમીને પોતાનો મુગટ સોંપી દીધો. લડાઈ પૂરી!';

  @override
  String get replayEndDraw => 'ડ્રો! બંને રાજાઓએ હાથ મિલાવ્યા.';

  @override
  String get replayEndUnfinished => 'આ લડાઈ હજી ચાલે છે.';

  @override
  String get replayPlay => 'ચલાવો';

  @override
  String get replayPause => 'થોભો';

  @override
  String get replayNextBattle => 'આગલી લડાઈ';

  @override
  String get replayChronicle => 'વૃત્તાંત';

  @override
  String get replayStepBack => 'ચાલ પાછળ';

  @override
  String get replayStepForward => 'ચાલ આગળ';

  @override
  String replayMoveOf(int n, int total) {
    return '$total માંથી ચાલ $n';
  }

  @override
  String get liveTitle => 'હમણાં રમાઈ રહ્યું છે';

  @override
  String get liveSwitch => 'ઇન્ટરનેટની રમતો';

  @override
  String get liveSwitchHint =>
      'આ ચાલુ હોય ત્યારે જ લાઇવ ટુર્નામેન્ટ ડાઉનલોડ થાય છે.';

  @override
  String get liveNothing => 'હમણાં કંઈ રમાતું નથી.';

  @override
  String get liveError => 'લોડ થઈ શક્યું નથી. પછી ફરી પ્રયત્ન કરો.';

  @override
  String get liveOffline =>
      'ઇન્ટરનેટ નથી: જે પહેલેથી ડાઉનલોડ થયું છે તે બતાવું છું.';

  @override
  String liveGame(int n) {
    return 'રમત $n';
  }
}
