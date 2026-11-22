// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Oriya (`or`).
class AppLocalizationsOr extends AppLocalizations {
  AppLocalizationsOr([String locale = 'or']) : super(locale);

  @override
  String get appTitle => 'ଚେସ୍ ରାଜ୍ୟ';

  @override
  String get mapTitle => 'ରାଜ୍ୟ';

  @override
  String get comingSoon => 'ଶୀଘ୍ର ଆସୁଛି';

  @override
  String get locked => 'ବନ୍ଦ';

  @override
  String get start => 'ଖେଳ!';

  @override
  String get again => 'ପୁଣି';

  @override
  String get next => 'ଆଗକୁ';

  @override
  String get back => 'ପଛକୁ';

  @override
  String get yes => 'ହଁ';

  @override
  String get no => 'ନା';

  @override
  String get wellDone => 'ବାହ୍!';

  @override
  String get lessonDone => 'ପାଠ ସରିଲା!';

  @override
  String get taskWon => 'ହୁରେ!';

  @override
  String get tryAgain => 'ଚାଲ ପୁଣି ଚେଷ୍ଟା କରିବା!';

  @override
  String get botWon => 'ରୋବଟ୍ ଜିତିଲା। ଚାଲ ପୁଣି ଖେଳିବା!';

  @override
  String get promoted => 'ସେ ରାଜକୁମାରୀ ହୋଇଗଲା!';

  @override
  String get lavaWarning => 'ଆରେ, ଲାଭା!';

  @override
  String tapTarget(String target) {
    return 'ଏଠାରେ ଦବାଅ: $target';
  }

  @override
  String street(String name) {
    return 'ଗଳି $name';
  }

  @override
  String house(String name) {
    return 'ଧାଡ଼ି $name';
  }

  @override
  String room(String name) {
    return 'କୋଠରୀ $name';
  }

  @override
  String get dragHint => 'ଗୁଟିକୁ ବୋର୍ଡକୁ ଟାଣି ଆଣ';

  @override
  String get armies => 'ସେନାଗୁଡ଼ିକ';

  @override
  String get myArmy => 'ମୋ ସେନା';

  @override
  String get rivalArmy => 'ପ୍ରତିପକ୍ଷ';

  @override
  String get battleDemo => 'ପରୀକ୍ଷା ଯୁଦ୍ଧ';

  @override
  String taskOf(int n, int total) {
    return 'କାମ $n/$total';
  }

  @override
  String get opponentThinking => 'ରୋବଟ୍ ଭାବୁଛି…';

  @override
  String get hallTitle => 'ଖ୍ୟାତି ଭବନ';

  @override
  String get hallFamous => 'ପ୍ରସିଦ୍ଧ ଖେଳ';

  @override
  String get replayCheck => 'ଚେକ୍!';

  @override
  String get replayMate => 'ଚେକ୍‌ମେଟ୍!';

  @override
  String get replayCastle => 'ରାଜା ଦୁର୍ଗରେ ଲୁଚିଗଲା!';

  @override
  String get replaySacrifice => 'ସାହସୀ ତ୍ୟାଗ!';

  @override
  String get replayEndMate => 'ଚେକ୍‌ମେଟ୍! ଯୁଦ୍ଧ ଜିତିଗଲା।';

  @override
  String get replayEndResign => 'ରାଜା ମୁଣ୍ଡ ନଇଁଇ ନିଜ ମୁକୁଟ ଦେଇଦେଲା। ଯୁଦ୍ଧ ଶେଷ!';

  @override
  String get replayEndDraw => 'ଡ୍ରୋ! ଦୁଇ ରାଜା ହାତ ମିଳାଇଲେ।';

  @override
  String get replayEndUnfinished => 'ଏହି ଯୁଦ୍ଧ ଏବେ ବି ଚାଲିଛି।';

  @override
  String get replayPlay => 'ଚଲାନ୍ତୁ';

  @override
  String get replayPause => 'ଅଟକାନ୍ତୁ';

  @override
  String get replayNextBattle => 'ପରବର୍ତ୍ତୀ ଯୁଦ୍ଧ';

  @override
  String get replayChronicle => 'ଇତିବୃତ୍ତ';

  @override
  String get replayStepBack => 'ଗୋଟିଏ ଚାଲ ପଛକୁ';

  @override
  String get replayStepForward => 'ଗୋଟିଏ ଚାଲ ଆଗକୁ';

  @override
  String replayMoveOf(int n, int total) {
    return '$totalରୁ $n ନମ୍ବର ଚାଲ';
  }

  @override
  String get liveTitle => 'ଏବେ ଖେଳାଯାଉଛି';

  @override
  String get liveSwitch => 'ଇଣ୍ଟରନେଟରୁ ଖେଳ';

  @override
  String get liveSwitchHint =>
      'ଏହା ଚାଲୁ ଥିବା ବେଳେ ହିଁ ଲାଇଭ୍ ଟୁର୍ନାମେଣ୍ଟ ଡାଉନଲୋଡ୍ ହୁଏ।';

  @override
  String get liveNothing => 'ଏବେ କିଛି ଖେଳାଯାଉନାହିଁ।';

  @override
  String get liveError => 'ଲୋଡ୍ ହୋଇପାରିଲା ନାହିଁ। ପରେ ପୁଣି ଚେଷ୍ଟା କର।';

  @override
  String get liveOffline => 'ଇଣ୍ଟରନେଟ ନାହିଁ: ଆଗରୁ ଡାଉନଲୋଡ୍ ହୋଇଥିବା ଦେଖାଉଛୁ।';

  @override
  String liveGame(int n) {
    return 'ଖେଳ $n';
  }
}
