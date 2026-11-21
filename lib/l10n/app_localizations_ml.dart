// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appTitle => 'ചെസ് രാജ്യം';

  @override
  String get mapTitle => 'രാജ്യം';

  @override
  String get comingSoon => 'ഉടൻ വരുന്നു';

  @override
  String get locked => 'പൂട്ടിയിരിക്കുന്നു';

  @override
  String get start => 'കളിക്കാം!';

  @override
  String get again => 'വീണ്ടും';

  @override
  String get next => 'അടുത്തത്';

  @override
  String get back => 'തിരികെ';

  @override
  String get yes => 'അതെ';

  @override
  String get no => 'ഇല്ല';

  @override
  String get wellDone => 'കൊള്ളാം!';

  @override
  String get lessonDone => 'പാഠം പൂർത്തിയായി!';

  @override
  String get taskWon => 'ഹുറേ!';

  @override
  String get tryAgain => 'നമുക്ക് വീണ്ടും ശ്രമിക്കാം!';

  @override
  String get botWon => 'റോബോട്ട് ജയിച്ചു. നമുക്ക് വീണ്ടും കളിക്കാം!';

  @override
  String get promoted => 'അവൾ രാജകുമാരിയായി!';

  @override
  String get lavaWarning => 'അയ്യോ, ലാവ!';

  @override
  String tapTarget(String target) {
    return 'ഇവിടെ തൊടുക: $target';
  }

  @override
  String street(String name) {
    return 'തെരുവ് $name';
  }

  @override
  String house(String name) {
    return 'വരി $name';
  }

  @override
  String room(String name) {
    return 'മുറി $name';
  }

  @override
  String get dragHint => 'കരു ബോർഡിലേക്ക് വലിച്ചിടുക';

  @override
  String get armies => 'സേനകൾ';

  @override
  String get myArmy => 'എന്റെ സേന';

  @override
  String get rivalArmy => 'എതിരാളി';

  @override
  String get battleDemo => 'പരീക്ഷണ യുദ്ധം';

  @override
  String taskOf(int n, int total) {
    return 'ചുമതല $n/$total';
  }

  @override
  String get opponentThinking => 'റോബോട്ട് ആലോചിക്കുന്നു…';
}
