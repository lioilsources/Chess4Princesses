// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Royaume des échecs';

  @override
  String get mapTitle => 'Royaume';

  @override
  String get comingSoon => 'Bientôt';

  @override
  String get locked => 'Verrouillé';

  @override
  String get start => 'On joue !';

  @override
  String get again => 'Encore';

  @override
  String get next => 'Suivant';

  @override
  String get back => 'Retour';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get wellDone => 'Bravo !';

  @override
  String get lessonDone => 'Leçon terminée !';

  @override
  String get taskWon => 'Hourra !';

  @override
  String get tryAgain => 'On réessaie !';

  @override
  String get botWon => 'Le petit robot a gagné. On rejoue !';

  @override
  String get promoted => 'Elle devient princesse !';

  @override
  String get lavaWarning => 'Aïe, la lave !';

  @override
  String tapTarget(String target) {
    return 'Touche : $target';
  }

  @override
  String street(String name) {
    return 'la rue $name';
  }

  @override
  String house(String name) {
    return 'la rangée $name';
  }

  @override
  String room(String name) {
    return 'la chambre $name';
  }

  @override
  String get dragHint => 'Fais glisser une pièce sur l\'échiquier';

  @override
  String get armies => 'Armées';

  @override
  String get myArmy => 'Mon armée';

  @override
  String get rivalArmy => 'Adversaire';

  @override
  String get battleDemo => 'Bataille d\'essai';

  @override
  String taskOf(int n, int total) {
    return 'Tâche $n sur $total';
  }

  @override
  String get opponentThinking => 'Le petit robot réfléchit…';
}
