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
}
