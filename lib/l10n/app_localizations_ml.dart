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
  String get promoted => 'അവൾ രാജ്ഞിയായി!';

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

  @override
  String get hallTitle => 'പ്രശസ്തിയുടെ ഹാൾ';

  @override
  String get hallFamous => 'പ്രശസ്തമായ കളികൾ';

  @override
  String get replayCheck => 'ചെക്ക്!';

  @override
  String get replayMate => 'ചെക്ക്മേറ്റ്!';

  @override
  String get replayCastle => 'രാജാവ് കോട്ടയിൽ ഒളിച്ചു!';

  @override
  String get replaySacrifice => 'ധീരമായ ത്യാഗം!';

  @override
  String get replayEndMate => 'ചെക്ക്മേറ്റ്! യുദ്ധം ജയിച്ചു.';

  @override
  String get replayEndResign =>
      'രാജാവ് തല കുനിച്ച് കിരീടം കൈമാറി. യുദ്ധം തീർന്നു!';

  @override
  String get replayEndDraw => 'സമനില! രണ്ട് രാജാക്കന്മാരും കൈ കൊടുത്തു.';

  @override
  String get replayEndUnfinished => 'ഈ യുദ്ധം ഇപ്പോഴും നടക്കുന്നു.';

  @override
  String get replayPlay => 'പ്ലേ ചെയ്യൂ';

  @override
  String get replayPause => 'നിർത്തൂ';

  @override
  String get replayNextBattle => 'അടുത്ത യുദ്ധം';

  @override
  String get replayChronicle => 'ചരിത്രക്കുറിപ്പ്';

  @override
  String get replayStepBack => 'ഒരു നീക്കം പിന്നിലേക്ക്';

  @override
  String get replayStepForward => 'ഒരു നീക്കം മുന്നിലേക്ക്';

  @override
  String replayMoveOf(int n, int total) {
    return '$total-ൽ $n-ാം നീക്കം';
  }

  @override
  String get liveTitle => 'ഇപ്പോൾ കളിക്കുന്നു';

  @override
  String get liveSwitch => 'ഇന്റർനെറ്റിൽ നിന്നുള്ള കളികൾ';

  @override
  String get liveSwitchHint =>
      'ഇത് ഓണായിരിക്കുമ്പോൾ മാത്രമേ തത്സമയ ടൂർണമെന്റുകൾ ഡൗൺലോഡ് ചെയ്യൂ.';

  @override
  String get liveNothing => 'ഇപ്പോൾ ഒന്നും കളിക്കുന്നില്ല.';

  @override
  String get liveError => 'ലോഡ് ചെയ്യാനായില്ല. പിന്നീട് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get liveOffline =>
      'ഇന്റർനെറ്റ് ഇല്ല: ഇതിനകം ഡൗൺലോഡ് ചെയ്തത് കാണിക്കുന്നു.';

  @override
  String liveGame(int n) {
    return 'കളി $n';
  }
}
