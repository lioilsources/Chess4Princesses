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
  String get promoted => 'ఆమె రాకుమారి అయింది!';

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
}
