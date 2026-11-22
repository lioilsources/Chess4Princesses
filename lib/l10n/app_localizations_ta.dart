// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'சதுரங்க ராஜ்ஜியம்';

  @override
  String get mapTitle => 'ராஜ்ஜியம்';

  @override
  String get comingSoon => 'விரைவில்';

  @override
  String get locked => 'பூட்டப்பட்டுள்ளது';

  @override
  String get start => 'விளையாடு!';

  @override
  String get again => 'மீண்டும்';

  @override
  String get next => 'அடுத்து';

  @override
  String get back => 'பின்';

  @override
  String get yes => 'ஆம்';

  @override
  String get no => 'இல்லை';

  @override
  String get wellDone => 'அருமை!';

  @override
  String get lessonDone => 'பாடம் முடிந்தது!';

  @override
  String get taskWon => 'ஹூரே!';

  @override
  String get tryAgain => 'மீண்டும் முயற்சிப்போம்!';

  @override
  String get botWon => 'ரோபோ வென்றது. மீண்டும் விளையாடுவோம்!';

  @override
  String get promoted => 'அவள் இளவரசி ஆகிவிட்டாள்!';

  @override
  String get lavaWarning => 'அச்சோ, எரிமலைக் குழம்பு!';

  @override
  String tapTarget(String target) {
    return 'தொடு: $target';
  }

  @override
  String street(String name) {
    return 'தெரு $name';
  }

  @override
  String house(String name) {
    return 'வரிசை $name';
  }

  @override
  String room(String name) {
    return 'அறை $name';
  }

  @override
  String get dragHint => 'காயை பலகையில் இழுத்து வை';

  @override
  String get armies => 'படைகள்';

  @override
  String get myArmy => 'என் படை';

  @override
  String get rivalArmy => 'எதிராளி';

  @override
  String get battleDemo => 'சோதனைப் போர்';

  @override
  String taskOf(int n, int total) {
    return 'பணி $n/$total';
  }

  @override
  String get opponentThinking => 'ரோபோ யோசிக்கிறது…';

  @override
  String get hallTitle => 'புகழ் மண்டபம்';

  @override
  String get hallFamous => 'புகழ்பெற்ற ஆட்டங்கள்';

  @override
  String get replayCheck => 'செக்!';

  @override
  String get replayMate => 'செக்மேட்!';

  @override
  String get replayCastle => 'ராஜா கோட்டைக்குள் ஒளிந்துகொண்டான்!';

  @override
  String get replaySacrifice => 'தைரியமான தியாகம்!';

  @override
  String get replayEndMate => 'செக்மேட்! போரில் வெற்றி.';

  @override
  String get replayEndResign =>
      'ராஜா தலை வணங்கி தன் கிரீடத்தைக் கொடுத்தான். போர் முடிந்தது!';

  @override
  String get replayEndDraw => 'சமநிலை! இரண்டு ராஜாக்களும் கை குலுக்கினர்.';

  @override
  String get replayEndUnfinished =>
      'இந்தப் போர் இன்னும் நடந்துகொண்டிருக்கிறது.';

  @override
  String get replayPlay => 'இயக்கு';

  @override
  String get replayPause => 'இடைநிறுத்து';

  @override
  String get replayNextBattle => 'அடுத்த போர்';

  @override
  String get replayChronicle => 'நாளேடு';

  @override
  String get replayStepBack => 'ஒரு நகர்வு பின்னால்';

  @override
  String get replayStepForward => 'ஒரு நகர்வு முன்னால்';

  @override
  String replayMoveOf(int n, int total) {
    return '$total-இல் $n-வது நகர்வு';
  }
}
